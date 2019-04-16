//
//  LoginVC.m
//  LLDebugToolDemo
//
//  Created by haleli on 2019/4/16.
//  Copyright © 2019 li. All rights reserved.
//

#import "LoginVC.h"
@interface LoginVC ()
@property (nonatomic,strong) UITextField *account;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UIButton *loginButton;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO ;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1]];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(20.0, 100.0, self.view.frame.size.width-40, 50.0);
    segmentedControl.selectedSegmentIndex = 2;
    [self.view addSubview:segmentedControl] ;
    
    _account=[[UITextField alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width-40, 50)];
    _account.backgroundColor=[UIColor whiteColor];
    _account.placeholder=[NSString stringWithFormat:@"Email"];
    [self.view addSubview:_account];
    
    _password=[[UITextField alloc] initWithFrame:CGRectMake(20, 260, self.view.frame.size.width-40, 50)];
    _password.backgroundColor=[UIColor whiteColor];
    _password.placeholder=[NSString stringWithFormat:@"Password"];
    [self.view addSubview:_password];
    
    _loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setFrame:CGRectMake(20, 320, self.view.frame.size.width-40, 50)];
    
    [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor colorWithRed:51/255.0 green:102/255.0 blue:255/255.0 alpha:1]];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    segmentedArray = [[NSArray alloc]initWithObjects:@"2",@"3",@"4",@"5",nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(20.0, 420.0, self.view.frame.size.width-40, 50.0);
    segmentedControl.selectedSegmentIndex = 2;
    [self.view addSubview:segmentedControl] ;
   
}
-(void)pressBtn:(UIButton*)btn{
    NSLog(@"haleli >>> press button") ;
    [self.navigationController pushViewController:[[CYXWaterflowController alloc]init] animated:YES];
//    [self.navigationController popViewControllerAnimated:YES] ;
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
