//
//  UIColor+LL_Utils.h
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/17.
//  Copyright © 2019 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (LL_Utils)
+ (UIColor *)ll_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
