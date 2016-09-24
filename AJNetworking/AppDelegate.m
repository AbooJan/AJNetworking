//
//  AppDelegate.m
//  AJNetworking
//
//  Created by aboojan on 16/3/19.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "AppDelegate.h"
#import "AJNetworking.h"
#import "NetworkHub.h"

@interface AppDelegate ()
@property (nonatomic, strong) NetworkHub *hub;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    AJLog(@"%@", documentsPath);
    
    self.hub = [[NetworkHub alloc] init];
    
    // 网络配置
    AJNetworkConfig *networkConfig = [AJNetworkConfig shareInstance];
    networkConfig.hostUrl = @"localhost:3000";
//    networkConfig.hostUrl = @"192.168.1.10:80";
    networkConfig.httpsCertificatePassword = CFSTR("666666");
    networkConfig.httpsCertificatePath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
    networkConfig.hubDelegate = self.hub;
    
    // 网络缓存配置
    AJCacheOptions *cacheOptions = [AJCacheOptions new];
    cacheOptions.cachePath = [documentsPath stringByAppendingPathComponent:@"aj_network_cache"];
    cacheOptions.openCacheGC = YES;
    cacheOptions.globalCacheExpirationSecond = 60;
    cacheOptions.globalCacheGCSecond = 2 * 60;
    networkConfig.cacheOptions = cacheOptions;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
