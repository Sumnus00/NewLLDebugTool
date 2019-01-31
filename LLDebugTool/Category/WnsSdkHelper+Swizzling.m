//
//  WnsSdkHelper+Swizzling.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/1/30.
//  Copyright © 2019 li. All rights reserved.
//

#import "WnsSdkHelper+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>



@implementation WnsSdkHelper


@end

@implementation WnsSdkHelper (Swizzling)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzling_instanceMethodWithOriginSel:@selector(sendBizData:) swizzledSel:@selector(swizzle_sendBizData:) ];
    });
}

- (long)swizzle_sendBizData:(WnsBizSendData *)bizData{
    NSLog(@"swizzle send data : %@",bizData) ;
    return [self swizzle_sendBizData:bizData] ;
}


@end
