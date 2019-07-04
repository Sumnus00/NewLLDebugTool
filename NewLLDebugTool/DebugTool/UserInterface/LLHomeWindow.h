//
//  LLHomeWindow.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/6/25.
//  Copyright © 2019 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLHomeWindow : UIWindow

/**
 Root viewController. tabbar风格
 */
@property (nonatomic , strong) UITabBarController *tabVC;


/**
 Root viewController. 表格风格
 */
@property (nonatomic , strong) UINavigationController *navVC;

/**
 Init the window.
 */
+ (LLHomeWindow *)shareInstance;

/**
 Show window.
 */
- (void)showWindow:(NSInteger)index ;

/**
 Hide window.
 */
- (void)hideWindow;


/**
 Automatic open debug view controller with index.
 */
- (void)showDebugViewControllerWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
