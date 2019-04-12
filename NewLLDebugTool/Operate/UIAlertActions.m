//
//  UIAlertActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/11.
//  Copyright © 2019 li. All rights reserved.
//

#import "UIAlertActions.h"
#import "FindTopController.h"

@implementation UIAlertActions
+(void)acknowledgeAlert{
    UIViewController *controller = [FindTopController topController] ;
    if([controller isKindOfClass:[UIAlertController class]]){
        UIAlertController *alert = ((UIAlertController *)controller) ;
        long int count = alert.actions.count ;
        if(count > 0){
            UIAlertAction *action = [alert.actions objectAtIndex:arc4random() % count] ;
            NSString* accessibilityLabel = action.title ;
            if([tester tryFindingViewWithAccessibilityLabel:accessibilityLabel error:nil]){
                [tester tapViewWithAccessibilityLabel:accessibilityLabel] ;
            }
        }
    }
}
@end
