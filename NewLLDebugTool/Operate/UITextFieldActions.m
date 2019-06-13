//
//  UITextFieldActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/16.
//  Copyright © 2019 li. All rights reserved.
//

#import "UITextFieldActions.h"

@implementation UITextFieldActions
+(void)clearTextFromAndThenEnterTextWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UITextField class]]){
        //删除文案
        [tester clearTextFromElement:element inView:view] ;
        //输入文案
        NSString *text = [self randomStringWithLength:(arc4random()%10 + 1 )] ;
        [tester enterText:text intoElement:element inView:view expectedResult:text] ;
        
        //放弃成为第一响应
        [((UITextField*)view) resignFirstResponder] ;
    }
}

+(NSString *)randomStringWithLength:(NSInteger)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length])]];
    }
    return randomString;
}
@end
