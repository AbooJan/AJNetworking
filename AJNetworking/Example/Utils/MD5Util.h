//
//  MD5Util.h
//  jianzhimao
//
//  Created by 刘骞 on 3/26/14.
//  Copyright (c) 2014 Guangzhou jiuwei technology company. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MD5Util : NSObject
+ (NSString *)md5ExamNum:(NSString *) examNum;
+ (NSString *)calc:(NSString *) str;
+ (NSString *)md5MakeByDic:(NSDictionary *)params md5key:(NSString *)key;

@end
