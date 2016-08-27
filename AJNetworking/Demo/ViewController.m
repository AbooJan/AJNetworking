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

#pragma mark GET请求示例
- (IBAction)loginBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    RequestBeanDemoLogin *requestBean = [[RequestBeanDemoLogin alloc] init];
    requestBean.account = self.accountTF.text;
    requestBean.pw = self.pwTF.text;
    
    //test
    requestBean.name = @"aboo";
    
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof ResponseBeanBase * _Nullable responseBean, AJError * _Nullable err) {
        
        if (!err) {
            
            // 返回结果处理
            ResponseBeanDemoLogin *response = responseBean;
            AJLog(@"user: %@", response.data);
            
        }else{
            
            if (responseBean) {
                AJLog(@"请求错误：%ld -- %@", responseBean.statusCode, responseBean.responseMessage);
            }else{
                AJLog(@"网络错误，稍后重试");
            }
        }
    }];
}

#pragma mark POST请求示例
- (IBAction)registerBtnClick:(id)sender
{
    [self.view endEditing:YES];
    
    RequestBeanDemoRegister *requestBean = [RequestBeanDemoRegister new];
    requestBean.userName = self.userNameTF.text;
    requestBean.pw = self.pwTF1.text;
    
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof ResponseBeanBase * _Nullable responseBean, AJError * _Nullable err) {
        
        if (!err) {
            
            // 结果处理
            ResponseBeanDemoRegister *response = responseBean;
            AJLog(@"userId:%@", response.data.userId);
        }
    }];
    
}

#pragma mark 短期缓存示例
- (IBAction)readNewsBtnClick:(id)sender
{
    [self.view endEditing:YES];
    
    RequestBeanDemoNews *requestBean = [RequestBeanDemoNews new];
    requestBean.userId = self.userIdTF.text;
    requestBean.dateTime = self.dateTimeTF.text;
    
    [AJNetworkManager requestWithBean:requestBean cacheCallBack:^(__kindof ResponseBeanBase * _Nullable responseBean, AJError * _Nullable err) {
        
        if (!err) {
            
            // 读取缓存
            AJLog(@"###来自缓存###");
            [self handleNews:responseBean];
            
        }else{
            // 读取缓存失败
            AJLog(@"%@", [err description]);
        }
        
    } httpCallBack:^(__kindof ResponseBeanBase * _Nullable responseBean, AJError * _Nullable err) {
        
        if (!err) {
            
            // 网络请求成功
            AJLog(@"###来自网络###");
            [self handleNews:responseBean];
            
        }else{
            // 网络请求失败
            AJLog(@"%@", [err description]);
        }
        
    }];
    
}

- (void)handleNews:(ResponseBeanDemoNews *)news
{
    for (News *page in news.data) {
        AJLog(@"%@ -- %@ -- %@", page.title, page.content, page.author);
    }
}

@end
