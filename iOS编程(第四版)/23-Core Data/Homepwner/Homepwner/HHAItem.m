//
//  HHAItem+CoreDataClass.m
//  Homepwner
//
//  Created by 李欢 on 2020/4/6.
//  Copyright © 2020 huan. All rights reserved.
//
//

#import "HHAItem.h"

@implementation HHAItem

- (void)setThumbnailFromImage:(UIImage *)image {
    CGSize origImageSize = image.size;
    
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    [path addClip];
    
    CGRect projectRect;
    
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;

    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    self.thumbnail = smallImage;
    
    UIGraphicsEndImageContext();
    
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    
    self.dateCreated = [NSDate date];
    
    //创建NSUUID对象，获取其UUID字符串
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.itemKey = key;
}

@end
