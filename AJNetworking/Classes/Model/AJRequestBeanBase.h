//
//  AJRequestBeanBase.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/18.
//  Copyright © 2016年 Joiway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJRequestBeanProtocol.h"

@interface AJRequestBeanBase : NSObject <AJRequestBeanProtocol>
@property (copy, nonatomic, readonly) NSString *taskKey;
@end
