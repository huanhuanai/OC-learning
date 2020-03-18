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
    HHAHypnosisView *backgroundView = [[HHAHypnosisView alloc] init];
    
    self.view = backgroundView;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Hypnotize";
        UIImage *i = [UIImage imageNamed:@"Hypno@2x.png"];
        self.tabBarItem.image = i;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
