//
//  AppDelegate.m
//  Nerdfeed
//
//  Created by 李欢 on 2020/4/1.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAAppDelegate.h"
#import "HHACoursesViewController.h"
#import "HHAWebViewController.h"

@interface HHAAppDelegate ()

@end

@implementation HHAAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    HHACoursesViewController *cvc = [[HHACoursesViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:cvc];
    
    self.window.rootViewController = masterNav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
