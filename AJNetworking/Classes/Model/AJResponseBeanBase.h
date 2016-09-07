//
//  AJResponseBeanBase.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 Joiway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJResponseBeanProtocol.h"
#import "AJNetworkConfig.h"

@interface AJResponseBeanBase : NSObject<AJResponseBeanProtocol>
@property (nonatomic, strong) id rawData;
@end
