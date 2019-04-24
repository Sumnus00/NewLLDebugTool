//
//  UISwitchActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/11.
//  Copyright © 2019 li. All rights reserved.
//

#import "UISwitchActions.h"

@implementation UISwitchActions
+ (void)setSwitchWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UISwitch class]]){
        if(((UISwitch*)view).isOn){
            [tester setSwitch:view element:element On:FALSE] ;
        }else{
            [tester setSwitch:view element:element On:TRUE] ;
        }
    }
}
@end
