//
//  ViewBoundConfig.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/20.
//  Copyright © 2019 li. All rights reserved.
//

#import "ViewBoundConfig.h"
#import "UIView+ViewCoverage.h"

@implementation ViewBoundConfig
+ (instancetype)defaultConfig
{
    static ViewBoundConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ViewBoundConfig new];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.borderUnClickedColor = [UIColor redColor] ;
        self.borderClickedColor = [UIColor blueColor];
        self.borderWidth = 1;
        self.enable = NO;
    }
    return self;
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        [window frameLineRecursiveEnable:enable] ;
    }
}
@end
