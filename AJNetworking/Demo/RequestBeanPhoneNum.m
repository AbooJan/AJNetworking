//
//  RequestBeanPhoneNum.m
//  AJNetworking
//
//  Created by aboojan on 16/3/20.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "RequestBeanPhoneNum.h"

@implementation RequestBeanPhoneNum

- (NSDictionary *)httpHeader
{
    return @{@"apikey": @"61979cba44a3b9abb16c5127574dd2e5"};
}

- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}

- (NSString *)apiPath
{
    return @"/apistore/mobilenumber/mobilenumber";
}

- (BOOL)cacheResponse
{
    return YES;
}

@end
