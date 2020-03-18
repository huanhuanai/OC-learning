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

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) NSArray *allArr;

@end

@implementation HHAItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.allArr = [[HHAItemStore sharedStore] allItems];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (indexPath.row < self.allArr.count) {
        HHAItem *item = self.allArr[indexPath.row];
        cell.textLabel.text = [item description];
        return cell;
    } else {
        cell.textLabel.text = @"No more items!";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果UITableView对象请求确认的是删除操作......
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[HHAItemStore sharedStore] allItems];
        HHAItem *item = items[indexPath.row];
        [[HHAItemStore sharedStore] removeItem:item];

        //还要删除表格视图中的相应表格行（带动画效果）
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[HHAItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

//9.5初级练习
- (nullable NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

//9.6中级练习
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //从0开始计数
    if (indexPath.row == self.allArr.count) {
        return NO;
    } else {
        return YES;
    }
}

//9.7高级练习
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)source toProposedIndexPath:(NSIndexPath *)destination {
    if (destination.row < self.allArr.count - 1) {
        return destination;
    }
    NSIndexPath *indexPath = nil;
    if (destination.row == 0) {
        indexPath = [NSIndexPath indexPathForRow:1
                                       inSection:0];
    } else {
        //不能放在最下面，只能放在倒数第二行，也就是不能移动那一行的上面一行
        indexPath = [NSIndexPath indexPathForRow:self.allArr.count - 1
                                       inSection:0];
    }
    return indexPath;
    return 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
}

- (UIView *)headerView {
    //如果还没有载入headerView...
    if (!_headerView) {
        //载入HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    return _headerView;
}

- (IBAction)addNewItem:(id)sender {
    //创建新的HHAItem对象并将其加入HHAItemStore
    HHAItem *newItem = [[HHAItemStore sharedStore] createItem];

    //获取新创建的对象在allItems数组中的索引
    NSInteger lastRow = [[[HHAItemStore sharedStore] allItems] indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];

    //将新行插入UITableView对象
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

- (IBAction)toggleEditingMode:(id)sender {
    //如果当前的视图控制器对象已经处于编辑模式...
    if (self.isEditing) {
        //修改按钮文字，提示用户当前的表格状态
        [sender setTitle:@"Edit" forState:UIControlStateNormal];

        //关闭编辑模式
        [self setEditing:NO animated:YES];
    } else {
        //修改按钮文字，提示用户当前的表格状态
        [sender setTitle:@"Done" forState:UIControlStateNormal];

        //开启编辑模式
        [self setEditing:YES animated:YES];
    }
}

@end
