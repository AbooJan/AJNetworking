//
//  AJNetworkConfig.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 Joiway. All rights reserved.
//

#import "AJNetworkConfig.h"

@implementation AJNetworkConfig

+ (AJNetworkConfig *)shareInstance
{
    static AJNetworkConfig * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AJNetworkConfig alloc] init];
    });
    
    return instance;
}

@end
