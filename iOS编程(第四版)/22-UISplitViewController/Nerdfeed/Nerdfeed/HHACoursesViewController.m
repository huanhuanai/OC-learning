//
//  ViewController.m
//  Nerdfeed
//
//  Created by 李欢 on 2020/4/1.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHACoursesViewController.h"
#import "HHAWebViewController.h"

@interface HHACoursesViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HHACoursesViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"HHA Courses";
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = @"huanhuanai";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.webViewController.title = @"title";
    NSURL *URL = [NSURL URLWithString:@"https://topbook.cc/overview"];
    self.webViewController.URL = URL;
    if (!self.splitViewController) {
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}



@end
