//
//  HHAItem+CoreDataProperties.h
//  Homepwner
//
//  Created by 李欢 on 2020/4/6.
//  Copyright © 2020 huan. All rights reserved.
//
//

#import "HHAItem.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHAItem (CoreDataProperties)

+ (NSFetchRequest<HHAItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateCreated;
@property (nullable, nonatomic, copy) NSString *itemKey;
@property (nullable, nonatomic, copy) NSString *itemName;
@property (nonatomic) double orderingValue;
@property (nullable, nonatomic, copy) NSString *serialNumber;
@property (nullable, nonatomic, strong) UIImage *thumbnail;
@property (nonatomic) int valueInDollars;
@property (nullable, nonatomic, retain) NSManagedObject *assetType;



@end

NS_ASSUME_NONNULL_END
