//
//  LLHomeWindowViewController.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/7/4.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLHomeWindowViewController.h"
#import "LLNetworkVC.h"
#import "LLAppInfoVC.h"
#import "LLSandboxVC.h"
#import "LLCrashVC.h"
#import "LLLogVC.h"
#import "LLOtherVC.h"
#import "LLMonkeySettingVC.h"
#import "LLMonkeySettingConfig.h"
#import "LLBaseTableViewCell.h"
#import "LLMacros.h"
#import "LLConfig.h"

static NSString *const kLLHomeVCNoneCellID = @"LLHomeVCNoneCellID";
static NSString *const kLLHomeVCCellID = @"LLHomeVCCellID";
static NSString *const kLLHomeVCHeaderID = @"LLHomeHeaderID";

@interface LLHomeWindowViewController ()
@property (nonatomic , strong) NSMutableArray *dataArray;
@end

@implementation LLHomeWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataArray = [self toolInfos];
    self.navigationItem.title = @"工具集";
}

- (NSArray *)networkInfos {
    return @[@{@"网络查看" : @""}];
}

- (NSArray *)crashInfos {
    return @[@{@"Crash查看" : @""}];
}

- (NSArray *)appInfos {
    return @[@{@"app信息查看" : @""}];
}

- (NSArray *)sandboxInfos {
    return @[@{@"沙箱查看" : @""}];
}

- (NSArray *)logInfos {
    return @[@{@"日志查看" : @""}];
}

- (NSArray *)monkeyInfos {
    return @[@{@"ios monkey" :  @""},
             @{@"cocos monkey" : @""}];
}

- (NSArray *)settingInfos{
    return @[@{@"设置" : @""}];
}

- (NSArray *)expectedInfos {
    return @[@{@"更多功能" : @""}];
}

- (NSMutableArray <NSArray <NSDictionary *>*>*)toolInfos {
    
    //网络功能
    NSArray *network = [self networkInfos];
    
    //crash功能
    NSArray *crash = [self crashInfos];
    
    //app信息
    NSArray *app = [self appInfos] ;
    
    //沙箱
    NSArray *sandbox = [self sandboxInfos] ;
    
    //日志
    NSArray *log = [self logInfos] ;
    
    //monkey
    NSArray *monkey = [self monkeyInfos] ;
    
    //设置
    NSArray *setting = [self settingInfos] ;
    
    // expected
    NSArray *expected = [self expectedInfos];
    
    return [[NSMutableArray alloc] initWithObjects:network ,crash, app,sandbox,log,monkey,setting, expected,nil];
}

- (void)initial {
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kLLHomeVCHeaderID];
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
            //网络查看
            LLNetworkVC *networkVC = [[LLNetworkVC alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:networkVC animated:YES];
            break ;
        }
        case 1:{
            //crash查看
            LLCrashVC *crashVC = [[LLCrashVC alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:crashVC animated:YES];
            break ;
        }
        case 2:{
            //app信息查看
           LLAppInfoVC *appInfoVC = [[LLAppInfoVC alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:appInfoVC animated:YES];
            break ;
        }
        case 3:{
            //沙箱查看
            LLSandboxVC *sandboxVC = [[LLSandboxVC alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:sandboxVC animated:YES];
            break ;
        }
        case 4:{
            //日志查看
            LLLogVC *logVC = [[LLLogVC alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:logVC animated:YES];
            break ;
        }
        case 5:{
            //monkey执行
            if(indexPath.row==0){
                //IOS monkey
                [LLMonkeySettingConfig defaultConfig].monkeyType = IOSMonkeyType ;
                LLMonkeySettingVC* vc = [[LLMonkeySettingVC alloc] initWithStyle:UITableViewStylePlain] ;
                [self.navigationController pushViewController:vc animated:YES] ;
            }else if(indexPath.row == 1){
                //cocos monkey
                [LLMonkeySettingConfig defaultConfig].monkeyType = CocosMonkeyType ;
                //cocos monkey
                LLMonkeySettingVC* vc = [[LLMonkeySettingVC alloc] initWithStyle:UITableViewStylePlain] ;
                [self.navigationController pushViewController:vc animated:YES] ;
            }
            break ;
        }
        case 6:{
            //设置
            LLOtherVC *otherVC = [[LLOtherVC alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:otherVC animated:YES] ;
            
            break ;
        }
        case 7:{
            //敬请期待
            break ;
        }
    }
}

-(LLBaseTableViewCell *)getTextCell:(UITableView*)tableView{
    //text cell
    LLBaseTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:kLLHomeVCCellID];
    if (!textCell) {
        textCell = [[LLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kLLHomeVCCellID];
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
    LLBaseTableViewCell *NoneCell = [tableView dequeueReusableCellWithIdentifier:kLLHomeVCNoneCellID];
    if (!NoneCell) {
        NoneCell = [[LLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLLHomeVCNoneCellID];
        NoneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NoneCell.accessoryType = UITableViewCellAccessoryNone ;
    }
    return NoneCell ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LLBaseTableViewCell *cell = nil ;
    
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    
    switch (indexPath.section) {
        case 0:{
            //网络功能
            cell = [self getTextCell:tableView]  ;
            cell.textLabel.text = dic.allKeys.firstObject ;
            break ;
        }
        case 1:{
            //crash功能
            cell = [self getTextCell:tableView]  ;
            cell.textLabel.text = dic.allKeys.firstObject ;
            break ;
            
        }
        case 2:{
            //app信息功能
            cell = [self getTextCell:tableView]  ;
            cell.textLabel.text = dic.allKeys.firstObject ;
            break ;
        }
        case 3:{
            //沙箱功能
            cell = [self getTextCell:tableView]  ;
            cell.textLabel.text = dic.allKeys.firstObject ;
            break ;
        }
        case 4:{
            //日志功能
            cell = [self getTextCell:tableView]  ;
            cell.textLabel.text = dic.allKeys.firstObject ;
            break ;
        }
        case 5:{
            //monkey功能
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
        case 6:{
            //设置功能
            cell = [self getTextCell:tableView]  ;
            cell.textLabel.text = dic.allKeys.firstObject ;
            break ;
        }
        case 7:{
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
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kLLHomeVCHeaderID];
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
        view.textLabel.text = @"网络";
    } else if (section == 1) {
        view = [self getHeaderFooterView:tableView] ;
        view.textLabel.text = @"Crash";
    }else if (section == 2){
        view = [self getHeaderFooterView:tableView] ;
        view.textLabel.text = @"App信息" ;
    }else if(section == 3){
        view = [self getHeaderFooterView:tableView] ;
        view.textLabel.text = @"沙箱" ;
    }else if(section == 4){
        view = [self getHeaderFooterView:tableView] ;
        view.textLabel.text = @"日志" ;
    }else if (section == 5) {
        view = [self getHeaderFooterView:tableView] ;
        view.textLabel.text = @"Monkey";
    }else if (section == 6){
        view = [self getHeaderFooterView:tableView] ;
        view.textLabel.text = @"设置";
    }else if (section == 7){
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
@end
