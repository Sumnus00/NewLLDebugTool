//
//  UIView+ViewCoverage.h
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/15.
//  Copyright © 2019 li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+Swizzling.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIView (ViewCoverage)
- (void)showFrameLineRecursive ;
- (void)hideFrameLineRecursive ;
@end

NS_ASSUME_NONNULL_END
