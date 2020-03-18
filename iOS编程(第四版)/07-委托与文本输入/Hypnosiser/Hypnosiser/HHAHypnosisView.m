//
//  HHAHypnosisView.m
//  Hypnosiser
//
//  Created by 李欢 on 2020/3/5.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAHypnosisView.h"

@interface HHAHypnosisView ()

@property (nonatomic, strong) UIColor *circleColor;

@end

@implementation HHAHypnosisView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@ was touched", self);

    //获取三个0到1之间的数字
    float red = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue = (arc4random() % 100) / 100.0;

    UIColor *randomColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    self.circleColor = randomColor;
}

- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }

    path.lineWidth = 10;
    [self.circleColor setStroke];
    [path stroke];
}

- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

@end
