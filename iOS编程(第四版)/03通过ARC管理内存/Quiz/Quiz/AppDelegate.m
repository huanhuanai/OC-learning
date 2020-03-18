//
//  AppDelegate.m
//  Quiz
//
//  Created by 李欢 on 2020/3/2.
//  Copyright © 2020 huan. All rights reserved.
//

#import "AppDelegate.h"
#import "HHAQuizViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //在这里添加相应启动后的初始代码
    
    HHAQuizViewController *quizVC = [[HHAQuizViewController alloc] init];
    self.window.rootViewController = quizVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
