//
//  HHAWebViewController.m
//  Nerdfeed
//
//  Created by 李欢 on 2020/4/3.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAWebViewController.h"
#import <WebKit/WebKit.h>

@interface HHAWebViewController ()

@end

@implementation HHAWebViewController

- (void)loadView {
    WKWebView *webView = [[WKWebView alloc] init];
    self.view = webView;
}

- (void)setURL:(NSURL *)URL {
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(WKWebView *)self.view loadRequest:req];
    }
}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    svc.displayModeButtonItem.title = @"Course";
    self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(nullable id)sender  {
    self.navigationItem.leftBarButtonItem = nil;
    return YES;
}

@end
