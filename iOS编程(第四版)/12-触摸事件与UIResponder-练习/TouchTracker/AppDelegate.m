//
//  AppDelegate.m
//  TouchTracker
//
//  Created by 李欢 on 2020/3/17.
//  Copyright © 2020 huan. All rights reserved.
//

#import "AppDelegate.h"
#import "HHADrawViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HHADrawViewController *dvc = [[HHADrawViewController alloc] init];
    self.window.rootViewController = dvc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
