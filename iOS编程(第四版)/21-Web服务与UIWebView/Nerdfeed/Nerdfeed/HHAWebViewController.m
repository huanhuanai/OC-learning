//
//  HHAWebViewController.m
//  Nerdfeed
//
//  Created by 李欢 on 2020/4/3.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAWebViewController.h"
#import <WebKit/WebKit.h>

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

@end
