//
//  UIApplication+Monkey.h
//  Master
//
//  Created by gogleyin on 23/03/2017.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Monkey)
-(void)monkey_sendEvent:(UIEvent*)event;

- (BOOL)monkey_canOpenURL:(NSURL *)url;

- (BOOL)monkey_openURL:(NSURL*)url;

- (void)monkey_openURL:(NSURL*)url options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion;
@end
