//
//  LLDebugTool.m
//
//  Copyright (c) 2018 LLDebugTool Software Foundation (https://github.com/HDB-Li/LLDebugTool)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "LLDebugTool.h"
#import "LLScreenshotHelper.h"
#import "LLStorageManager.h"
#import "LLNetworkHelper.h"
#import "LLCrashHelper.h"
#import "LLLogHelper.h"
#import "LLAppHelper.h"
#import "LLWindow.h"
#import "LLDebugToolMacros.h"
#import "LLLogHelperEventDefine.h"
#import "LLConfig.h"
#import "LLTool.h"
#import "LLNetworkModel.h"
#import "LLRoute.h"
#import "LLHomeWindow.h"

static LLDebugTool *_instance = nil;

@interface LLDebugTool (){
    /**
     丢包个数
     */
    float _packetCount;
}

@property (nonatomic , strong , nonnull) LLWindow *window;

@property (nonatomic , copy , nonnull) NSString *versionNumber;

@end

@implementation LLDebugTool

/**
 * Singleton
 @return Singleton
 */
+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLDebugTool alloc] init];
        [_instance initial];
    });
    return _instance;
}

- (void)startWorking{
    if (!_isWorking) {
        _isWorking = YES;
        LLConfigAvailableFeature available = [LLConfig sharedConfig].availables;
        if (available & LLConfigAvailableCrash) {
            // Open crash helper
            [[LLCrashHelper sharedHelper] setEnable:YES];
        }
        if (available & LLConfigAvailableLog) {
            // Open log helper
            [[LLLogHelper sharedHelper] setEnable:YES];
        }
        if (available & LLConfigAvailableNetwork) {
            // Open network monitoring
            [[LLNetworkHelper sharedHelper] setEnable:YES];
        }
        if (available & LLConfigAvailableAppInfo) {
            // Open app monitoring
            [[LLAppHelper sharedHelper] setEnable:YES];
        }
        if (available & LLConfigAvailableScreenshot) {
            // Open screenshot
            [[LLScreenshotHelper sharedHelper] setEnable:YES];
        }
        // show window
        [self.window showWindow];
    }
}

- (void)stopWorking {
    if (_isWorking) {
        _isWorking = NO;
        // Close screenshot
        [[LLScreenshotHelper sharedHelper] setEnable:NO];
        // Close app monitoring
        [[LLAppHelper sharedHelper] setEnable:NO];
        // Close network monitoring
        [[LLNetworkHelper sharedHelper] setEnable:NO];
        // Close log helper
        [[LLLogHelper sharedHelper] setEnable:NO];
        // Close crash helper
        [[LLCrashHelper sharedHelper] setEnable:NO];
        // hide window
        [self.window hideWindow];
    }
}

- (void)showDebugViewControllerWithIndex:(NSInteger)index {
//    [[LLHomeWindow shareInstance] showDebugViewControllerWithIndex:index];
}

- (void)logInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo level:(LLConfigLogLevel)level onEvent:(NSString *)onEvent message:(NSString *)message {
    if (![LLConfig sharedConfig].showDebugToolLog) {
        NSArray *toolEvent = @[kLLLogHelperDebugToolEvent,kLLLogHelperFailedLoadingResourceEvent];
        if ([toolEvent containsObject:onEvent]) {
            return;
        }
    }
    [[LLLogHelper sharedHelper] logInFile:file function:function lineNo:lineNo level:level onEvent:onEvent message:message];
}

#pragma mark - Primary
/**
 Initial something.
 */
- (void)initial {
    
    //重新启动的时候，把所有的开关关掉
    [self saveMockSwitch:NO];
    [self saveLowNetworkSwitch:NO];
    [self saveLowMemorySwitch:NO];
    [self saveIOSMonkeySwitch:NO];
    [self saveCocosMonkeySwitch:NO];
    [self savePrivateNetworkSwitch:NO];
  
    // Set Default
    _packetCount = 0.0 ;
    
    _cmd_to_send = [[NSMutableString alloc] init];
    
    _cmd_to_receive = [[NSMutableString alloc] init];
    
    _cmd_seq_dict = [[NSMutableDictionary alloc] init];
    
    _isBetaVersion = NO;

    _versionNumber = @"1.2.2";

    _version = _isBetaVersion ? [_versionNumber stringByAppendingString:@"(BETA)"] : _versionNumber;
    
    
    // Check version.
    [self checkVersion];
    
    // Set window.
    CGFloat windowWidth = [LLConfig sharedConfig].suspensionBallWidth;
    self.window = [[LLWindow alloc] initWithFrame:CGRectMake(0, 0, windowWidth, windowWidth)];
}

- (void)checkVersion {
    [LLTool createDirectoryAtPath:[LLConfig sharedConfig].folderPath];
    __block NSString *filePath = [[LLConfig sharedConfig].folderPath stringByAppendingPathComponent:@"LLDebugTool.plist"];
    NSMutableDictionary *localInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if (!localInfo) {
        localInfo = [[NSMutableDictionary alloc] init];
    }
    NSString *version = localInfo[@"version"];
    // localInfo will be nil before version 1.1.2
    if (!version) {
        version = @"0.0.0";
    }
    
    if ([self.versionNumber compare:version] == NSOrderedDescending) {
        // Do update if needed.
        [self updateSomethingWithVersion:version completion:^(BOOL result) {
            if (!result) {
                NSLog(@"Failed to update old data");
            }
            [localInfo setObject:self.versionNumber forKey:@"version"];
            [localInfo writeToFile:filePath atomically:YES];
        }];
    }
    
    if (self.isBetaVersion) {
        // This method called in instancetype, can't use macros to log.
        [self logInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ level:LLConfigLogLevelAlert onEvent:kLLLogHelperDebugToolEvent message:kLLLogHelperUseBetaAlert];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Check whether has a new LLDebugTool version.
        if ([LLConfig sharedConfig].autoCheckDebugToolVersion) {
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://cocoapods.org/pods/LLDebugTool"]];
            NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error == nil && data != nil) {
                    NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSArray *array = [htmlString componentsSeparatedByString:@"http://cocoadocs.org/docsets/LLDebugTool/"];
                    if (array.count > 2) {
                        NSString *str = array[1];
                        NSArray *array2 = [str componentsSeparatedByString:@"/preview.png"];
                        if (array2.count >= 2) {
                            NSString *newVersion = array2[0];
                            if ([newVersion componentsSeparatedByString:@"."].count == 3) {
                                if ([self.version compare:newVersion] == NSOrderedAscending) {
                                    NSString *message = [NSString stringWithFormat:@"A new version for LLDebugTool is available, New Version : %@, Current Version : %@",newVersion,self.version];
                                    [self logInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ level:LLConfigLogLevelAlert onEvent:kLLLogHelperDebugToolEvent message:message];
                                }
                            }
                        }
                    }
                }
            }];
            [dataTask resume];
        }
    });
}

- (void)updateSomethingWithVersion:(NSString *)version completion:(void (^)(BOOL result))completion {
    // Refactory database. Need rename tableName and table structure.
    if ([version compare:@"1.1.3"] == NSOrderedAscending) {
        [[LLStorageManager sharedManager] updateDatabaseWithVersion:@"1.1.3" complete:^(BOOL result) {
            if (completion) {
                completion(result);
            }
        }];
    }
}


- (void)addPrivateNetworkSendBlock:(void(^)(NSString *command))block{
    self.sendBlock = block ;
}

- (void)addPrivateNetworkReceiveBlock:(void(^)(NSString *command))block{
    self.receiveBlock = block ;
}


- (void)dealWithResponseData:(NSString *)command response:(NSData *)response request:(NSData *)request date:(NSDate *)date{
    LLNetworkModel *model = [[LLNetworkModel alloc] init];
    model.startDate = [LLTool stringFromDate:date];
    NSURLComponents *components = [NSURLComponents new] ;
    [components setHost:command] ;
    model.url = components.URL ;
    model.requestBody = [LLTool convertJSONStringFromData:request];
    model.responseData = response ;
    model.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSinceDate:date]];
    
    //request 和 response 为解包后的 bzibuff ，所以统计的流量只有bzibuff的量大小，而包头以及bzibuff在实际传输过程中的压缩以及加密等均不考虑
    [[LLStorageManager sharedManager] saveModel:model complete:nil];
    
    [LLRoute updateRequestDataTraffic:model.requestDataTrafficValue responseDataTraffic:model.responseDataTrafficValue];
}


- (void)dealWithHttpResponseData:(NSString *)command response:(NSData *)response request:(NSData *)request date:(NSDate *)date{
    LLNetworkModel *model = [[LLNetworkModel alloc] init];
    model.startDate = [LLTool stringFromDate:date];
    
    
    //request
    NSDictionary* req_dict = [NSJSONSerialization JSONObjectWithData:request options:NSJSONReadingAllowFragments error:nil];
    
    NSString *jce_body = [req_dict objectForKey:@"jce_body"] ;
    NSString *jce_method = [req_dict objectForKey:@"jce_method"] ;
    NSString *jce_header = [req_dict objectForKey:@"jce_header"] ;
    NSString *jce_domain = [req_dict objectForKey:@"jce_domain"] ;
    
    NSURLComponents *components = [NSURLComponents new] ;
    [components setHost:command] ;
    model.url = components.URL ;
    model.requestBody = jce_body;
    model.method = jce_method ;
    model.headerFields = [NSDictionary dictionaryWithObject:jce_header forKey:@"headers"] ;
    
    
    //rsponse
    NSDictionary* response_dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    NSString *httpResponseStatusCode = [response_dict objectForKey:@"httpResponseStatusCode"] ;
    NSString *httpResponseVersion = [response_dict objectForKey:@"httpResponseVersion"] ;
    NSDictionary *httpResponseHeader = [response_dict objectForKey:@"httpResponseHeader"] ;
    NSString *httpResponseBody = [response_dict objectForKey:@"httpResponseBody"] ;
    
    model.statusCode = httpResponseStatusCode ;
    model.responseData = [httpResponseBody dataUsingEncoding:NSUTF8StringEncoding] ;
    model.responseHeaderFields = httpResponseHeader ;
    
    
    model.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSinceDate:date]];
    
    //request 和 response 为解包后的 bzibuff ，所以统计的流量只有bzibuff的量大小，而包头以及bzibuff在实际传输过程中的压缩以及加密等均不考虑
    [[LLStorageManager sharedManager] saveModel:model complete:nil];
    
    [LLRoute updateRequestDataTraffic:model.requestDataTrafficValue responseDataTraffic:model.responseDataTrafficValue];
}


static NSString * const kLLMockKey = @"ll_mock_key";
static NSString * const kLLLowNetworkKey = @"ll_low_network_key";
static NSString * const kLLLowMemoryKey = @"ll_low_memory_key";
static NSString * const kLLIOSMonkeyKey = @"ll_ios_monkey_key";
static NSString * const kLLCocosMonkeyKey = @"ll_cocos_monkey_key";
static NSString * const kLLPrivateNetworkKey = @"ll_private_network_key";


- (void)saveMockSwitch:(BOOL)on{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:on forKey:kLLMockKey];
    [defaults synchronize];
}

- (BOOL)mockSwitch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kLLMockKey];
}


- (void)saveLowNetworkSwitch:(BOOL)on{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:on forKey:kLLLowNetworkKey];
    [defaults synchronize];
}

- (BOOL)lowNetworkSwitch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kLLLowNetworkKey];
}

- (void)saveLowMemorySwitch:(BOOL)on{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:on forKey:kLLLowMemoryKey];
    [defaults synchronize];
}

- (BOOL)lowMemorySwitch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kLLLowMemoryKey];
}

- (BOOL)iosMonkeySwitch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kLLIOSMonkeyKey];
}

- (void)saveIOSMonkeySwitch:(BOOL)on{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:on forKey:kLLIOSMonkeyKey];
    [defaults synchronize];
}

- (BOOL)cocosMonkeySwitch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kLLCocosMonkeyKey];
}

- (void)saveCocosMonkeySwitch:(BOOL)on{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:on forKey:kLLCocosMonkeyKey];
    [defaults synchronize];
}

- (BOOL)privateNetworkSwitch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kLLPrivateNetworkKey];
}

- (void)savePrivateNetworkSwitch:(BOOL)on{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:on forKey:kLLPrivateNetworkKey];
    [defaults synchronize];
}

//丢包率为0.08
- (BOOL)isPacketLoss:(float)increase{
    NSLog(@"haleli >>> packet_count : %f",_packetCount) ;
    _packetCount = _packetCount + increase ;
    if(_packetCount > 1){
        _packetCount = 0.0 ;
        return TRUE ;
    }
    return FALSE ;
}
- (void)setPacketCount:(float)packetCount{
    _packetCount = packetCount ;
}

- (void)simulateDirectTakeScreenshot:(NSString *)imagePath{
    [[LLScreenshotHelper sharedHelper] simulateDirectTakeScreenshot:imagePath] ;
}

- (NSMutableArray *)copySourceFileArr:(NSArray*)sourceFileArr toDestDir:(NSString*)destDir{
    NSMutableArray* tempFiles = [[NSMutableArray alloc] init];
    for(NSString* filePath in sourceFileArr) {
        NSString* name = [[[filePath lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"txt"];
        NSString* newPath = [destDir stringByAppendingPathComponent:name];
        if([[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:newPath error:nil];
        }
        [[NSFileManager defaultManager] copyItemAtPath:filePath
                                                toPath:newPath
                                                 error:nil];
        [tempFiles addObject:newPath];
        
    }
    
    return tempFiles ;
    
}

- (void)addCocosCreatorTree:(CocosCreatorTree)ccTree{
    self.ccTree = ccTree ;
}

- (void)addUploadLog:(UploadLog)uploadLog{
    self.uploadLog = uploadLog ;
}
@end
