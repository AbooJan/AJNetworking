//
//  NetworkHub.m
//  AJNetworking
//
//  Created by aboojan on 2016/9/25.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "NetworkHub.h"

@implementation NetworkHub

- (void)showHub:(NSString *)tip
{
    AJLog(@"显示Hub: %@", tip);
}

- (void)dismissHub
{
    AJLog(@"隐藏Hub");
}

@end
