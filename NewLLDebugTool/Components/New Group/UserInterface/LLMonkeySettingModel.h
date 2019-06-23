//
//  LLMonkeySettingModel.h
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/21.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLStorageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLMonkeySettingModel : LLStorageModel
/**
 * algorithm
 */
@property (copy , nonatomic  , nonnull) NSString *algorithm;

/**
 * black list
 */
@property (strong , nonatomic , nullable) NSMutableArray <NSString *>*blacklist;

/**
 * white list
 */
@property (strong , nonatomic  , nullable) NSMutableArray <NSString *>*whitelist;

/**
 * time (HH:mm)
 */
@property (copy , nonatomic  , nullable) NSString *date;

/**
 Model identity.
 */
@property (nonatomic , copy , readonly , nonnull) NSString *identity;

- (instancetype _Nonnull)initWithIdentity:(NSString *_Nullable)identity ;

@end

NS_ASSUME_NONNULL_END
