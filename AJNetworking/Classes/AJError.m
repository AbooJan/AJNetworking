//
//  AJError.m
//  AJNetworking
//
//  Created by aboojan on 16/8/24.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "AJError.h"

@implementation AJError

+ (AJError *)defaultError
{
    AJError *err = [[AJError alloc] initWithCode:AJErrorCodeDefault message:@"error"];
    return err;
}

- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message
{
    self = [super init];
    if (self) {
        self.code = code;
        self.message = message;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"code:%ld \n message:%@", self.code, self.message];
}

@end
