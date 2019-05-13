//
//  ViewController.m
//  MXImageManagerDemo
//
//  Created by kuroky on 2019/5/10.
//  Copyright © 2019 Emucoo. All rights reserved.
//

#import "ViewController.h"
#import "Demo1TableViewController.h"
#import <MXImageManager/UIImageView+MXAdd.h>
#import <MXImageManager/MXImageCache.h>
#import "ImageListViewController.h"
#import "ImageTestViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = @[@"images", @"cache size", @"remove", @"clearCache", @"compress"];
    UITableView *tbl = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];\
    tbl.rowHeight = 50;
    tbl.dataSource = self;
    tbl.delegate = self;
    [tbl registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tbl];
    self.tableView = tbl;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *index = self.dataList[indexPath.row];
    if ([index isEqualToString:@"images"]) {
        [self.navigationController pushViewController:[ImageListViewController new] animated:YES];
    }
    else if ([index isEqualToString:@"cache size"]) {
        [MXImageCache mx_getCacheSize:^(CGFloat totalCost) {
            NSLog(@"size: %.2fM", totalCost);
        }];
    }
    else if ([index isEqualToString:@"remove"]) {
        [MXImageCache mx_removeDiskImageForKey:@"https://wx4.sinaimg.cn/large/a7d296e6ly1g2zdmlrqmej20sg0sg0vh.jpg"];
    }
    else if ([index isEqualToString:@"clearCache"]) {
        [MXImageCache mx_clearCacheCompletion:nil];
    }
    else if ([index isEqualToString:@"compress"]) {
        [self.navigationController pushViewController:[ImageTestViewController new] animated:YES];
    }
    
    //Demo1TableViewController *demoVC = [Demo1TableViewController new];
    //[self.navigationController pushViewController:demoVC animated:YES];
}

@end
