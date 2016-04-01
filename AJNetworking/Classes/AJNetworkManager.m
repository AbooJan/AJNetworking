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

#pragma mark - <请求处理>

+ (void)requestWithBean:(__kindof RequestBeanBase *)requestBean callBack:(AJRequestCallBack)callBack
{
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
    
    __weak __typeof__(self) weakSelf = self;
    switch ([requestBean httpMethod]) {
            
        case HTTP_METHOD_GET:
        {
            [manager GET:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
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
                    [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    __strong __typeof__(weakSelf) strongSelf = weakSelf;
                    [strongSelf handleFailureWithError:error callBack:callBack];
                }];
                
            }else{
                
                [manager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    __strong __typeof__(weakSelf) strongSelf = weakSelf;
                    [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    __strong __typeof__(weakSelf) strongSelf = weakSelf;
                    [strongSelf handleFailureWithError:error callBack:callBack];
                }];
            }
            
            break;
        }
            
        case HTTP_METHOD_HEAD:
        {
            [manager HEAD:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task) {
                
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf handleSuccessWithRequestBean:requestBean response:task callBack:callBack];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf handleFailureWithError:error callBack:callBack];
            }];
            
            break;
        }
            
        case HTTP_METHOD_PUT:
        {
            [manager PUT:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf handleFailureWithError:error callBack:callBack];
            }];
            
            break;
        }
            
        case HTTP_METHOD_PATCH:
        {
            [manager PATCH:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf handleFailureWithError:error callBack:callBack];
            }];
            
            break;
        }
            
        case HTTP_METHOD_DELETE:
        {
            [manager DELETE:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf handleSuccessWithRequestBean:requestBean response:responseObject callBack:callBack];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf handleFailureWithError:error callBack:callBack];
            }];
            
            break;
        }
            
        default:
            NSLog(@"unknow http method");
            break;
    }
}

+ (NSURLSessionDownloadTask *)downloadTaskWithBean:(__kindof RequestBeanDownloadTaskBase *)requestBean progress:(AJDownloadProgressCallBack)progressCallBack completion:(AJDownloadCompletionCallBack)completionCallBack
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

#pragma mark - <结果处理>

+ (void)handleSuccessWithRequestBean:(__kindof RequestBeanBase *)requestBean response:(id  _Nullable) responseObject callBack:(AJRequestCallBack)callBack
{
    [AJNetworkLog logWithRequestBean:requestBean json:responseObject];
    

    //TODO: HEAD 请求结果处理有待补充
    if ([requestBean httpMethod]== HTTP_METHOD_HEAD) {
        callBack(nil, NO);
        return;
    }
    
    if (!responseObject) {
        callBack(nil, NO);
        [AJNetworkLog logWithContent:@"请求失败：没有数据返回!"];
        return;
    }
    
    const char *requestClassName = class_getName([requestBean class]);
    NSString *responseBeanNameStr = [[NSString stringWithUTF8String:requestClassName] stringByReplacingOccurrencesOfString:@"Request" withString:@"Response"];
    const char *responseBeanName = [responseBeanNameStr UTF8String];
    
    ResponseBeanBase *responseBean = [objc_getClass(responseBeanName) mj_objectWithKeyValues:responseObject];
    responseBean.rawData = responseObject;
    
    if ([responseBean checkSuccess]) {
        // 成功
        callBack(responseBean, YES);
        
    }else{
        // 失败
        NSString *errMsg = [NSString stringWithFormat:@"错误码：%ld", (long)[responseBean statusCode]];
        NSString *responseMsg = [responseBean responseMessage];
        if ((responseMsg != nil) && ![responseMsg isEqualToString:@""] ) {
            errMsg = [NSString stringWithFormat:@"%@ -- %@", errMsg, responseMsg];
        }

        [AJNetworkLog logWithContent:[NSString stringWithFormat:@"请求失败：%@", errMsg]];
        
        callBack(responseBean, NO);
    }
}

+ (void)handleFailureWithError:(NSError *)error callBack:(AJRequestCallBack)callBack
{
    [AJNetworkLog logWithContent:[NSString stringWithFormat:@"请求失败：%@", [error description]]];
    
    callBack(nil, NO);
}

@end
