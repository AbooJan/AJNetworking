//
//  AJNetworkLog.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/28.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestBeanBase.h"
#import "ResponseBeanBase.h"

@interface AJNetworkLog : NSObject
+ (void)logWithRequestBean:(__kindof RequestBeanBase *)requestBean;
+ (void)logWithRequestBean:(__kindof RequestBeanBase *)requestBean json:(id)responseJSON;
+ (void)logWithContent:(NSString *)logContent;
@end
