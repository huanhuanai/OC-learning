//
//  HHADrawLine.m
//  TouchTracker
//
//  Created by 李欢 on 2020/3/17.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHADrawLine.h"
#import "HHALine.h"

@interface HHADrawLine ()

@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@end

@implementation HHADrawLine

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    return self;
}

- (void)strokeLine:(HHALine *)line {
    UIBezierPath *bp = [UIBezierPath bezierPath];
    
    //12.7高级练习
    //根据圆心和半径画圆
    CGPoint center;
    CGFloat x = line.end.x - line.begin.x;
    CGFloat y = line.end.y - line.begin.y;
    center.x = line.begin.x + x / 2;
    center.y = line.begin.y + y / 2;
    CGFloat radius = x / 2;
    [bp addArcWithCenter:center radius:radius startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
    bp.lineWidth = 6;
    bp.lineCapStyle = kCGLineCapRound;

    [bp moveToPoint:line.begin];
//    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect {
    //用黑色绘制已经完成的线条
    for (HHALine *line in self.finishedLines) {
        
        //12.6中级练习：颜色
        CGFloat x = line.end.x - line.begin.x;
        CGFloat y = line.end.y - line.begin.y;
        
        CGFloat bowstring = y * y + x * x;
        CGFloat sqrtBowstring = sqrt(bowstring);
        CGFloat hook = y / sqrtBowstring;
        CGFloat thigh = x / sqrtBowstring;
        UIColor *color = [UIColor colorWithRed:hook green:thigh blue:thigh alpha:1.0];

        [color set];
        [self strokeLine:line];
    }

    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
        
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));

    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];

        HHALine *line = [[HHALine alloc] init];
        line.begin = location;
        line.end = location;
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        HHALine *line = self.linesInProgress[key];
        line.end = [t locationInView:self];
    }

    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        HHALine *line = self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
        
    }
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

@end
