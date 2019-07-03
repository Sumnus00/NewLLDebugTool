//
//  LLOscillogramViewController.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/17.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLOscillogramViewController.h"
#import "LLMacros.h"

@interface LLOscillogramViewController ()
//每秒运行一次
@property (nonatomic, strong) NSTimer *secondTimer;
@end

@implementation LLOscillogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = [self title];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:kLLSizeFrom750_Landscape(50)];
    _titleLabel.textColor = [UIColor yellowColor];
    [self.view addSubview:_titleLabel];
    [_titleLabel sizeToFit];    
     _titleLabel.frame = CGRectMake(kLLSizeFrom750_Landscape(20), kLLSizeFrom750_Landscape(10), LL_SCREEN_WIDTH, _titleLabel.frame.size.height);
}

- (NSString *)title{
    return @"";
}


- (void)startRecord{
    if(!_secondTimer){
        _secondTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(doSecondFunction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_secondTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)drawTitleViewWithValue:(NSString *)title{
    _titleLabel.text = title ;
}

- (void)doSecondFunction{
    
}

- (void)endRecord{
    if(_secondTimer){
        [_secondTimer invalidate];
        _secondTimer = nil;
    }
}
@end
