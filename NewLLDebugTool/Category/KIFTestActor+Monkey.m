//
//  KIFTestActor+Monkey.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/5/15.
//  Copyright © 2019 li. All rights reserved.
//

#import "KIFTestActor+Monkey.h"

@implementation KIFTestActor (Monkey)
- (void)monkey_failWithError:(NSError *)error stopTest:(BOOL)stopTest{
    //nothing to do ,fail with monkey continue to execute
    NSLog(@"haleli >>> KIF error , monkey continue to execute") ;
}
@end
