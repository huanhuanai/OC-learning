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

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        CGRect screenRect = self.view.bounds;
//        CGRect bigRect = screenRect;
//        bigRect.size.width *= 2.0;
//
//        HHAHypnosisView *firstView = [[HHAHypnosisView alloc] initWithFrame:screenRect];
//        [self.view addSubview:firstView];
//    }
//    return self;
//}

- (void)loadView {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;

    HHAHypnosisView *firstView = [[HHAHypnosisView alloc] initWithFrame:screenRect];
    self.view = firstView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
