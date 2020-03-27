//
//  HHAImageStore.h
//  Homepwner
//
//  Created by 李欢 on 2020/3/13.
//  Copyright © 2020 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHAImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
