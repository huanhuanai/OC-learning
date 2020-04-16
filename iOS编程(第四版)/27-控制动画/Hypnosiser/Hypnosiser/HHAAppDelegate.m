//
//  AppDelegate.m
//  Hypnosiser
//
//  Created by 李欢 on 2020/3/5.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAAppDelegate.h"
#import "HHAHypnosisViewController.h"
#import "HHAHypnosisView.h"
#import "HHAReminderViewController.h"

@interface HHAAppDelegate ()

@end

@implementation HHAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    HHAHypnosisViewController *vc = [[HHAHypnosisViewController alloc] init];
    
    NSBundle *appBundle = [NSBundle mainBundle];
    HHAReminderViewController *rvc = [[HHAReminderViewController alloc]
                                       initWithNibName:@"HHAReminderViewController"
                                                bundle:appBundle];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[vc, rvc];
    self.window.rootViewController = tabBarController;


    self.window.backgroundColor = [UIColor whiteColor];

    [self.window makeKeyAndVisible];
    return YES;
}

@end
