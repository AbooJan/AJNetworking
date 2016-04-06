//
//  AJCacheOptions.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/4/6.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>


extern const NSUInteger AJCacheDefaultExpirationSecond;
extern const NSUInteger AJCacheDefaultGCSecond;


@interface AJCacheOptions : NSObject

/**
 *  @author aboojan
 *
 *  @brief 缓存存放路径
 */
@property (nonatomic, copy) NSString *cachePath;

/**
 *  @author aboojan
 *
 *  @brief 缓存过期时间,最小不能小于60s
 */
@property (nonatomic, assign) NSUInteger globalCacheExpirationSecond;

/**
 *  @author aboojan
 *
 *  @brief 缓存自动回收时间,最小不能小于60s
 */
@property (nonatomic, assign) NSUInteger globalCacheGCSecond;

@end
