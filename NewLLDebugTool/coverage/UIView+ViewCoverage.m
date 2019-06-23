//
//  UIView+ViewCoverage.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/15.
//  Copyright © 2019 li. All rights reserved.
//

#import "UIView+ViewCoverage.h"
#import <objc/runtime.h>
#import "ViewBound.h"
#import "Element.h"
#import "App.h"
#import "ViewBoundConfig.h"

/**
 click type
 **/
typedef NS_ENUM(NSUInteger, LLClickType) {
    CLICKED = 2,
    UNCLICKED = 1,
    NOTCLICKED = -1 ,
};

@implementation UIView (ViewCoverage)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class viewClass = NSClassFromString(@"UIView");
        [viewClass swizzling_instanceMethodWithOriginSel:@selector(layoutSubviews) swizzledSel:@selector(swizzle_layoutSubviews) ];
    });
}
- (void)swizzle_layoutSubviews{
    [self swizzle_layoutSubviews];
    [self showFrameLineRecursive];
}

-(BOOL)isClicked:(NSString*)accessibilityIdentifier{
    NSString* identifier = accessibilityIdentifier;
    if(identifier){
        UIViewController *controller = [FindTopController topController] ;
        NSString * treeId = NSStringFromClass([controller class]) ;
        Tree* tree = [[App sharedApp] getTree:treeId] ;
        if(tree){
            Element* element = [tree getElement:identifier] ;
            if(element){
                if(element.clickTimes > 0 ){
                    return TRUE ;
                }
            }
        }
    }
    return FALSE ;
}

- (int)shouldShowFrameLine
{
    
    if (![ViewBoundConfig defaultConfig].enable) {
        return NOTCLICKED;
    }
    
    if ([self isKindOfClass:[ViewBound class]]) {
        return NOTCLICKED;
    }
    
    
    if([self isKindOfClass:[UITableView class]]){
        if([self isClicked:self.accessibilityIdentifier]){
            return CLICKED ;
        }else{
            return UNCLICKED ;
        }
    }else if([self isKindOfClass:[UISwitch class]]){
        if([self isClicked:self.accessibilityIdentifier]){
            return CLICKED ;
        }else{
            return UNCLICKED ;
        }
    }else if([self isKindOfClass:[UINavigationBar class]]){
        if([self isClicked:self.accessibilityIdentifier]){
            return CLICKED ;
        }else{
            return UNCLICKED ;
        }
    }else if([self isKindOfClass:[UITextField class]]){
        if([self isClicked:self.accessibilityIdentifier]){
            return CLICKED ;
        }else{
            return UNCLICKED ;
        }
    }else if([self isKindOfClass:[UIButton class]]){
        if([self isClicked:self.accessibilityIdentifier]){
            return CLICKED ;
        }else{
            return UNCLICKED ;
        }
    }else if([self isKindOfClass:[UISegmentedControl class]]){
        if([self isClicked:self.accessibilityIdentifier]){
            return CLICKED ;
        }else{
            return UNCLICKED ;
        }
    }else if([self isKindOfClass:[UICollectionView class]]){
        if([self isClicked:self.accessibilityIdentifier]){
            return CLICKED ;
        }else{
            return UNCLICKED ;
        }
    }else if([self isKindOfClass:NSClassFromString(@"UITabBarButton")]){
        if([self isClicked:self.accessibilityIdentifier]){
            return CLICKED ;
        }else{
            return UNCLICKED ;
        }
    }else if([self isKindOfClass:[UITableViewCell class]]){
        UIView *view = [self superview];
        while (view && [view isKindOfClass:[UITableView class]] == NO) {
            view = [view superview];
        }
        UITableView *tableView = (UITableView *)view;
        NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)self];
        NSString*accessibilityIdentifier = [NSString stringWithFormat:@"TBUIAutoTest_TableCell_%ld_%ld",indexPath.section,indexPath.row] ;
        if([self isClicked:accessibilityIdentifier]){
            return CLICKED ;
        }else{
            return UNCLICKED ;
        }
    }
    else if([self isKindOfClass:[UICollectionViewCell class]]){
        UIView *view = [self superview];
        while (view && [view isKindOfClass:[UICollectionView class]] == NO) {
            view = [view superview];
        }
        UICollectionView *collectionView = (UICollectionView *)view;
        NSIndexPath *indexPath = [collectionView indexPathForCell:(UICollectionViewCell *)self];
         NSString*accessibilityIdentifier = [NSString stringWithFormat:@"TBUIAutoTest_CollectionCell_%ld_%ld", indexPath.section,indexPath.row];
        if([self isClicked:accessibilityIdentifier]){
            return CLICKED ;
        }else{
            return UNCLICKED ;
        }
    }else if([self isKindOfClass:[UIPickerView class]]){
        if([self isClicked:self.accessibilityIdentifier]){
            return CLICKED ;
        }else{
            return UNCLICKED ;
        }
    }
   
    
    return NOTCLICKED;
}
- (void)hideFrameLineRecursive
{
    for (UIView *subView in self.subviews) {
        [subView hideFrameLineRecursive];
    }
    [self hideFrameLine];
}

- (void)hideFrameLine
{
    ViewBound *metricsView = [self getViewBound];
    if (metricsView) {
        metricsView.hidden = YES;
    }
}

- (void)showFrameLineRecursive
{
    for (UIView *subView in self.subviews) {
        [subView showFrameLineRecursive];
    }
    [self showFrameLine];
    
}

-(void) showFrameLine{
    int result =[self shouldShowFrameLine] ;
    if (result == NOTCLICKED) {
        if(![ViewBoundConfig defaultConfig].enable){
            [self hideFrameLine] ;
        }
        return;
    }
    
    ViewBound *viewBound = [self getViewBound];
    if (!viewBound) {
        ViewBound *viewBound = [[ViewBound alloc] initWithFrame:self.bounds];
        viewBound.tag = [NSStringFromClass([ViewBound class]) hash]+(NSInteger)self;
        viewBound.userInteractionEnabled = NO;
        [self addSubview:viewBound];
    }
    if(result ==  UNCLICKED){
        viewBound.layer.borderColor = [ViewBoundConfig defaultConfig].borderUnClickedColor.CGColor;
        viewBound.layer.borderWidth  = [ViewBoundConfig defaultConfig].borderWidth;
    }else{
        viewBound.layer.borderColor = [ViewBoundConfig defaultConfig].borderClickedColor.CGColor;
        viewBound.layer.borderWidth  = [ViewBoundConfig defaultConfig].borderWidth;
    }
    
    viewBound.hidden = ![ViewBoundConfig defaultConfig].enable;

}

-(ViewBound *)getViewBound{
    NSInteger tag = [NSStringFromClass([ViewBound class]) hash]+(NSInteger)self;
    return (ViewBound*)[self viewWithTag:tag];
}

@end
