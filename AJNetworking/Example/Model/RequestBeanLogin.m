//
//  RequestBeanLogin.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/26.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "RequestBeanLogin.h"

@implementation RequestBeanLogin

- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}

- (NSString *)apiPath
{
    return @"/company/login";
}

@end
