//
//  ResponseBeanDemoFilm.h
//  AJNetworking
//
//  Created by aboojan on 16/8/27.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "ResponseBeanDemo.h"

@interface Film : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *type;
@end


@interface ResponseBeanDemoFilm : ResponseBeanDemo
@property (nonatomic,strong) NSArray<__kindof Film *> *data;
@end
