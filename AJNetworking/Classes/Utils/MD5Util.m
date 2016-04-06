//
//  MD5Util.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/28.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "MD5Util.h"
#import <CommonCrypto/CommonDigest.h>
#include <objc/runtime.h>

// MD5加密因子
#define MD5_DEFAULT_ENCRYPTION_FACTOR @"123456789"

@implementation MD5Util

+ (NSString *)md5WithDefaultEncryptionFactor:(NSString *) targetContent
{
    
    NSString *s1 = [self md5WithoutEncryptionFactor:[targetContent stringByAppendingString:MD5_DEFAULT_ENCRYPTION_FACTOR]];
    NSString *s2 = [self md5WithoutEncryptionFactor:s1];
    return s2;
}

+ (NSString *)md5WithContent:(NSString *) targetContent encryptionFactor:(NSString *) factor
{

    if (factor == nil || [factor isEqualToString:@""]) {
        factor = MD5_DEFAULT_ENCRYPTION_FACTOR;
    }
    
    NSString *s1 = [self md5WithoutEncryptionFactor:[targetContent stringByAppendingString:factor]];
    NSString *s2 = [self md5WithoutEncryptionFactor:s1];
    return s2;
}


+ (NSString *)md5WithoutEncryptionFactor:(NSString *) targetContent
{
    const char *cStr = [targetContent UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *md5Str = [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
    return md5Str;
}

NSInteger letterSorted(id string1,id string2, void *context){
    if (string1&&string2) {
        return [string1 compare:string2];
    }else{
        return 0;
    }
    
}

+ (NSString *)md5WithDictionary:(NSDictionary *) targetDictionary encryptionFactor:(NSString *) factor
{
    if ( (targetDictionary != nil) && (targetDictionary.allKeys.count > 0) ) {
        
        NSArray *keys = targetDictionary.allKeys;
        NSArray *sortedKeys = [keys sortedArrayUsingFunction:letterSorted context:NULL];
        NSMutableString *sortedValueString = [[NSMutableString alloc] init];
        
        for (NSString *key in sortedKeys) {
            
            id value = [targetDictionary objectForKey:key];
            
            if (value && ![value isEqual:[NSNull null]]) {
                
                NSString *valueString = @"";
                
                Class numberClass = objc_getClass("__NSCFNumber");
                Class boolClass = objc_getClass("__NSCFBoolean");
                
                if ([value class] == numberClass || [value class] == boolClass) {
                    
                    valueString = [value stringValue];
                    
                }else{
                    
                    valueString = value;
                }
                
                [sortedValueString appendString:valueString];
            }
            
        }
        
        return [self md5WithContent:sortedValueString encryptionFactor:factor];
    }
    
    return @"";
}

@end
