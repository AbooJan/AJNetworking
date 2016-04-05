//
//  AJNetworkConfig.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 Joiway. All rights reserved.
//

#import "AJNetworkConfig.h"
#import <SPTPersistentCache/SPTPersistentCache.h>

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
    });
    
    return instance;
}

- (SPTPersistentCache *)globalHttpCache
{
    if (_httpCache == nil) {
        
        NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        NSString *cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", bundleID]];
        NSString *cacheIdentifier = [NSString stringWithFormat:@"%@.cache", bundleID];
        
        // 缓存配置
        SPTPersistentCacheOptions *options = [[SPTPersistentCacheOptions alloc] initWithCachePath:cachePath identifier:cacheIdentifier defaultExpirationInterval:SPTPersistentCacheDefaultExpirationTimeSec garbageCollectorInterval:SPTPersistentCacheDefaultGCIntervalSec debug:^(NSString * _Nonnull string) {
            
            AJLog(@"###SPTPersistentCache###: %@", string);
        }];
        
        _httpCache = [[SPTPersistentCache alloc] initWithOptions:options];
    }
    
    return _httpCache;
}

@end
