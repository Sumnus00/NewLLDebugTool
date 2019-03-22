//
//  UINavigationController+AutoRotate.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/3/22.
//  Copyright © 2019 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (AutoRotate)
-(BOOL)shouldAutorotate;
-(UIInterfaceOrientationMask)supportedInterfaceOrientations;
@end

NS_ASSUME_NONNULL_END
