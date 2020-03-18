//
//  HHADatePickerViewController.h
//  Homepwner
//
//  Created by 李欢 on 2020/3/12.
//  Copyright © 2020 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HHAItem;
@interface HHADatePickerViewController : UIViewController

@property(nonatomic, strong) HHAItem *item;
@property(nonatomic, assign) NSInteger itemNumber;

@end

NS_ASSUME_NONNULL_END
