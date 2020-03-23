//
//  HHADrawLine.m
//  TouchTracker
//
//  Created by 李欢 on 2020/3/17.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHADrawLine.h"
#import "HHALine.h"

@interface HHADrawLine () <UIGestureRecognizerDelegate, UIResponderStandardEditActions>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipe;
@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@property (nonatomic, weak) HHALine *selectedLine;

@end

@implementation HHADrawLine

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
//        self.isUserInteractionEnabled = true;
        //添加双击手势
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];

        //添加单击手势
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];

        //添加长按手势
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];

        //拖动手势
        self.moveRecognizer =  [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
        
        //三指轻扫手势
        self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        self.swipe.numberOfTouchesRequired = 2;
        self.swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:self.swipe];
        
    }
    return self;
}

- (int)numberOfLines {
    int count = 0;
    if (self.linesInProgress && self.finishedLines) {
        count = [self.linesInProgress count] + [self.finishedLines count];
    }
    return count;
}

#pragma mark - 几种动作方法
//双击动作
- (void)doubleTap:(UIGestureRecognizer *)gr {
    NSLog(@"Recognized Double Tap");
    [self.linesInProgress removeAllObjects];
//    [self.finishedLines removeAllObjects];
    self.finishedLines = [[NSMutableArray alloc] init];
    [self setNeedsDisplay];
}

//单击动作
- (void)tap:(UIGestureRecognizer *)gr {
    NSLog(@"Recognized tap");

    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];

    if (self.selectedLine) {
        //使视图成为UIMenuItem动作消息的目标
        [self becomeFirstResponder];

        //获取UIMenuController对象
        UIMenuController *menu = [UIMenuController sharedMenuController];

        //创建一个新的标题为“delete”的UIMenuItem对象
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];

        //先为UIMenuController对象设置显示区域，然后将其设置为可见
        [menu showMenuFromView:self rect:CGRectMake(point.x, point.y, 2, 2)];
    } else {
        //如果没有选中的线条，就隐藏UIMenuController对象
        [[UIMenuController sharedMenuController] hideMenuFromView:self];
    }
    [self setNeedsDisplay];
}

//长按动作
- (void)longPress:(UIGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];

        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    } else if (gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}

//拖动动作
- (void)moveLine:(UIPanGestureRecognizer *)gr {
    //如果没有选中的线条就返回
    if (!self.selectedLine) {
        return;
    }

    //如果UIPanGestureRecognizer对象处于“变化后”状态
    if (gr.state == UIGestureRecognizerStateChanged) {
        //获取手指的托移距离
        CGPoint translation = [gr translationInView:self];

        //将拖移距离加至选中的线条的起点和终点
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;

        //为选中的线条设置新的起点和终点
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;

        CGPoint speed = [gr velocityInView:self];
        NSLog(@"滑动速度:%@", NSStringFromCGPoint(speed));
        
        //重画视图
        [self setNeedsDisplay];
        [gr setTranslation:CGPointZero inView:self];
    }
}

#pragma mark - 13.11高级练习：颜色
//轻扫动作
- (void)swipe:(UIPanGestureRecognizer *)gr {
    if (self.swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        CGPoint point = [gr locationInView:self];
        
        [self becomeFirstResponder];

        //获取UIMenuController对象
        UIMenuController *menu = [UIMenuController sharedMenuController];

        //创建一个新的标题为“delete”的UIMenuItem对象
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];

        //先为UIMenuController对象设置显示区域，然后将其设置为可见
        [menu showMenuFromView:self rect:CGRectMake(point.x, point.y, 2, 2)];
    }
}

#pragma mark - 私有方法

- (void)deleteLine:(id)sender {
    //从已经完成的线条中删除选中的线条
    [self.finishedLines removeObject:self.selectedLine];

    //重绘整个视图
    [self setNeedsDisplay];
}

//根据传入的位置找出距离最近的那个HHALine对象
- (HHALine *)lineAtPoint:(CGPoint)p {
    //找出离p最近的HHALine对象
    for (HHALine *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;

        //检查线条的若干点
        for (float t = 0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);

            //如果线条的某个点和p的距离在20点以内，就返回相应的HHALine对象
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return l;
            }
        }
    }
    //如果没能找到符合条件的线条，就返回nil，代表不选择任何线条
    return nil;
}

#pragma mark - 重写第一响应者

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - 绘图方法
//绘制直线的方法
- (void)strokeLine:(HHALine *)line {
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;

    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

//drawRect：方法
- (void)drawRect:(CGRect)rect {
    //用黑色绘制已经完成的线条
    [[UIColor blackColor] set];
    for (HHALine *line in self.finishedLines) {
        [self strokeLine:line];
    }

    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
//    float f = 0.0;
//    for (int i = 0; i < 1000000; i++) {
//        f = f + sin(sin(sin(time(NULL) + i)));
//    }
//    NSLog(@"f = %f", f);
}

#pragma mark - UIResponder触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    //13.9中级练习：修正错误
    self.selectedLine = nil;
    [[UIMenuController sharedMenuController] hideMenuFromView:self];

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
        
        line.containingArray = self.finishedLines;
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

#pragma mark - UIGestureRecognizerDelegate-手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}

@end
