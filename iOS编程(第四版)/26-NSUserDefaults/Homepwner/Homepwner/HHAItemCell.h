//
//  HHAItemCell.h
//  Homepwner
//
//  Created by 李欢 on 2020/3/26.
//  Copyright © 2020 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHAItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UIButton *thumbnailButton;

@property (nonatomic, copy) void (^actionBlock)(void);


@end

NS_ASSUME_NONNULL_END
