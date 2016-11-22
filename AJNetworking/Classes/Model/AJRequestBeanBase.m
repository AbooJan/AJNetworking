//
//  AJRequestBeanBase.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 Joiway. All rights reserved.
//

#import "AJRequestBeanBase.h"
#import <objc/runtime.h>
#import "MJExtension.h"
#import "MD5Util.h"

static const NSTimeInterval DEFAULT_TIMEOUT = 30.0;

@implementation AJRequestBeanBase

- (HTTP_SCHEME)httpScheme
{
    return HTTP_SCHEME_HTTP;
}

- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_GET;
}

- (NSTimeInterval)timeout
{
    return DEFAULT_TIMEOUT;
}

- (NSString *)apiHost
{
    return [AJNetworkConfig shareInstance].hostUrl;
}

- (NSString *)apiPath
{
    return @"";
}

- (NSDictionary *)httpHeader
{
    return nil;
}

- (NSString *)requestUrl
{
    NSString *scheme = @"http";
    if ([self httpScheme] == HTTP_SCHEME_HTTPS) {
        scheme = @"https";
    }
    
    NSString *baseUrl = [self apiHost];
    NSString *apiPath = [self apiPath];
    NSString *requestUrl = [NSString stringWithFormat:@"%@://%@%@", scheme, baseUrl, apiPath];
    
    return requestUrl;
}

- (AFConstructingBlock)constructingBodyBlock
{
    return nil;
}

- (BOOL)cacheResponse
{
    return NO;
}

- (NSUInteger)cacheLiveSecond
{
    return 0;
}

+ (NSArray<NSString *> *)ignoredPropertyNames
{
    return @[];
}

+ (NSArray<NSString *> *)mj_ignoredPropertyNames
{
    NSMutableArray *ignoreArray = [NSMutableArray arrayWithArray:[self ignoredPropertyNames]];
    
    [ignoreArray addObject:@"taskKey"];
    
    // 解决MJExtension最新版本的BUG
    [ignoreArray addObject:@"debugDescription"];
    [ignoreArray addObject:@"description"];
    [ignoreArray addObject:@"hash"];
    [ignoreArray addObject:@"superclass"];
    
    return ignoreArray;
}

- (BOOL)isShowHub
{
    return NO;
}

- (NSString *)hubTips
{
    return nil;
}

- (NSString *)responseBeanClassName
{
    const char *requestClassName = class_getName([self class]);
    NSString *responseBeanNameStr = [[NSString stringWithUTF8String:requestClassName] stringByReplacingOccurrencesOfString:@"Request" withString:@"Response"];
    return responseBeanNameStr;
}

- (NSString *)taskKey
{
    NSString *cacheInfoStr = [NSString stringWithFormat:@"URL:%@ PARAMS:%@", [self requestUrl], [self mj_keyValues]];
    
    NSString *key = [MD5Util md5WithoutEncryptionFactor:cacheInfoStr];
    
    return key;
}

@end
