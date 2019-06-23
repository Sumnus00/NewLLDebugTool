//
//  LLMonkeySettingConfig.h
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/21.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 monkey type
 **/
typedef NS_ENUM(NSUInteger, LLMonekyType) {
    IOSMonkeyType,
    CocosMonkeyType,
};

/**
 list type
 **/
typedef NS_ENUM(NSUInteger, LLListType) {
    WhiteListType,
    BlackListType,
};

@interface LLMonkeySettingConfig : NSObject
@property (nonatomic, assign) NSInteger monkeyType ;
@property (nonatomic, assign) NSInteger listType ;
@property (nonatomic ,assign) BOOL coverageTextEnable ;
+ (instancetype)defaultConfig;
@end

NS_ASSUME_NONNULL_END
