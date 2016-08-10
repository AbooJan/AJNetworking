//
//  AJNetworkStatus.h
//  AJNetworking
//
//  Created by aboojan on 16/8/10.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AJNetworkReachabilityStatus)
{
    AJNetworkReachabilityStatusUnknown,
    AJNetworkReachabilityStatusNotReachable,
    AJNetworkReachabilityStatusWWAN,
    AJNetworkReachabilityStatusWiFi
};

@interface AJNetworkStatus : NSObject

+ (AJNetworkStatus *)shareInstance;

- (AJNetworkReachabilityStatus)currentStatus;

- (BOOL)canReachable;

@end
