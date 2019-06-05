//
//  App.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/6/5.
//  Copyright © 2019 li. All rights reserved.
//

#import "App.h"

static App *_instance = nil;
@implementation App
/**
 * Singleton
 @return Singleton
 */
+ (instancetype)sharedApp {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[App alloc] init];
        [_instance initial];
    });
    return _instance;
}

/**
 Initial something.
 */
- (void)initial {
    _trees = [[NSMutableDictionary alloc] init] ;
}

-(Tree *)getCurrentTree{
    return nil ;
}
@end
