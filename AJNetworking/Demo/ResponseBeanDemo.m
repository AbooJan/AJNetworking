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
    return self.errNum;
}

- (NSString *)responseMessage
{
    return self.retMsg;
}

- (BOOL)checkSuccess
{
    if (self.errNum == SUCCESS_CODE) {
        return YES;
    }else{
        return NO;
    }
}

@end
