//
//  RequestBeanUploadAvatar.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/29.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "RequestBeanUploadAvatar.h"

@implementation RequestBeanUploadAvatar

- (NSString *)apiPath
{
    return @"/company/updateLogo";
}

- (HTTP_METHOD)httpMethod
{
    return HTTP_METHOD_POST;
}

- (NSTimeInterval)timeout
{
    return 30.0;
}

+ (NSArray<NSString *> *)mj_ignoredPropertyNames
{
    return @[@"avatar"];
}

- (AFConstructingBlock)constructingBodyBlock
{
    NSData *data = UIImageJPEGRepresentation(self.avatar, 0.8);
    NSString *name = @"img";
    NSString *formKey = @"img";
    NSString *type = @"applicaton/octet-stream";
    
    return AJConstructingBlockDefine {
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}

@end
