//
//  UICollectionViewActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/16.
//  Copyright © 2019 li. All rights reserved.
//

#import "UICollectionViewActions.h"

@implementation UICollectionViewActions
+(void)swipeCollectionViewWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UICollectionView class]]){
        [tester swipeAccessibilityElement:element inView:view inDirection:KIFSwipeDirectionUp] ;
    }
    
}
+(void)tapItemAtIndexPathWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UICollectionView class]]){
        NSInteger sections = ((UICollectionView *)view).numberOfSections ;
        if(sections > 0){
            int section = arc4random() % sections ;
            NSInteger items = [((UICollectionView *)view) numberOfItemsInSection:section] ;
            if(items > 0){
                int item = arc4random() % items ;
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section] ;
                [tester tapItemAtIndexPath:indexPath inCollectionView:view] ;
            }
        }
    }
}
@end
