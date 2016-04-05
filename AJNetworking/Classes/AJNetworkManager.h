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


typedef void(^AJRequestCallBack)(__kindof ResponseBeanBase * _Nullable responseBean, BOOL success);
typedef void(^AJDownloadProgressCallBack)(int64_t totalUnitCount, int64_t completedUnitCount, double progressRate);
typedef void(^AJDownloadCompletionCallBack)(NSURL * _Nullable filePath, NSError * _Nullable error);


@interface AJNetworkManager : NSObject

/**
 *  @author aboojan
 *
 *  @brief 发请请求
 *
 *  @param requestBean 请求参数模型Bean
 *  @param callBack    请求结果回调
 */
+ (void)requestWithBean:(__kindof RequestBeanBase * _Nonnull)requestBean callBack:(AJRequestCallBack _Nonnull)callBack;


/**
 *  @author aboojan
 *
 *  @brief 文件下载
 *
 *  @param requestBean        文件下载请求Bean
 *  @param progressCallBack   下载进度回调
 *  @param completionCallBack 完成回调
 *
 *  @return 当前下载任务线程
 */
+ ( NSURLSessionDownloadTask * _Nullable )downloadTaskWithBean:(__kindof RequestBeanDownloadTaskBase * _Nonnull)requestBean progress:(AJDownloadProgressCallBack _Nullable )progressCallBack completion:(AJDownloadCompletionCallBack _Nullable)completionCallBack;

/**
 *  @author aboojan
 *
 *  @brief 读取缓存
 *
 *  @param requestBean 请求Bean
 *  @param callBack    读取缓存回调
 */
+ (void)cacheWithRequestWithBean:(__kindof RequestBeanBase * _Nonnull)requestBean callBack:(AJRequestCallBack _Nonnull)callBack;

@end
