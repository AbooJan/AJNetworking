//
//  ResponseBeanDemoNews.h
//  AJNetworking
//
//  Created by aboojan on 16/8/6.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "ResponseBeanDemo.h"

@interface News : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *author;
@end

@interface ResponseBeanDemoNews : ResponseBeanDemo
@property (nonatomic,strong) NSArray<__kindof News *> *data;
@end
