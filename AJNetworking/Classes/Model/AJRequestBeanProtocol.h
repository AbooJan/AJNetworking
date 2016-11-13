//
//  AJRequestBeanProtocol.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/22.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJNetworkConfig.h"

@protocol AJRequestBeanProtocol <NSObject>

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
 *  @brief 缓存有效时间，单位为秒, 默认为0,即长期有效；
 *
 *  @return 有效时间
 */
- (NSUInteger)cacheLiveSecond;

/**
 *  @author aboojan
 *
 *  @brief 忽略的请求参数名称数组
 *
 *  @return 忽略参数数组，如：@[@"param1", @"param2"]
 */
+ (NSArray<__kindof NSString *> *)ignoredPropertyNames;


/**
 *  @author aboojan
 *
 *  @brief 是否需要显示Loading，默认不显示
 *
 *  @return YES，显示；NO，不显示
 */
- (BOOL)isShowHub;


/**
 *  @author aboojan
 *
 *  @brief Hub提示文案,isShowHub设置为YES时才会生效
 *
 *  @return 提示文案
 */
- (NSString *)hubTips;


/**
 *  @author aboojan
 *
 *  @brief 用于Response JSON解析的目标类名，默认为根据RequestBean解析名称。
 *         如果返回nil，则解析为`AJResponseBeanBase`。
 *         类名对应的类必须继承自`AJResponseBeanBase`。
 *
 @return Response JSON解析的目标类名
 */
- (NSString *)responseBeanClassName;

@end
