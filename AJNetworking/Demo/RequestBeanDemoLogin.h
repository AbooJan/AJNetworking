//
//  RequestBeanDemoLogin.h
//  AJNetworking
//
//  Created by aboojan on 16/8/6.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "RequestBeanDemoBase.h"

@interface RequestBeanDemoLogin : RequestBeanDemoBase
@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *pw;

// 测试参数忽略
@property (copy, nonatomic) NSString *name;

@end
