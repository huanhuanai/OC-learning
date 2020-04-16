//
//  HHAPaletteViewController.m
//  Colorboard
//
//  Created by 李欢 on 2020/4/15.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAPaletteViewController.h"
#import "HHAColorViewController.h"
#import "HHAColorDescription.h"

@interface HHAPaletteViewController ()

@property (nonatomic) NSMutableArray *colors;

@end

@implementation HHAPaletteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (NSMutableArray *)colors {
    if (!_colors) {
        _colors = [NSMutableArray array];
        HHAColorDescription *cd = [[HHAColorDescription alloc] init];
        [_colors addObject:cd];
    }
    return _colors;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.colors count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                    forIndexPath:indexPath];

    HHAColorDescription *color = self.colors[indexPath.row];
    cell.textLabel.text = color.name;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewColor"]) {
        
        //如果是添加新颜色
        //就创建一个HHAColorDescription对象并将其添加到colors数组中
        HHAColorDescription *color = [[HHAColorDescription alloc] init];
        [self.colors addObject:color];
        
        //通过UIStoryboardSegue对象
        //设置HHAColorViewController对象的颜色（colorDescription属性）
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        HHAColorViewController *mvc = (HHAColorViewController *)[nc topViewController];
        mvc.reloadDataBlock = ^{
            [self.tableView reloadData];
        };
        mvc.colorDescription = color;
    } else if ([segue.identifier isEqualToString:@"ExistingColor"]) {
        
        //对于push样式的UIStoryboardSegue对象，sender是UITableViewCell对象
        NSIndexPath *ip = [self.tableView indexPathForCell:sender];
        HHAColorDescription *color = self.colors[ip.row];
        
        //设置HHAColorViewController对象的颜色，
        //同时设置其existingColor属性为YES（该颜色已经存在）
        HHAColorViewController *cvc = (HHAColorViewController *)segue.destinationViewController;
        cvc.colorDescription = color;
        cvc.existingColor = YES;
        
    }
}

@end
