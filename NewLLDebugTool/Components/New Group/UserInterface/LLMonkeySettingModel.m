//
//  LLMonkeySettingModel.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/21.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLMonkeySettingModel.h"
#import "LLTool.h"
#import "NSObject+LL_Utils.h"

@implementation LLMonkeySettingModel
- (instancetype _Nonnull)initWithIdentity:(NSString *_Nullable)identity{
    if (self = [super init]) {
        _identity = identity;
        _algorithm = @"快速遍历算法";
        _date = @"连续运行";
    }
    return self;
}

- (NSString *)storageIdentity {
    return self.identity;
}

@end
