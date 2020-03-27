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
#import "HHAItemCell.h"
#import "HHAImageStore.h"
#import "HHAImageViewController.h"

@interface HHAItemsViewController ()<UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *imagePopover;

@end

@implementation HHAItemsViewController

#pragma mark - 初始化方法
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

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    HHADetailViewController *detailViewController = [[HHADetailViewController alloc] init];
    HHADetailViewController *detailViewController = [[HHADetailViewController alloc] initForNewItem:NO];
    NSArray *items = [[HHAItemStore sharedStore] allItems];
    HHAItem *selectedItem = items[indexPath.row];

    //将选中的HHAItem对象赋给DetailViewController对象
    detailViewController.item = selectedItem;
    //将新创建的HHADetailViewController对象压入UINavigationController对象的栈
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[HHAItemStore sharedStore] allItems].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取HHAItemCell对象，返回的可能是现有的对象，也可能是新创建的对象
    HHAItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHAItemCell" forIndexPath:indexPath];

    NSArray *items = [[HHAItemStore sharedStore] allItems];
    HHAItem *item = items[indexPath.row];

    //根据HHAItem对象设置HHAItemCell对象
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    cell.thumbnailView.image = item.thumbnail;

    __weak typeof(cell) weakCell = cell;
    cell.actionBlock = ^{
        __strong typeof(weakCell) strongCell = weakCell;
        NSLog(@"Going to show image for  %@", item);

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            NSString *imageKey = item.itemKey;

            //如果HHAItem对象没有图片，就直接返回
            UIImage *img = [[HHAImageStore sharedStore] imageForKey:imageKey];
            if (!img) {
                return;
            }

            //根据UITableView对象的坐标系获取UIImageView对象的位置和大小
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];

            //创建HHAImageViewController对象并为image属性赋值
            HHAImageViewController *ivc = [[HHAImageViewController alloc] init];
            ivc.image = img;

            //根据UIImageView对象的位置和大小
            //显示一个大小为600*600点的UIPopoverController对象
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    };

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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}

#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.imagePopover = nil;
}

#pragma mark - view life cycle
- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];

    //创建UINib对象，该对象代表包含了HHAItemCell的NIB文件
    UINib *nib = [UINib nibWithNibName:@"HHAItemCell" bundle:nil];

    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HHAItemCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - private method
- (IBAction)addNewItem:(id)sender {
    //创建新的HHAItem对象并将其加入HHAItemStore
    HHAItem *newItem = [[HHAItemStore sharedStore] createItem];

    HHADetailViewController *detailViewController = [[HHADetailViewController alloc] initForNewItem:YES];

    detailViewController.item = newItem;

    detailViewController.dismissBlock = ^{
//        NSInteger lastRow = [[[HHAItemStore sharedStore] allItems] indexOfObject:newItem];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//
//        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView reloadData];
    };

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];

    navController.modalPresentationStyle = UIModalPresentationFormSheet;

    [self presentViewController:navController animated:YES completion:nil];
}

@end
