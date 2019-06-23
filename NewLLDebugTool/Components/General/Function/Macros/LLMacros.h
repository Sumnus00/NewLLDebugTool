//
//  LLMacros.h
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

#ifndef LLMacros_h
#define LLMacros_h

#import "LLAppHelper.h"

#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define LL_NAVIGATION_HEIGHT (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)

//根据750*1334分辨率计算size
#define kLLSizeFrom750(x) ((x)*LL_SCREEN_WIDTH/750)

// 如果横屏显示
#define kLLSizeFrom750_Landscape(x) (kInterfaceOrientationPortrait ? kLLSizeFrom750(x) : ((x)*LL_SCREEN_HEIGHT/750))

#define kInterfaceOrientationPortrait UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)

#define IS_IPHONE_X_Series [[LLAppHelper sharedHelper] isIPhoneXSeries]
#define IPHONE_TOPSENSOR_HEIGHT      (IS_IPHONE_X_Series ? 32 : 0)

#endif /* LLMacros_h */
