//
//  UICollectionViewCellActions.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/8.
//  Copyright © 2019 li. All rights reserved.
//

#import "UICollectionViewCellActions.h"

@implementation UICollectionViewCellActions
+(void)tapCollectionViewCellWithAccessibilityIdentifier:(NSString *)identifier{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UICollectionViewCell class]]){
        [tester tapAccessibilityElement:element inView:view] ;
    }
}
@end
