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

@property(nonatomic, strong) HHALine *currentLine;
@property(nonatomic, strong) NSMutableArray *finishedLines;

@end

@implementation HHADrawLine

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)strokeLine:(HHALine *)line {
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect {
    //用黑色绘制已经完成的线条
    [[UIColor blackColor] set];
    for (HHALine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    if (self.currentLine) {
        //用红色绘制正在画的线条
        [[UIColor redColor] set];
        [self strokeLine:self.currentLine];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    
    //根据触摸位置创建HHALine对象
    CGPoint location = [t locationInView:self];
    
    self.currentLine = [[HHALine alloc] init];
    self.currentLine.begin = location;
    self.currentLine.end = location;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    CGPoint location = [t locationInView:self];
    
    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.finishedLines addObject:self.currentLine];
    
    self.currentLine = nil;
    
    [self setNeedsDisplay];
}
@end
