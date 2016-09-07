//
//  RequestBeanLogin.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/26.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "AJRequestBeanBase.h"

@interface RequestBeanLogin : AJRequestBeanBase
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *pwd;
@end
