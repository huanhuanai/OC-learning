//
//  HHAReminderViewController.m
//  Hypnosiser
//
//  Created by 李欢 on 2020/3/7.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAReminderViewController.h"

@interface HHAReminderViewController ()

@property(nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation HHAReminderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *tbi = self.tabBarItem;
        tbi.title = @"Reminder";
        UIImage *i = [UIImage imageNamed:@"Time@2x.png"];
        tbi.image = i;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"HHAReminderViewController loaded its view.");
}

- (IBAction)addReminder:(id)sender {
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@", date);
    
}

@end
