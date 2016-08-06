//
//  RequestBeanDemoBase.m
//  AJNetworking
//
//  Created by aboojan on 16/8/6.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "RequestBeanDemoBase.h"
#import "RequestConfig.h"

@implementation RequestBeanDemoBase

- (NSString *)apiPath
{
    return [[RequestConfig shareInstance] apiPathWithRequestClass:[self class]];
}

- (HTTP_SCHEME)httpScheme
{
    return [[RequestConfig shareInstance] httpSchemeWithRequestClass:[self class]];
}

- (HTTP_METHOD)httpMethod
{
    return [[RequestConfig shareInstance] httpMethodWithRequestClass:[self class]];
}

@end
