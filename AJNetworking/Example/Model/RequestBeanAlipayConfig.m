//
//  RequestBeanAlipayConfig.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/28.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "RequestBeanAlipayConfig.h"

@implementation RequestBeanAlipayConfig

- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}

- (HTTP_SCHEME)httpScheme
{
    return HTTP_SCHEME_HTTPS;
}

- (NSString *)apiPath
{
    return @"/pay/getKey";
}

- (NSInteger)device
{
    return 1;
}

- (NSTimeInterval)timeout
{
    return 35.0;
}

@end
