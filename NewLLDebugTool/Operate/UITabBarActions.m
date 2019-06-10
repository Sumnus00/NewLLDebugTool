//
//  UITabBarActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/11.
//  Copyright © 2019 li. All rights reserved.
//

#import "UITabBarActions.h"

@implementation UITabBarActions
+(void)tapTabBarWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UITabBar class]]){
        long int random = arc4random() % ((UITabBar *)view).items.count;
        if(random > 0){
            int i = 0 ;
            for(UIView* subView in view.subviews){
                if([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]){
                    if(i==random){
                        NSString* accessibilityIdentifier = subView.accessibilityIdentifier;
                        
                        UIView *view = nil;
                        UIAccessibilityElement *element = nil;
                        
                        NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",accessibilityIdentifier] ;
                        
                        [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
                        
                        if([view isKindOfClass:NSClassFromString(@"UITabBarButton")]){
                            [tester tapAccessibilityElement:element inView:view] ;
                        }
                        break ;
                    }
                    i = i + 1 ;
                }
            }
          
        }
    }
}
@end
