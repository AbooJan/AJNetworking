//
//  AJNetworkManager.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJNetworkConfig.h"
#import "AJRequestBeanBase.h"
#import "AJResponseBeanBase.h"
#import "AJRequestBeanDownloadTaskBase.h"
#import "AJError.h"

/**
 *  @author aboojan
 *
 *  @brief 结果回调
 *
 *  @param responseBean 数据Bean，可能是缓存或网络数据
 *  @param err          错误，如果为nil，回调成功，否则失败
 */
typedef void(^AJRequestCallBack)(__kindof AJResponseBeanBase * _Nullable responseBean, AJError * _Nullable err);

typedef void(^AJDownloadProgressCallBack)(int64_t totalUnitCount, int64_t completedUnitCount, double progressRate);
typedef void(^AJDownloadCompletionCallBack)(NSURL * _Nullable filePath, NSError * _Nullable error);


@interface AJNetworkManager : NSObject

/**
 *  @author aboojan
 *
 *  @brief 发请网络请求，没有缓存
 *
 *  @param requestBean 网络请求参数模型Bean
 *  @param callBack    网络请求结果回调
 */
+ (void)requestWithBean:(__kindof AJRequestBeanBase * _Nonnull)requestBean
               callBack:(AJRequestCallBack _Nonnull)callBack;

/**
 *  @author aboojan
 *
 *  @brief 发起网络请求，有缓存
 *
 *  @param requestBean   网络请求参数模式Bean
 *  @param cacheCallBack 缓存读取回调
 *  @param httpCallBack  网络请求结果回调
 */
+ (void)requestWithBean:(__kindof AJRequestBeanBase * _Nonnull)requestBean
          cacheCallBack:(AJRequestCallBack _Nonnull)cacheCallBack
           httpCallBack:(AJRequestCallBack _Nonnull)httpCallBack;


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
+ ( NSURLSessionDownloadTask * _Nullable )downloadTaskWithBean:(__kindof AJRequestBeanDownloadTaskBase * _Nonnull)requestBean progress:(AJDownloadProgressCallBack _Nullable )progressCallBack completion:(AJDownloadCompletionCallBack _Nullable)completionCallBack;

/**
 *  @author aboojan
 *
 *  @brief 读取缓存
 *
 *  @param requestBean 请求Bean
 *  @param callBack    读取缓存回调
 */
+ (void)cacheWithRequestWithBean:(__kindof AJRequestBeanBase * _Nonnull)requestBean callBack:(AJRequestCallBack _Nonnull)callBack;

/**
 根据 taskKey 结束目标网络请求任务

 @param taskKeyArray 任务Key数组
 */
+ (void)stopRequestTaskWithTaskKey:(NSArray<__kindof NSString *> * _Nonnull)taskKeyArray;

@end
