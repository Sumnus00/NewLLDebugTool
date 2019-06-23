//
//  LLOscillogramWindowManager.h
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/17.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLOscillogramWindowManager : NSObject
+ (LLOscillogramWindowManager *)shareInstance;

- (void)resetLayout;
@end

NS_ASSUME_NONNULL_END
