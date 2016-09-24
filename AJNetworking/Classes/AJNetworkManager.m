//
//  AJNetworkManager.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 Joiway. All rights reserved.
//

#import "AJNetworkManager.h"
#import "MJExtension.h"
#import "AJNetworkLog.h"
#import <SPTPersistentCache/SPTPersistentCache.h>
#import "MD5Util.h"
#import "AJNetworkStatus.h"


@implementation AJNetworkManager

#pragma mark - <基本信息>

+ (AFHTTPSessionManager *)httpsSessionManager {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    __weak __typeof(&*self) weakSelf = self;
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *credential) {
        
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            
            *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            return NSURLSessionAuthChallengeUseCredential;
            
        }else if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
            
            NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:[AJNetworkConfig shareInstance].httpsCertificatePath];
            CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
            SecIdentityRef identity = NULL;
            [strongSelf extractIdentity :inPKCS12Data :&identity];
            SecCertificateRef certificate = NULL;
            SecIdentityCopyCertificate (identity, &certificate);
            
            *credential = [NSURLCredential credentialWithIdentity:identity certificates:nil persistence:NSURLCredentialPersistencePermanent];
            
            return NSURLSessionAuthChallengeUseCredential;
            
        }else{
            return NSURLSessionAuthChallengeUseCredential;
        }
    }];
    
    return manager;
}

#pragma mark 设置加密信息
+ (OSStatus)extractIdentity:(CFDataRef)inP12Data :(SecIdentityRef*)identity
{
    OSStatus securityError = errSecSuccess;
    CFStringRef password = [AJNetworkConfig shareInstance].httpsCertificatePassword;
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12Data, options, &items);
    
    if (securityError == 0)
    {
        CFDictionaryRef ident = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(ident, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
    }
    
    if (options)
    {
        CFRelease(options);
    }
    
    return securityError;
}

#pragma mark 缓存Key
+ (NSString *)cacheKeyWithRequestBean:(__kindof AJRequestBeanBase *) requestBean
{
    NSString *cacheInfoStr = [NSString stringWithFormat:@"URL:%@ PARAMS:%@", [requestBean requestUrl], [requestBean mj_keyValues]];
    NSString *cacheKey = [MD5Util md5WithoutEncryptionFactor:cacheInfoStr];
    
    return cacheKey;
}


+ (Class)responseClassWithRequestBean:(__kindof AJRequestBeanBase *) requestBean
{
    const char *requestClassName = class_getName([requestBean class]);
    NSString *responseBeanNameStr = [[NSString stringWithUTF8String:requestClassName] stringByReplacingOccurrencesOfString:@"Request" withString:@"Response"];
    const char *responseBeanName = [responseBeanNameStr UTF8String];
    
    return objc_getClass(responseBeanName);
}


#pragma mark - <请求处理>

+ (void)requestWithBean:(__kindof AJRequestBeanBase *)requestBean callBack:(AJRequestCallBack)callBack
{
    // 网络检测
    if (![[AJNetworkStatus shareInstance] canReachable]) {
        
        AJError *err = [[AJError alloc] initWithCode:AJErrorCodeNoNetwork message:@"network can not reach"];
        callBack(nil, err);

        return;
    }
    
    // 发起请求
    NSString *requestUrl = [requestBean requestUrl];
    NSDictionary *params = [requestBean mj_keyValues];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = [requestBean timeout];
    
    // Http Header
    NSDictionary *headerFieldValueDictionary = [requestBean httpHeader];
    if (headerFieldValueDictionary != nil) {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            } else {
                AJLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
    
    // 序列化
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", @"application/msexcel", nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([requestBean httpScheme] == HTTP_SCHEME_HTTPS) {
        manager = [self httpsSessionManager];
    }
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = responseSerializer;
    
    // LOG
    [AJNetworkLog logWithRequestBean:requestBean];
    
    //Hub
    [self showHub:requestBean];
    
    __weak __typeof__(self) weakSelf = self;
    switch ([requestBean httpMethod]) {
            
        case HTTP_METHOD_GET:
        {
            [manager GET:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                
                [strongSelf dismissHub:requestBean];
                [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                
                [strongSelf dismissHub:requestBean];
                [strongSelf handleFailureWithError:error callBack:callBack];
                
            }];
            
            break;
        }
            
        case HTTP_METHOD_POST:
        {

            if ([requestBean constructingBodyBlock] != nil) {
                
                // 文件等富文本内容
                [manager POST:requestUrl parameters:params constructingBodyWithBlock:[requestBean constructingBodyBlock] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    __strong __typeof__(weakSelf) strongSelf = weakSelf;
                    
                    [strongSelf dismissHub:requestBean];
                    [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    __strong __typeof__(weakSelf) strongSelf = weakSelf;
                    
                    [strongSelf dismissHub:requestBean];
                    [strongSelf handleFailureWithError:error callBack:callBack];
                }];
                
            }else{
                
                [manager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    __strong __typeof__(weakSelf) strongSelf = weakSelf;
                    
                    [strongSelf dismissHub:requestBean];
                    [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    __strong __typeof__(weakSelf) strongSelf = weakSelf;
                    
                    [strongSelf dismissHub:requestBean];
                    [strongSelf handleFailureWithError:error callBack:callBack];
                }];
            }
            
            break;
        }
            
        case HTTP_METHOD_HEAD:
        {
            [manager HEAD:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                
                [strongSelf dismissHub:requestBean];
                [strongSelf handleSuccessWithRequestBean:requestBean response:task callBack:callBack];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                
                [strongSelf dismissHub:requestBean];
                [strongSelf handleFailureWithError:error callBack:callBack];
            }];
            
            break;
        }
            
        case HTTP_METHOD_PUT:
        {
            [manager PUT:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                
                [strongSelf dismissHub:requestBean];
                [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                
                [strongSelf dismissHub:requestBean];
                [strongSelf handleFailureWithError:error callBack:callBack];
            }];
            
            break;
        }
            
        case HTTP_METHOD_PATCH:
        {
            [manager PATCH:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                
                [strongSelf dismissHub:requestBean];
                [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                
                [strongSelf dismissHub:requestBean];
                [strongSelf handleFailureWithError:error callBack:callBack];
            }];
            
            break;
        }
            
        case HTTP_METHOD_DELETE:
        {
            [manager DELETE:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                
                [strongSelf dismissHub:requestBean];
                [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                
                [strongSelf dismissHub:requestBean];
                [strongSelf handleFailureWithError:error callBack:callBack];
            }];
            
            break;
        }
            
        default:
            NSLog(@"unknow http method");
            break;
    }
}

+ (void)requestWithBean:(__kindof AJRequestBeanBase *)requestBean cacheCallBack:(AJRequestCallBack)cacheCallBack httpCallBack:(AJRequestCallBack)httpCallBack
{
    __weak __typeof__(self) weakSelf = self;
    [self cacheWithRequestWithBean:requestBean callBack:^(__kindof AJResponseBeanBase * _Nullable responseBean, AJError * _Nullable err) {
        
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        // 缓存结果回调
        cacheCallBack(responseBean, err);
        
        if (err != nil) {
            
            // 没有缓存，发起网络请求
            [strongSelf requestWithBean:requestBean callBack:^(__kindof AJResponseBeanBase * _Nullable responseBean, AJError * _Nullable err) {
                httpCallBack(responseBean, err);
            }];
            
        }else{
        
            if ([requestBean cacheLiveSecond] == 0) {
                
                // 缓存长期有效，需要发起网络请求
                [strongSelf requestWithBean:requestBean callBack:^(__kindof AJResponseBeanBase * _Nullable responseBean, AJError * _Nullable err) {
                    httpCallBack(responseBean, err);
                }];
                
            }else{
                // 缓存短期有效，无需网络请求
            }
        }
    }];
}

+ (NSURLSessionDownloadTask *)downloadTaskWithBean:(__kindof AJRequestBeanDownloadTaskBase *)requestBean progress:(AJDownloadProgressCallBack)progressCallBack completion:(AJDownloadCompletionCallBack)completionCallBack
{
    // 如果已存在，则不下载
    NSString *saveFilePath = [requestBean.saveFilePath stringByAppendingPathComponent:requestBean.saveFileName];
    NSURL *saveFileUrl = [NSURL fileURLWithPath:saveFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:saveFilePath]) {
        completionCallBack(saveFileUrl, nil);
        return nil;
    }
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:requestBean.fileUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

        if (progressCallBack) {
            progressCallBack(downloadProgress.totalUnitCount, downloadProgress.completedUnitCount, (downloadProgress.completedUnitCount * 1.0) / (downloadProgress.totalUnitCount * 1.0));
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return saveFileUrl;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (completionCallBack) {
            completionCallBack(filePath, error);
        }
        
    }];
    
    [downloadTask resume];
    
    return downloadTask;
}

+ (void)cacheWithRequestWithBean:(__kindof AJRequestBeanBase *)requestBean callBack:(AJRequestCallBack)callBack
{
    if ([requestBean cacheResponse]) {
        
        SPTPersistentCache *httpCache = [[AJNetworkConfig shareInstance] globalHttpCache];
        NSString *cacheKey = [self cacheKeyWithRequestBean:requestBean];
        
        __weak __typeof(&*self) weakSelf = self;
        [httpCache loadDataForKey:cacheKey withCallback:^(SPTPersistentCacheResponse * _Nonnull response) {
            
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            
            if (response.result == SPTPersistentCacheResponseCodeOperationSucceeded) {
                NSData *cacheData = response.record.data;
                NSDictionary *jsonDic = [cacheData mj_keyValues];
                
                Class responseClass = [strongSelf responseClassWithRequestBean:requestBean];
                AJResponseBeanBase *responseBean = [responseClass mj_objectWithKeyValues:jsonDic];
                responseBean.rawData = jsonDic;
                
                callBack(responseBean, nil);
                
            }else{
                
                AJError *err = [[AJError alloc] initWithCode:AJErrorCodeCacheInvalid message:@"cache invalid"];
                callBack(nil, err);
            }
            
        } onQueue:dispatch_get_main_queue()];
        
    }else{
        
        AJError *err = [[AJError alloc] initWithCode:AJErrorCodeNoCache message:@"no cache"];
        callBack(nil, err);
    }
}

#pragma mark - <结果处理>

+ (void)handleSuccessWithRequestBean:(__kindof AJRequestBeanBase *)requestBean response:(id  _Nullable) responseObject callBack:(AJRequestCallBack)callBack
{
    [AJNetworkLog logWithRequestBean:requestBean json:responseObject];
    

    //TODO: HEAD 请求结果处理有待补充
    if ([requestBean httpMethod] == HTTP_METHOD_HEAD) {
        callBack(nil, [AJError defaultError]);
        return;
    }
    
    if (!responseObject) {
        
        AJError *err = [[AJError alloc] initWithCode:AJErrorCodeNoResponse message:@"no response data"];
        callBack(nil, err);
        [AJNetworkLog logWithContent:@"请求失败：没有数据返回!"];
        return;
    }
    
    Class responseClass = [self responseClassWithRequestBean:requestBean];
    AJResponseBeanBase *responseBean = [responseClass mj_objectWithKeyValues:responseObject];
    responseBean.rawData = responseObject;
    
    if ([responseBean checkSuccess]) {
        
        // 缓存
        if ([requestBean cacheResponse]) {
            [self saveCacheWithRequestBean:requestBean responseObj:responseObject];
        }
        
        // 成功
        callBack(responseBean, nil);
        
    }else{
        // 失败
        NSString *errMsg = [NSString stringWithFormat:@"错误码：%ld", (long)[responseBean statusCode]];
        NSString *responseMsg = [responseBean responseMessage];
        if ((responseMsg != nil) && ![responseMsg isEqualToString:@""] ) {
            errMsg = [NSString stringWithFormat:@"%@ -- %@", errMsg, responseMsg];
        }

        [AJNetworkLog logWithContent:[NSString stringWithFormat:@"请求失败：%@", errMsg]];
        
        AJError *err = [[AJError alloc] initWithCode:[responseBean statusCode] message:errMsg];
        callBack(responseBean, err);
    }
}

+ (void)handleFailureWithError:(NSError *)error callBack:(AJRequestCallBack)callBack
{
    [AJNetworkLog logWithContent:[NSString stringWithFormat:@"请求失败：%@", [error description]]];
    
    AJError *err = [[AJError alloc] initWithCode:error.code message:error.description];
    callBack(nil, err);
}


+ (void)saveCacheWithRequestBean:(__kindof AJRequestBeanBase *) requestBean responseObj:(id  _Nullable) responseObject
{
    SPTPersistentCache *httpCache = [[AJNetworkConfig shareInstance] globalHttpCache];
    
    NSData *cacheData = [responseObject mj_JSONData];
    NSString *cacheKey = [self cacheKeyWithRequestBean:requestBean];
    NSTimeInterval ttl = [requestBean cacheLiveSecond];
    
    [httpCache storeData:cacheData forKey:cacheKey ttl:ttl locked:NO withCallback:^(SPTPersistentCacheResponse * _Nonnull response) {
        
        if (response.result == SPTPersistentCacheResponseCodeOperationSucceeded) {
            AJLog(@"#cache data success#: %@", cacheKey);
        }else{
            AJLog(@"#cache fail#: %@", [response.error description]);
        }
        
    } onQueue:dispatch_get_main_queue()];
}

#pragma mark Hub
+ (void)showHub:(AJRequestBeanBase *)requestBean
{
    if ([requestBean showHub]) {
        
        id delegate = [AJNetworkConfig shareInstance].hubDelegate;
        if ([delegate respondsToSelector:@selector(showHubWithRequestBean:)]) {
            [delegate showHubWithRequestBean:requestBean];
        }
    }
}

+ (void)dismissHub:(AJRequestBeanBase *)requestBean
{
    if ([requestBean showHub]) {
        
        id delegate = [AJNetworkConfig shareInstance].hubDelegate;
        if ([delegate respondsToSelector:@selector(dismissHubWithRequestBean:)]) {
            [delegate dismissHubWithRequestBean:requestBean];
        }
    }
}

@end
