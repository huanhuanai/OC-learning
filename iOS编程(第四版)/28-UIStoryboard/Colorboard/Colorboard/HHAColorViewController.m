//
//  HHAColorViewController.m
//  Colorboard
//
//  Created by 李欢 on 2020/4/15.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAColorViewController.h"

@interface HHAColorViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

@end

@implementation HHAColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color = self.colorDescription.color;
    
    //从UIColor对象中取出RGB颜色分量
    CGFloat red, green, blue;
    [color getRed:&red
            green:&green
             blue:&blue
            alpha:nil];
    
    //初始化UISlider对象的滑块值
    self.redSlider.value = red;
    self.greenSlider.value = green;
    self.blueSlider.value = blue;
    
    //初始化view的背景颜色和颜色名称
    self.view.backgroundColor = color;
    self.textField.text = self.colorDescription.name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //如果颜色已经存在，就移除Done按钮
    if (self.existingColor) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.colorDescription.name = self.textField.text;
    self.colorDescription.color = self.view.backgroundColor;
}

- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.reloadDataBlock];
}

- (IBAction)changeColor:(id)sender {
    float red = self.redSlider.value;
    float green = self.greenSlider.value;
    float blue = self.blueSlider.value;
    UIColor *newColor = [UIColor colorWithRed:red
                                        green:green
                                         blue:blue
                                        alpha:1.0];
    self.view.backgroundColor = newColor;
}
@end
