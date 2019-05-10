//
//  ViewController.m
//  MXImageManagerDemo
//
//  Created by kuroky on 2019/5/10.
//  Copyright © 2019 Emucoo. All rights reserved.
//

#import "ViewController.h"
#import "Demo1TableViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tbl = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];\
    tbl.rowHeight = 50;
    tbl.dataSource = self;
    tbl.delegate = self;
    [tbl registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tbl];
    self.tableView = tbl;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Demo1TableViewController *demoVC = [Demo1TableViewController new];
    [self.navigationController pushViewController:demoVC animated:YES];
}

@end
