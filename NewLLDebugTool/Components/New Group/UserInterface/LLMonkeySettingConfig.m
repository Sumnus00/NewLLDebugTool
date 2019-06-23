//
//  LLMonkeySettingConfig.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/21.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLMonkeySettingConfig.h"
#import "LLConfig.h"
#import "CoverageOscillogramWindow.h"


@implementation LLMonkeySettingConfig

+ (instancetype)defaultConfig
{
    static LLMonkeySettingConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [LLMonkeySettingConfig new];
    });
    
    return sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.monkeyType = IOSMonkeyType ;
        self.listType = BlackListType ;
        self.coverageTextEnable = NO;
    }
    return self;
}

- (void)setCoverageTextEnable:(BOOL)enable
{
    _coverageTextEnable = enable;
    if(enable){
        [[CoverageOscillogramWindow shareInstance] show];
    }else{
        [[CoverageOscillogramWindow shareInstance] hide] ;
    }
}

@end
