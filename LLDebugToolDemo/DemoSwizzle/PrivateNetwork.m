//
//  PrivateNetwork.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/1/30.
//  Copyright © 2019 li. All rights reserved.
//


#import "PrivateNetwork.h"

@implementation PrivateNetwork
- (void)sendBizData:(NSString *)data{
    NSLog(@"send data : %@",data) ;
}
- (void)didReceviedData:(NSString *)data{
    NSLog(@"receive data : %@",data) ;
}

@end
