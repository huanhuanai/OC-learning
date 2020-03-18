//
//  ViewController.m
//  Hypnosiser
//
//  Created by 李欢 on 2020/3/5.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAHypnosisViewController.h"
#import "HHAHypnosisView.h"
#import "HHAQuizViewController.h"

@interface HHAHypnosisViewController ()

@property (nonatomic, strong) HHAHypnosisView *backgroundView;

@end

@implementation HHAHypnosisViewController

- (void)loadView {
    self.backgroundView = [[HHAHypnosisView alloc] init];
    self.view = self.backgroundView;
    NSArray *segTitle = @[@"红色", @"绿色", @"蓝色"];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:segTitle];
    seg.selectedSegmentIndex = 0;
    seg.frame = CGRectMake(20, 50, 374, 45);
    [seg addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.backgroundView addSubview:seg];
}

- (void)segmentValueChanged:(UISegmentedControl *)seg {
    switch (seg.selectedSegmentIndex) {
        case 0:
            self.backgroundView.circleColor = [UIColor redColor];
            break;
        case 1:
            self.backgroundView.circleColor = [UIColor greenColor];
            break;
        case 2:
            self.backgroundView.circleColor = [UIColor blueColor];
            break;
        default:
            break;
    }
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

    NSLog(@"ViewController loaded its view.");
}

@end
