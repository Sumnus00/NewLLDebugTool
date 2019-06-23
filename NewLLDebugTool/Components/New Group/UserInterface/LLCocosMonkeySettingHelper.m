//
//  LLCocosMonkeySettingHelper.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/22.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLCocosMonkeySettingHelper.h"
#import "LLStorageManager.h"
#import "NSObject+LL_Utils.h"
#import "LLConfig.h"

static LLCocosMonkeySettingHelper *_instance = nil;

@implementation LLCocosMonkeySettingHelper

+ (instancetype _Nonnull)sharedHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLCocosMonkeySettingHelper alloc] init];
        [_instance initial];
    });
    return _instance;
}

/**
 Initial something.
 */
- (void)initial {
    __weak typeof(self) weakSelf = self;
    _monkeySettingModel = [[LLMonkeySettingModel alloc] initWithIdentity:kCocosMonekyIdentity] ;
    [[LLStorageManager sharedManager] getModels:[LLMonkeySettingModel class] launchDate:@"" storageIdentity:_monkeySettingModel.storageIdentity complete:^(NSArray<LLMonkeySettingModel *> *result) {
        if(result.count==0){
            [[LLStorageManager sharedManager] saveModel:weakSelf.monkeySettingModel complete:nil];
        }else{
            weakSelf.monkeySettingModel = [result objectAtIndex:0] ;
        }
    } synchronous:YES];
}

-(BOOL)update{
    __block BOOL flag = false ;
    [[LLStorageManager sharedManager] updateModel:_monkeySettingModel complete:^(BOOL result) {
        flag = result ;
    } synchronous:YES];
    return flag ;
}

-(BOOL)setAlgorithm:(NSString *)algorithm{
    _monkeySettingModel.algorithm = algorithm ;
    return [self update] ;
}

-(BOOL)setDate:(NSString *)date{
    _monkeySettingModel.date = date ;
    return [self update] ;
}

-(BOOL)setBlacklist:(NSMutableArray<NSString *> *)blacklist{
    _monkeySettingModel.blacklist = blacklist ;
    return [self update] ;
}

-(BOOL)setWhitelist:(NSMutableArray<NSString *> *)whitelist{
    _monkeySettingModel.whitelist = whitelist ;
    return [self update] ;
}
@end
