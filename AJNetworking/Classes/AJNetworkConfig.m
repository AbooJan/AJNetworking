//
//  AJNetworkConfig.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 Joiway. All rights reserved.
//

#import "AJNetworkConfig.h"
#import "AJNetworkStatus.h"

#define kBundleID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]


@interface AJNetworkConfig ()
/// 网络缓存
@property (nonatomic, strong) SPTPersistentCache *httpCache;
@end

@implementation AJNetworkConfig

+ (AJNetworkConfig *)shareInstance
{
    static AJNetworkConfig * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AJNetworkConfig alloc] init];
        
        // 开启网络状态监听
        [AJNetworkStatus shareInstance];
    });
    
    return instance;
}

- (SPTPersistentCache *)globalHttpCache
{
    if (!_httpCache) {
        
        NSString *cacheIdentifier = [NSString stringWithFormat:@"%@.cache", kBundleID];
        
        // 缓存配置
        SPTPersistentCacheOptions *options = [[SPTPersistentCacheOptions alloc]
                                              initWithCachePath:self.cacheOptions.cachePath
                                              identifier:cacheIdentifier
                                              defaultExpirationInterval:self.cacheOptions.globalCacheExpirationSecond
                                              garbageCollectorInterval:self.cacheOptions.globalCacheGCSecond
                                              debug:^(NSString * _Nonnull string) {
                                                  
                                                  AJLog(@"###SPTPersistentCache###: %@", string);
                                              }];
        
        _httpCache = [[SPTPersistentCache alloc] initWithOptions:options];
        
        // 开启缓存自动回收
        if (self.cacheOptions.openCacheGC) {
            [_httpCache scheduleGarbageCollector];
        }
        
    }
    
    return _httpCache;
}

- (AJCacheOptions *)cacheOptions
{
    if (!_cacheOptions){
        
        _cacheOptions = [[AJCacheOptions alloc] init];
        
        _cacheOptions.cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", kBundleID]];
        _cacheOptions.globalCacheExpirationSecond = AJCacheDefaultExpirationSecond;
        _cacheOptions.globalCacheGCSecond = AJCacheDefaultGCSecond;
    }
    
    if( (_cacheOptions.cachePath == nil) || [_cacheOptions.cachePath isEqualToString:@""] )
    {
        _cacheOptions.cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", kBundleID]];
    }
    
    if (_cacheOptions.globalCacheExpirationSecond < 60) {
        _cacheOptions.globalCacheExpirationSecond = AJCacheDefaultExpirationSecond;
    }
    
    if (_cacheOptions.globalCacheGCSecond < 60) {
        _cacheOptions.globalCacheGCSecond = AJCacheDefaultGCSecond;
    }
    
    return _cacheOptions;
}


@end
