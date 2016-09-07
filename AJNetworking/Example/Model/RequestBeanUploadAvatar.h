//
//  RequestBeanUploadAvatar.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/29.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "AJRequestBeanBase.h"

@interface RequestBeanUploadAvatar : AJRequestBeanBase

@property (nonatomic, copy) NSString *compid;

@property (nonatomic, strong) UIImage *avatar;
@end
