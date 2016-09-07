//
//  RequestBeanDownloadTaskBase.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/30.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "AJRequestBeanBase.h"

@interface AJRequestBeanDownloadTaskBase : AJRequestBeanBase

@property (nonatomic, copy) NSString *fileUrl;
@property (nonatomic, copy) NSString *saveFilePath;
@property (nonatomic, copy) NSString *saveFileName;

@end
