//
//  UITableViewCellActions.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/8.
//  Copyright © 2019 li. All rights reserved.
//

#import "UITableViewCellActions.h"

@implementation UITableViewCellActions
+(void)tapTableViewCellWithAccessibilityIdentifier:(NSString *)identifier section:(NSInteger) section row:(NSInteger) row{
    
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@",identifier] ;
    
    [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
    
    if([view isKindOfClass:[UITableView class]]){
        NSInteger sections = ((UITableView *)view).numberOfSections ;
        if(section < sections){
            NSInteger rows = [((UITableView *)view) numberOfRowsInSection:section] ;
            if(row < rows){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section] ;
                [tester tapRowAtIndexPath:indexPath inTableView:view] ;
            }
        }
       
    }
}
@end
