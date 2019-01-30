//
//  PrivateNetwork.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/1/30.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PrivateNetwork:NSObject
- (void)sendBizData:(NSString *)data;
- (void)didReceviedData:(NSString *)data;
@end
