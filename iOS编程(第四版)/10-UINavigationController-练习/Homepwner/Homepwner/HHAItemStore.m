//
//  HHAItemStore.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/8.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAItemStore.h"
#import "HHAItem.h"

@interface HHAItemStore ()

@property(nonatomic) NSMutableArray *privateItems;

@end

@implementation HHAItemStore

+ (instancetype)sharedStore {
    static HHAItemStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [HHAItemStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems {
    return self.privateItems;
}

- (HHAItem *)createItem {
    HHAItem *item = [HHAItem randomItem];
    [self.privateItems addObject:item];
    return item;
}

- (void)removeItem:(HHAItem *)item {
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    //得到要移动对象的指针，以便稍后能将其插入新的位置
    HHAItem *item = self.privateItems[fromIndex];
    
    //将item从allItems数组中移除
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    //根据新的索引位置，将item插回allItems数组
    [self.privateItems insertObject:item atIndex:toIndex];
}

@end
