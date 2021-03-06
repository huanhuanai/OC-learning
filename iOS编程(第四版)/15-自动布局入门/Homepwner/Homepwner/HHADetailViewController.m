//
//  HHADetailViewController.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/11.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHADetailViewController.h"
#import "HHAItem.h"
#import "HHAImageStore.h"

@interface HHADetailViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *vlaueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;


@end


@implementation HHADetailViewController

- (void)setItem:(HHAItem *)item {
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    //如果设备支持相机，就使用拍照模式
    //否则让用户从照片库中选择照片
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    
    //以模态的形式显示UIImagePickerController对象
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    //通过info字典获取选择的照片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //以itemKey为键，将照片存入HHAImageStore对象
    [[HHAImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    //将照片放入UIImageView对象
    self.imageView.image = image;
    
    
    //关闭UIImagePickerController对象
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    
    NSString *itemKey = self.item.itemKey;
    
    //根据itemKey，从HHAImageStore对象获取照片
    UIImage *imageToDisplay = [[HHAImageStore sharedStore] imageForKey:itemKey];
    
    //将得到的照片赋给UIImageView对象
    self.imageView.image = imageToDisplay;
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
