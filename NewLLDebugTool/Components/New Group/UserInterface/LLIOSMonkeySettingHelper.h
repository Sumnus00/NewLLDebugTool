//
//  LLMonkeySettingHelper.h
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/21.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLStorageModel.h"
#import "LLMonkeySettingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLIOSMonkeySettingHelper : NSObject

@property (nonatomic , strong , nullable) LLMonkeySettingModel *monkeySettingModel;
/**
 Singleton to control enable.
 
@return Singleton
*/
+ (instancetype _Nonnull)sharedHelper;

/**
 update algorithm
 **/
-(BOOL)setAlgorithm:(NSString *)algorithm ;

/**
 update date
 **/
-(BOOL)setDate:(NSString *)date ;


/**
 update black list
 **/

-(BOOL)setBlacklist:(NSMutableArray<NSString *> *)blacklist ;

/**
 update white list
 **/
-(BOOL)setWhitelist:(NSMutableArray<NSString *> *)whitelist ;
@end

NS_ASSUME_NONNULL_END
