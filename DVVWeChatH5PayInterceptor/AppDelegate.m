//
//  AppDelegate.m
//  DVVWeChatH5PayInterceptor
//
//  Created by David on 2020/1/14.
//  Copyright © 2020 David. All rights reserved.
//

#import "AppDelegate.h"
#import "Const.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"openURL: %@", url);
    if ([url.scheme hasPrefix:WeChatH5PayCustomSchemePrefix]) {
        // 微信H5支付拦截，不用处理
    } else {
        
    }
    return YES;
}

@end
