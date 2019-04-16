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
        if(
           [className isEqual:@"UITabBar"] ||
           [className isEqual:@"UITableView"] ||
           [className isEqual:@"UISwitch"] ||
           [className isEqual:@"UINavigationBar"] ||
           [className isEqual:@"UITextField"] ||
           [className isEqual:@"UIButton"] ||
           [className isEqual:@"UISegmentedControl"] ||
           [className isEqual:@"UICollectionView"]){
            
            
            //UITableViewCell的默认UIButton无法点击，点击会发生crash。这个不影响button的功能，因为cell是可以点击的
            if(!([className isEqual:@"UIButton"] && [[self superview] isKindOfClass:[UITableViewCell class]])){
                [array addObject:@{@"identifier":identifier,@"className":className}] ;
            }
        }
    }
    for (UIView *view in self.subviews) {
        [view subviews:array];
    }
}
@end
