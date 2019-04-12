//
//  UIView+Tree.m
//  TenMinDemo
//
//  Created by haleli on 2019/4/8.
//  Copyright © 2019 CYXiang. All rights reserved.
//

#import "UIView+Tree.h"

@implementation UIView (Tree)

+(NSMutableArray *)tree{
    NSMutableArray *array = [NSMutableArray array];
    NSArray* windows = [UIApplication sharedApplication].windows;
    if(windows.count == 1) {
        [windows[0] subviews:array];
    } else {
        for (UIWindow* window in windows) {
            [window subviews:array];
        }
    }
    return array ;
}


- (void)subviews:(NSMutableArray *)array
{
    NSString* identifier = self.accessibilityIdentifier;
    
    if(identifier){
        NSString* className = NSStringFromClass([self class]);
        if([className isEqual:@"UITabBar"] ||
           [className isEqual:@"UITableView"] ||
           [className isEqual:@"UISwitch"] ||
           [className isEqual:@"UINavigationBar"]){

            [array addObject:@{@"identifier":identifier,@"className":className}] ;
        }
    }
    for (UIView *view in self.subviews) {
        [view subviews:array];
    }
}
@end
