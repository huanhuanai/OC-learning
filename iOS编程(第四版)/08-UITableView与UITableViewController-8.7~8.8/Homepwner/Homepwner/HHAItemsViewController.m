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



@implementation HHAItemsViewController

- (instancetype)init {
 return [self initWithStyle:UITableViewStyleInsetGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [backImageView setImage:[UIImage imageNamed:@"IMG_1374.png"]];
        self.tableView.backgroundView = backImageView;
        for (int i = 0; i < 5; i++) {
            [[HHAItemStore sharedStore] createItem];
        }
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [[[HHAItemStore sharedStore] allItems] count]) {
        return 60;
    } else {
        return 44;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[HHAItemStore sharedStore] allItems] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger arrNum = [[[HHAItemStore sharedStore] allItems] count];
    if (indexPath.row < arrNum) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        NSArray *items = [[HHAItemStore sharedStore] allItems];
        HHAItem *item = items[indexPath.row];
        cell.textLabel.text = [item description];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.textLabel.text = @"No more items";
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

@end
