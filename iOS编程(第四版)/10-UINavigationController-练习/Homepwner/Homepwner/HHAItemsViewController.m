//
//  HHAItemsViewController.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/8.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAItemsViewController.h"
#import "HHADetailViewController.h"
#import "HHAItemStore.h"
#import "HHAItem.h"

@interface HHAItemsViewController ()

@property(nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation HHAItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        //创建新的UIBarButtonItem对象
        //将其目标对象设置为当前对象，将其动作方法设置为addNewItem：
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        //为UINavigationItem对象的rightBarButtonItem属性赋值，
        //指向新创建的UIBarButtonItem对象
        navItem.rightBarButtonItem = bbi;
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHADetailViewController *detailViewController = [[HHADetailViewController alloc] init];
    NSArray *items = [[HHAItemStore sharedStore] allItems];
    HHAItem *selectedItem = items[indexPath.row];
    detailViewController.index = indexPath.row;
    //将选中的HHAItem对象赋给DetailViewController对象
    detailViewController.item = selectedItem;
    //将新创建的HHADetailViewController对象压入UINavigationController对象的栈
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[HHAItemStore sharedStore] allItems].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *items = [[HHAItemStore sharedStore] allItems];
    HHAItem *item = items[indexPath.row];
    
    cell.textLabel.text = [item description];
    
    return cell;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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



@end
