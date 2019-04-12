//
//  UIApplication+FakeTouchPrivate.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/9.
//  Copyright © 2019 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (FakeTouchPrivate)
-(UIEvent *)_touchesEvent;
@end

NS_ASSUME_NONNULL_END
