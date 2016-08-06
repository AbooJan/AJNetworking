//
//  ResponseBeanDemoRegister.h
//  AJNetworking
//
//  Created by aboojan on 16/8/6.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "ResponseBeanDemo.h"

@interface RegisterUser : NSObject
@property (copy, nonatomic) NSString *userId;
@end

@interface ResponseBeanDemoRegister : ResponseBeanDemo
@property (nonatomic,strong) RegisterUser *data;
@end
