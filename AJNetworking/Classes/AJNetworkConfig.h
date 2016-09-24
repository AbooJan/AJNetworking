//
//  AJNetworkConfig.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 Joiway. All rights reserved.
//

#import "AJCacheOptions.h"
#import <SPTPersistentCache/SPTPersistentCache.h>
#import <AFNetworking/AFNetworking.h>
#import "AJHubProtocol.h"

#ifdef DEBUG
#   define AJLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define AJLog(...)
#endif

#define AJConstructingBlockDefine ^(id<AFMultipartFormData> formData)

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);


typedef NS_ENUM(NSInteger, HTTP_METHOD)
{
    HTTP_METHOD_GET,
    HTTP_METHOD_POST,
    HTTP_METHOD_HEAD,
    HTTP_METHOD_PUT,
    HTTP_METHOD_DELETE,
    HTTP_METHOD_PATCH
};

typedef NS_ENUM(NSInteger, HTTP_SCHEME)
{
    HTTP_SCHEME_HTTP,
    HTTP_SCHEME_HTTPS
};

@interface AJNetworkConfig : NSObject

+ (AJNetworkConfig *)shareInstance;

- (SPTPersistentCache *)globalHttpCache;

/// 服务器域名
@property (nonatomic, copy) NSString *hostUrl;
/// HTTPS 证书密码
@property (nonatomic, assign) CFStringRef httpsCertificatePassword;
/// HTTPS 证书路径
@property (nonatomic, copy) NSString *httpsCertificatePath;
/// 缓存配置
@property (nonatomic, strong) AJCacheOptions *cacheOptions;
/// Hub显示代理
@property (nonatomic, weak) id<AJHubProtocol> hubDelegate;

@end
