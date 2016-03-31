//
//  RequestBeanDownloadTaskBase.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/30.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "RequestBeanDownloadTaskBase.h"

@implementation RequestBeanDownloadTaskBase

+ (NSArray<NSString *> *)mj_ignoredPropertyNames
{
    return @[@"fileUrl", @"saveFilePath", @"saveFileName"];
}

@end
