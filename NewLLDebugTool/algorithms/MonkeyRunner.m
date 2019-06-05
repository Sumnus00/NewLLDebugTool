//
//  MonkeyRunner.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/6/5.
//  Copyright © 2019 li. All rights reserved.
//

#import "MonkeyRunner.h"

@implementation MonkeyRunner

- (instancetype)init{
    self = [super init] ;
    if(self){
        _preTree = nil ;
        _curTree = nil ;
        _preElement = nil ;
    }
    return self ;
}

-(void)runOneStep{
    _preTree = _curTree ;
    _curTree = [[App sharedApp] getCurrentTree] ;
}
@end
