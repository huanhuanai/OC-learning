//
//  ViewController.m
//  Hypnosiser
//
//  Created by 李欢 on 2020/3/5.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAHypnosisViewController.h"
#import "HHAHypnosisView.h"

@interface HHAHypnosisViewController ()<UITextFieldDelegate>

@end

@implementation HHAHypnosisViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Hypnotize";
        UIImage *i = [UIImage imageNamed:@"Hypno@2x.png"];
        self.tabBarItem.image = i;
    }
    return self;
}

- (void)loadView {
    CGRect frame = [UIScreen mainScreen].bounds;
    HHAHypnosisView *backgroundView = [[HHAHypnosisView alloc] initWithFrame:frame];

    CGRect textFieldRect = CGRectMake(30, 70, 354, 45);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];

    //设置UITextField对象的边框样式，便于查看在屏幕上的位置
    textField.borderStyle = UITextBorderStyleRoundedRect;

    textField.placeholder = @"Hypnotize me";
    textField.returnKeyType = UIReturnKeyDone;

    textField.delegate = self;

    [backgroundView addSubview:textField];

    self.view = backgroundView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self drawHypnoticMessage:textField.text];
    textField.text = @"";
//    textField.textColor = [UIColor redColor];
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Private Method
- (void)drawHypnoticMessage:(NSString *)message {
    for (int i = 0; i < 20; i++) {
        UILabel *messageLebel = [[UILabel alloc] init];
        
        //设置UILabel对象的文字和颜色
        messageLebel.backgroundColor = [UIColor clearColor];
        messageLebel.textColor = [UIColor redColor];
        messageLebel.text = message;
        
        //根据需要显示的文字调整UILabel对象的大小
        [messageLebel sizeToFit];
        
        //获取随机x坐标
        //使UILabel对象的宽度不超出HHAHypnosisViewController的view的宽度
        int width = (int)(self.view.bounds.size.width - messageLebel.bounds.size.width);
        int x = arc4random() % width;
        
        //获取随机y坐标
        int height = (int)(self.view.bounds.size.height - messageLebel.bounds.size.height);
        int y = arc4random() % height;
        
        //设置UILabel对象的frame
        CGRect frame = messageLebel.frame;
        frame.origin = CGPointMake(x, y);
        messageLebel.frame = frame;
        
        //将UILabel对象添加到HHAHypnosisViewController的view中
        [self.view addSubview:messageLebel];
        
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLebel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLebel addMotionEffect:motionEffect];
    }
}

@end
