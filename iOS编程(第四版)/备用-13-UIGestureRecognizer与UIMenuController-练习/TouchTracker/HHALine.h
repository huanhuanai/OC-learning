//
//  HHALine.h
//  TouchTracker
//
//  Created by 李欢 on 2020/3/17.
//  Copyright © 2020 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHALine : NSObject

@property (nonatomic, weak) NSMutableArray *containingArray;
@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;

@end

NS_ASSUME_NONNULL_END
