//
//  HHADatePickerViewController.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/12.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHADatePickerViewController.h"
#import "HHAItemStore.h"
#import "HHAItem.h"

@interface HHADatePickerViewController ()



@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation HHADatePickerViewController

- (void)setItem:(HHAItem *)item {
    _item = item;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //取消当前的第一响应者
    [self.view endEditing:YES];
    //将修改“保存”至HHAItem对象
    HHAItem *item = self.item;
    item.dateCreated = self.datePicker.date;
    NSLog(@"");
}

@end
