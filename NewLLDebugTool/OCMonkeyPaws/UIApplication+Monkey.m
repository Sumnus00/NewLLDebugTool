//
//  UIApplication+Monkey.m
//  Master
//
//  Created by gogleyin on 23/03/2017.
//

#import "UIApplication+Monkey.h"
#import "MonkeyPaws.h"

@implementation UIApplication (Monkey)

-(void)monkey_sendEvent:(UIEvent*)event
{
    NSMutableArray<MonkeyPaws*> *tracks = [MonkeyPaws tappingTracks];
    for (MonkeyPaws* track in tracks) {
        if (track) {
            [track append:event];
        }
    }
    [self monkey_sendEvent:event];
}



- (BOOL)monkey_canOpenURL:(NSURL *)url{
    NSLog(@"haleli >>>> canOpenURL:%@",url) ;
    return false ;
}

- (BOOL)monkey_openURL:(NSURL*)url{
    NSLog(@"haleli >>>> openURL:%@",url) ;
    return false ;
}

- (void)monkey_openURL:(NSURL*)url options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion{
    NSLog(@"haleli >>>> openURL:%@",url) ;
}

@end
