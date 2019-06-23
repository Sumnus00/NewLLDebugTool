//
//  LLMonkeyListVC.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/22.
//  Copyright © 2019 li. All rights reserved.
//

#import "LLMonkeyListVC.h"
#import "LLMonkeySettingConfig.h"
#import "LLIOSMonkeySettingHelper.h"
#import "LLCocosMonkeySettingHelper.h"
#import "LLBaseTableViewCell.h"
#import "LLImageNameConfig.h"
#import "LLConfig.h"
#import "LLTool.h"
#import "LLMacros.h"

static NSString *const kMonkeyListCellID = @"MonkeyListCellID";
static NSString *const kLLMonkeyListButtonCellID = @"MonkeyListButtonCellID";
static NSString *const kLLMonkeyListVCHeaderID = @"LLMonkeyListVCHeaderID";
static NSString *const kLLMonkeyListVCSpaceHeaderID = @"LLMonkeyListVCSpaceHeaderID";

@interface LLMonkeyListVC ()
@property (nonatomic , strong) UIBarButtonItem *selectAllItem;

@property (nonatomic , strong) UIBarButtonItem *deleteItem;

@property (nonatomic , strong) NSMutableArray<NSMutableArray*> *dataArray;

@end



@implementation LLMonkeyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.tableView.isEditing) {
        [self rightItemClick];
    }
}

- (void)rightItemClick {
    UIBarButtonItem *buttonItem = self.navigationItem.rightBarButtonItem;
    UIButton *btn = buttonItem.customView;
    if (!btn.isSelected) {
        if ([self.dataArray objectAtIndex:0].count) {
            btn.selected = !btn.selected;
            [self.tableView setEditing:YES animated:YES];
            self.deleteItem.enabled = NO;
            [self.navigationController setToolbarHidden:NO animated:YES];
        }
    } else {
        btn.selected = !btn.selected;
        [self.tableView setEditing:NO animated:YES];
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

- (void)selectAllItemClick:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"Select All"]) {
        item.title = @"Cancel All";
        self.deleteItem.enabled = YES;
        for (int i = 0; i < [self.dataArray objectAtIndex:0].count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        item.title = @"Select All";
        self.deleteItem.enabled = NO;
        for (int i = 0; i < [self.dataArray objectAtIndex:0].count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

- (void)deleteItemClick:(UIBarButtonItem *)item {
    NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
    [self _showDeleteAlertWithIndexPaths:indexPaths];
    [self rightItemClick];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}


-(LLBaseTableViewCell *)getCell:(UITableView*)tableView{
    // cell
    LLBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMonkeyListCellID];
    if (!cell) {
        cell = [[LLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMonkeyListCellID];
        cell.accessoryType = UITableViewCellAccessoryNone ;
    }
    return cell ;
}

-(LLBaseTableViewCell *)getButtonCell:(UITableView*)tableView{
    //button cell
    LLBaseTableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:kLLMonkeyListButtonCellID];
    if (!buttonCell) {
        buttonCell = [[LLBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLLMonkeyListButtonCellID];
        buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        buttonCell.accessoryType = UITableViewCellAccessoryNone ;
    }
    buttonCell.textLabel.textAlignment = NSTextAlignmentCenter ;
    buttonCell.textLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    return buttonCell ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLBaseTableViewCell *cell = nil ;
    
    NSString *text = self.dataArray[indexPath.section][indexPath.row];
    switch (indexPath.section) {
        case 0:
            //名单
            cell = [self getCell:tableView] ;
            cell.textLabel.text = text ;
            break;
            
        case 1:
            //monkey button
            cell = [self getButtonCell:tableView] ;
            cell.textLabel.text = text;
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
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kLLMonkeyListVCHeaderID];
    view.frame = CGRectMake(0, 0, LL_SCREEN_WIDTH, 30);
    if (view.backgroundView == nil) {
        view.backgroundView = [[UIView alloc] initWithFrame:view.bounds];
        view.backgroundView.backgroundColor = [LLCONFIG_TEXT_COLOR colorWithAlphaComponent:0.2];
    }
    return view ;
}

-(UITableViewHeaderFooterView*)getHeaderFooterViewWithSpace:(UITableView*)tableView{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kLLMonkeyListVCSpaceHeaderID];
    view.frame = CGRectMake(0, 0, LL_SCREEN_WIDTH, 30);
    if (view.backgroundView == nil) {
        view.backgroundView = [[UIView alloc] initWithFrame:view.bounds];
        view.backgroundView.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    }
    return view ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = nil ;
    if (section == 0) {
        view = [self getHeaderFooterView:tableView] ;
        if([LLMonkeySettingConfig defaultConfig].monkeyType == IOSMonkeyType){
            if([LLMonkeySettingConfig defaultConfig].listType == BlackListType){
                view.textLabel.text = @"IOS Monkey黑名单";
            }else{
                view.textLabel.text = @"IOS Monkey白名单";
            }
        }else{
            if([LLMonkeySettingConfig defaultConfig].listType == BlackListType){
                view.textLabel.text = @"Cocos Monkey黑名单";
            }else{
                view.textLabel.text = @"Cocos Monkey白名单";
            }
        }
    } else if(section == 1){
        view = [self getHeaderFooterViewWithSpace:tableView] ;
    }
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    if (![header.textLabel.textColor isEqual:LLCONFIG_TEXT_COLOR]) {
        header.textLabel.textColor = LLCONFIG_TEXT_COLOR;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section){
        case 0:{
            if (self.tableView.isEditing == NO) {
                [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            } else {
                self.deleteItem.enabled = YES;
                if (self.tableView.indexPathsForSelectedRows.count == [self.dataArray objectAtIndex:0].count) {
                    if ([self.selectAllItem.title isEqualToString:@"Select All"]) {
                        self.selectAllItem.title = @"Cancel All";
                    }
                }
            }
            break ;
        }
        case 1:{
            [self confirmAction];
        }
    }
    
}

- (void)confirmAction {
    __weak __block typeof(self) weakSelf = self;
    __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Note" message:@"添加名字" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text =alert.textFields.firstObject.text ;
        if(text && text.length==0){
            [LLTool toastMessage:@"name不能为空."];
        }else{
            [weakSelf doConfirmAction:text];
        }
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doConfirmAction:(NSString *)name {
    [self _addFilesWithName:name] ;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        if ([self.selectAllItem.title isEqualToString:@"Select All"] == NO) {
            self.selectAllItem.title = @"Select All";
        }
        if (self.tableView.indexPathsForSelectedRows.count == 0) {
            self.deleteItem.enabled = NO;
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self _showDeleteAlertWithIndexPaths:@[indexPath]];
    }
}

-  (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section){
        case 0:
            return YES ;
        case 1:
            return NO ;
    }
    return YES ;
}
#pragma mark - Primary
- (void)initial {
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kLLMonkeyListVCHeaderID];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kLLMonkeyListVCSpaceHeaderID];
    
    if([LLMonkeySettingConfig defaultConfig].monkeyType == IOSMonkeyType){
        if([LLMonkeySettingConfig defaultConfig].listType == BlackListType){
            self.navigationItem.title = @"IOS Monkey黑名单";
        }else{
            self.navigationItem.title = @"IOS Monkey白名单";
        }
    }else{
        if([LLMonkeySettingConfig defaultConfig].listType == BlackListType){
            self.navigationItem.title = @"Cocos Monkey黑名单";
        }else{
            self.navigationItem.title = @"Cocos Monkey白名单";
        }
    }
    
    self.dataArray = [[NSMutableArray alloc] init];
    // TableView
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    // Navigation bar item
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[[UIImage LL_imageNamed:kEditImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btn setImage:[[UIImage LL_imageNamed:kDoneImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    btn.showsTouchWhenHighlighted = NO;
    btn.adjustsImageWhenHighlighted = NO;
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.tintColor = LLCONFIG_TEXT_COLOR;
    [btn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    // ToolBar
    self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllItemClick:)];
    self.selectAllItem.tintColor = LLCONFIG_TEXT_COLOR;
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteItemClick:)];
    self.deleteItem.tintColor = LLCONFIG_TEXT_COLOR;
    self.deleteItem.enabled = NO;
    [self setToolbarItems:@[self.selectAllItem,spaceItem,self.deleteItem] animated:YES];
    
    self.navigationController.toolbar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
    
    [self _loadData];
}

- (NSArray *)monkeyButton {
    return @[@"添加"];
}

- (NSArray *)listInfos {
    NSArray *list = nil ;
    if([LLMonkeySettingConfig defaultConfig].monkeyType == IOSMonkeyType){
        if([LLMonkeySettingConfig defaultConfig].listType == BlackListType){
            list = [LLIOSMonkeySettingHelper sharedHelper].monkeySettingModel.blacklist ;
        }else{
            list = [LLIOSMonkeySettingHelper sharedHelper].monkeySettingModel.whitelist ;
        }
    }else{
        if([LLMonkeySettingConfig defaultConfig].listType == BlackListType){
            list = [LLCocosMonkeySettingHelper sharedHelper].monkeySettingModel.blacklist ;
        }else{
            list = [LLCocosMonkeySettingHelper sharedHelper].monkeySettingModel.whitelist ;
        }
    }
    
    return list ;
    
}

- (NSMutableArray <NSMutableArray *>*)infos {
    
    //名单设置
    NSMutableArray *list = [self listInfos]?[[NSMutableArray alloc] initWithArray:[self listInfos]]:[[NSMutableArray alloc] initWithArray:@[]];
    
    //monkey button
    NSArray *monkeyButton = [[NSMutableArray alloc] initWithArray:[self monkeyButton]] ;
    
    return [[NSMutableArray alloc] initWithObjects:list , monkeyButton,nil];
}

- (void)_loadData {
    
    [LLTool loadingMessage:@"Loading"];
    self.dataArray = [self infos] ;
    [LLTool hideLoadingMessage];
    [self.tableView reloadData] ;
}

- (void)_showDeleteAlertWithIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count) {
        [self showAlertControllerWithMessage:@"Sure to remove items ?" handler:^(NSInteger action) {
            if (action == 1) {
                [self _deleteFilesWithIndexPaths:indexPaths];
            }
        }];
    }
}

- (void)_deleteFilesWithIndexPaths:(NSArray *)indexPaths {
    
    NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
    
    for (NSIndexPath *indexPath in indexPaths) {
         [indexSets addIndex:indexPath.row];
    }
    [[self.dataArray objectAtIndex:0] removeObjectsAtIndexes:indexSets] ;

    __weak typeof(self) weakSelf = self;
    [LLTool loadingMessage:@"Deleting"];
    BOOL result = false ;
    if([LLMonkeySettingConfig defaultConfig].monkeyType == IOSMonkeyType){
        if([LLMonkeySettingConfig defaultConfig].listType == BlackListType){
            result = [[LLIOSMonkeySettingHelper sharedHelper] setBlacklist:[self.dataArray objectAtIndex:0]] ;
        }else{
            result = [[LLIOSMonkeySettingHelper sharedHelper] setWhitelist:[self.dataArray objectAtIndex:0]] ;
        }
    }else{
        if([LLMonkeySettingConfig defaultConfig].listType == BlackListType){
            result = [[LLCocosMonkeySettingHelper sharedHelper] setBlacklist:[self.dataArray objectAtIndex:0]] ;
        }else{
            result = [[LLCocosMonkeySettingHelper sharedHelper] setWhitelist:[self.dataArray objectAtIndex:0]] ;
        }
    }
    
    [LLTool hideLoadingMessage];
    if (result) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self showAlertControllerWithMessage:@"save data fail" handler:^(NSInteger action) {
            if (action == 1) {
                [weakSelf _loadData];
            }
        }];
    }
}

- (void)_addFilesWithName:(NSString*)name {
    NSIndexPath* index = [NSIndexPath indexPathForRow:0 inSection:0] ;
    [[self.dataArray objectAtIndex:0] insertObject:name atIndex:0];
    
    
    __weak typeof(self) weakSelf = self;
    [LLTool loadingMessage:@"Adding"];
    BOOL result = false ;
    if([LLMonkeySettingConfig defaultConfig].monkeyType == IOSMonkeyType){
        if([LLMonkeySettingConfig defaultConfig].listType == BlackListType){
            result = [[LLIOSMonkeySettingHelper sharedHelper] setBlacklist:[self.dataArray objectAtIndex:0]] ;
        }else{
            result = [[LLIOSMonkeySettingHelper sharedHelper] setWhitelist:[self.dataArray objectAtIndex:0]] ;
        }
    }else{
        if([LLMonkeySettingConfig defaultConfig].listType == BlackListType){
            result = [[LLCocosMonkeySettingHelper sharedHelper] setBlacklist:[self.dataArray objectAtIndex:0]] ;
        }else{
            result = [[LLCocosMonkeySettingHelper sharedHelper] setWhitelist:[self.dataArray objectAtIndex:0]] ;
        }
    }
    
    [LLTool hideLoadingMessage];
    if (result) {
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade] ;
        [self.tableView endUpdates];
    } else {
        [self showAlertControllerWithMessage:@"save data fail" handler:^(NSInteger action) {
            if (action == 1) {
                [weakSelf _loadData];
            }
        }];
    }
}
@end
