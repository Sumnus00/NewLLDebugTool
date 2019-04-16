//
//  UIButtonActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/16.
//  Copyright © 2019 li. All rights reserved.
//

#import "UIButtonActions.h"

@implementation UIButtonActions
+(void)tapButtonWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UIButton class]]){
        [tester tapAccessibilityElement:element inView:view] ;
    }
}
@end
