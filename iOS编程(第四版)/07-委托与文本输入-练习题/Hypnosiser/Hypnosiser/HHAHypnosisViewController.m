//
//  ViewController.m
//  Hypnosiser
//
//  Created by 李欢 on 2020/3/5.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAHypnosisViewController.h"
#import "HHAHypnosisView.h"

@interface HHAHypnosisViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) HHAHypnosisView *firstView;

@end

@implementation HHAHypnosisViewController

- (void)loadView {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
    bigRect.size.height *= 2.0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    [scrollView setPagingEnabled:NO];
    
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 0.2;
    scrollView.contentSize = CGSizeMake(screenRect.size.width * 2, screenRect.size.height * 2);
    
    self.view = scrollView;
    self.firstView = [[HHAHypnosisView alloc] initWithFrame:bigRect];
    [scrollView addSubview:self.firstView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.firstView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
