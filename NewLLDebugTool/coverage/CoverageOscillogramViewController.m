//
//  CoverageOscillogramViewController.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/6/17.
//  Copyright © 2019 li. All rights reserved.
//

#import "CoverageOscillogramViewController.h"
#import "App.h"

@interface CoverageOscillogramViewController ()

@end

@implementation CoverageOscillogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString *)title{
    return @"当前界面控件覆盖率：\nApp控件覆盖率：";
}

//每一秒钟采样一次控件覆盖率
- (void)doSecondFunction{
    CGFloat appCoverage = [[App sharedApp] getCoverage];
    CGFloat treeCoverage = 0.0;
    UIViewController *controller = [FindTopController topController] ;
    NSString * treeId = NSStringFromClass([controller class]) ;
    Tree* tree = [[App sharedApp] getTree:treeId] ;
    if(tree){
        treeCoverage = [tree getCoverage] ;
    }
    NSString *title = [NSString stringWithFormat:@"当前界面控件覆盖率：%.2f%%\nApp控件覆盖率：%.2f%%",treeCoverage,appCoverage];
    [self drawTitleViewWithValue:title] ;
}
@end
