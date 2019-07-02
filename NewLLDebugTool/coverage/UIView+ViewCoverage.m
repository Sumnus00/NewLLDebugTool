//
//  UIView+ViewCoverage.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/15.
//  Copyright © 2019 li. All rights reserved.
//

#import "UIView+ViewCoverage.h"
#import <objc/runtime.h>
#import "Element.h"
#import "App.h"
#import "ViewBoundConfig.h"

/**
 click type
 **/
typedef NS_ENUM(NSInteger, LLClickType) {
    CLICKED = 2,
    UNCLICKED = 1,
    NOTCLICKED = -1 ,
};

@interface UIView ()

@property (nonatomic ,strong) CALayer *borderLayer;

@end


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
    [self frameLineRecursiveEnable:[ViewBoundConfig defaultConfig].enable];
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

- (void)frameLineRecursiveEnable:(BOOL)enable{
    // 状态栏不显示元素边框
    UIWindow *statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"_statusBarWindow"];
    if (statusBarWindow && [self isDescendantOfView:statusBarWindow]) {
        return;
    }
    
    for (UIView *subView in self.subviews) {
        [subView frameLineRecursiveEnable:enable];
    }
    
    int result =[self shouldShowFrameLine] ;
    if (result == NOTCLICKED) {
        enable = false ;
    }
    
    if (enable) {
        if (!self.metricsBorderLayer) {
             UIColor *borderColor = [ViewBoundConfig defaultConfig].borderUnClickedColor;
            if(result ==  UNCLICKED){
                borderColor = [ViewBoundConfig defaultConfig].borderUnClickedColor;
            }else{
                borderColor = [ViewBoundConfig defaultConfig].borderClickedColor;
            }
           
            self.metricsBorderLayer = ({
                CALayer *layer = CALayer.new;
                layer.borderWidth = [ViewBoundConfig defaultConfig].borderWidth;
                layer.borderColor = borderColor.CGColor;
                layer;
            });
            [self.layer addSublayer:self.metricsBorderLayer];
        }
        
        self.metricsBorderLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.metricsBorderLayer.hidden = NO;
    } else if (self.metricsBorderLayer) {
        self.metricsBorderLayer.hidden = YES;
    }
}

- (void)setMetricsBorderLayer:(CALayer *)metricsBorderLayer
{
    objc_setAssociatedObject(self, @selector(metricsBorderLayer), metricsBorderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)metricsBorderLayer
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
