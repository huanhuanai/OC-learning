//
//  HHAItemStore.h
//  Homepwner
//
//  Created by 李欢 on 2020/3/8.
//  Copyright © 2020 huan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HHAItem;

@interface HHAItemStore : NSObject

@property(nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (HHAItem *)createItem;
- (void)removeItem:(HHAItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex;

@end

NS_ASSUME_NONNULL_END
