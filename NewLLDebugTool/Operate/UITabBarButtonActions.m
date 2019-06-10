//
//  UITabBarButtonActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/6/10.
//  Copyright © 2019 li. All rights reserved.
//

#import "UITabBarButtonActions.h"

@implementation UITabBarButtonActions
+(void)tapTabBarButtonWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    if([view isKindOfClass:NSClassFromString(@"UITabBarButton")]){
        [tester tapAccessibilityElement:element inView:view] ;
    }
}
@end
