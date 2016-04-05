//
//  RequestBeanProtocol.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/22.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJNetworkConfig.h"

@protocol RequestBeanProtocol <NSObject>

/**
 *  @author aboojan
 *
 *  @brief HTTP协议
 *
 *  @return HTTP or HTTPS
 */
- (HTTP_SCHEME)httpScheme;

/**
 *  @author aboojan
 *
 *  @brief HTTP请求方法
 *
 *  @return GET / POST ...
 */
- (HTTP_METHOD)httpMethod;

/**
 *  @author aboojan
 *
 *  @brief 请求超时
 *
 *  @return 超时时长
 */
- (NSTimeInterval)timeout;

/**
 *  @author aboojan
 *
 *  @brief Api的主域名
 *
 *  @return 域名或IP
 */
- (NSString *)apiHost;

/**
 *  @author aboojan
 *
 *  @brief 请求API路径
 *
 *  @return api路径
 */
- (NSString *)apiPath;

/**
 *  @author aboojan
 *
 *  @brief HTTP 请求 header
 *
 *  @return 字典型，如果没有返回nil
 */
- (NSDictionary *)httpHeader;

/**
 *  @author aboojan
 *
 *  @brief 发起请求的完整链接
 *
 *  @return 完整请求链接
 */
- (NSString *)requestUrl;

/**
 *  @author aboojan
 *
 *  @brief 当POST的内容带有文件等富文本时使用
 *
 *  @return MultipartFormData Block
 */
- (AFConstructingBlock)constructingBodyBlock;

/**
 *  @author aboojan
 *
 *  @brief 是否缓存请求结果,默认不缓存
 *
 *  @return YES，缓存；NO，不缓存
 */
- (BOOL)cacheResponse;

/**
 *  @author aboojan
 *
 *  @brief 忽略的请求参数名称数组
 *
 *  @return 忽略参数数组，如：@[@"param1", @"param2"]
 */
+ (NSArray<__kindof NSString *> *)mj_ignoredPropertyNames;

@end
