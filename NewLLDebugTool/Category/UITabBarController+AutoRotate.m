//
//  UITabBarController+AutoRotate.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/3/22.
//  Copyright © 2019 li. All rights reserved.
//

#import "UITabBarController+AutoRotate.h"

@implementation UITabBarController (AutoRotate)
-(BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}
@end
