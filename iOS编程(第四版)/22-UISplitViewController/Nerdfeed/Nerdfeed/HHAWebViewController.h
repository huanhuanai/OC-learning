//
//  HHAWebViewController.h
//  Nerdfeed
//
//  Created by 李欢 on 2020/4/3.
//  Copyright © 2020 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHAWebViewController : UIViewController<UISplitViewControllerDelegate>

@property (nonatomic) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
