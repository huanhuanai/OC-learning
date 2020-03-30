//
//  HHAItemCell.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/26.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAItemCell.h"

@implementation HHAItemCell

- (IBAction)showImage:(id)sender {
    
    //调用Block对象之前要先检查Block对象是否存在
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
