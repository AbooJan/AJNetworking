//
//  ViewController.m
//  AJNetworking
//
//  Created by aboojan on 16/3/19.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "ViewController.h"
#import "AJNetworkManager.h"
#import "RequestBeanDemoLogin.h"
#import "ResponseBeanDemoLogin.h"
#import "MJExtension.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UITextView *resultTV;

- (IBAction)loginBtnClick:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)loginBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    RequestBeanDemoLogin *requestBean = [[RequestBeanDemoLogin alloc] init];
    requestBean.account = self.accountTF.text;
    requestBean.pw = self.pwTF.text;
    
    //test
    requestBean.name = @"aboo";
    
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof ResponseBeanBase *responseBean, BOOL success) {
    
            if (success) {
                
                // 返回结果处理
                ResponseBeanDemoLogin *response = responseBean;
            }
    }];
}

@end
