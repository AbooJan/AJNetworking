//
//  TripleDESEncrypt.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/28.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

@interface TripleDESEncrypt : NSObject

/**
 *  内容加密解密
 *
 *  @param plainText        需要加密的内容
 *  @param encryptOrDecrypt 加密/解密
 *
 *  @return 加密/解密后的内容
 */
+ (NSString*)tripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt;

@end
