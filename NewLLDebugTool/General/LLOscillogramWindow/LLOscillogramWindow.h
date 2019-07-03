//
//  LLOscillogramWindow.h
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/17.
//  Copyright © 2019 li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLOscillogramViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface LLOscillogramWindow : UIWindow
+ (LLOscillogramWindow *)shareInstance;
@property (nonatomic, strong) LLOscillogramViewController *vc;
//需要子类重写
- (void)addRootVc;

- (void)show;

- (void)hide;
@end

NS_ASSUME_NONNULL_END
