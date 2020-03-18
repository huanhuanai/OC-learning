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


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    HHAHypnosisViewController *vc = [[HHAHypnosisViewController alloc] init];
    self.window.rootViewController = vc;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    return YES;
}




@end
