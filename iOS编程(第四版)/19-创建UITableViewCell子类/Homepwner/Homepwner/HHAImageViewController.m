//
//  HHAImageViewController.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/26.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAImageViewController.h"

@interface HHAImageViewController ()

@end

@implementation HHAImageViewController

- (void)loadView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //必须将view转换为UIImageView对象，以便向其发送setImage消息
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = self.image;
}

@end
