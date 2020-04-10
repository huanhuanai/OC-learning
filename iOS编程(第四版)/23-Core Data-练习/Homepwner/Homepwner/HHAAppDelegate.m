//
//  AppDelegate.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/8.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAAppDelegate.h"
#import "HHAItemStore.h"
#import "HHAItemsViewController.h"

@interface HHAAppDelegate ()

@end

@implementation HHAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    HHAItemsViewController *itemsViewController = [[HHAItemsViewController alloc] init];

    //创建UINavigationController对象
    //该对象的栈只包含itemsViewController
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];

    //将UINavigationController对象设置为UIWindow的根视图控制器，
    //这样就可以将UINavigationController对象的视图添加到屏幕上
    self.window.rootViewController = navController;

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    BOOL success = [[HHAItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the HHAItems");
    } else {
        NSLog(@"Could not save any of the HHAItems");
    }
}

@end
