//
//  RequestBeanUploadAvatar.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/29.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "RequestBeanBase.h"

@interface RequestBeanUploadAvatar : RequestBeanBase

@property (nonatomic, copy) NSString *compid;

@property (nonatomic, strong) UIImage *avatar;
@end
