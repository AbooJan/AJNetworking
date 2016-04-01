//
//  MD5Util.m
//  jianzhimao
//
//  Created by 刘骞 on 3/26/14.
//  Copyright (c) 2014 Guangzhou jiuwei technology company. All rights reserved.
//

#import "MD5Util.h"
#import <CommonCrypto/CommonDigest.h>
#include <objc/runtime.h>
#import "RegexKitLite.h"

// MD5加密因子
#define MD5_ACCESSORY_STR @"123456789"
///字母+数字
#define REGXEX_LETTER_AND_NUM           @"[a-zA-Z\\d]"

@implementation MD5Util

+(NSString *)md5ExamNum:(NSString *)examNum{
    
    NSString *s1 = [self calc:[examNum stringByAppendingString:MD5_ACCESSORY_STR]];
    NSString *s2 = [self calc:s1];
    return s2;
}

+ (NSString *)companyMd5ExamNum:(NSString *)examNum md5Key:(NSString *)md5Key
{
    NSString *key = md5Key;
    
    if (!key) {
        
        key = MD5_ACCESSORY_STR;
        
    }
    NSString *s  = [self cleanSpecialCharForMD5:examNum];
    NSString *s1 = [self calc:[s stringByAppendingString:key]];//密码因子，增加破解难度
    NSString *s2 = [self calc:s1];
    return s2;
}

+ (NSString *)cleanSpecialCharForMD5:(NSString *)aString{
    
    NSArray *letterAndNums = [aString arrayOfCaptureComponentsMatchedByRegex:REGXEX_LETTER_AND_NUM];
    if (letterAndNums != nil && letterAndNums.count>0) {
        NSMutableString *s = [NSMutableString new];
        for (NSArray *arr in letterAndNums) {
            for (NSString *code in arr) {
                [s appendString:code];
            }
        }
        return s;
    }
    return @"";
}


+ (NSString *)calc:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
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

+ (NSString *)md5MakeByDic:(NSDictionary *)params md5key:(NSString *)key
{
    if (params&&params.count>0) {
        NSArray *keys = params.allKeys;
        NSArray *sortedKeys = [keys sortedArrayUsingFunction:letterSorted context:NULL];
        NSMutableString *sortedValueString = [[NSMutableString alloc] init];
        
        for (NSString *key in sortedKeys) {
            
            id value = [params objectForKey:key];
            
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
        
        return [self companyMd5ExamNum:sortedValueString md5Key:key];
        
    }
    return @"";
    
}

@end
