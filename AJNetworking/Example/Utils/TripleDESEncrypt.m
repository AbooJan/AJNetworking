//
//  TripleDESEncrypt.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/28.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "TripleDESEncrypt.h"
#import "NSData+Base64.h"

#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH

#define DESKEY              @"12345678912312312"

@implementation TripleDESEncrypt

+ (NSString*)tripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    const void *vkey = (const void *)[DESKEY UTF8String];
    NSString *result = [self tripleDES:plainText encryptOrDecrypt:encryptOrDecrypt vkey:vkey];
    
    return result;
}

+ (NSString*)tripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt vkey:(const void *)vkey
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        
        NSData *EncryptData = [NSData dataFromBase64String:plainText];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [myData base64EncodedString];
    }
    free(bufferPtr);
    
    return result;
}

@end
