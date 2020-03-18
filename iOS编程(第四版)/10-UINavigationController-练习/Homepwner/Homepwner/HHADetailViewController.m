//
//  HHADetailViewController.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/11.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHADetailViewController.h"
#import "HHADatePickerViewController.h"
#import "HHAItem.h"

@interface HHADetailViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end


@implementation HHADetailViewController

- (void)setItem:(HHAItem *)item {
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.valueField resignFirstResponder];
    return YES;
}
- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor grayColor];

    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"return" style:UIBarButtonItemStylePlain target:self action:@selector(numberFieldCancle)];
    toolbar.items = @[bar];
    return toolbar;
}
- (IBAction)changeDate:(id)sender {
    HHADatePickerViewController *dpVC = [[HHADatePickerViewController alloc] init];
    dpVC.itemNumber = self.index;
    dpVC.item = self.item;
    [self.navigationController pushViewController:dpVC animated:YES];
}

- (void)numberFieldCancle
{
    [self.valueField resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.valueField) {
    
        self.valueField.inputAccessoryView=[self addToolbar];
    }
    return YES;
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    HHAItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
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
    item.valueInDollars = [self.valueField.text intValue];
}
@end
