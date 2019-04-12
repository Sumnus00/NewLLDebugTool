//
//  UITableViewActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/10.
//  Copyright © 2019 li. All rights reserved.
//

#import "UITableViewActions.h"

@implementation UITableViewActions
+(void)swipeTableViewWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UITableView class]]){
        [tester swipeAccessibilityElement:element inView:view inDirection:KIFSwipeDirectionUp] ;
    }
}

+(void)swipeRowAtIndexPathWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UITableView class]]){
        NSInteger sections = ((UITableView *)view).numberOfSections ;
        if(sections > 0){
            int section = arc4random() % sections ;
            NSInteger rows = [((UITableView *)view) numberOfRowsInSection:section] ;
            if(rows > 0){
                int row = arc4random() % rows ;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section] ;
                [tester swipeRowAtIndexPath:indexPath inTableView:view inDirection:KIFSwipeDirectionDown] ;
            }
        }
    }
}

+(void)moveRowAtIndexPathWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UITableView class]]){
        NSInteger sections = ((UITableView *)view).numberOfSections ;
        if(sections > 0){
            int sectionS = arc4random() % sections ;
            int sectionD = arc4random() % sections ;
            NSInteger rowsS = [((UITableView *)view) numberOfRowsInSection:sectionS] ;
            NSInteger rowsD = [((UITableView *)view) numberOfRowsInSection:sectionD] ;
            if(rowsS > 0 && rowsD > 0){
                int rowS = arc4random() % rowsS ;
                int rowD = arc4random() % rowsD ;
                NSLog(@"%d,%d,%d,%d",sectionS,rowS,sectionD,rowD) ;
                NSIndexPath *indexPathS = [NSIndexPath indexPathForRow:rowS inSection:sectionS] ;
                NSIndexPath *indexPathD = [NSIndexPath indexPathForRow:rowD inSection:sectionD] ;
                [tester moveRowAtIndexPath:indexPathS toIndexPath:indexPathD inTableView:view] ;
            }
        }
    }
}

+(void)tapRowAtIndexPathWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;

    if([view isKindOfClass:[UITableView class]]){
        NSInteger sections = ((UITableView *)view).numberOfSections ;
        if(sections > 0){
            int section = arc4random() % sections ;
            NSInteger rows = [((UITableView *)view) numberOfRowsInSection:section] ;
            if(rows > 0){
                int row = arc4random() % rows ;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section] ;
                [tester tapRowAtIndexPath:indexPath inTableView:view] ;
            }
        }
    }
}
@end
