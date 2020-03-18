//
//  ViewController.m
//  TouchTracker
//
//  Created by 李欢 on 2020/3/17.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHADrawViewController.h"
#import "HHADrawLine.h"

@interface HHADrawViewController ()

@end

@implementation HHADrawViewController

- (void)loadView {
    self.view = [[HHADrawLine alloc] initWithFrame:CGRectZero];
}

@end
