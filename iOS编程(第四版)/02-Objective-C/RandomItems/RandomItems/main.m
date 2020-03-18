//
//  main.m
//  RandomItems
//
//  Created by 李欢 on 2020/3/4.
//  Copyright © 2020 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHAItem.h"

int main(int argc, const char *argv[])
{
    @autoreleasepool {
        //创建一个NSMutableArray对象，并用items变量保存该对象的地址
        NSMutableArray *items = [[NSMutableArray alloc] init];

        //向items所指向的NSMutableArray对象发送addObject：消息
        //每次传入一个字符串
        //[items addObject:@"One"];
        //[items addObject:@"Two"];
        //[items addObject:@"Three"];

        //继续向同一个对象发送消息，这次是insertObject：atIndex：
        //[items insertObject:@"Zero" atIndex:0];
        
        //遍历items数组中的每一个item
        //for (NSString *item in items) {
            //打印对象信息
            //NSLog(@"%@", item);
        //}
        
        //HHAItem *item = [[HHAItem alloc] initWithItemName:@"Red Sofa" valueInDollars:100 serialNumber:@"A1B2C"];
        //NSLog(@"%@", item);
        //HHAItem *itemWithName = [[HHAItem alloc] initWithItemName:@"Blue Sofa"];
        //NSLog(@"%@", itemWithName);
        
        //HHAItem *itemWithNoName = [[HHAItem alloc] init];
        //NSLog(@"%@", itemWithNoName);
        //创建一个新的NSString对象“Red Sofa”，并传给HHAItem对象
        //[item setItemName:@"Red Sofa"];
        //item.itemName = @"Red Sofa";
        
        //创建一个新的NSSring对象“A1B2C”，并传给HHAItem对象
        //[item setSerialNumber:@"A1B2C"];
        //item.serialNumber = @"A1B2C";
        
        //将数值100传给HHAItem对象，赋给valueInDollars
        //[item setValueInDollars:100];
        //item.valueInDollars = 100;
        //NSLog(@"%@ %@ %@ %d", [item itemName], [item dateCreated], [item serialNumber], [item valueInDollars]);
        //NSLog(@"%@ %@ %@ %d", item.itemName, item.dateCreated, item.serialNumber, item.valueInDollars);
        
        //释放items所指向的NSMutableArray对象
        
        for (int i = 0; i < 10; i++) {
            HHAItem *item = [HHAItem randomItem];
            [items addObject:item];
        }
        
        for (HHAItem *item in items) {
            NSLog(@"%@", item);
        }
        
        items = nil;
    }
    return 0;
}
