//
//  WnsSdkHelper+Swizzling.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/1/30.
//  Copyright © 2019 li. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface WnsBizSendData : NSObject

@end

@interface WnsSdkHelper : NSObject
- (long)sendBizData:(WnsBizSendData *)bizData ;
@end


@interface WnsSdkHelper (Swizzling)

@end

