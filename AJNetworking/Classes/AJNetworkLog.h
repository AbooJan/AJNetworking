//
//  AJNetworkLog.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/28.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJRequestBeanBase.h"
#import "AJResponseBeanBase.h"

@interface AJNetworkLog : NSObject
+ (void)logWithRequestBean:(__kindof AJRequestBeanBase *)requestBean;
+ (void)logWithRequestBean:(__kindof AJRequestBeanBase *)requestBean json:(id)responseJSON;
+ (void)logWithContent:(NSString *)logContent;
@end
