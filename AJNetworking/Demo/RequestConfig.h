//
//  RequestConfig.h
//  AJNetworking
//
//  Created by aboojan on 16/8/6.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJNetworking.h"


@interface RequestConfig : NSObject

+(RequestConfig *)shareInstance;

- (NSString *)apiPathWithRequestClass:(Class)requestClass;
- (HTTP_SCHEME)httpSchemeWithRequestClass:(Class)requestClass;
- (HTTP_METHOD)httpMethodWithRequestClass:(Class)requestClass;

@end
