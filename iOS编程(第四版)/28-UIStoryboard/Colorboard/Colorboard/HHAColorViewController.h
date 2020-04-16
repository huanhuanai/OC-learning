//
//  HHAColorViewController.h
//  Colorboard
//
//  Created by 李欢 on 2020/4/15.
//  Copyright © 2020 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHAColorDescription.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHAColorViewController : UIViewController

@property (nonatomic) BOOL existingColor;

@property (nonatomic) HHAColorDescription *colorDescription;

@end

NS_ASSUME_NONNULL_END
