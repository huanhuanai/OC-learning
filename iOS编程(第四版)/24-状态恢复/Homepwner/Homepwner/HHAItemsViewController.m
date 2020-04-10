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
#import "HHAItem+CoreDataClass.h"
#import "HHAItemCell.h"
#import "HHAImageStore.h"
#import "HHAImageViewController.h"

@interface HHAItemsViewController ()<UIPopoverPresentationControllerDelegate, UIDataSourceModelAssociation>

@property (nonatomic, strong) UIPopoverPresentationController *imagePopover;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

@implementation HHAItemsViewController

#pragma mark - 初始化方法
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";

        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        //创建新的UIBarButtonItem对象
        //将其目标对象设置为当前对象，将其动作方法设置为addNewItem：
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];

        //为UINavigationItem对象的rightBarButtonItem属性赋值，
        //指向新创建的UIBarButtonItem对象
        navItem.rightBarButtonItem = bbi;
        navItem.leftBarButtonItem = self.editButtonItem;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self init];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self init];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
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
            HHAImageViewController *ivc = [[HHAImageViewController alloc] init];
            ivc.image = img;

            ivc.preferredContentSize = CGSizeMake(600, 600);        //popover视图的大小
            ivc.modalPresentationStyle = UIModalPresentationPopover;//这句一定要
            
            self.imagePopover = ivc.popoverPresentationController;
            self.imagePopover.delegate = self;     //代理一定要
            self.imagePopover.sourceView = strongCell.thumbnailView;
            [self.imagePopover setPermittedArrowDirections:UIPopoverArrowDirectionLeft];
            [self presentViewController:ivc animated:YES completion:nil];
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

#pragma mark - view life cycle
- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];

    //创建UINib对象，该对象代表包含了HHAItemCell的NIB文件
    UINib *nib = [UINib nibWithNibName:@"HHAItemCell" bundle:nil];

    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HHAItemCell"];
    self.tableView.restorationIdentifier = @"HHAItemsViewControllerTableView";
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    [self updateTableViewForDynamicTypeSize];
}

#pragma mark - private method
- (IBAction)addNewItem:(id)sender {
    //创建新的HHAItem对象并将其加入HHAItemStore
    HHAItem *newItem = [[HHAItemStore sharedStore] createItem];

    HHADetailViewController *detailViewController = [[HHADetailViewController alloc] initForNewItem:YES];

    detailViewController.item = newItem;

    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];

    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;

    [self presentViewController:navController animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)updateTableViewForDynamicTypeSize {
    static NSDictionary *cellHeightDictionary;

    if (!cellHeightDictionary) {
        cellHeightDictionary = @{
                UIContentSizeCategoryExtraSmall: @44,
                UIContentSizeCategorySmall: @44,
                UIContentSizeCategoryMedium: @44,
                UIContentSizeCategoryLarge: @44,
                UIContentSizeCategoryExtraLarge: @55,
                UIContentSizeCategoryExtraExtraLarge: @65,
                UIContentSizeCategoryExtraExtraExtraLarge: @75
        };
    }
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];

    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents coder:(NSCoder *)coder {
    return [[self alloc] init];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    self.editing = [coder decodeObjectForKey:@"TableViewIsEditing"];
    
    [super decodeRestorableStateWithCoder:coder];
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view {
    NSString *identifier = nil;
    
    if (idx && view) {
        //为NSIndexPath参数所对应的HHAItem对象设置唯一标识符
        HHAItem *item = [[HHAItemStore sharedStore] allItems][idx.row];
        identifier = item.itemKey;
    }
    return identifier;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view {
    NSIndexPath *indexPath = nil;
    
    if (identifier && view) {
        NSArray *items = [[HHAItemStore sharedStore] allItems];
        for (HHAItem *item in items) {
            if ([identifier isEqualToString:item.itemKey]) {
                NSUInteger row = [items indexOfObjectIdenticalTo:item];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    return indexPath;
}

@end
