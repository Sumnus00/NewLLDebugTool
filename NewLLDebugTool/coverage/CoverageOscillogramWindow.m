//
//  CoverageOscillogramWindow.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/17.
//  Copyright © 2019 li. All rights reserved.
//

#import "CoverageOscillogramWindow.h"
#import "CoverageOscillogramViewController.h"

@implementation CoverageOscillogramWindow
+ (CoverageOscillogramWindow *)shareInstance{
    static dispatch_once_t once;
    static CoverageOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[CoverageOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (void)addRootVc{
    CoverageOscillogramViewController *vc = [[CoverageOscillogramViewController alloc] init];
    self.rootViewController = vc;
    self.vc = vc;
}
@end
