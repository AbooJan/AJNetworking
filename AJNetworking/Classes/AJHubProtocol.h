//
//  AJHubProtocol.h
//  AJNetworking
//
//  Created by aboojan on 2016/9/24.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AJRequestBeanBase;

@protocol AJHubProtocol <NSObject>
- (void)showHubWithRequestBean:(__kindof AJRequestBeanBase *)requestBean;
- (void)dismissHubWithRequestBean:(__kindof AJRequestBeanBase *)requestBean;
@end
