//
//  RequestConfig.m
//  AJNetworking
//
//  Created by aboojan on 16/8/6.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "RequestConfig.h"

static NSString * const KEY_API    = @"api";
static NSString * const KEY_SCHEME = @"schme";
static NSString * const KEY_METHOD = @"method";

@interface RequestConfig()
@property (nonatomic,strong) NSDictionary *config;
@end

@implementation RequestConfig

+ (RequestConfig *)shareInstance
{
    static RequestConfig *instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[RequestConfig alloc] init];
        
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"RequestConfig" ofType:@"plist"];
        instance.config = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
    });
    
    return instance;
}

- (NSString *)apiPathWithRequestClass:(Class)requestClass
{
    NSString *apiPath = self.config[NSStringFromClass(requestClass)][KEY_API];
    return apiPath;
}

- (HTTP_SCHEME)httpSchemeWithRequestClass:(Class)requestClass
{
    NSString *httpScheme = self.config[NSStringFromClass(requestClass)][KEY_API];
    if ([httpScheme isEqualToString:@"HTTPS"]) {
        return HTTP_SCHEME_HTTPS;
    }else{
        return HTTP_SCHEME_HTTP;
    }
}

- (HTTP_METHOD)httpMethodWithRequestClass:(Class)requestClass
{
    NSString *httpMethod = self.config[NSStringFromClass(requestClass)][KEY_METHOD];
    if ([httpMethod isEqualToString:@"GET"]) {
        return HTTP_METHOD_GET;
        
    }else if ([httpMethod  isEqualToString:@"POST"]){
        return HTTP_METHOD_POST;
        
    }else if ([httpMethod isEqualToString:@"HEAD"]){
        return HTTP_METHOD_HEAD;
        
    }else if ([httpMethod isEqualToString:@"PUT"]){
        return HTTP_METHOD_PUT;
        
    }else if ([httpMethod isEqualToString:@"DELETE"]){
        return HTTP_METHOD_DELETE;
        
    }else{
        return HTTP_METHOD_PATCH;
    }
}


@end
