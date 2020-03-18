//
//  HHADetailViewController.h
//  Homepwner
//
//  Created by 李欢 on 2020/3/11.
//  Copyright © 2020 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HHAItem;

@interface HHADetailViewController : UIViewController

@property(nonatomic, strong) HHAItem *item;
@property(nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
