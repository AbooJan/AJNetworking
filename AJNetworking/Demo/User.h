//
//  User.h
//  AJNetworking
//
//  Created by aboojan on 16/8/6.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *name;
@property (nonatomic,assign) NSInteger age;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *job;

@end
