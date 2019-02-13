////
////  NSMutableArray+Swizzling.m
////  SwizzleExample
////
////  Created by haleli on 2019/1/30.
////  Copyright © 2019 haleli. All rights reserved.
////
//
//#import "NSMutableArray+Swizzling.h"
//#import "NSObject+Swizzling.h"
//#import <objc/runtime.h>
//
//@implementation NSMutableArray (Swizzling)
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [objc_getClass("__NSArrayM") swizzling_instanceMethodWithOriginSel:@selector(removeObject:) swizzledSel:@selector(safeRemoveObject:) ];
//        [objc_getClass("__NSArrayM") swizzling_instanceMethodWithOriginSel:@selector(addObject:) swizzledSel:@selector(safeAddObject:)];
//        [objc_getClass("__NSArrayM") swizzling_instanceMethodWithOriginSel:@selector(removeObjectAtIndex:) swizzledSel:@selector(safeRemoveObjectAtIndex:)];
//        [objc_getClass("__NSArrayM") swizzling_instanceMethodWithOriginSel:@selector(insertObject:atIndex:) swizzledSel:@selector(safeInsertObject:atIndex:)];
//        [objc_getClass("__NSArrayM") swizzling_instanceMethodWithOriginSel:@selector(objectAtIndex:) swizzledSel:@selector(safeObjectAtIndex:)];
//    });
//}
//- (void)safeAddObject:(id)obj {
//    NSLog(@"NSMutableArray+Swizzling >>>> safeAddObject") ;
//    if (obj == nil) {
//        NSLog(@"%s can add nil object into NSMutableArray", __FUNCTION__);
//    } else {
//        [self safeAddObject:obj];
//    }
//}
//- (void)safeRemoveObject:(id)obj {
//    NSLog(@"NSMutableArray+Swizzling >>>> safeAddObject") ;
//    if (obj == nil) {
//        NSLog(@"%s call -removeObject:, but argument obj is nil", __FUNCTION__);
//        return;
//    }
//    [self safeRemoveObject:obj];
//}
//- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index {
//    NSLog(@"NSMutableArray+Swizzling >>>> safeInsertObject") ;
//    if (anObject == nil) {
//        NSLog(@"%s can't insert nil into NSMutableArray", __FUNCTION__);
//    } else if (index > self.count) {
//        NSLog(@"%s index is invalid", __FUNCTION__);
//    } else {
//        [self safeInsertObject:anObject atIndex:index];
//    }
//}
//- (id)safeObjectAtIndex:(NSUInteger)index {
//    NSLog(@"NSMutableArray+Swizzling >>>> safeObjectAtIndex") ;
//    if (self.count == 0) {
//        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
//        return nil;
//    }
//    if (index > self.count) {
//        NSLog(@"%s index out of bounds in array", __FUNCTION__);
//        return nil;
//    }
//    return [self safeObjectAtIndex:index];
//}
//- (void)safeRemoveObjectAtIndex:(NSUInteger)index {
//    NSLog(@"NSMutableArray+Swizzling >>>> safeRemoveObjectAtIndex") ;
//    if (self.count <= 0) {
//        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
//        return;
//    }
//    if (index >= self.count) {
//        NSLog(@"%s index out of bound", __FUNCTION__);
//        return;
//    }
//    [self safeRemoveObjectAtIndex:index];
//}
//@end
