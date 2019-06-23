//
//  ViewBoundConfig.h
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/20.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ViewBoundConfig : NSObject
@property (nonatomic, strong) UIColor *borderUnClickedColor;     //default red
@property (nonatomic, strong) UIColor *borderClickedColor;     //default blue
@property (nonatomic, assign) CGFloat borderWidth;      //default 1
@property (nonatomic, assign) BOOL enable;              //default NO

+ (instancetype)defaultConfig;
@end

NS_ASSUME_NONNULL_END
