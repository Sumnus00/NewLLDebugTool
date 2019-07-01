//
//  FindElementTree.h
//  TenMinDemo
//
//  Created by haleli on 2019/4/8.
//  Copyright © 2019 CYXiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Tree.h"
#import <UIKit/UIKit.h>
#import "Tree.h"
#import "FindTopController.h"
NS_ASSUME_NONNULL_BEGIN

@interface FindElementTree : NSObject
+(Tree *)tree ;
+(NSString *)treeId ;
@end

NS_ASSUME_NONNULL_END
