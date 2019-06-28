//
//  UIView+TBUIAutoTest.m
//  TBUIAutoTestDemo
//
//  Created by 杨萧玉 on 16/3/3.
//  Copyright © 2016年 杨萧玉. All rights reserved.
//

#import "UIView+TBUIAutoTest.h"
#import "UIResponder+TBUIAutoTest.h"
#import "TBUIAutoTest.h"
#import <objc/runtime.h>

#define kiOS8Later SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation UIView (TBUIAutoTest)

+ (void)load
{
//    BOOL isAutoTestUI = [NSUserDefaults.standardUserDefaults boolForKey:kAutoTestUITurnOnKey];
    BOOL isAutoTestUI = TRUE ;
    if (isAutoTestUI)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class viewClass = NSClassFromString(@"UIView");
            [viewClass swizzleSelector:@selector(accessibilityIdentifier) withAnotherSelector:@selector(tb_accessibilityIdentifier)];
            if ([NSUserDefaults.standardUserDefaults boolForKey:kAutoTestUILongPressKey]) {
                [viewClass swizzleSelector:@selector(addSubview:) withAnotherSelector:@selector(tb_addSubview:)];
            }
        });
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (kiOS8Later) {
            CGFloat previousWidth = self.layer.borderWidth;
            CGColorRef previousColor =  self.layer.borderColor;
            self.layer.borderWidth = 3;
            self.layer.borderColor = [UIColor redColor].CGColor;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自动化测试Label" message:self.accessibilityIdentifier preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.layer.borderWidth = previousWidth;
                self.layer.borderColor = previousColor;
            }];
            [alert addAction:confirmAction];
            [[self viewController] presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - Generate Label

- (NSString *)labelForOriginalLabel:(NSString *)originalLabel
{
    if (originalLabel.length > 0) {
        if ([originalLabel hasPrefix:@"TBUIAutoTest_"]) {
            NSString *reuseLabel = [self labelForReuseView];
            if (reuseLabel.length > 0) {
                return reuseLabel;
            }
        }
        return originalLabel;
    }
    else if ([originalLabel isEqualToString:@"null"]) {
        originalLabel = @"";
    }
    
    if ([self isKindOfClass:UINavigationBar.class]) {
        NSString *result = [NSString stringWithFormat:@"TBUIAutoTest_NavigationItem_%@",((UINavigationBar *)self).topItem.title?: @""] ;
        //判断是否定义rightBarButtonItem
        if(((UINavigationBar *)self).topItem.rightBarButtonItem){
            NSString *title = ((UINavigationBar *)self).topItem.rightBarButtonItem.title ;
            ((UINavigationBar *)self).topItem.rightBarButtonItem.accessibilityLabel = [NSString stringWithFormat:@"TBUIAutoTest_BarButtonItem_%@",title?: @""] ;
        }else{
            NSLog(@"rightBarButtonItem is nil") ;
        }
        
        //判断是否定义leftBarButtonItem，不进行hook，back不需要该标签
//        if(((UINavigationBar *)self).topItem.leftBarButtonItem){
//            NSString *title = ((UINavigationBar *)self).topItem.leftBarButtonItem.title ;
//            ((UINavigationBar *)self).topItem.leftBarButtonItem.accessibilityLabel = [NSString stringWithFormat:@"TBUIAutoTest_BarButtonItem_%@",title] ;
//        }else if(((UINavigationBar *)self).backItem.backBarButtonItem){
//            NSString *title = ((UINavigationBar *)self).backItem.backBarButtonItem.title ;
//            ((UINavigationBar *)self).backItem.backBarButtonItem.accessibilityLabel = [NSString stringWithFormat:@"TBUIAutoTest_BarButtonItem_%@",title] ;
//        }else if(((UINavigationBar *)self).backItem.title){
//            NSLog(@"haleli >>> title : %@",((UINavigationBar *)self).backItem.title) ;
//        }
        
        return result;
    }
    
    NSString *labelStr = [self.superview findNameWithInstance:self];
    
    if (labelStr && ![labelStr isEqualToString:@""]) {
        labelStr = [NSString stringWithFormat:@"TBUIAutoTest_Property_%@_%@", NSStringFromClass([self class]),labelStr];
    }
    else {
        if ([self isKindOfClass:[UILabel class]]) {//UILabel 使用 text
            labelStr = [NSString stringWithFormat:@"TBUIAutoTest_Label_%@", ((UILabel *)self).text ?: @""];
        }
        else if ([self isKindOfClass:[UIImageView class]]) {//UIImageView 使用 image 的 imageName
            labelStr = [NSString stringWithFormat:@"TBUIAutoTest_ImageView_%@", ((UIImageView *)self).image.accessibilityIdentifier ?: [NSString stringWithFormat:@"image%ld", (long)((UIImageView *)self).tag]];
        }
        else if ([self isKindOfClass:[UIButton class]]) {//UIButton 使用 button 的 text 和 image
            labelStr = [NSString stringWithFormat:@"TBUIAutoTest_Button_%@_%@",((UIButton *)self).titleLabel.text ?: @"", ((UIButton *)self).imageView.image.accessibilityIdentifier ?: @""];
        }
        else if ([self isKindOfClass:[UISwitch class]]){ //UISwitch 使用 switch 的 tag
            labelStr = [NSString stringWithFormat:@"TBUIAutoTest_Switch_%ld",((UISwitch *)self).tag] ;
        }
        else if ([self isKindOfClass: [UITabBar class]]){
            labelStr = @"TBUIAutoTest_TabBar" ;
        }
        else if([self isKindOfClass:[UISegmentedControl class]]){
            long int count =  ((UISegmentedControl*)self).numberOfSegments ;
            NSString *str = @"" ;
            for(int i=0 ;i<count ;i++){
                NSString *title =  [((UISegmentedControl*)self) titleForSegmentAtIndex:i] ;
                str = [str stringByAppendingFormat:@"_%@",title?: @"" ] ;
            }
            labelStr = [@"TBUIAutoTest_UISegmentedControl" stringByAppendingFormat:@"%@",str];
        }
        else if([self isKindOfClass:[UITableView class]]){
            labelStr = @"TBUIAutoTest_Table" ;
        }
        else if([self isKindOfClass:[UICollectionView class]]){
            labelStr = @"TBUIAutoTest_Collection" ;
        }else if([self isKindOfClass:[UIPickerView class]]){
            labelStr = @"TBUIAutoTest_Picker" ;
        }
        
        NSString *label = [self labelForReuseView];
        if (label.length > 0) {
            labelStr = label;
        }
        if ([self isKindOfClass:[UIButton class]]) {
            self.accessibilityValue = [NSString stringWithFormat:@"TBUIAutoTest_Button_%@", ((UIButton *)self).currentBackgroundImage.accessibilityIdentifier ?: @""];
        }
    }
    if ([labelStr isEqualToString:@"TBUIAutoTest_"] || [labelStr isEqualToString:@"TBUIAutoTest_null"] || [labelStr isEqualToString:@"null"]) {
        labelStr = @"";
    }
    return labelStr;
}

- (NSString *)labelForReuseView
{
    
    if([self isKindOfClass:[UISegmentedControl class]]){//UISegmentedControl 特殊处理
        long int count =  ((UISegmentedControl*)self).numberOfSegments ;
        NSString *str = @"" ;
        for(int i=0 ;i<count ;i++){
            NSString *title =  [((UISegmentedControl*)self) titleForSegmentAtIndex:i] ;
            str = [str stringByAppendingFormat:@"_%@",title?: @"" ] ;
        }
        for(int i=0;i<count;i++){
            NSString *title =  [((UISegmentedControl*)self) titleForSegmentAtIndex:i] ;
            [[[[[((UISegmentedControl *)self) subviews] reverseObjectEnumerator] allObjects] objectAtIndex:i] setAccessibilityLabel:[NSString stringWithFormat:@"TBUIAutoTest_Segment_%@_%@",str,title?: @""]] ;
        }
//        int i = 0 ;
//        for(UIView* view in self.subviews){
//            if([view isKindOfClass:NSClassFromString(@"UISegment")]){
//                NSString *title =  [((UISegmentedControl*)self) titleForSegmentAtIndex:i] ;
//                NSString* accessibilityIdentifier = [NSString stringWithFormat:@"TBUIAutoTest_Segment_%@_%@",str,title?: @""] ;
//                [view setAccessibilityIdentifier:accessibilityIdentifier] ;
//
//                i = i + 1 ;
//            }
//        }
    }
    
    if ([self isKindOfClass:[UITabBar class]]){//UITabBarButton 特殊处理
//        long int count =  ((UITabBar*)self).items.count ;
//        for(int i=0 ; i<count ;i++){
//            NSString* title = [((UITabBar*)self).items objectAtIndex:i].title ;
//            [((UITabBar*)self).items objectAtIndex:i].accessibilityLabel = [NSString stringWithFormat:@"TBUIAutoTest_TabBar_%@",title?: @""] ;
//        }
        int i = 0 ;
        for(UIView* view in self.subviews){
            if([view isKindOfClass:NSClassFromString(@"UITabBarButton")]){
                NSString* title = [((UITabBar*)self).items objectAtIndex:i].title ;
                view.accessibilityIdentifier = [NSString stringWithFormat:@"TBUIAutoTest_TabBar_%@",title?: @""] ;
                i = i + 1 ;
            }
        }

    }
    
    if ([self isKindOfClass:[UITableViewCell class]]) {//UITableViewCell 特殊处理
        UIView *view = [self superview];
        while (view && [view isKindOfClass:[UITableView class]] == NO) {
            view = [view superview];
        }
        UITableView *tableView = (UITableView *)view;
//        tableView.accessibilityIdentifier = @"TBUIAutoTest_Table" ;
        NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)self];
    
        UITableViewCell *cell = ((UITableViewCell *)self) ;
        
        cell.textLabel.accessibilityIdentifier = [NSString stringWithFormat:@"TBUIAutoTest_TableCell_%@_%@_%ld_%ld", ((UITableViewCell *)self).reuseIdentifier,@"TextLabel",(long)indexPath.section, (long)indexPath.row];
        
        for (UIView *view in self.subviews) {
            view.accessibilityIdentifier = [NSString stringWithFormat:@"TBUIAutoTest_TableCell_%@_%@_%ld_%ld", ((UITableViewCell *)self).reuseIdentifier, NSStringFromClass([view class]),(long)indexPath.section, (long)indexPath.row];
        }
        
        return [NSString stringWithFormat:@"TBUIAutoTest_TableCell_%@_%ld_%ld", ((UITableViewCell *)self).reuseIdentifier, (long)indexPath.section, (long)indexPath.row];
    }
    if ([self isKindOfClass:[UICollectionViewCell class]]) {//UICollectionViewCell 特殊处理
        UIView *view = [self superview];
        while (view && [view isKindOfClass:[UICollectionView class]] == NO) {
            view = [view superview];
        }
        UICollectionView *collectionView = (UICollectionView *)view;
//        collectionView.accessibilityIdentifier = @"TBUIAutoTest_Collection" ;
        NSIndexPath *indexPath = [collectionView indexPathForCell:(UICollectionViewCell *)self];
        return [NSString stringWithFormat:@"TBUIAutoTest_CollectionCell_%@_%ld_%ld", ((UICollectionViewCell *)self).reuseIdentifier, (long)indexPath.section, (long)indexPath.row];
    }
    return @"";
}

- (UIViewController*)viewController
{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - Method Swizzling

- (NSString *)tb_accessibilityIdentifier
{
    NSString *accessibilityIdentifier = [self tb_accessibilityIdentifier];
    NSString *labelStr = [self labelForOriginalLabel:accessibilityIdentifier];
    [self setAccessibilityIdentifier:labelStr];
    return labelStr;
}

- (void)tb_addSubview:(UIView *)view
{
    [self tb_addSubview:view];
    if (!view.isAccessibilityElement) {
        return;
    }
    UILongPressGestureRecognizer *longPress = objc_getAssociatedObject(view, _cmd);
    if (!longPress) {
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:view action:@selector(longPress:)];
        longPress.delegate = [TBUIAutoTest sharedInstance];
        [view addGestureRecognizer:longPress];
        objc_setAssociatedObject(view, _cmd, longPress, OBJC_ASSOCIATION_RETAIN);
    }
}

@end
