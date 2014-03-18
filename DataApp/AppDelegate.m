//
//  AppDelegate.m
//  DataApp
//
//  Created by HsiuYi on 2014/3/13.
//  Copyright (c) 2014年 HsiuYi. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataHelper.h"

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[CoreDataHelper instance] saveContext];
}



@end
