//
//  BViewController.m
//  AJNetworking
//
//  Created by aboojan on 2016/11/24.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "BViewController.h"
#import "AJNetworkManager.h"
#import "RequestBeanDemoRegister.h"
#import "ResponseBeanDemoRegister.h"

@interface BViewController ()
@property (nonatomic, strong) NSMutableArray *taskKeyArray;
@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.taskKeyArray = [NSMutableArray array];
    
    [self performSelector:@selector(closePage) withObject:nil afterDelay:1.0];
    [self sendRequest];
}

- (void)closePage
{
    [self dismissViewControllerAnimated:YES completion:^{
        // 结束网络请求也可以放到这里
    }];
}

- (void)dealloc
{
    // 可以在控制器释放的时候结束正在进行着的网络请求
    // 可以写一个控制器基类，暴露出一个taskKey数组，然后统一在页面关闭时结束网络请求
    [AJNetworkManager stopRequestTaskWithTaskKey:self.taskKeyArray];
    
    AJLog(@"dealloc");
}

- (void)sendRequest
{
    [self request1];
    [self request2];
}

- (void)request1
{
    RequestBeanDemoRegister *requestBean = [RequestBeanDemoRegister new];
    requestBean.userName = @"Github";
    requestBean.pw = @"123456";
    
    [self.taskKeyArray addObject:[requestBean taskKey]];
    
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof AJResponseBeanBase * _Nullable responseBean, AJError * _Nullable err) {
        
        AJLog(@"#request1 Callback#: %@", err);
    }];
}

- (void)request2
{
    RequestBeanDemoRegister *requestBean = [RequestBeanDemoRegister new];
    requestBean.userName = @"Google";
    requestBean.pw = @"123456";
    
    [self.taskKeyArray addObject:[requestBean taskKey]];
    
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof AJResponseBeanBase * _Nullable responseBean, AJError * _Nullable err) {
        
        AJLog(@"#request2 Callback#: %@", err);
    }];
}


@end
