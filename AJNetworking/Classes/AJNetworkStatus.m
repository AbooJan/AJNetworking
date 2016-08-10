//
//  AJNetworkStatus.m
//  AJNetworking
//
//  Created by aboojan on 16/8/10.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "AJNetworkStatus.h"
#import "AFNetworkReachabilityManager.h"

@interface AJNetworkStatus()
@property (nonatomic, strong) AFNetworkReachabilityManager *networkManager;
@end

@implementation AJNetworkStatus

+ (AJNetworkStatus *)shareInstance
{
    static AJNetworkStatus *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AJNetworkStatus alloc] init];
        
        instance.networkManager = [AFNetworkReachabilityManager manager];
        [instance.networkManager startMonitoring];
    });
    
    return instance;
}

- (AJNetworkReachabilityStatus)currentStatus
{
    switch (self.networkManager.networkReachabilityStatus) {
            
        case AFNetworkReachabilityStatusUnknown: {
            return AJNetworkReachabilityStatusUnknown;
        }
            
        case AFNetworkReachabilityStatusNotReachable: {
            return AJNetworkReachabilityStatusNotReachable;
        }
            
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            return AJNetworkReachabilityStatusWWAN;
        }
            
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            return AJNetworkReachabilityStatusWiFi;
        }
            
        default:
            return AJNetworkReachabilityStatusUnknown;
    }
}

- (BOOL)canReachable
{
    return self.networkManager.reachable;
}

@end
