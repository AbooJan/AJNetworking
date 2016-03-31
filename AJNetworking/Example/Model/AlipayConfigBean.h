//
//  AlipayConfigBean.h
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/28.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayConfigBean : NSObject
@property (nonatomic,strong) NSString *alipayPubKey;
@property (nonatomic,strong) NSString *partnerPrivKey;
@property (nonatomic,strong) NSString *sellerID;
@property (nonatomic,strong) NSString *partnerID;
@end
