//
//  PrivateNetwork+Swizzling.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/1/30.
//  Copyright © 2019 li. All rights reserved.
//

#import "PrivateNetwork+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation PrivateNetwork (Swizzling)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzling_instanceMethodWithOriginSel:@selector(sendBizData:) swizzledSel:@selector(swizzle_sendBizData:) ];
        [self swizzling_instanceMethodWithOriginSel:@selector(didReceviedData:) swizzledSel:@selector(swizzle_didReceviedData:)];
    });
}

- (void)swizzle_sendBizData:(NSString *)data{
    NSLog(@"swizzle send data : %@",data) ;
    [self swizzle_sendBizData:data] ;
}
- (void)swizzle_didReceviedData:(NSString *)data{
    NSLog(@"swizzle receive data : %@",data) ;
    [self swizzle_didReceviedData:data] ;
}

@end
