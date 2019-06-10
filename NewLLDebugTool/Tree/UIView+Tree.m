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

+(NSMutableDictionary *)tree1{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray* windows = [UIApplication sharedApplication].windows;
    if(windows.count == 1) {
        [windows[0] subviews1:dict];
    } else {
        for (UIWindow* window in windows) {
            [window subviews1:dict];
        }
    }
    return dict ;
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
           [className isEqual:@"UICollectionView"] ||
           [className isEqual:@"UITableViewCell"] ||
           [className isEqual:@"UICollectionViewCell"]
           ){
            
            
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



- (void)subviews1:(NSMutableDictionary *)dict
{
    NSString* identifier = self.accessibilityIdentifier;
    if(identifier){
        NSString* className = nil ;
        if([self isKindOfClass:[UITabBar class]]){
//            className = @"UITabBar" ;
//            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
//            [dict setObject:element forKey:element.elementId] ;
        }else if([self isKindOfClass:[UITableView class]]){
            className = @"UITableView" ;
            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
            [dict setObject:element forKey:element.elementId] ;

            if([self isKindOfClass:[UITableView class]]){
                NSInteger sections = ((UITableView *)self).numberOfSections ;
                for(int section = 0 ; section < sections; section++){
                    NSInteger rows = [((UITableView *)self) numberOfRowsInSection:section] ;
                    for(int row = 0 ; row < rows ; row++){
                        NSString* elementId = [NSString stringWithFormat:@"TBUIAutoTest_TableCell_%d_%d",section,row] ;
                        Element *element = [[Element alloc] initWithElementId:elementId elementName:elementId type:@"UITableViewCell"] ;
                        [element setInfoKey:@"section" withInfoValue:[NSString stringWithFormat:@"%d",section]] ;
                        [element setInfoKey:@"row" withInfoValue:[NSString stringWithFormat:@"%d",row]] ;
                        [element setInfoKey:@"accessibilityIdentifier" withInfoValue:identifier] ;
                        [dict setObject:element forKey:element.elementId] ;
                    }
                }
            }

        }else if([self isKindOfClass:[UISwitch class]]){
            className = @"UISwitch" ;
            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
            [dict setObject:element forKey:element.elementId] ;
        }else if([self isKindOfClass:[UINavigationBar class]]){
            className = @"UINavigationBar" ;
            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
            [dict setObject:element forKey:element.elementId] ;
        }else if([self isKindOfClass:[UITextField class]]){
            className = @"UITextField" ;
            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
            [dict setObject:element forKey:element.elementId] ;
        }else if([self isKindOfClass:[UIButton class]]){
            className = @"UIButton" ;
            //UITableViewCell的默认UIButton无法点击，点击会发生crash。这个不影响button的功能，因为cell是可以点击的
            if(!([className isEqual:@"UIButton"] && [[self superview] isKindOfClass:[UITableViewCell class]])){
                Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
                [dict setObject:element forKey:element.elementId] ;
            }
        }else if([self isKindOfClass:[UISegmentedControl class]]){
            className = @"UISegmentedControl" ;
            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
            [dict setObject:element forKey:element.elementId] ;
        }else if([self isKindOfClass:[UICollectionView class]]){
            className = @"UICollectionView" ;
            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
            [dict setObject:element forKey:element.elementId] ;

            if([self isKindOfClass:[UICollectionView class]]){
                NSInteger sections = ((UICollectionView *)self).numberOfSections ;
                for(int section = 0 ; section < sections; section++){
                    NSInteger items = [((UICollectionView *)self) numberOfItemsInSection:section] ; ;
                    for(int item = 0 ; item < items ; item++){
                        NSString* elementId = [NSString stringWithFormat:@"TBUIAutoTest_CollectionCell_%d_%d",section,item] ;
                        Element *element = [[Element alloc] initWithElementId:elementId elementName:elementId type:@"UICollectionViewCell"] ;
                        [element setInfoKey:@"section" withInfoValue:[NSString stringWithFormat:@"%d",section]] ;
                        [element setInfoKey:@"item" withInfoValue:[NSString stringWithFormat:@"%d",item]] ;
                        [element setInfoKey:@"accessibilityIdentifier" withInfoValue:identifier] ;
                        [dict setObject:element forKey:element.elementId] ;
                    }
                }
            }
        }else if([self isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            className = @"UITabBarButton" ;
            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
            [dict setObject:element forKey:element.elementId] ;
        }
    }
    for (UIView *view in self.subviews) {
        [view subviews1:dict];
    }
}
@end
