//
//  ResponseBeanExample.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/26.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "AJResponseBeanBase.h"

@interface ResponseBeanExample : AJResponseBeanBase <AJResponseBeanProtocol>
///提示语
@property (nonatomic,strong) NSString *msg;
///状态值
@property (nonatomic,assign) NSInteger status;
@end
