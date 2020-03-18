//
//  ViewController.m
//  Hypnosiser
//
//  Created by 李欢 on 2020/3/5.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAHypnosisViewController.h"
#import "HHAHypnosisView.h"

@interface HHAHypnosisViewController ()

@end

@implementation HHAHypnosisViewController

- (void)loadView {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    [scrollView setPagingEnabled:YES];
    self.view = scrollView;
    
    HHAHypnosisView *firstView = [[HHAHypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:firstView];
    
    screenRect.origin.x += screenRect.size.width;
    HHAHypnosisView *anotherView = [[HHAHypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:anotherView];
    scrollView.contentSize = bigRect.size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
