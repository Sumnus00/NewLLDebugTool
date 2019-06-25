//
//  LLWindowViewController.m
//
//  Copyright (c) 2018 LLDebugTool Software Foundation (https://github.com/HDB-Li/LLDebugTool)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "LLWindowViewController.h"
#import "LLScreenshotHelper.h"
#import "LLImageNameConfig.h"
#import "LLMacros.h"
#import "LLWindow.h"
#import "LLConfig.h"
#import "LLDebugTool.h"
#import "LLDebugToolMacros.h"
#import "LLLogHelperEventDefine.h"
#import "LLHomeWindow.h"

@interface LLWindowViewController ()

@property (nonatomic , strong) UIView *contentView;

@property (nonatomic , strong) UILabel *memoryLabel;

@property (nonatomic , strong) UILabel *CPULabel;

@property (nonatomic , strong) UILabel *FPSLabel;

@property (nonatomic , strong) UIView *lineView;

@property (nonatomic , assign) CGFloat sBallHideWidth;

@property (nonatomic , strong) UITabBarController *tabVC;

@end

@implementation LLWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initial];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public
- (void)registerLLAppHelperNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLAppHelperDidUpdateAppInfosNotification:) name:LLAppHelperDidUpdateAppInfosNotificationName object:nil];
}

- (void)unregisterLLAppHelperNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LLAppHelperDidUpdateAppInfosNotificationName object:nil];
}


#pragma mark - LLAppHelperNotification
- (void)didReceiveLLAppHelperDidUpdateAppInfosNotification:(NSNotification *)notifi {
    NSDictionary *userInfo = notifi.userInfo;
    CGFloat cpu = [userInfo[LLAppHelperCPUKey] floatValue];
    CGFloat usedMemory = [userInfo[LLAppHelperMemoryUsedKey] floatValue];
    CGFloat fps = [userInfo[LLAppHelperFPSKey] floatValue];
    self.memoryLabel.text = [NSString stringWithFormat:@"%@",[NSByteCountFormatter stringFromByteCount:usedMemory countStyle:NSByteCountFormatterCountStyleMemory]];
    self.CPULabel.text = [NSString stringWithFormat:@"CPU:%.2f%%",cpu];
    self.FPSLabel.text = [NSString stringWithFormat:@"%ld",(long)fps];
}

#pragma mark - LLConfigDidUpdateColorStyleNotification
- (void)didReceiveLLConfigDidUpdateColorStyleNotification {
    _contentView.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    _contentView.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    _memoryLabel.textColor = LLCONFIG_TEXT_COLOR;
    _CPULabel.textColor = LLCONFIG_TEXT_COLOR;
    _FPSLabel.backgroundColor = LLCONFIG_TEXT_COLOR;
    _FPSLabel.textColor = LLCONFIG_BACKGROUND_COLOR;
    _lineView.backgroundColor = LLCONFIG_TEXT_COLOR;
}

#pragma mark - LLConfigDidUpdateWindowStyleNotificationName
- (void)didReceiveLLConfigDidUpdateWindowStyleNotification {
    self.windowStyle = [LLConfig sharedConfig].windowStyle;
    [self updateSettings];
    [self updateSubViews];
    [self updateGestureRecognizers];
}

#pragma mark - Primary
/**
 * initial method
 */
- (void)initial {
    [self updateSettings];
    [self updateSubViews];
    [self updateGestureRecognizers];
    [self registerNotifications];
}

- (void)updateSettings {
    // Check sBallWidth
    if (_sBallWidth < 70) {
        _sBallWidth = 70;
    }
    self.sBallHideWidth = 10;
    switch (self.windowStyle) {
        case LLConfigWindowPowerBar:{
            CGFloat width = 90;
            CGRect rect = [UIApplication sharedApplication].statusBarFrame;
            CGFloat gap = 0.5;
            self.window.frame = CGRectMake(LL_SCREEN_WIDTH - width - 2, rect.origin.y + gap, width, rect.size.height - gap * 2 < 20 - gap * 2 ? 20 - gap * 2 : rect.size.height - gap * 2);
        }
            break;
        case LLConfigWindowNetBar:{
            CGFloat width = 90;
            CGRect rect = [UIApplication sharedApplication].statusBarFrame;
            CGFloat gap = 0.5;
            self.window.frame = CGRectMake(gap, rect.origin.y + gap, width, rect.size.height - gap * 2 < 20 - gap * 2 ? 20 - gap * 2 : rect.size.height - gap * 2);
        }
            break;
        case LLConfigWindowSuspensionBall:
        default:{
            self.windowStyle = LLConfigWindowSuspensionBall;
            self.window.frame = CGRectMake(-self.sBallHideWidth, LL_SCREEN_HEIGHT / 3.0, _sBallWidth, _sBallWidth);
        }
            break;
    }
    self.view.frame = self.window.bounds;
}

- (void)updateSubViews {
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    for (UIView *subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    
    // Create contentView
    self.contentView.frame = self.view.bounds;
    [self.view addSubview:self.contentView];
    
    // Set up views by windowStyle.
    switch (self.windowStyle) {
        case LLConfigWindowSuspensionBall:{
            // Set ContentView
            self.contentView.layer.cornerRadius = _sBallWidth / 2.0;
            self.contentView.layer.borderWidth = 2;
            
            // Create memoryLabel
            self.memoryLabel.frame = CGRectMake(_sBallWidth / 8.0, _sBallWidth / 4.0, _sBallWidth * 3 / 4.0, _sBallWidth / 4.0);
            [self.contentView addSubview:self.memoryLabel];
            
            // Create CPULabel
            self.CPULabel.frame = CGRectMake(_sBallWidth / 8.0, _sBallWidth / 2.0, _sBallWidth * 3 / 4.0, _sBallWidth / 4.0);
            [self.contentView addSubview:self.CPULabel];
            
            // Create FPSLabel
            self.FPSLabel.frame = CGRectMake(0, 0, 20, 20);
            self.FPSLabel.center = CGPointMake(_sBallWidth * 0.85 + _contentView.frame.origin.x, _sBallWidth * 0.15 + _contentView.frame.origin.y);
            self.FPSLabel.layer.cornerRadius = self.FPSLabel.frame.size.height / 2.0;
            [self.view addSubview:self.FPSLabel];
            
            // Create Line
            self.lineView.frame = CGRectMake(_sBallWidth / 8.0, _sBallWidth / 2.0 - 0.5, _sBallWidth * 3 / 4.0, 1);
            [self.contentView addSubview:self.lineView];
        }
            break;
        case LLConfigWindowPowerBar:
        case LLConfigWindowNetBar:{
            // Set ContentView
            CGFloat gap = self.contentView.frame.size.height / 2.0;
            self.contentView.layer.cornerRadius = gap;
            
            // Create memoryLabel
            self.memoryLabel.frame = CGRectMake(gap, 0, self.contentView.frame.size.width - gap * 2, self.contentView.frame.size.height);
            [self.contentView addSubview:self.memoryLabel];
        }
            break;
        default:
            break;
    }
}

- (void)updateGestureRecognizers {
    for (UIGestureRecognizer *gr in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:gr];
    }
    // Pan, to moveable.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    
    // Double tap, to screenshot.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGR:)];
    doubleTap.numberOfTapsRequired = 2;
    
    // Tap, to show tool view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    [tap requireGestureRecognizerToFail:doubleTap];
    
    [self.contentView addGestureRecognizer:tap];
    [self.contentView addGestureRecognizer:doubleTap];
    
    switch (self.windowStyle) {
        case LLConfigWindowSuspensionBall:{
            [self.contentView addGestureRecognizer:pan];
        }
            break;
        default:
            break;
    }
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLConfigDidUpdateColorStyleNotification) name:LLConfigDidUpdateColorStyleNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLConfigDidUpdateWindowStyleNotification) name:LLConfigDidUpdateWindowStyleNotificationName object:nil];
}

- (void)becomeActive {
    self.contentView.alpha = [LLConfig sharedConfig].activeAlpha;
}

- (void)resignActive {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.alpha = [LLConfig sharedConfig].normalAlpha;
        // Calculate End Point
        CGFloat x = self.window.center.x;
        CGFloat y = self.window.center.y;
        CGFloat x1 = LL_SCREEN_WIDTH / 2.0;
        CGFloat y1 = LL_SCREEN_HEIGHT / 2.0;
        
        CGFloat distanceX = x1 > x ? x : LL_SCREEN_WIDTH - x;
        CGFloat distanceY = y1 > y ? y : LL_SCREEN_HEIGHT - y;
        CGPoint endPoint = CGPointZero;
    
        if (distanceX <= distanceY) {
            // animation to left or right
            endPoint.y = y;
            if (x1 < x) {
                // to right
                endPoint.x = LL_SCREEN_WIDTH - self.window.frame.size.width / 2.0 + self.sBallHideWidth;
            } else {
                // to left
                endPoint.x = self.window.frame.size.width / 2.0 - self.sBallHideWidth;
            }
        } else {
            // animation to top or bottom
            endPoint.x = x;
            if (y1 < y) {
                // to bottom
                endPoint.y = LL_SCREEN_HEIGHT - self.window.frame.size.height / 2.0 + self.sBallHideWidth;
            } else {
                // to top
                endPoint.y = self.window.frame.size.height / 2.0 - self.sBallHideWidth;
            }
        }
        self.window.center = endPoint;
        
        CGFloat horizontalPer = x1 < x ? 0.15 : 0.85;
        CGFloat verticalPer = endPoint.y > self.sBallWidth ? 0.15 : 0.85;
        CGPoint fpsCenter = CGPointMake(self.sBallWidth * horizontalPer + self.contentView.frame.origin.x, self.sBallWidth * verticalPer + self.contentView.frame.origin.y);
        self.FPSLabel.center = fpsCenter;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)changeSBallViewFrameWithPoint:(CGPoint)point {
    if (point.x > LL_SCREEN_WIDTH) {
        point.x = LL_SCREEN_WIDTH;
    } else if (point.x < 0) {
        point.x = 0;
    }
    if (point.y > LL_SCREEN_HEIGHT) {
        point.y = LL_SCREEN_HEIGHT;
    } else if (point.y < 0) {
        point.y = 0;
    }
    self.window.center = CGPointMake(point.x, point.y);
}

// Fix the bug of missing status bars under ios9.
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [LLConfig sharedConfig].statusBarStyle;
}

// TODO: Know why does this method affect the statusBar for keywindow.
- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Action
- (void)panGR:(UIPanGestureRecognizer *)gr {
    if ([LLConfig sharedConfig].suspensionBallMoveable) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        CGPoint panPoint = [gr locationInView:window];
        if (gr.state == UIGestureRecognizerStateBegan)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resignActive) object:nil];
            [self becomeActive];
        } else if (gr.state == UIGestureRecognizerStateChanged) {
            [self changeSBallViewFrameWithPoint:panPoint];
        } else if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled || gr.state == UIGestureRecognizerStateFailed) {
            [self resignActive];
        }
    }
}

- (void)tapGR:(UITapGestureRecognizer *)gr {
    
    [[LLHomeWindow shareInstance] showDebugViewControllerWithIndex:0];
}

- (void)doubleTapGR:(UITapGestureRecognizer *)gr {
    [[LLScreenshotHelper sharedHelper] simulateTakeScreenshot];
}


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
        _contentView.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
        _contentView.layer.masksToBounds = YES;
        _contentView.alpha = [LLConfig sharedConfig].normalAlpha;
    }
    return _contentView;
}

- (UILabel *)memoryLabel {
    if (!_memoryLabel) {
        _memoryLabel = [[UILabel alloc] init];
        _memoryLabel.textAlignment = NSTextAlignmentCenter;
        _memoryLabel.textColor = LLCONFIG_TEXT_COLOR;
        _memoryLabel.font = [UIFont systemFontOfSize:12];
        _memoryLabel.adjustsFontSizeToFitWidth = YES;
        _memoryLabel.text = @"loading";
    }
    return _memoryLabel;
}

- (UILabel *)CPULabel {
    if (!_CPULabel) {
        _CPULabel = [[UILabel alloc] init];
        _CPULabel.textAlignment = NSTextAlignmentCenter;
        _CPULabel.textColor = LLCONFIG_TEXT_COLOR;
        _CPULabel.font = [UIFont systemFontOfSize:10];
        _CPULabel.adjustsFontSizeToFitWidth = YES;
        _CPULabel.text = @"loading";
    }
    return _CPULabel;
}

- (UILabel *)FPSLabel {
    if (!_FPSLabel) {
        _FPSLabel = [[UILabel alloc] init];
        _FPSLabel.textAlignment = NSTextAlignmentCenter;
        _FPSLabel.backgroundColor = LLCONFIG_TEXT_COLOR;
        _FPSLabel.textColor = LLCONFIG_BACKGROUND_COLOR;
        _FPSLabel.font = [UIFont systemFontOfSize:12];
        _FPSLabel.adjustsFontSizeToFitWidth = YES;
        _FPSLabel.text = @"60";
        _FPSLabel.layer.masksToBounds = YES;
    }
    return _FPSLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LLCONFIG_TEXT_COLOR;
    }
    return _lineView;
}

@end
