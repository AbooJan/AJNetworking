//
//  AJError.h
//  AJNetworking
//
//  Created by aboojan on 16/8/24.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AJErrorCode)
{
    AJErrorCodeDefault = 0,
    AJErrorCodeNoCache = 101,
    AJErrorCodeCacheInvalid = 102,
    AJErrorCodeNoNetwork = 103,
    AJErrorCodeNoResponse = 104
};

@interface AJError : NSObject

@property (nonatomic,assign) NSInteger code;
@property (copy, nonatomic) NSString *message;

+ (AJError *)defaultError;
- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message;

@end
