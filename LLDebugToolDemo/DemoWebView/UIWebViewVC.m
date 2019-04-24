//
//  UIWebViewVC.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/18.
//  Copyright © 2019 li. All rights reserved.
//

#import "UIWebViewVC.h"

@interface UIWebViewVC ()

@end

@implementation UIWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO ;
    self.title = @"UIWebView";
    UIWebView * view = [[UIWebView alloc] initWithFrame:self.view.frame];
    [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    [self.view addSubview:view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
