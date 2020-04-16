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

@property (nonatomic, weak) UITextField *textField;

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

    CGRect textFieldRect = CGRectMake(30, -20, 354, 45);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];

    //设置UITextField对象的边框样式，便于查看在屏幕上的位置
    textField.borderStyle = UITextBorderStyleRoundedRect;

    textField.placeholder = @"Hypnotize me";
    textField.returnKeyType = UIReturnKeyDone;

    textField.delegate = self;

    [backgroundView addSubview:textField];

    self.textField = textField;
    self.view = backgroundView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:2.0
                          delay:0.0
         usingSpringWithDamping:0.25
          initialSpringVelocity:0.0
                        options:0
                     animations:^{
        CGRect frame = CGRectMake(30, 70, 354, 45);
        self.textField.frame = frame;
    }
                     completion:nil];
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

        //设置messageLabel透明度的起始值
        messageLebel.alpha = 0.0;

        //让messageLabel的透明度由0.0变为1.0
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            messageLebel.alpha = 1.0;
        }
                         completion:nil];
        
        [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:0 animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.8 animations:^{
                messageLebel.center = self.view.center;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
                NSInteger x = arc4random() % width;
                NSInteger y = arc4random() % height;
                messageLebel.center = CGPointMake(x, y);
            }];
        } completion:^(BOOL finished) {
            NSLog(@"Animation finished");
        }];
        
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
