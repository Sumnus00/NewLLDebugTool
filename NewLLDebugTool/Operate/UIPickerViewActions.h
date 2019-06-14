//
//  UIPickerViewActions.h
//  LLDebugToolDemo
//
//  Created by haleli on 2019/6/13.
//  Copyright © 2019 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIF.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIPickerViewActions : NSObject
+(void)selectPickerViewRowWithAccessibilityIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
