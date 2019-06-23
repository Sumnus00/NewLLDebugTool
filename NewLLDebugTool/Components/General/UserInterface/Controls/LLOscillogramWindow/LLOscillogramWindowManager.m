//
//  LLOscillogramWindowManager.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/17.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLOscillogramWindowManager.h"
#import "CoverageOscillogramWindow.h"
#import "LLMacros.h"
@interface LLOscillogramWindowManager()
@property (nonatomic, strong) CoverageOscillogramWindow *coverageWindow;
@end

@implementation LLOscillogramWindowManager
+ (LLOscillogramWindowManager *)shareInstance{
    static dispatch_once_t once;
    static LLOscillogramWindowManager *instance;
    dispatch_once(&once, ^{
        instance = [[LLOscillogramWindowManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _coverageWindow = [CoverageOscillogramWindow shareInstance];
    }
    return self;
}

- (void)resetLayout{
    CGFloat offsetY = 0;
    CGFloat width = 0;
    CGFloat height = kLLSizeFrom750_Landscape(240);
    if (kInterfaceOrientationPortrait){
        width = LL_SCREEN_WIDTH;
        offsetY = IPHONE_TOPSENSOR_HEIGHT;
    }else{
        width = LL_SCREEN_HEIGHT;
    }
    if (!_coverageWindow.hidden) {
        _coverageWindow.frame = CGRectMake(0, offsetY, width, height);
        offsetY += _coverageWindow.frame.size.height+kLLSizeFrom750(4);
    }
}

@end
