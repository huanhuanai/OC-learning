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

@interface HHADetailViewController : UIViewController<UIViewControllerRestoration>

@property(nonatomic, strong) HHAItem *item;
@property (nonatomic, strong) void (^dismissBlock)(void);

- (instancetype)initForNewItem:(BOOL)isNew;

@end

NS_ASSUME_NONNULL_END
