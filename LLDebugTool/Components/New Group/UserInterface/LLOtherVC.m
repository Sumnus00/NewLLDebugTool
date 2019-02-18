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

- (NSArray *)expectedInfos {
    return @[@{@"更多功能" : [NSNumber numberWithInteger:LLConfigCellAccessoryStyleNone]}];
}

- (NSMutableArray <NSArray <NSDictionary *>*>*)otherInfos {
    
    //mock功能
    NSArray *mock = [self mockInfos];
    
    // low resource
    NSArray *lowResources = [self lowResourcesInfos];
    
    // expected
    NSArray *expected = [self expectedInfos];
    
    return [[NSMutableArray alloc] initWithObjects:mock ,lowResources, expected, nil];
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

    //1、cell 要改 2、根据样式改变switch样式
//    cell.detailTextLabel.text = @"开关";
   
    
    UISwitch *myswitch = [[UISwitch alloc]init];
    if([cell.textLabel.text isEqualToString:@"mock开关"]){
        myswitch.tag = LLConfigSwitchTagMock ;
        myswitch.on = [[LLDebugTool sharedTool] mockSwitch] ;
    }else if([cell.textLabel.text isEqualToString:@"弱网开关"]){
        myswitch.tag = LLConfigSwitchTagLowNetwork ;
        myswitch.on = [[LLDebugTool sharedTool] lowNetworkSwitch] ;
    }else if([cell.textLabel.text isEqualToString:@"低内存开关"]){
        myswitch.tag = LLConfigSwitchTagLowMemory ;
        myswitch.on = [[LLDebugTool sharedTool] lowMemorySwitch] ;
    }else if([cell.textLabel.text isEqualToString:@"更多功能"]){
       myswitch.tag = LLConfigSwitchTagExpected ;
    }
    
    [myswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = myswitch ;
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
    } else if (section == 2) {
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
    }else if(switchButton.tag == LLConfigSwitchTagLowNetwork){
        [[LLDebugTool sharedTool] saveLowNetworkSwitch:isButtonOn];
    }else if(switchButton.tag == LLConfigSwitchTagLowMemory){
        [[LLDebugTool sharedTool] saveLowMemorySwitch:isButtonOn];
        if(isButtonOn){
            [LLDebugTool sharedTool].memoryThread = [[NSThread alloc] initWithTarget:self selector:@selector(highMemoryOperate) object:nil];
            [LLDebugTool sharedTool].memoryThread.name = @"HighMemoryThread";
            NSLog(@"haleli >>> switch_low_memoryk : %@",@"开始") ;
            [[LLDebugTool sharedTool].memoryThread  start];
        }else{
            NSLog(@"haleli >>> switch_low_memoryk : %@",@"关闭") ;
            [[LLDebugTool sharedTool].memoryThread  cancel];
            [LLDebugTool sharedTool].memoryThread  = nil;
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
