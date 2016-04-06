//
//  ResponseBeanBase.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 Joiway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseBeanProtocol.h"
#import "AJNetworkConfig.h"

@interface ResponseBeanBase : NSObject<ResponseBeanProtocol>
@property (nonatomic, strong) id rawData;
@end
