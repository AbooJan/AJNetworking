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
#import "RequestBeanDemoRegister.h"
#import "ResponseBeanDemoRegister.h"
#import "RequestBeanDemoNews.h"
#import "ResponseBeanDemoNews.h"
#import "MJExtension.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
- (IBAction)loginBtnClick:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF1;
- (IBAction)registerBtnClick:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *userIdTF;
@property (weak, nonatomic) IBOutlet UITextField *dateTimeTF;
- (IBAction)readNewsBtnClick:(id)sender;

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
            }else{
                
                if (responseBean) {
                    AJLog(@"请求错误：%ld -- %@", responseBean.statusCode, responseBean.responseMessage);
                }else{
                    AJLog(@"网络错误，稍后重试");
                }
            }
    }];
}

- (IBAction)registerBtnClick:(id)sender
{
    [self.view endEditing:YES];
    
    RequestBeanDemoRegister *requestBean = [RequestBeanDemoRegister new];
    requestBean.userName = self.userNameTF.text;
    requestBean.pw = self.pwTF1.text;
    
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof ResponseBeanBase * _Nullable responseBean, BOOL success) {
        
        if (success) {
            
            // 结果处理
            ResponseBeanDemoRegister *responseBean = responseBean;
        }
        
    }];
    
    
}
- (IBAction)readNewsBtnClick:(id)sender
{
    [self.view endEditing:YES];
    
    RequestBeanDemoNews *requestBean = [RequestBeanDemoNews new];
    requestBean.userId = self.userIdTF.text;
    requestBean.dateTime = self.dateTimeTF.text;
    
    // 1. 网络检测
    
    // 2. 缓存读取
    
    // 3. 网络请求
    
    [AJNetworkManager cacheWithRequestWithBean:requestBean callBack:^(__kindof ResponseBeanBase * _Nullable responseBean, BOOL success) {
        
        if (success) {
            
            // 读取缓存结果处理
            AJLog(@"#####读缓存#####");
            
            ResponseBeanDemoNews *response = responseBean;
            for (News *page in response.data) {
                AJLog(@"%@ -- %@ -- %@", page.title, page.content, page.author);
            }
            
        }else{
            
            // 发起网络请求
            [self sendRequest:requestBean];
        }
        
    }];
    
}

- (void)sendRequest:(RequestBeanDemoNews *)requestBean
{
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof ResponseBeanBase * _Nullable responseBean, BOOL success) {
        
        if (success) {
            
            // 结果处理
            ResponseBeanDemoNews *response = responseBean;
            
        }
    }];
}

@end
