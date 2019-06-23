//
//  LLMonkeyAlgorithmVC.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/19.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLMonkeyAlgorithmVC.h"
#import "LLConfig.h"
#import "LLBaseTableViewCell.h"
#import "LLIOSMonkeySettingHelper.h"
#import "LLCocosMonkeySettingHelper.h"
#import "LLMacros.h"
#import "LLMonkeySettingConfig.h"

static NSString *const kLLMonkeyAlgorithmVCCellID = @"LLMonkeyAlgorithmVCCellID";
static NSString *const kLLMonkeyAlgorithmVCHeaderID = @"LLMonkeyAlgorithmVCHeaderID";
@interface LLMonkeyAlgorithmVC ()
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) NSIndexPath *selIndex ;
@end

@implementation LLMonkeyAlgorithmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([LLMonkeySettingConfig defaultConfig].monkeyType==IOSMonkeyType){
        self.navigationItem.title = @"IOS Monkey算法设置";
    }else{
        self.navigationItem.title = @"Cococs Monkey算法设置";
    }
    [self _loadData] ;
}

-(void)_loadData{
    self.dataArray = [self monkeyAlgorithmInfos];
    NSString *algorithm = nil ;
    if([LLMonkeySettingConfig defaultConfig].monkeyType==IOSMonkeyType){
        algorithm = [LLIOSMonkeySettingHelper sharedHelper].monkeySettingModel.algorithm;
    }else{
        algorithm = [LLCocosMonkeySettingHelper sharedHelper].monkeySettingModel.algorithm;
    }
    for(int section=0;section<self.dataArray.count ;section++){
        NSArray *infos = [self.dataArray objectAtIndex:section] ;
        for(int row=0;row<infos.count;row++){
            NSDictionary *dic = self.dataArray[section][row] ;
            if([algorithm isEqual: dic.allKeys.firstObject]){
                _selIndex = [NSIndexPath indexPathForRow:row inSection:section] ;
                break ;
            }
        }
    }
}

- (NSArray *)algorithmInfos {
    return @[@{@"快速遍历算法" :@""},
             @{@"随机遍历算法" : @""}];
    
}

- (NSMutableArray <NSArray <NSDictionary *>*>*)monkeyAlgorithmInfos {
    
    //算法设置
    NSArray *algorithm = [self algorithmInfos];
    
    return [[NSMutableArray alloc] initWithObjects:algorithm ,nil];
}


- (void)initial {
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kLLMonkeyAlgorithmVCHeaderID];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row] ;

    BOOL result = false ;
    if([LLMonkeySettingConfig defaultConfig].monkeyType==IOSMonkeyType){
        result = [[LLIOSMonkeySettingHelper sharedHelper] setAlgorithm:dic.allKeys.firstObject] ;
    }else{
        result = [[LLCocosMonkeySettingHelper sharedHelper] setAlgorithm:dic.allKeys.firstObject] ;
    }
    
    if(result){
        //取消之前的选择
        UITableViewCell *celled = [tableView cellForRowAtIndexPath:_selIndex] ;
        celled.accessoryType = UITableViewCellAccessoryNone ;
        
        _selIndex = indexPath ;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
    }else{
        [self showAlertControllerWithMessage:@"save data fail" handler:^(NSInteger action) {
            if (action == 1) {
                [self _loadData];
            }
        }];
    }
    
    
}
-(LLBaseTableViewCell *)getCheckMarkCell:(UITableView*) tableView{
    //checkmark cell
    LLBaseTableViewCell *checkMarkCell = [tableView dequeueReusableCellWithIdentifier:kLLMonkeyAlgorithmVCCellID];
    if (!checkMarkCell) {
        checkMarkCell = [[LLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLLMonkeyAlgorithmVCCellID];
        checkMarkCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return checkMarkCell ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LLBaseTableViewCell *cell = [self getCheckMarkCell:tableView];
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = dic.allKeys.firstObject;

    if(_selIndex == indexPath){
        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone ;
    }
    return cell ;
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
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kLLMonkeyAlgorithmVCHeaderID];
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
        view.textLabel.text = @"monkey算法";
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
