//
//  LLOtherVC.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/2/15.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLOtherVC.h"
#import "LLBaseTableViewCell.h"
#import "LLMacros.h"
#import "LLConfig.h"
#import "LLDebugTool.h"
#import "ZSFakeTouch.h"
#import "FindElementTree.h"
#import "KIF.h"
#import "Actions.h"
#import "MonkeyPaws.h"
//#ifdef ISLOCAL
//#import "LLDebugToolDemo-Swift.h"
//#else
////#import "NewLLDebugTool-Swift.h"
//#import "NewLLDebugTool/NewLLDebugTool-Swift.h"
//#endif

static NSString *const kLLOtherVCCellID = @"LLOtherVCCellID";
static NSString *const kLLOtherVCHeaderID = @"LLOtherHeaderID";

@interface LLOtherVC (){
    Byte  *_addMemory;
}

@property (nonatomic , strong) NSMutableArray *dataArray;
@end



@implementation LLOtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}


- (NSArray *)mockInfos {
    return @[@{@"mock开关" : [NSNumber numberWithInteger:LLConfigCellAccessoryStyleSwitch]}];
}

- (NSArray *)lowResourcesInfos {
    return @[@{@"弱网开关" :  [NSNumber numberWithInteger:LLConfigCellAccessoryStyleSwitch]},
             @{@"低内存开关" : [NSNumber numberWithInteger:LLConfigCellAccessoryStyleDisclosureIndicator]}];
}

- (NSArray *)monkeyInfos {
    return @[@{@"Monkey开关" : [NSNumber numberWithInteger:LLConfigCellAccessoryStyleSwitch]}];
}

- (NSArray *)expectedInfos {
    return @[@{@"更多功能" : [NSNumber numberWithInteger:LLConfigCellAccessoryStyleNone]}];
}


- (NSMutableArray <NSArray <NSDictionary *>*>*)otherInfos {
    
    //mock功能
    NSArray *mock = [self mockInfos];
    
    // low resource
    NSArray *lowResources = [self lowResourcesInfos];
    
    //monkey
    NSArray *monkey = [self monkeyInfos] ;
    
    // expected
    NSArray *expected = [self expectedInfos];
    
    return [[NSMutableArray alloc] initWithObjects:mock ,lowResources, monkey,expected, nil];
}

- (void)initial {
    self.dataArray = [self otherInfos];
    self.navigationItem.title = @"更多功能";
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kLLOtherVCHeaderID];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLLOtherVCCellID];
    if (!cell) {
        cell = [[LLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kLLOtherVCCellID];
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        cell.detailTextLabel.minimumScaleFactor = 0.5;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = dic.allKeys.firstObject;

    //1、cell 要改 
//    cell.detailTextLabel.text = @"开关";
   
    
    UISwitch *myswitch = [[UISwitch alloc]init];
    if([cell.textLabel.text isEqualToString:@"mock开关"]){
        myswitch.tag = LLConfigSwitchTagMock ;
        myswitch.on = [[LLDebugTool sharedTool] mockSwitch] ;
        cell.accessoryView = myswitch ;
    }else if([cell.textLabel.text isEqualToString:@"弱网开关"]){
        myswitch.tag = LLConfigSwitchTagLowNetwork ;
        myswitch.on = [[LLDebugTool sharedTool] lowNetworkSwitch] ;
        cell.accessoryView = myswitch ;
    }else if([cell.textLabel.text isEqualToString:@"低内存开关"]){
        myswitch.tag = LLConfigSwitchTagLowMemory ;
        myswitch.on = [[LLDebugTool sharedTool] lowMemorySwitch] ;
        cell.accessoryView = myswitch ;
    }else if([cell.textLabel.text isEqualToString:@"Monkey开关"]){
        myswitch.tag = LLConfigSwitchTagMonkey ;
        myswitch.on = [[LLDebugTool sharedTool] monkeySwitch] ;
        cell.accessoryView = myswitch ;
    }else if([cell.textLabel.text isEqualToString:@"更多功能"]){
        cell.accessoryType = UITableViewCellAccessoryNone ;
    }
    
    [myswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kLLOtherVCHeaderID];
    view.frame = CGRectMake(0, 0, LL_SCREEN_WIDTH, 30);
    if (view.backgroundView == nil) {
        view.backgroundView = [[UIView alloc] initWithFrame:view.bounds];
        view.backgroundView.backgroundColor = [LLCONFIG_TEXT_COLOR colorWithAlphaComponent:0.2];
    }

    if (section == 0) {
        view.textLabel.text = @"随机mock功能";
    } else if (section == 1) {
        view.textLabel.text = @"低资源模拟功能";
    }else if (section == 2){
        view.textLabel.text = @"monkey功能" ;
    }else if (section == 3) {
        view.textLabel.text = @"敬请期待";
    }
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    if (![header.textLabel.textColor isEqual:LLCONFIG_TEXT_COLOR]) {
        header.textLabel.textColor = LLCONFIG_TEXT_COLOR;
    }
}


- (void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    if(switchButton.tag == LLConfigSwitchTagMock){
        [[LLDebugTool sharedTool] saveMockSwitch:isButtonOn];
        NSLog(@"haleli >>> 界面消失") ;
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if(switchButton.tag == LLConfigSwitchTagLowNetwork){
        [[LLDebugTool sharedTool] saveLowNetworkSwitch:isButtonOn];
    }else if(switchButton.tag == LLConfigSwitchTagLowMemory){
        [[LLDebugTool sharedTool] saveLowMemorySwitch:isButtonOn];
        if(isButtonOn){
            if ([LLDebugTool sharedTool].memoryThread == nil){
                [LLDebugTool sharedTool].memoryThread = [[NSThread alloc] initWithTarget:self selector:@selector(highMemoryOperate) object:nil];
                [LLDebugTool sharedTool].memoryThread.name = @"HighMemoryThread";
                NSLog(@"haleli >>> switch_low_memoryk : %@",@"开始") ;
                [[LLDebugTool sharedTool].memoryThread  start];
            }
        }else{
            if([LLDebugTool sharedTool].memoryThread != nil){
                NSLog(@"haleli >>> switch_low_memoryk : %@",@"关闭") ;
                [[LLDebugTool sharedTool].memoryThread  cancel];
                [LLDebugTool sharedTool].memoryThread  = nil;
            }
        }
    }else if(switchButton.tag == LLConfigSwitchTagMonkey){
        [[LLDebugTool sharedTool] saveMonkeySwitch:isButtonOn];
        if(isButtonOn){
            if([LLDebugTool sharedTool].monkeyTimer == nil){
                NSLog(@"haleli >>> switch_monkey : %@",@"开始") ;
//                [[[OCMonkey alloc] init] showMonkeyPawsINUITestWithWindow:[self lastWindow] ] ;
//                UIWindow *theWindow = [[UIApplication sharedApplication] delegate].window ;
//                [LLDebugTool sharedTool].paws = [[MonkeyPaws alloc] initWithView:theWindow tapUIApplication:YES] ;
                
                
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
                    if (delegate) {
                        UIWindow *window;
                        if ([delegate respondsToSelector:@selector(window)]) {
                            window = [delegate window];
                        } else {
                            NSLog(@"Delegate does not respond to selector (window).");
                            window = [[UIApplication sharedApplication] windows][0];
                        }
                         [LLDebugTool sharedTool].paws = [[MonkeyPaws alloc] initWithView:window tapUIApplication:YES];
                    } else {
                         NSLog(@"Delegate is nil.");
                    }
                });
                
                
                [LLDebugTool sharedTool].monkeyTimer =[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(randomMonkey) userInfo:nil repeats:YES];
                NSLog(@"haleli >>> 界面消失") ;
//                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            if([LLDebugTool sharedTool].monkeyTimer != nil){
                NSLog(@"haleli >>> switch_monkey : %@",@"关闭") ;
                [[LLDebugTool sharedTool].monkeyTimer  invalidate];
                [LLDebugTool sharedTool].monkeyTimer  = nil;
            }
        }
    }
}

-(UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
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

-(UIViewController *)topController {
    
    UIViewController *topC = [self topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (topC.presentedViewController) {
        topC = [self topViewController:topC.presentedViewController];
    }
    return topC;
}

-(UIViewController *)topViewController:(UIViewController *)controller {
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)controller topViewController]];
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)controller selectedViewController]];
    } else {
        return controller;
    }
}
-(void)randomTest{
//    [UITextFieldActions clearTextFromAndThenEnterTextWithAccessibilityIdentifier:@"TBUIAutoTest_Property_account"] ;
//    [UIButtonActions tapButtonWithAccessibilityIdentifier:@"TBUIAutoTest_Property_loginButton"] ;
//    [BackActions back] ;
    [system deactivateAppForDuration:1] ;
}

- (void)randomMonkey{
    
    int width = self.view.bounds.size.width ;
    int height = self.view.bounds.size.height ;
    int x = arc4random() % width  ;
    int y = arc4random() % height ;
    int seed = arc4random() % 10 ;

    //10%的概率发送滑动事件
    if(seed<1){
        int endX = arc4random() % width ;
        int endY = arc4random() % height ;
        NSLog(@"haleli >>>> test monkey,swip(%d,%d) to (%d,%d)",x,y,endX,endY) ;
        [self swapWithPoint:CGPointMake(x, y) endPoint:CGPointMake(endX, endY)] ;
    //10%的返回事件
    }
    else if(seed<2){
        NSLog(@"haleli >>>> test monkey,back action") ;
        [BackActions back] ;
    //10%的点击alert事件
    }
    else if(seed<3){
        NSLog(@"haleli >>>> test monkey,acknowledge alert action") ;
        [UIAlertActions acknowledgeAlert] ;
    //30%的概率发送click事件
    }
    else if(seed<6){
        NSLog(@"haleli >>>> test monkey,click(%d,%d)",x,y) ;
        [self touchesWithPoint:CGPointMake(x,y)];
    }else if(seed < 10){
        //40%的概率发送UI事件
        //查找控件树
        NSMutableArray *array = [FindElementTree tree] ;

        if(array.count>0){
            int random = arc4random() % [array count] ;
            
            NSDictionary *dict = [array objectAtIndex:random] ;
            
            if(![[dict objectForKey:@"identifier"] isEqual:@""] ){
                NSString *accessibilityIdentifier = [dict objectForKey:@"identifier"] ;
                NSString *className = [dict objectForKey:@"className"] ;
                
                if([className isEqual:@"UITableView"]){
                    int tableSeed = arc4random() % 2 ;
                    //50%执行活动操作
                    if(tableSeed<1){
                        NSLog(@"haleli >>>> test monkey,UITableView swipe action") ;
                        [UITableViewActions swipeTableViewWithAccessibilityIdentifier:accessibilityIdentifier] ;
                    }else{
                        NSLog(@"haleli >>>> test monkey,UITableView tap action") ;
                        [UITableViewActions tapRowAtIndexPathWithAccessibilityIdentifier:accessibilityIdentifier] ;
                    }
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
                }else if([className isEqual:@"UIButton"]){
                    NSLog(@"haleli >>>> test monkey,UIButton tap action") ;
                    [UIButtonActions tapButtonWithAccessibilityIdentifier:accessibilityIdentifier] ;
                }else if([className isEqual:@"UISegmentedControl"]){
                    NSLog(@"haleli >>>> test monkey,UISegmentedControl tap action") ;
                    [UISegmentedControlActions tapSegmentedControlWithAccessibilityIdentifier:accessibilityIdentifier] ;
                }else if([className isEqual:@"UICollectionView"]){
                    int collectionSeed = arc4random() % 2 ;
                    //50%执行活动操作
                    if(collectionSeed<1){
                        NSLog(@"haleli >>>> test monkey,UICollectionView swipe action") ;
                        [UICollectionViewActions swipeCollectionViewWithAccessibilityIdentifier:accessibilityIdentifier] ;
                    }else{
                        NSLog(@"haleli >>>> test monkey,UICollectionView tap action") ;
                        [UICollectionViewActions tapItemAtIndexPathWithAccessibilityIdentifier:accessibilityIdentifier] ;
                    }
                }
                else{
                    NSLog(@"haleli >>>> test monkey,no support view : %@",className) ;
                }
            }else{
                NSLog(@"haleli >>>> test monkey,no identifier") ;
            }
        }
    }
}

- (void)highMemoryOperate{
    //点击按钮，如果未释放，则释放
    @synchronized (self) {
        if (_addMemory) {
            NSLog(@"free memory") ;
            free(_addMemory);
            _addMemory = nil;
            
        }
    }
    int addedMemSize = 0;
    int interval = 2;
    BOOL needAddMem = TRUE ;
    
    while (TRUE) {
        if(needAddMem){
            addedMemSize = addedMemSize + 400 ;
        }
        
        if ([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
        
        @synchronized (self) {
            if (!_addMemory) {
                _addMemory = malloc(1024*1024*addedMemSize);
                if (_addMemory) {
                    memset(_addMemory, 0, 1024*1024*addedMemSize);
                    NSLog(@"haleli >>> add memory :%d",addedMemSize) ;
                }else{
                    addedMemSize = addedMemSize - 400 ;
                    needAddMem = FALSE ;
                    NSLog(@"add mem failed!");
                }
                
            }
        }
        
        [NSThread sleepForTimeInterval:interval];
            
        @synchronized (self) {
            if (_addMemory) {
                NSLog(@"haleli >>> free memory : %d",addedMemSize) ;
                free(_addMemory);
                _addMemory = nil;
                
            }
        }
            
        if ([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
        
        
        
        [NSThread sleepForTimeInterval:interval];
    }
}

@end
