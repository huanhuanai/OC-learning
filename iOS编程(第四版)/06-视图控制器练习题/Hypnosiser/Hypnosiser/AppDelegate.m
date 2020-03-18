//
//  AppDelegate.m
//  Hypnosiser
//
//  Created by 李欢 on 2020/3/5.
//  Copyright © 2020 huan. All rights reserved.
//

#import "AppDelegate.h"
#import "HHAHypnosisViewController.h"
#import "HHAHypnosisView.h"
#import "HHAReminderViewController.h"
#import "HHAQuizViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    HHAHypnosisViewController *vc = [[HHAHypnosisViewController alloc] init];
    
    NSBundle *appBundle = [NSBundle mainBundle];
    HHAReminderViewController *rvc = [[HHAReminderViewController alloc]
                                       initWithNibName:@"HHAReminderViewController"
                                                bundle:appBundle];
    
    HHAQuizViewController *qvc = [[HHAQuizViewController alloc] initWithNibName:@"HHAQuizViewController" bundle:appBundle];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[vc, rvc, qvc];
    self.window.rootViewController = tabBarController;
    
    


    self.window.backgroundColor = [UIColor whiteColor];

    [self.window makeKeyAndVisible];
    return YES;
}

@end
