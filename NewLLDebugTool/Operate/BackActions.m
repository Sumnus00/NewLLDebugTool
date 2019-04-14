//
//  BackActions.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/11.
//  Copyright © 2019 li. All rights reserved.
//

#import "BackActions.h"

@implementation BackActions
+(void)back{
    if ([FindTopController topController].presentingViewController) {
        [[FindTopController topController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[FindTopController topController].navigationController popViewControllerAnimated:YES];
    }
//    //如果topItem设置了左侧按钮组(leftBarButtonItems属性)，则默认使用最后一个item
//    //如果topItem设置了左侧按钮(leftBarButtonItem属性), 则展示左侧按钮
//    //如果backItem设置了返回按钮(backBarButtonItem属性), 则展示返回按钮
//    //如果backItem设置了标题文字(title属性), 则展示利用标题文字封装的返回按钮
//    //如果当前是中文环境，则展示利用文字”返回”封装的返回按钮
//    //如果当前是英文环境，则展示利用文字”Back”封装的返回按钮
//    NSString *back = nil ;
//    if([FindTopController topController].navigationController.navigationBar.topItem.leftBarButtonItems){
//        UIBarButtonItem *item = [[FindTopController topController].navigationController.navigationBar.topItem.leftBarButtonItems lastObject] ;
//        //返回按钮是由UIBarButtonItem的initWithCustomView定义
//        if(item.customView){
//            back = item.customView.accessibilityLabel ;
//        }else{
//            //如果定义了title
//            if(item.title){
//                back = item.title ;
//            }
//        }
//    }else if([FindTopController topController].navigationController.navigationBar.topItem.leftBarButtonItem){
//
//        //返回按钮是由UIBarButtonItem的initWithCustomView定义
//        if([FindTopController topController].navigationController.navigationBar.topItem.leftBarButtonItem.customView){
//            back = [FindTopController topController].navigationController.navigationBar.topItem.leftBarButtonItem.customView.accessibilityLabel ;
//        }else{
//           //如果定义了title
//           if([FindTopController topController].navigationController.navigationBar.topItem.leftBarButtonItem.title){
//               back = [FindTopController topController].navigationController.navigationBar.topItem.leftBarButtonItem.title ;
//           }
//        }
//    }else if([FindTopController topController].navigationController.navigationBar.backItem.backBarButtonItem){
//
//        //返回按钮是由UIBarButtonItem的initWithCustomView定义
//        if([FindTopController topController].navigationController.navigationBar.backItem.backBarButtonItem.customView){
//            back = [FindTopController topController].navigationController.navigationBar.backItem.backBarButtonItem.customView.accessibilityLabel ;
//        }else{
//            //如果定义了title
//           if([FindTopController topController].navigationController.navigationBar.backItem.backBarButtonItem.title){
//               back = [FindTopController topController].navigationController.navigationBar.backItem.backBarButtonItem.title ;
//           }
//        }
//    }else if([FindTopController topController].navigationController.navigationBar.backItem.title){
//        back = [FindTopController topController].navigationController.navigationBar.backItem.title ;
//    }else{
//        //获取当前语言环境
//        NSArray *languages = [NSLocale preferredLanguages] ;
//        NSString* preferredLang = [languages objectAtIndex:0];
//
//        //判断当前app是否支持中文环境
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
//        if(path){
//            back = @"返回" ;
//        }else{
//            back = @"Back" ;
//        }
//    }
//
//    if(back){
//        UIView *view = nil;
//        UIAccessibilityElement *element = nil;
//        NSPredicate *filter = [NSPredicate predicateWithFormat:@"accessibilityLabel = %@",back] ;
//        [tester tryFindingAccessibilityElement:&element view:&view withElementMatchingPredicate:filter tappable:NO error:nil] ;
//        //当前没有找到返回按钮
//        if(element != NULL && view != NULL){
//            [tester tapAccessibilityElement:element inView:view] ;
//        }else{
//            //尝试点击右上角按钮
//            [ZSFakeTouch beginTouchWithPoint:CGPointMake(55, 55)];
//            [ZSFakeTouch endTouchWithPoint:CGPointMake(55, 55)];
//        }
//    }else{
//        //尝试点击右上角按钮,兜底逻辑
//        [ZSFakeTouch beginTouchWithPoint:CGPointMake(55, 55)];
//        [ZSFakeTouch endTouchWithPoint:CGPointMake(55, 55)];
//    }
}
@end
