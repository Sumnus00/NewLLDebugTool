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
        long int count = ((UITabBar *)view).items.count;
        if(count > 0){
            NSString* accessibilityLabel = [((UITabBar*)view).items objectAtIndex:arc4random() % count].accessibilityLabel ;
            if([tester tryFindingViewWithAccessibilityLabel:accessibilityLabel error:nil]){
                [tester tapViewWithAccessibilityLabel:accessibilityLabel] ;
            }
        }
    }
}
@end
