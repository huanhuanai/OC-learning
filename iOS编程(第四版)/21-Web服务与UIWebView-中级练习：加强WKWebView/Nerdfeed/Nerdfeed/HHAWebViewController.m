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

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HHAWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect webRect = CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height - 80);
    self.webView = [[WKWebView alloc] initWithFrame:webRect];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
    [self.webView loadRequest:req];
    self.webView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.webView];
    
    CGRect toolBarRect = CGRectMake(0, 44, self.view.bounds.size.width, 80);
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:toolBarRect];
    toolBar.barTintColor = [UIColor redColor];
    [self.view addSubview:toolBar];

    UIBarButtonItem *goBackButton = [[UIBarButtonItem alloc] initWithTitle:@"GoBack" style:UIBarButtonItemStyleDone target:self action:@selector(goBackAction)];
    UIBarButtonItem *goForwardButton = [[UIBarButtonItem alloc] initWithTitle:@"GoForward" style:UIBarButtonItemStylePlain target:self action:@selector(goForwardAction)];
    toolBar.items = @[goBackButton, goForwardButton];
}

- (void)goBackAction {
    if (self.webView.canGoBack == YES) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)goForwardAction {
    if (self.webView.canGoForward == YES) {
        [self.webView goForward];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
