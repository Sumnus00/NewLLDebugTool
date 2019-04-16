//
//  UISegmentedControlActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/16.
//  Copyright © 2019 li. All rights reserved.
//

#import "UISegmentedControlActions.h"

@implementation UISegmentedControlActions
+(void)tapSegmentedControlWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UISegmentedControl class]]){
        long int count = ((UISegmentedControl *)view).numberOfSegments;
        if(count > 0){
            NSString* accessibilityLabel = [[((UISegmentedControl *)view) subviews] objectAtIndex:arc4random() % count].accessibilityLabel ;
            
            if([tester tryFindingViewWithAccessibilityLabel:accessibilityLabel error:nil]){
                [tester tapViewWithAccessibilityLabel:accessibilityLabel] ;
            }
        }
    }
}
@end
