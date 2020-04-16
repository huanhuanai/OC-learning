//
//  AppDelegate.m
//  Test-iOS-Learning
//
//  Created by 李欢 on 2020/4/16.
//  Copyright © 2020 huan. All rights reserved.
//

#import "AppDelegate.h"
#import "HHANewsViewController.h"
#import "HHAVideoViewController.h"
#import "HHARecommandViewController.h"
#import "HHAMineViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    HHANewsViewController *newsVC = [[HHANewsViewController alloc] init];
    HHAVideoViewController *videoVC = [[HHAVideoViewController alloc] init];
    HHARecommandViewController *recommandVC = [[HHARecommandViewController alloc] init];
    HHAMineViewController *mineVC = [[HHAMineViewController alloc] init];
    
    UITabBarController *tabBC = [[UITabBarController alloc] init];
    tabBC.viewControllers = @[newsVC, videoVC, recommandVC, mineVC];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tabBC];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
