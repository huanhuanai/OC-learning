//
//  AppDelegate.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/8.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAAppDelegate.h"
#import "HHAItemsViewController.h"

@interface HHAAppDelegate ()

@end

@implementation HHAAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    HHAItemsViewController *itemsViewController = [[HHAItemsViewController alloc] init];
    self.window.rootViewController = itemsViewController;
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}






@end
