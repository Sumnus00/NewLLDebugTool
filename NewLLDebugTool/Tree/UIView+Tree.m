//
//  UIView+Tree.m
//  TenMinDemo
//
//  Created by haleli on 2019/4/8.
//  Copyright © 2019 CYXiang. All rights reserved.
//

#import "UIView+Tree.h"

CG_INLINE CGPoint CGPointCenteredInRect(CGRect bounds) {
    return CGPointMake(bounds.origin.x + bounds.size.width * 0.5f, bounds.origin.y + bounds.size.height * 0.5f);
}

@implementation UIView (Tree)

+(NSMutableDictionary *)tree{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray* windows = [UIApplication sharedApplication].windows;
    if(windows.count == 1) {
        [windows[0] subviews:dict];
    } else {
        for (UIWindow* window in windows) {
            [window subviews:dict];
        }
    }
    return dict ;
}


-(BOOL) isDisplayedInScreen{
    
    if(self.superview == nil){
        return false ;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds ;
    
    CGRect rect = [self.superview convertRect:self.frame toView:nil ] ;
    
    if(CGRectIsEmpty(rect) || CGRectIsNull(rect)){
        return false ;
    }
    
    if(CGSizeEqualToSize(rect.size, CGSizeZero)){
        return false ;
    }
    
    CGRect intersectionRect = CGRectIntersection(rect, screenRect) ;
    if(CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)){
        return false ;
    }
    
    return true ;
}

- (BOOL)isProbablyTappable
{
    // There are some issues with the tappability check in UIWebViews, so if the view is a UIWebView we will just skip the check.
    return [NSStringFromClass([self class]) isEqualToString:@"UIWebBrowserView"] || self.isTappable;
}

// Is this view currently on screen?
- (BOOL)isTappable;
{
    return ([self hasTapGestureRecognizer] ||
            [self isTappableInRect:self.bounds]);
}

- (BOOL)hasTapGestureRecognizer
{
    __block BOOL hasTapGestureRecognizer = NO;
    
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj,
                                                          NSUInteger idx,
                                                          BOOL *stop) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            hasTapGestureRecognizer = YES;
            
            if (stop != NULL) {
                *stop = YES;
            }
        }
    }];
    
    return hasTapGestureRecognizer;
}

- (BOOL)isTappableWithHitTestResultView:(UIView *)hitView;
{
    // Special case for UIControls, which may have subviews which don't respond to -hitTest:,
    // but which are tappable. In this case the hit view will be the containing
    // UIControl, and it will forward the tap to the appropriate subview.
    // This applies with UISegmentedControl which contains UISegment views (a private UIView
    // representing a single segment).
    if ([hitView isKindOfClass:[UIControl class]] && [self isDescendantOfView:hitView]) {
        return YES;
    }
    
    // Button views in the nav bar (a private class derived from UINavigationItemView), do not return
    // themselves in a -hitTest:. Instead they return the nav bar.
    if ([hitView isKindOfClass:[UINavigationBar class]] && [self isNavigationItemView] && [self isDescendantOfView:hitView]) {
        return YES;
    }
    
    return [hitView isDescendantOfView:self];
}

- (BOOL)isNavigationItemView;
{
    return [self isKindOfClass:NSClassFromString(@"UINavigationItemView")] || [self isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")];
}

- (BOOL)isTappableInRect:(CGRect)rect;
{
    CGPoint tappablePoint = [self tappablePointInRect:rect];
    
    return !isnan(tappablePoint.x);
}

- (CGPoint)tappablePointInRect:(CGRect)rect;
{
    // Start at the top and recurse down
    CGRect frame = [self.window convertRect:rect fromView:self];
    
    UIView *hitView = nil;
    CGPoint tapPoint = CGPointZero;
    
    // Mid point
    tapPoint = CGPointCenteredInRect(frame);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([self isTappableWithHitTestResultView:hitView]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Top left
    tapPoint = CGPointMake(frame.origin.x + 1.0f, frame.origin.y + 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([self isTappableWithHitTestResultView:hitView]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Top right
    tapPoint = CGPointMake(frame.origin.x + frame.size.width - 1.0f, frame.origin.y + 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([self isTappableWithHitTestResultView:hitView]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Bottom left
    tapPoint = CGPointMake(frame.origin.x + 1.0f, frame.origin.y + frame.size.height - 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([self isTappableWithHitTestResultView:hitView]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Bottom right
    tapPoint = CGPointMake(frame.origin.x + frame.size.width - 1.0f, frame.origin.y + frame.size.height - 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([self isTappableWithHitTestResultView:hitView]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    return CGPointMake(NAN, NAN);
}


- (void)subviews:(NSMutableDictionary *)dict
{
    
    if([NSStringFromClass([self class]) isEqual:@"UIRemoteKeyboardWindow"]){
        return ;
    }
    
    if(self.hidden){
        return ;
    }
    NSString* identifier = self.accessibilityIdentifier;
    if(identifier && [self isDisplayedInScreen] &&[self isProbablyTappable] ){
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
            return ;
        }else if([self isKindOfClass:[UITextField class]]){
            className = @"UITextField" ;
            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
            [dict setObject:element forKey:element.elementId] ;
        }else if([self isKindOfClass:[UITextView class]]){
            className = @"UITextView" ;
            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
            [dict setObject:element forKey:element.elementId] ;
        }else if([self isKindOfClass:[UIButton class]]){
            className = @"UIButton" ;
            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
            [dict setObject:element forKey:element.elementId] ;
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
        }else if([self isKindOfClass:[UITableViewCell class]]){
            return ;
        }else if([self isKindOfClass:[UICollectionViewCell class]]){
            return ;
        }else if([self isKindOfClass:[UIPickerView class]]){
            className = @"UIPickerView" ;
            Element *element = [[Element alloc] initWithElementId:identifier elementName:identifier type:className] ;
            [dict setObject:element forKey:element.elementId] ;
            return ;
        }
    }
    for (UIView *view in self.subviews) {
        [view subviews:dict];
    }
}
@end
