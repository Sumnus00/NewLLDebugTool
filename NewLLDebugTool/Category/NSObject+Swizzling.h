//
//  NSObject+Swizzling.h
//  SwizzleExample
//
//  Created by haleli on 2019/1/30.
//  Copyright © 2019 haleli. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (Swizzling)

/**
 swizzle 类方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 */
+ (void)swizzling_classMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

/**
 swizzle 实例方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 */
+ (void)swizzling_instanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

@end

