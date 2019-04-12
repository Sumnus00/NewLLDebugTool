//
//  UINavigationBarActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/11.
//  Copyright © 2019 li. All rights reserved.
//

#import "UINavigationBarActions.h"

@implementation UINavigationBarActions
+(void)tapNavigationBarWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UINavigationBar class]]){
        if(((UINavigationBar *)view).topItem.rightBarButtonItem){
            NSString* accessibilityLabel = ((UINavigationBar *)view).topItem.rightBarButtonItem.accessibilityLabel ;
            if([tester tryFindingViewWithAccessibilityLabel:accessibilityLabel error:nil]){
                [tester tapViewWithAccessibilityLabel:accessibilityLabel] ;
            }
        }else{
            [tester tapAccessibilityElement:element inView:view] ;
        }
    }
}
@end
