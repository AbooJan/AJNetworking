//
//  ResponseBeanDemoFilm.m
//  AJNetworking
//
//  Created by aboojan on 16/8/27.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "ResponseBeanDemoFilm.h"

@implementation Film
@end

@implementation ResponseBeanDemoFilm
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"Film"};
}
@end
