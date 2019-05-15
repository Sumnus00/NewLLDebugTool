//
//  KIFTestActor+Monkey.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/5/15.
//  Copyright © 2019 li. All rights reserved.
//

#import "KIFTestActor.h"

NS_ASSUME_NONNULL_BEGIN

@interface KIFTestActor (Monkey)
- (void)monkey_failWithError:(NSError *)error stopTest:(BOOL)stopTest ;
@end

NS_ASSUME_NONNULL_END
