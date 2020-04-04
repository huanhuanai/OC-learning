//
//  BNRAppDelegate.m
//  Nerdfeed
//
//  Created by John Gallagher on 1/9/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRAppDelegate.h"
#import "BNRCoursesViewController.h"
#import "BNRWebViewController.h"

@implementation BNRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    BNRCoursesViewController *cvc = [[BNRCoursesViewController alloc] initWithStyle:UITableViewStylePlain];

    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:cvc];

    BNRWebViewController *wvc = [[BNRWebViewController alloc] init];
    cvc.webViewController = wvc;

    self.window.rootViewController = masterNav;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
