//
//  UICollectionViewCellActions.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/8.
//  Copyright © 2019 li. All rights reserved.
//

#import "UICollectionViewCellActions.h"

@implementation UICollectionViewCellActions
+(void)tapCollectionViewCellWithAccessibilityIdentifier:(NSString *)identifier section:(NSInteger)section item:(NSInteger)item{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UICollectionView class]]){
        NSInteger sections = ((UICollectionView *)view).numberOfSections ;
        if(section < sections){
            NSInteger items = [((UICollectionView *)view) numberOfItemsInSection:section] ;
            if(item < items){
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section] ;
                [tester tapItemAtIndexPath:indexPath inCollectionView:view] ;
            }
        }
        
    }
}
@end
