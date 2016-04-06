//
//  ResponseBeanExample.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/26.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "ResponseBeanExample.h"
#import <objc/runtime.h>

#define kDataName @"data."

@implementation ResponseBeanExample

- (NSInteger)statusCode
{
    return self.status;
}

- (NSString *)responseMessage
{
    return self.msg;
}

- (BOOL)checkSuccess
{
    if (self.status == 0) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    unsigned int propCount;
    objc_property_t* properties = class_copyPropertyList([self class], &propCount);
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] initWithCapacity:propCount];
    
    for (int i=0; i<propCount; i++) {
        
        objc_property_t prop = properties[i];
        const char *propName = property_getName(prop);
        
        if(propName) {
            
            NSString *key = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            
            if ([key isEqualToString:@"msg"] || [key isEqualToString:@"status"]) {
                continue;
            }
            
            NSString *value = [kDataName stringByAppendingString:key];
            
            [parmas setObject:value forKey:key];
            
        }
        
    }
    
    return parmas;
}

@end
