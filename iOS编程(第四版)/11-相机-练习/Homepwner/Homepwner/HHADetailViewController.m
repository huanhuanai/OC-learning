//
//  HHADetailViewController.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/11.
//  Copyright © 2020 huan. All rights reserved.
//

//练习题答案在这位大神的博客里：https://blog.csdn.net/zaijianbali/article/details/40482887

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
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation HHADetailViewController

- (void)setItem:(HHAItem *)item {
    _item = item;
    self.navigationItem.title = _item.itemName;
}

//11.10高级练习：Camera Overlay
- (IBAction)takePicture:(id)sender {
    self.imagePicker = [[UIImagePickerController alloc] init];

    //如果设备支持相机，就使用拍照模式
    //否则让用户从照片库中选择照片
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

        self.imagePicker.showsCameraControls = NO;//禁用摄像头控件

        //创建叠加层
        UIView *overLayView = [[UIView alloc]initWithFrame:self.view.bounds];

        UIImageView *crosshairs = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];

        crosshairs.frame = CGRectMake(self.view.center.x - 25,
                                      self.view.center.y - 25,
                                      50,
                                      50);
        crosshairs.image = [UIImage imageNamed:@"logo"];
        crosshairs.alpha = 0.5f;
        crosshairs.contentMode = UIViewContentModeCenter;

        [overLayView addSubview:crosshairs];

        self.imagePicker.cameraOverlayView = overLayView;

        //在叠加视图上自定义一个拍照按钮
        UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [takePhotoBtn setFrame:CGRectMake(74, 370, 178, 37)];
        [takePhotoBtn setTitle:@"选取图片" forState:UIControlStateNormal];
        [takePhotoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [overLayView addSubview:takePhotoBtn];
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.imagePicker.allowsEditing = YES;

    self.imagePicker.delegate = self;

    //以模态的形式显示UIImagePickerController对象
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)takePhoto:(id)sender
{
    [self.imagePicker takePicture];
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}


//11.9中级练习：删除照片
- (IBAction)deleteItem:(id)sender {
    
    [[HHAImageStore sharedStore] deleteImageForKey:self.item.itemKey];
    
    self.imageView.image = nil;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//11.8初级练习：编辑照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    
    NSString *oldKey = self.item.itemKey;
    if (oldKey) {
        [[HHAImageStore sharedStore] deleteImageForKey:oldKey];
    }
    //通过info字典获取选择的照片
    UIImage *image;
    if (info[UIImagePickerControllerEditedImage]) {
        image = info[UIImagePickerControllerEditedImage];
    } else {
        image = info[UIImagePickerControllerOriginalImage];
    }

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
