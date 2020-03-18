//
//  HHAItemsViewController.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/8.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAItemsViewController.h"
#import "HHAItemStore.h"
#import "HHAItem.h"

@interface HHAItemsViewController ()

@property (nonatomic, strong) NSMutableArray *largeArray;
@property (nonatomic, strong) NSMutableArray *smallArray;

@end

@implementation HHAItemsViewController

- (instancetype)init {
 return [self initWithStyle:UITableViewStyleInsetGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[HHAItemStore sharedStore] createItem];
        }
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.largeArray = [NSMutableArray array];
    self.smallArray = [NSMutableArray array];
    NSArray *allItems = [[HHAItemStore sharedStore] allItems];
    for (HHAItem *item in allItems) {
        if (item.valueInDollars > 50) {
            [self.largeArray addObject:item];
        } else {
            [self.smallArray addObject:item];
        }
    }

    if (section == 0) {
        return self.largeArray.count;
    } else {
        return self.smallArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        HHAItem *item = self.largeArray[indexPath.row];
        cell.textLabel.text = [item description];
        return cell;
    }
    if (indexPath.section == 1) {
        HHAItem *item = self.smallArray[indexPath.row];
        cell.textLabel.text = [item description];
        return cell;
    }

    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"More than 50";
    } else if (section == 1) {
        return @"Less and equal to 50";
    } else {
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

@end
