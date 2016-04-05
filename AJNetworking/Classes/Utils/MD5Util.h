//
//  MD5Util.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/28.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MD5Util : NSObject

/**
 *  @author aboojan
 *
 *  @brief 使用默认加密因子进行MD5加密
 *
 *  @param targetContent 需要加密的内容
 *
 *  @return 经过MD5之后的内容
 */
+ (NSString *)md5WithDefaultEncryptionFactor:(NSString *) targetContent;

/**
 *  @author aboojan
 *
 *  @brief 使用目标加密因子进行MD5加密
 *
 *  @param targetContent 需要加密的内容
 *  @param factor        加密因子
 *
 *  @return MD5之后的内容
 */
+ (NSString *)md5WithContent:(NSString *) targetContent encryptionFactor:(NSString *) factor;

/**
 *  @author aboojan
 *
 *  @brief 普通MD5加密
 *
 *  @param targetContent 需要加密的内容
 *
 *  @return MD5之后的内容
 */
+ (NSString *)md5WithoutEncryptionFactor:(NSString *) targetContent;

/**
 *  @author aboojan
 *
 *  @brief 对NSDictionary数据进行MD5
 *
 *  @param targetDictionary 需要进行MD5的Dictionary
 *  @param factor           加密因子，如果没有加密因子则使用默认加密因子
 *
 *  @return MD5之后的内容
 */
+ (NSString *)md5WithDictionary:(NSDictionary *)targetDictionary encryptionFactor:(NSString *)factor;

@end
