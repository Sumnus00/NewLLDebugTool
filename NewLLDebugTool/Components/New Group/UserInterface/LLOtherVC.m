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
#import "LLMonkeySettingVC.h"
#import "LLMonkeySettingConfig.h"
//#ifdef ISLOCAL
//#import "LLDebugToolDemo-Swift.h"
//#else
////#import "NewLLDebugTool-Swift.h"
//#import "NewLLDebugTool/NewLLDebugTool-Swift.h"
//#endif

static NSString *const kLLOtherVCCellID = @"LLOtherVCCellID";
static NSString *const kLLOtherVCSwitchCellID = @"LLOtherVCSwitchCellID";
static NSString *const kLLOtherVCNoneCellID = @"LLOtherVCNoneCellID";
static NSString *const kLLOtherVCLogCellID = @"LLOtherVCLogCellID";
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataArray = [self otherInfos];
    self.navigationItem.title = @"更多功能";
}

- (NSArray *)mockInfos {
    return @[@{@"mock开关" : @""}];
}

- (NSArray *)lowResourcesInfos {
    return @[@{@"弱网开关" :  @""},
             @{@"低内存开关" : @""}];
}

- (NSArray *)monkeyInfos {
    return @[@{@"ios Monkey开关" : @""},
             @{@"cocos Monkey开关" : @""}];
}

- (NSArray *)privateNetworkInfos {
    return @[@{@"私有包显示开关" : @""}];
}

- (NSArray *)commonToolsInfos {
    return @[@{@"日志上传" : @""}];
}

- (NSArray *)expectedInfos {
    return @[@{@"更多功能" : @""}];
}


- (NSMutableArray <NSArray <NSDictionary *>*>*)otherInfos {
    
    //mock功能
    NSArray *mock = [self mockInfos];
    
    // low resource
    NSArray *lowResources = [self lowResourcesInfos];
    
    //monkey
    NSArray *monkey = [self monkeyInfos] ;
    
    //private network
    NSArray *privateNetwork = [self privateNetworkInfos] ;
    
    //common tools
    NSArray *commonTools = [self commonToolsInfos] ;
    
    // expected
    NSArray *expected = [self expectedInfos];
    
    return [[NSMutableArray alloc] initWithObjects:mock ,lowResources, monkey,privateNetwork,commonTools,expected, nil];
}



- (void)initial {
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kLLOtherVCHeaderID];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section){
        case 0:{
            //随机mock功能
            break ;
        }
        case 1:{
            //低资源模拟功能
            break ;
        }
        case 2:{
            //monkey功能
            if(indexPath.row==0){
                //IOS monkey
                [LLMonkeySettingConfig defaultConfig].monkeyType = IOSMonkeyType ;
                
                LLMonkeySettingVC* vc = [[LLMonkeySettingVC alloc] init] ;
                [self.navigationController pushViewController:vc animated:YES] ;
            }else if(indexPath.row == 1){
                
                [LLMonkeySettingConfig defaultConfig].monkeyType = CocosMonkeyType ;
                //cocos monkey
                LLMonkeySettingVC* vc = [[LLMonkeySettingVC alloc] init] ;
                [self.navigationController pushViewController:vc animated:YES] ;
            }
            break ;
        }
        case 3:{
            //私有包显示功能
            break ;
        }
        case 4:{
            //常用工具
            if(indexPath.row == 0){
                //日志上传
                if([LLDebugTool sharedTool].uploadLog){
                    [self showAlertControllerWithMessage:@"Sure to upload log ?" handler:^(NSInteger action) {
                        if (action == 1) {
                            [LLDebugTool sharedTool].uploadLog() ;
                        }
                    }];
                    
                }
            }
            break ;
        }
        case 5:{
            //敬请期待
            break ;
        }
    }
}

-(LLBaseTableViewCell *)getSwithCell:(UITableView*) tableView switchTag:(NSInteger)tag switchOn:(BOOL)on{
    //switch cell
    UISwitch *myswitch = [[UISwitch alloc]init];
    myswitch.tag = tag ;
    [myswitch setOn:on] ;
    [myswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    LLBaseTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:kLLOtherVCSwitchCellID];
    if (!switchCell) {
        switchCell = [[LLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLLOtherVCSwitchCellID];
        switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        switchCell.accessoryView = myswitch ;
    }
    return switchCell ;
}

-(LLBaseTableViewCell *)getTextCell:(UITableView*)tableView{
    //text cell
    LLBaseTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:kLLOtherVCCellID];
    if (!textCell) {
        textCell = [[LLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kLLOtherVCCellID];
        textCell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        textCell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        textCell.detailTextLabel.minimumScaleFactor = 0.5;
        textCell.selectionStyle = UITableViewCellSelectionStyleNone;
        textCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    }
    return textCell ;
}

-(LLBaseTableViewCell *)getNoneCell:(UITableView*)tableView{
    //None cell
    LLBaseTableViewCell *NoneCell = [tableView dequeueReusableCellWithIdentifier:kLLOtherVCNoneCellID];
    if (!NoneCell) {
        NoneCell = [[LLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLLOtherVCNoneCellID];
        NoneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NoneCell.accessoryType = UITableViewCellAccessoryNone ;
    }
    return NoneCell ;
}

-(LLBaseTableViewCell *)getLogCell:(UITableView*)tableView{
    //Log cell
    LLBaseTableViewCell *LogCell = [tableView dequeueReusableCellWithIdentifier:kLLOtherVCLogCellID];
    if (!LogCell) {
        LogCell = [[LLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLLOtherVCLogCellID];
        LogCell.selectionStyle = UITableViewCellSelectionStyleNone;
        LogCell.accessoryType = UITableViewCellAccessoryNone ;
        LogCell.textLabel.textColor = [[UIView alloc] init].tintColor ;
    }
    return LogCell ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LLBaseTableViewCell *cell = nil ;
    
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    
    switch (indexPath.section) {
        case 0:{
            //mock 开关
            cell = [self getSwithCell:tableView switchTag:LLConfigSwitchTagMock switchOn: [[LLDebugTool sharedTool] mockSwitch] ];
            cell.textLabel.text = dic.allKeys.firstObject ;
            break ;
        }
        case 1:{
            //弱网开关
            if(indexPath.row == 0){
                cell = [self getSwithCell:tableView switchTag:LLConfigSwitchTagLowNetwork switchOn: [[LLDebugTool sharedTool] lowNetworkSwitch] ];
                cell.textLabel.text = dic.allKeys.firstObject ;
            }else if(indexPath.row == 1){
                //低内存开关
                cell = [self getSwithCell:tableView switchTag:LLConfigSwitchTagLowMemory switchOn:[[LLDebugTool sharedTool] lowMemorySwitch]] ;
                cell.textLabel.text = dic.allKeys.firstObject ;
            }
            break ;
            
        }
        case 2:{
            //ios Monkey开关
            if(indexPath.row == 0){
                cell = [self getTextCell:tableView] ;
                cell.textLabel.text = dic.allKeys.firstObject ;
            }else if(indexPath.row == 1){
                //cocos Monkey开关
                cell = [self getTextCell:tableView]  ;
                cell.textLabel.text = dic.allKeys.firstObject ;
            }
            break ;
        }
        case 3:{
            //私有包显示开关
            cell = [self getSwithCell:tableView switchTag:LLConfigSwitchTagPrivateNetwork switchOn:[[LLDebugTool sharedTool] privateNetworkSwitch]] ;
            cell.textLabel.text = dic.allKeys.firstObject ;
            break ;
        }
        case 4:{
            //日志上传
            cell = [self getLogCell:tableView] ;
            cell.textLabel.text = dic.allKeys.firstObject ;
            break ;
        }
        case 5:{
            //更多功能
            cell = [self getNoneCell:tableView] ;
            cell.textLabel.text = dic.allKeys.firstObject ;
            break ;
        }

    }
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

-(UITableViewHeaderFooterView*)getHeaderFooterView:(UITableView*)tableView{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kLLOtherVCHeaderID];
    view.frame = CGRectMake(0, 0, LL_SCREEN_WIDTH, 30);
    if (view.backgroundView == nil) {
        view.backgroundView = [[UIView alloc] initWithFrame:view.bounds];
        view.backgroundView.backgroundColor = [LLCONFIG_TEXT_COLOR colorWithAlphaComponent:0.2];
    }
    return view ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = nil ;
    if (section == 0) {
        view = [self getHeaderFooterView:tableView] ;
        view.textLabel.text = @"随机mock功能";
    } else if (section == 1) {
        view = [self getHeaderFooterView:tableView] ;
        view.textLabel.text = @"低资源模拟功能";
    }else if (section == 2){
        view = [self getHeaderFooterView:tableView] ;
        view.textLabel.text = @"monkey功能" ;
    }else if(section == 3){
        view = [self getHeaderFooterView:tableView] ;
        view.textLabel.text = @"私有包显示功能" ;
    }else if(section == 4){
        view = [self getHeaderFooterView:tableView] ;
        view.textLabel.text = @"常用工具" ;
    }else if (section == 5) {
        view = [self getHeaderFooterView:tableView] ;
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
    }else if(switchButton.tag == LLConfigSwitchTagPrivateNetwork){
        [[LLDebugTool sharedTool] savePrivateNetworkSwitch:isButtonOn];
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
