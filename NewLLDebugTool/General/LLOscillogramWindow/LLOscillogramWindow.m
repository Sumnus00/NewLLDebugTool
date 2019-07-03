//
//  LLOscillogramWindow.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/17.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLOscillogramWindow.h"
#import "UIColor+LL_Utils.h"
#import "LLOscillogramWindowManager.h"

@implementation LLOscillogramWindow

+ (LLOscillogramWindow *)shareInstance{
    static dispatch_once_t once;
    static LLOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[LLOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 2.f;
        self.backgroundColor = [UIColor ll_colorWithHex:0x000000 andAlpha:0.0];
        self.layer.masksToBounds = YES;
        
        [self addRootVc];
    }
    return self;
}

- (void)addRootVc{
    //需要子类重写
}

- (void)becomeKeyWindow{
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    [appWindow makeKeyWindow];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return NO;
}

- (void)show{
    self.hidden = NO;
    [_vc startRecord];
    [self resetLayout];
}

- (void)hide{
    [_vc endRecord];
    self.hidden = YES;
    [self resetLayout];
}

- (void)resetLayout{
    [[LLOscillogramWindowManager shareInstance] resetLayout];
}

@end
