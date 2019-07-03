//
//  LLOscillogramViewController.h
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/17.
//  Copyright © 2019 li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLOscillogramViewController : UIViewController
@property (nonatomic, strong) UILabel *titleLabel;

- (NSString *)title;
- (void)startRecord;
- (void)endRecord;
- (void)doSecondFunction;
- (void)drawTitleViewWithValue:(NSString *)title ;
@end

NS_ASSUME_NONNULL_END
