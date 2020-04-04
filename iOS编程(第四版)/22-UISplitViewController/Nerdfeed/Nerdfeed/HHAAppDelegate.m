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
    HHAWebViewController *wvc = [[HHAWebViewController alloc] init];
    cvc.webViewController = wvc;
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:cvc];
    
    //检查当前设备是否是iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        //必须将webViewController包含在导航控制器视图中，稍后会解释原因
        UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:wvc];
        UISplitViewController *svc = [[UISplitViewController alloc] init];
        
        //将从视图控制器设置为UISplitViewController对象的委托对象
        svc.viewControllers = @[masterNav, detailNav];
        
        //将UISplitViewController对象设置为UIWindow对象的根视图控制器
        self.window.rootViewController = svc;
    } else {
        //对于非iPad设备，任然使用导航视图控制器
        self.window.rootViewController = masterNav;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
