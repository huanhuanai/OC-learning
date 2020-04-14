//
//  HHAItem+CoreDataClass.h
//  Homepwner
//
//  Created by 李欢 on 2020/4/6.
//  Copyright © 2020 huan. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class HHAAssetType, NSObject;

NS_ASSUME_NONNULL_BEGIN

@interface HHAItem : NSManagedObject

- (void)setThumbnailFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

#import "HHAItem+CoreDataProperties.h"
