//
//  HHAImageStore.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/13.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAImageStore.h"

@interface HHAImageStore ()

@property(nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation HHAImageStore

+ (instancetype)sharedStore {
    static HHAImageStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

//不允许直接调用init方法
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [HHAImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

//私有化初始化方法
- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    self.dictionary[key] = image;
}

- (UIImage *)imageForKey:(NSString *)key {
    return self.dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
}

@end
