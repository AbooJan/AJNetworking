//
//  RequestBeanDownloadTaskBase.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/30.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "AJRequestBeanDownloadTaskBase.h"

@implementation AJRequestBeanDownloadTaskBase

+ (NSArray<NSString *> *)ignoredPropertyNames
{
    return @[@"fileUrl", @"saveFilePath", @"saveFileName"];
}

@end
