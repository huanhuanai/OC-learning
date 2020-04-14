//
//  HHAImageTransformer.m
//  Homepwner
//
//  Created by 李欢 on 2020/4/6.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAImageTransformer.h"
#import <UIKit/UIKit.h>

@implementation HHAImageTransformer

+ (Class)transformedValueClass {
    return [NSData class];
}

- (id)transformedValue:(id)value {
    if (!value) {
        return nil;
    }
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value {
    return [UIImage imageWithData:value];
}

@end
