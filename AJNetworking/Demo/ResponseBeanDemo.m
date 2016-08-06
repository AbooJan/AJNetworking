//
//  ResponseBeanDemo.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/22.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "ResponseBeanDemo.h"

@implementation ResponseBeanDemo
- (NSInteger)statusCode
{
    return self.code;
}

- (NSString *)responseMessage
{
    return self.msg;
}

- (BOOL)checkSuccess
{
    if (self.code == 1) {
        return YES;
    }else{
        return NO;
    }
}

@end
