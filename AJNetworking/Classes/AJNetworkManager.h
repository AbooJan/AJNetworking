//
//  AJNetworkManager.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 Joiway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJNetworkConfig.h"
#import "RequestBeanBase.h"
#import "ResponseBeanBase.h"
#import "RequestBeanDownloadTaskBase.h"


typedef void(^AJRequestCallBack)(__kindof ResponseBeanBase *responseBean, BOOL success);
typedef void(^AJDownloadProgressCallBack)(int64_t totalUnitCount, int64_t completedUnitCount, double progressRate);
typedef void(^AJDownloadCompletionCallBack)(NSURL *filePath, NSError *error);


@interface AJNetworkManager : NSObject

/**
 *  @author aboojan
 *
 *  @brief 发请请求
 *
 *  @param requestBean 请求参数模型Bean
 *  @param callBack    请求结果回调
 */
+ (void)requestWithBean:(__kindof RequestBeanBase *)requestBean callBack:(AJRequestCallBack)callBack;

/**
 *  @author aboojan
 *
 *  @brief 文件下载
 *
 *  @param requestBean        文件下载请求Bean
 *  @param progressCallBack   下载进度回调
 *  @param completionCallBack 完成回调
 */
+ (void)downloadTaskWithBean:(__kindof RequestBeanDownloadTaskBase *)requestBean progress:(AJDownloadProgressCallBack)progressCallBack completion:(AJDownloadCompletionCallBack)completionCallBack;

@end
