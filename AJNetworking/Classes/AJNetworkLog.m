//
//  AJNetworkLog.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/28.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "AJNetworkLog.h"
#import "MJExtension.h"


@implementation AJNetworkLog

+ (NSString *)createPostURL:(NSDictionary *)params
{
    NSString *postString = @"";
    for (NSString *key in params.allKeys) {
        NSString *value = [params objectForKey:key];
        postString  = [postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if ([postString length]>1) {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}

+ (void)logWithRequestBean:(__kindof AJRequestBeanBase *)requestBean
{
    NSString *hostStr = [requestBean apiHost];
    NSString *apiStr = [requestBean apiPath];
    
    BOOL loseConfigHost = (hostStr == nil) || [hostStr isEqualToString:@""];
    NSCAssert(!loseConfigHost, @"找不到Host!");
    
    BOOL loseConfigApi = (apiStr == nil) || [apiStr isEqualToString:@""];
    NSCAssert(!loseConfigApi, @"找不到Api路径!");
    
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n"];
    [logString appendFormat:@"**************************************************************\n"];
    [logString appendFormat:@"*                       Request Start                        *\n"];
    [logString appendFormat:@"**************************************************************\n\n"];
    [logString appendFormat:@"请求:\n%@?%@\n\n", [requestBean requestUrl], [self createPostURL:[requestBean mj_keyValues]]];
    [logString appendFormat:@"%@", [requestBean mj_keyValues]];
    [logString appendFormat:@"\n\n"];
    [logString appendFormat:@"**************************************************************\n"];
    [logString appendFormat:@"*                         Request End                        *\n"];
    [logString appendFormat:@"**************************************************************\n\n"];
    
    AJLog(@"%@", logString);
}

+ (void)logWithRequestBean:(__kindof AJRequestBeanBase *)requestBean json:(id)responseJSON
{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n"];
    [logString appendFormat:@"==============================================================\n"];
    [logString appendFormat:@"=                        API Response                        =\n"];
    [logString appendFormat:@"==============================================================\n\n"];
    [logString appendFormat:@"URL: %@\n\n", [requestBean requestUrl]];
    [logString appendFormat:@"%@", responseJSON];
    [logString appendFormat:@"\n\n"];
    [logString appendFormat:@"==============================================================\n"];
    [logString appendFormat:@"=                        Response End                        =\n"];
    [logString appendFormat:@"==============================================================\n\n\n"];
    
    AJLog(@"%@", logString);
}

+ (void)logWithContent:(NSString *)logContent
{
    NSMutableString *logStr = [NSMutableString stringWithString:@"\n\n"];
    [logStr appendFormat:@"################################################################\n"];
    [logStr appendFormat:@"#                             Error                            #\n"];
    [logStr appendFormat:@"################################################################\n\n"];
    [logStr appendFormat:@"%@\n\n", logContent];
    [logStr appendFormat:@"################################################################\n\n\n"];
    
    AJLog(@"%@", logStr);
}

@end
