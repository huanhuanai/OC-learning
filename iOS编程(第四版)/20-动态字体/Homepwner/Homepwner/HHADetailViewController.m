//
//  HHADetailViewController.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/11.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHADetailViewController.h"
#import "HHAItemsViewController.h"
#import "HHAItem.h"
#import "HHAImageStore.h"
#import "HHAItemStore.h"

@interface HHADetailViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic, strong) UIPopoverPresentationController *imagePickerPopover;
@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation HHADetailViewController


#pragma mark - 初始化方法
- (instancetype)initForNewItem:(BOOL)isNew {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                              target:self
                                                              action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;

            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                target:self
                                                                action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }

        //注意不要将注册通知的代码写在if（isNew）{}中
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem:" userInfo:nil];
    return nil;
}

#pragma mark - dealloc
- (void)dealloc {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

#pragma mark - 设置字体的方法
- (void)updateFonts {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;

    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
}

#pragma mark - action method
- (IBAction)takePicture:(id)sender {
    if (self.imagePickerPopover) {
        //如果imagePickerPopover指向的是有效的UIpopoverController对象，
        //并且该对象的视图是可见的，就关闭这个对象，并将其设置为nil
        self.imagePickerPopover = nil;
        return;
    }

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

    imagePicker.preferredContentSize = CGSizeMake(300, 400);
    imagePicker.modalPresentationStyle = UIModalPresentationPopover;
    //如果设备支持相机，就使用拍照模式
    //否则让用户从照片库中选择照片
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;

    //显示UIImagePickerController对象
    //创建UIPopoverController对象前先检查当前设备是否是iPad
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        UIPopoverPresentationController *presentationController =
            [imagePicker popoverPresentationController];

        // 设置委托协议
        presentationController.delegate = self;

        // 设置背景色
        presentationController.backgroundColor = imagePicker.view.backgroundColor;

        //设置ButtonItem
        presentationController.barButtonItem = sender;

        // 以模态形式呈现视图
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        [self presentViewController:imagePicker
                           animated:YES
                         completion:nil];
    }
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - 重写Item的setter方法
- (void)setItem:(HHAItem *)item {
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)prepareViewsForSize:(CGSize)size {
    //如果是iPad，则不执行任何操作
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGSize directionSize = size;

    //判断设备是否处于横排方向
    if (directionSize.width == screenWidth) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

#pragma mark - 为navigationItem的左右Button设置方法
- (void)save:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender {
    //如果用户按下了Cancel按钮，就从HHAItemStore对象移除新创建的HHAItem对象
    [[HHAItemStore sharedStore] removeItem:self.item];

    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

#pragma mark - UIContentContainer
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [self prepareViewsForSize:size];
}

#pragma mark - textField收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    //通过info字典获取选择的照片
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    [self.item setThumbnailFromImage:image];

    //以itemKey为键，将照片存入HHAImageStore对象
    [[HHAImageStore sharedStore] setImage:image forKey:self.item.itemKey];

    //将照片放入UIImageView对象
    self.imageView.image = image;

    //判断UIPopoverController对象是否存在
    if (self.imagePickerPopover) {
        //关闭UIPopoverController对象
        self.imagePickerPopover = nil;
    } else {
        //关闭以模态形式显示的UIImagePickerController对象
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];

    //设置UIImageView对象的内容缩放模式
    iv.contentMode = UIViewContentModeScaleAspectFit;

    //告诉自动布局系统不要将自动缩放掩码转换为约束
    iv.translatesAutoresizingMaskIntoConstraints = NO;

    //将UIImageView对象添加到view上
    [self.view addSubview:iv];

    //将UIImageView对象赋给imageView属性
    self.imageView = iv;

    //将imageView垂直方向的优先级设置为比其他视图低的数值
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];

    NSDictionary *nameMap = @{ @"imageView": self.imageView,
                               @"dateLabel": self.dateLabel,
                               @"toolbar": self.toolbar };

    //imageView的左边和右边与父视图的距离都是0点
    NSArray *horizontalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                          options:0
                                                          metrics:nil
                                                            views:nameMap];

    //imageView的顶边与dateLabel的距离是8点，底边与toolbar的距离也是8点
    NSArray *veiticalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                                          options:0
                                                          metrics:nil
                                                            views:nameMap];

    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:veiticalConstraints];
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

    NSString *itemKey = self.item.itemKey;

    //根据itemKey，从HHAImageStore对象获取照片
    UIImage *imageToDisplay = [[HHAImageStore sharedStore] imageForKey:itemKey];

    //将得到的照片赋给UIImageView对象
    self.imageView.image = imageToDisplay;
    [self updateFonts];
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

//返回none的时候才会有弹出框效果
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
