//
//  UINavigationController+AutoRotate.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/3/22.
//  Copyright © 2019 li. All rights reserved.
//

#import "UINavigationController+AutoRotate.h"

@implementation UINavigationController (AutoRotate)
-(BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}
@end
