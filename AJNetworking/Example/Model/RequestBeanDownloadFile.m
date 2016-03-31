//
//  RequestBeanDownloadFile.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/30.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "RequestBeanDownloadFile.h"

@implementation RequestBeanDownloadFile

- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}

- (NSString *)apiPath
{
    return @"/apply/exportBalance";
}

@end
