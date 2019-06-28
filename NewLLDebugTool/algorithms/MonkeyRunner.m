//
//  MonkeyRunner.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/6/5.
//  Copyright © 2019 li. All rights reserved.
//

#import "MonkeyRunner.h"
#import "LLDebugTool.h"

@implementation MonkeyRunner

- (instancetype)initWithAlgorithm: (id<MonkeyAlgorithmDelegate>) algorithm{
    self = [super init] ;
    if(self){
        _preTree = nil ;
        _curTree = nil ;
        _preElement = nil ;
        _algorithm = algorithm ;
        _blacklist = [[NSMutableArray alloc] initWithArray:@[@"UIActivityViewController",@"UIAlertController",@"TestCrashViewController",@"LLOtherVC",@"UIViewController"]] ;
    }
    return self ;
}

//cocos monkey
-(void)runOneCocosStep{
    UIViewController *controller = [FindTopController topController] ;
    //cocos 页面
    if([controller isKindOfClass:[[UIApplication sharedApplication].keyWindow.rootViewController class]]){
        NSLog(@"haleli >>>> 页面 属于 cocos") ;
        int width = [[UIScreen mainScreen] bounds].size.width ;
        int height = [[UIScreen mainScreen] bounds].size.height ;
        int x = arc4random() % width  ;
        int y = arc4random() % height ;
        int seed = arc4random() % 10 ;
        
        //10%的概率发送滑动事件
        if(seed<1){
            int endX = arc4random() % width ;
            int endY = arc4random() % height ;
            NSLog(@"haleli >>>> test monkey,swip(%d,%d) to (%d,%d)",x,y,endX,endY) ;
            [self swapWithPoint:CGPointMake(x, y) endPoint:CGPointMake(endX, endY)] ;
            //10%的概率发送click事件
        }else if(seed<2){
            NSLog(@"haleli >>>> test monkey,click(%d,%d)",x,y) ;
            [self touchesWithPoint:CGPointMake(x,y)];
        }else if(seed < 10){
            if([LLDebugTool sharedTool].ccTree){
                
                double width = MAX([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height) ;
                double height = MIN([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height) ;
                
                NSDictionary *tree = [LLDebugTool sharedTool].ccTree() ;
                
                NSArray *children = [tree objectForKey:@"children"] ;
                
                NSDictionary *child = nil ;
                //10%的返回事件
                if(seed < 3){
                    if([children count] > 0){
                        
                        child = [children lastObject] ;
                        NSLog(@"haleli >>>> test monkey,back action , click name : %@ ",[child objectForKey:@"name"]) ;
                        if(![[[child objectForKey:@"name"] lowercaseString] containsString:@"back"]){
                            [self touchesWithPoint:CGPointMake(344,32)];
                            return ;
                        }
                        
                    }
                    //70%的概率发送UI事件
                }else{
                    if([children count] > 1){
                        int random = arc4random() % ([children count] - 1);
                        child = [children objectAtIndex:random] ;
                        
                        NSLog(@"haleli >>>> test monkey,ui action , click name : %@ ",[child objectForKey:@"name"]) ;
                    }
                }
                
                NSDictionary *payload = [child objectForKey:@"payload"] ;
                
                NSArray *pos = [payload objectForKey:@"pos"] ;
                
                
                double x = [[pos objectAtIndex:0] doubleValue] * width;
                double y = [[pos objectAtIndex:1] doubleValue] * height;
                [self touchesWithPoint:CGPointMake(x,y)];
                
                
            }else{
                NSLog(@"cocos creator don't get tree") ;
            }
        }
        //ios 页面
    }else{
        NSLog(@"haleli >>>> 页面 属于 iOS") ;
        [self runOneRandomStep] ;
    }
}
//随机便利算法的一步
-(void)runOneRandomStep{
    int width = [[UIScreen mainScreen] bounds].size.height ;
    int height = [[UIScreen mainScreen] bounds].size.height ;
    int x = arc4random() % width  ;
    int y = arc4random() % height ;
    int seed = arc4random() % 20 ;
    
    //5%的概率发送滑动事件
    if(seed<1){
        int endX = arc4random() % width ;
        int endY = arc4random() % height ;
        NSLog(@"haleli >>>> test monkey,swip(%d,%d) to (%d,%d)",x,y,endX,endY) ;
        [self swapWithPoint:CGPointMake(x, y) endPoint:CGPointMake(endX, endY)] ;
        //5%的返回事件
    }
    else if(seed<2){
        NSLog(@"haleli >>>> test monkey,back action") ;
        [BackActions back] ;
        //5%的点击alert事件
    }
    else if(seed<3){
        NSLog(@"haleli >>>> test monkey,acknowledge alert action") ;
        [UIAlertActions acknowledgeAlert] ;
        //15%的概率发送click事件
    }
    else if(seed<6){
        NSLog(@"haleli >>>> test monkey,click(%d,%d)",x,y) ;
        [self touchesWithPoint:CGPointMake(x,y)];
    }else if(seed < 20){
        //75%的概率发送UI事件
        //查找控件树
        Tree* tree =[[App sharedApp] getCurrentTree] ;
        
        //从树里面选择一个控件
        Element *element = [_algorithm chooseElementFromTree:tree] ;
        
        if(element == nil){
            //需要返回上一个界面
            [BackActions back] ;
        }else{
            [self OperateElement:element] ;
        }
    }
}

//快速遍历算法的一步
-(void)runOneQuickStep{
    Tree* tree =[[App sharedApp] getCurrentTree] ;
    
    if(tree){
        if([_blacklist containsObject:tree.treeID]){
            NSLog(@"点击到黑名单控件或者UIActivityViewController或者UIAlertController") ;
            _preTree = nil ;
            _curTree = nil ;
            [BackActions back] ;
            return ;
        }
    }
    //更新树
    [[App sharedApp] updateTree: tree] ;

    if(_preTree && _preElement && tree && !_preElement.isMenu && [_preTree isSameTreeId:tree]){
        _preElement.isBack = YES ;
        _preTree = nil ;
        _curTree = nil ;
    }

    if(_curTree && tree && _preElement && ![_curTree isSameTreeId:tree] && !_preElement.isBack && _preElement.isMenu){
        _preElement.isJumped = true ;
        _preTree = nil ;
        _curTree = nil ;
    }else if(_curTree && tree && _preElement && ![_curTree isSameTreeId:tree] && !_preElement.isBack && !_preElement.isMenu){
        _preElement.isJumped = true ;
        _preElement.toTree = [[App sharedApp] getTree:tree.treeID] ;
    }else if(_curTree && tree && _preElement && ![_curTree isSameTree: tree] && !_preElement.isBack && !_preElement.isMenu){
        _preElement.isTreeChanged = true ;
    }

    if(tree && _curTree && ![tree isSameTreeId:_curTree]){
        _preTree = _curTree ;
    }

    _curTree = tree ;

    //从树里面选择一个控件
    Element *element = [_algorithm chooseElementFromTree:_curTree] ;

    if(element == nil){
        //需要返回上一个界面
        _preTree = nil ;
        _curTree = nil ;
        [BackActions back] ;

    }else{
        _preElement = element ;
        
        @try {
             [self OperateElement:element] ;
        } @catch (NSException *exception) {
            NSLog(@"haleli >>>> test monkey,exception : %@",exception.name);
        } @finally {
            ;
        }
        
        element.clickTimes = element.clickTimes + 1 ;
        if([element.type isEqual:@"UITabBarButton"]){
            element.isMenu = true ;
        }
    }
    
}

-(void)OperateElement:(Element *)element{
  
    NSString *accessibilityIdentifier = element.elementId;
    NSString *className = element.type ;

    if([className isEqual:@"UITableView"]){
        NSLog(@"haleli >>>> test monkey,UITableView swipe action") ;
        [UITableViewActions swipeTableViewWithAccessibilityIdentifier:accessibilityIdentifier] ;
    }else if([className isEqual:@"UISwitch"]){
        NSLog(@"haleli >>>> test monkey,UISwitch tap action") ;
        [UISwitchActions setSwitchWithAccessibilityIdentifier:accessibilityIdentifier] ;
    }else if([className isEqual:@"UITabBar"]){
        NSLog(@"haleli >>>> test monkey,UITabBar tap action") ;
        [UITabBarActions tapTabBarWithAccessibilityIdentifier:accessibilityIdentifier] ;
    }else if([className isEqual:@"UINavigationBar"]){
        NSLog(@"haleli >>>> test monkey,UINavigationBar tap action") ;
        [UINavigationBarActions tapNavigationBarWithAccessibilityIdentifier:accessibilityIdentifier] ;
    }else if([className isEqual:@"UITextField"]){
        NSLog(@"haleli >>>> test monkey,UITextFieldActions enter text action") ;
        [UITextFieldActions clearTextFromAndThenEnterTextWithAccessibilityIdentifier:accessibilityIdentifier] ;
    }else if([className isEqual:@"UITextView"]){
        NSLog(@"haleli >>>> test monkey,UITextViewActions enter text action") ;
        [UITextViewActions clearTextFromAndThenEnterTextWithAccessibilityIdentifier:accessibilityIdentifier] ;
    }else if([className isEqual:@"UIButton"]){
        NSLog(@"haleli >>>> test monkey,UIButton tap action") ;
        [UIButtonActions tapButtonWithAccessibilityIdentifier:accessibilityIdentifier] ;
    }else if([className isEqual:@"UISegmentedControl"]){
        NSLog(@"haleli >>>> test monkey,UISegmentedControl tap action") ;
        [UISegmentedControlActions tapSegmentedControlWithAccessibilityIdentifier:accessibilityIdentifier] ;
    }else if([className isEqual:@"UICollectionView"]){
        NSLog(@"haleli >>>> test monkey,UICollectionView swipe action") ;
        [UICollectionViewActions swipeCollectionViewWithAccessibilityIdentifier:accessibilityIdentifier] ;
        
    }else if([className isEqual:@"UITableViewCell"]){
        NSLog(@"haleli >>>> test monkey,UITableViewCell tap action") ;
        if([element.info count] > 0){
            NSInteger section = [[element.info objectForKey:@"section"] intValue];
            NSInteger row = [[element.info objectForKey:@"row"] intValue];
            NSString *accessibilityIdentifier = [element.info objectForKey:@"accessibilityIdentifier"] ;
            [UITableViewCellActions tapTableViewCellWithAccessibilityIdentifier:accessibilityIdentifier section:section row:row] ;
        }
    }else if([className isEqual:@"UICollectionViewCell"]){
        NSLog(@"haleli >>>> test monkey,UICollectionViewCell tap action") ;
        if([element.info count] > 0){
            NSInteger section = [[element.info objectForKey:@"section"] intValue];
            NSInteger item = [[element.info objectForKey:@"item"] intValue];
            NSString *accessibilityIdentifier = [element.info objectForKey:@"accessibilityIdentifier"] ;
            [UICollectionViewCellActions tapCollectionViewCellWithAccessibilityIdentifier:accessibilityIdentifier section:section item:item] ;
        }
    }else if([className isEqual:@"UITabBarButton"]){
        NSLog(@"haleli >>>> test monkey,UITabBarButton tap action") ;
        [UITabBarButtonActions tapTabBarButtonWithAccessibilityIdentifier:accessibilityIdentifier] ;
    }else if([className isEqual:@"UIPickerView"]){
        NSLog(@"haleli >>>> test monkey,UIPickerView select action") ;
        [UIPickerViewActions selectPickerViewRowWithAccessibilityIdentifier:accessibilityIdentifier] ;
    }
    else{
        NSLog(@"haleli >>>> test monkey,no support view : %@",className) ;
    }
}


-(void)touchesWithPoint:(CGPoint)zspoint{
    [ZSFakeTouch beginTouchWithPoint:zspoint];
    [ZSFakeTouch endTouchWithPoint:zspoint];
}

-(void)swapWithPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    [ZSFakeTouch beginTouchWithPoint:startPoint];
    [ZSFakeTouch moveTouchWithPoint:endPoint];
    [ZSFakeTouch endTouchWithPoint:endPoint];
}
@end
