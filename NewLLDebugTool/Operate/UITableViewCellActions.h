//
//  UITableViewCellActions.h
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/8.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIF.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCellActions : NSObject
+(void)tapTableViewCellWithAccessibilityIdentifier:(NSString *)identifier section:(NSInteger) section row:(NSInteger) row ;
@end

NS_ASSUME_NONNULL_END
