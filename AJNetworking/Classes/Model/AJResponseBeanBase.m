//
//  AJResponseBeanBase.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 Joiway. All rights reserved.
//

#import "AJResponseBeanBase.h"

@implementation AJResponseBeanBase

- (NSInteger)statusCode
{
    return 0;
}

- (NSString *)responseMessage
{
    return nil;
}

- (BOOL)checkSuccess
{
    return NO;
}

@end
