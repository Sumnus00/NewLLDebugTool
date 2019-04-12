//
//  UITouch+FakeTouch.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/9.
//  Copyright © 2019 li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOHIDEvent+KIF.h"
#import "FixCategoryBug.h"

KW_FIX_CATEGORY_BUG_H(UITouch_FakeTouch)

@interface UITouch ()


- (void)setWindow:(UIWindow *)window;
- (void)setView:(UIView *)view;
- (void)setTapCount:(NSUInteger)tapCount;
- (void)setIsTap:(BOOL)isTap;
- (void)setTimestamp:(NSTimeInterval)timestamp;
- (void)setPhase:(UITouchPhase)touchPhase;
- (void)setGestureView:(UIView *)view;
- (void)_setLocationInWindow:(CGPoint)location resetPrevious:(BOOL)resetPrevious;
- (void)_setIsFirstTouchForView:(BOOL)firstTouchForView;

- (void)_setHidEvent:(IOHIDEventRef)event;
- (void)kif_setHidEvent ;
@end

@interface UITouch (FakeTouch)
- (id)initAtPoint:(CGPoint)point inWindow:(UIWindow *)window;
@end
