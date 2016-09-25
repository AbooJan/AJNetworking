//
//  AJHubProtocol.h
//  AJNetworking
//
//  Created by aboojan on 2016/9/24.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AJHubProtocol <NSObject>

/**
 * 显示Hub
 *
 @param tip hub文案
 */
- (void)showHub:(nullable NSString *)tip;


/**
 * 隐藏Hub
 */
- (void)dismissHub;
@end
