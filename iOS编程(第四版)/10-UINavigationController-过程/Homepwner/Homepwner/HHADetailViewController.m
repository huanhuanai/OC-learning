//
//  HHADetailViewController.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/11.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHADetailViewController.h"
#import "HHAItem.h"

@interface HHADetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *vlaueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end


@implementation HHADetailViewController

- (void)setItem:(HHAItem *)item {
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    HHAItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.vlaueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    //创建NSDateFormatter对象，用于将NSDate对象转换成简单的日期字符串
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    //将转换后得到的日期字符串设置为dateLabel的标题
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //取消当前的第一响应者
    [self.view endEditing:YES];
    //将修改“保存”至HHAItem对象
    HHAItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.vlaueField.text intValue];
}
@end
