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
    
    //如果应用没有触发状态恢复，就创建并设置各个视图控制器
    if (!self.window.rootViewController) {
    HHAItemsViewController *itemsViewController = [[HHAItemsViewController alloc] init];

    //创建UINavigationController对象
    //该对象的栈只包含itemsViewController
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];

    //将UINavigatonController对象的类名设置为恢复标识
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
    //将UINavigationController对象设置为UIWindow的根视图控制器，
    //这样就可以将UINavigationController对象的视图添加到屏幕上
    self.window.rootViewController = navController;
    }
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

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveSecureApplicationState:(nonnull NSCoder *)coder {
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreSecureApplicationState:(nonnull NSCoder *)coder {
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents coder:(NSCoder *)coder {
    //创建一个新的UINavigationController对象
    UIViewController *vc = [[UINavigationController alloc] init];
    
    //恢复标识路径中的最后一个对象就是UINavigationViewController对象的恢复标识
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    //如果恢复标识路径中只有一个对象，
    //就将UINavigationController对象设置为UIWindow的rootViewController
    if ([identifierComponents count] == 1) {
        self.window.rootViewController = vc;
    }
    return vc;
}

@end
