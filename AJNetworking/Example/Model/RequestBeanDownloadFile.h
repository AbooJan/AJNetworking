//
//  RequestBeanDownloadFile.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/30.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "RequestBeanBase.h"

@interface RequestBeanDownloadFile : RequestBeanBase
@property (nonatomic, copy) NSString *compid;
@property (nonatomic,strong) NSString *job_id;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, assign) NSInteger system;
@property (nonatomic, copy) NSString *versions;
@end
