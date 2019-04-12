//
//  UITableViewActions.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/10.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIF.h"
NS_ASSUME_NONNULL_BEGIN

@interface UITableViewActions : NSObject

//swipe table
+(void)swipeTableViewWithAccessibilityIdentifier:(NSString *)identifier;

//swipe table with drag the cell
+(void)swipeRowAtIndexPathWithAccessibilityIdentifier:(NSString *)identifier;

//move table cell
+(void)moveRowAtIndexPathWithAccessibilityIdentifier:(NSString *)identifier;

//tap table cell
+(void)tapRowAtIndexPathWithAccessibilityIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
