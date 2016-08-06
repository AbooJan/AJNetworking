//
//  ResponseBeanDemoNews.m
//  AJNetworking
//
//  Created by aboojan on 16/8/6.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "ResponseBeanDemoNews.h"

@implementation News

@end

@implementation ResponseBeanDemoNews

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"News"};
}

@end
