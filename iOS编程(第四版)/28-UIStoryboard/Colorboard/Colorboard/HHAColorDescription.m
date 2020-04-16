//
//  HHAColorDescription.m
//  Colorboard
//
//  Created by 李欢 on 2020/4/15.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAColorDescription.h"

@implementation HHAColorDescription

- (instancetype)init
{
    self = [super init];
    if (self) {
        _color = [UIColor colorWithRed:0
                                 green:0
                                  blue:1
                                 alpha:1];
        _name = @"Blue";
    }
    return self;
}

@end
