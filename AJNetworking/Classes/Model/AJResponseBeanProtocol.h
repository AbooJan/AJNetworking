//
//  AJResponseBeanProtocol.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/22.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AJResponseBeanProtocol <NSObject>

/**
 *  @author zhongbaojian
 *
 *  @brief 请求结果状态码
 *
 *  @return 状态码
 */
- (NSInteger)statusCode;

/**
 *  @author zhongbaojian
 *
 *  @brief 返回提示信息
 *
 *  @return 提示信息
 */
- (NSString *)responseMessage;

/**
 *  @author aboojan, 16-03-20 10:03:57
 *
 *  @brief 根据自定义的状态码校验返回结果是否正确
 *
 *  @return YES，正确；NO，错误
 */
- (BOOL)checkSuccess;

@end
