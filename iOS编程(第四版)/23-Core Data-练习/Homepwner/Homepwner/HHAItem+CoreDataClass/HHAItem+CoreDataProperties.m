//
//  HHAItem+CoreDataProperties.m
//  Homepwner
//
//  Created by 李欢 on 2020/4/6.
//  Copyright © 2020 huan. All rights reserved.
//
//

#import "HHAItem+CoreDataProperties.h"

@implementation HHAItem (CoreDataProperties)

+ (NSFetchRequest<HHAItem *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"HHAItem"];
}

@dynamic dateCreated;
@dynamic itemKey;
@dynamic itemName;
@dynamic orderingValue;
@dynamic serialNumber;
@dynamic thumbnail;
@dynamic valueInDollars;
@dynamic assetType;

@end
