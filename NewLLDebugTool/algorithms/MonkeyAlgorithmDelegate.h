//
//  MonkeyAlgorithmDelegate.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/5/17.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tree.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MonkeyAlgorithmDelegate <NSObject>
-(Element *) chooseElementFromTree:(Tree *)currentTree;
@end

NS_ASSUME_NONNULL_END
