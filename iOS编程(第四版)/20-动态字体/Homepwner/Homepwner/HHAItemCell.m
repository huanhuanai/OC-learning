//
//  HHAItemCell.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/26.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAItemCell.h"

@interface HHAItemCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;

@end

@implementation HHAItemCell

- (IBAction)showImage:(id)sender {
    //调用Block对象之前要先检查Block对象是否存在
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)updateInterfaceForDynamicTypeSize {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;

    static NSDictionary *imageSizeDictionary;

    if (!imageSizeDictionary) {
        imageSizeDictionary = @{
                UIContentSizeCategoryExtraSmall: @40,
                UIContentSizeCategorySmall: @40,
                UIContentSizeCategoryMedium: @40,
                UIContentSizeCategoryLarge: @40,
                UIContentSizeCategoryExtraLarge: @45,
                UIContentSizeCategoryExtraExtraLarge: @55,
                UIContentSizeCategoryExtraExtraExtraLarge: @65
        };
    }

    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightConstraint.constant = imageSize.floatValue;
    self.imageViewWidthConstraint.constant = imageSize.floatValue;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateInterfaceForDynamicTypeSize];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(updateInterfaceForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:self.thumbnailView
                                               attribute:NSLayoutAttributeHeight
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:self.thumbnailView
                                               attribute:NSLayoutAttributeWidth
                                              multiplier:1
                                                constant:0];
    [self.thumbnailView addConstraint:constraint];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

@end
