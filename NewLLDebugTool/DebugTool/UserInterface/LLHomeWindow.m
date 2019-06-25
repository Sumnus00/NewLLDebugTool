//
//  LLHomeWindow.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/6/25.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLHomeWindow.h"
#import "LLMacros.h"
#import "LLNetworkVC.h"
#import "LLAppInfoVC.h"
#import "LLSandboxVC.h"
#import "LLAppHelper.h"
#import "LLCrashVC.h"
#import "LLBaseNavigationController.h"
#import "LLImageNameConfig.h"
#import "LLConfig.h"
#import "LLLogVC.h"
#import "LLOtherVC.h"
#import "LLLogHelperEventDefine.h"
#import "LLDebugToolMacros.h"
#import "LLRoute.h"
@implementation LLHomeWindow



+ (LLHomeWindow *)shareInstance{
    static dispatch_once_t once;
    static LLHomeWindow *instance;
    dispatch_once(&once, ^{
        instance = [[LLHomeWindow alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT)];
    });
    return instance;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initial] ;
    }
    return self;
}

-(void)initial{
    // Set color
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    
    // Set level
    self.windowLevel = UIWindowLevelStatusBar + 200;
    
    //set hidden
    self.hidden = YES;
}

- (void)showWindow:(NSInteger)index {
    if (self.isHidden) {
        if ([[NSThread currentThread] isMainThread]) {
            // Set root
            _tabVC = [self tabVC] ;
            _tabVC.selectedIndex = index;
            self.rootViewController = _tabVC;
            self.hidden = NO;
        } else {
            [self performSelectorOnMainThread:@selector(showWindow) withObject:nil waitUntilDone:YES];
        }
    }
}

- (void)hideWindow {
    if (self.isHidden == NO) {
        if ([[NSThread currentThread] isMainThread]) {
            _tabVC = nil ;
            self.rootViewController = nil ;
            self.hidden = YES;
        } else {
            [self performSelectorOnMainThread:@selector(hideWindow) withObject:nil waitUntilDone:YES];
        }
    }
}

- (void)showDebugViewControllerWithIndex:(NSInteger)index {
    if ([LLConfig sharedConfig].availables == LLConfigAvailableScreenshot) {
        // Screenshot only. Don't open the window.
        LLog_Event(kLLLogHelperDebugToolEvent, @"Current availables is only screenshot, can't open the tabbar.");
        return;
    }

    if (![LLConfig sharedConfig].XIBBundle) {
        LLog_Warning_Event(kLLLogHelperFailedLoadingResourceEvent, [@"Failed to load the XIB bundle," stringByAppendingString:kLLLogHelperOpenIssueInGithub]);
        return;
    }

    if (![LLConfig sharedConfig].imageBundle) {
        LLog_Warning_Event(kLLLogHelperFailedLoadingResourceEvent, [@"Failed to load the image bundle," stringByAppendingString:kLLLogHelperOpenIssueInGithub]);
    }
    if ([[NSThread currentThread] isMainThread]) {
        [LLRoute hideWindow];
        [self showWindow:index] ;
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLRoute hideWindow];
            [self showWindow:index] ;
        });
    }
}

#pragma mark - Lazy load
- (UITabBarController *)tabVC {
    if (_tabVC == nil) {
        UITabBarController *tab = [[UITabBarController alloc] init];
        
        LLNetworkVC *networkVC = [[LLNetworkVC alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *networkNav = [[LLBaseNavigationController alloc] initWithRootViewController:networkVC];
        networkNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Network" image:[UIImage LL_imageNamed:kNetworkImageName] selectedImage:nil];
        networkNav.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
        networkNav.navigationBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
        
        LLLogVC *logVC = [[LLLogVC alloc] initWithStyle:UITableViewStylePlain];
        UINavigationController *logNav = [[LLBaseNavigationController alloc] initWithRootViewController:logVC];
        logNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Log" image:[UIImage LL_imageNamed:kLogImageName] selectedImage:nil];
        logNav.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
        logNav.navigationBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
        
        LLCrashVC *crashVC = [[LLCrashVC alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *crashNav = [[LLBaseNavigationController alloc] initWithRootViewController:crashVC];
        crashNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Crash" image:[UIImage LL_imageNamed:kCrashImageName] selectedImage:nil];
        crashNav.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
        crashNav.navigationBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
        
        LLAppInfoVC *appInfoVC = [[LLAppInfoVC alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *appInfoNav = [[LLBaseNavigationController alloc] initWithRootViewController:appInfoVC];
        appInfoNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"App" image:[UIImage LL_imageNamed:kAppImageName] selectedImage:nil];
        appInfoNav.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
        appInfoNav.navigationBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
        
        LLSandboxVC *sandboxVC = [[LLSandboxVC alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *sandboxNav = [[LLBaseNavigationController alloc] initWithRootViewController:sandboxVC];
        sandboxNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Sandbox" image:[UIImage LL_imageNamed:kSandboxImageName] selectedImage:nil];
        sandboxNav.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
        sandboxNav.navigationBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
        
        
        LLOtherVC *otherVC = [[LLOtherVC alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *otherNav = [[LLBaseNavigationController alloc] initWithRootViewController:otherVC];
        otherNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Other" image:[UIImage LL_imageNamed:kSandboxImageName] selectedImage:nil];
        otherNav.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
        otherNav.navigationBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
        
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        LLConfigAvailableFeature availables = [LLConfig sharedConfig].availables;
        if (availables & LLConfigAvailableNetwork) {
            [viewControllers addObject:networkNav];
        }
        //        if (availables & LLConfigAvailableLog) {
        //            [viewControllers addObject:logNav];
        //        }
        if (availables & LLConfigAvailableCrash) {
            [viewControllers addObject:crashNav];
        }
        if (availables & LLConfigAvailableAppInfo) {
            [viewControllers addObject:appInfoNav];
        }
        if (availables & LLConfigAvailableSandbox) {
            [viewControllers addObject:sandboxNav];
        }
        
        if (availables & LLConfigAvailableOther) {
            [viewControllers addObject:otherNav] ;
        }
        
        if (viewControllers.count == 0) {
            [LLConfig sharedConfig].availables = LLConfigAvailableAll;
            [viewControllers addObjectsFromArray:@[networkNav,logNav,crashNav,appInfoNav,sandboxNav,otherNav]];
        }
        
        tab.viewControllers = viewControllers;
        tab.tabBar.tintColor = LLCONFIG_TEXT_COLOR;
        tab.tabBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
        
        _tabVC = tab;
    }
    return _tabVC;
}

@end
