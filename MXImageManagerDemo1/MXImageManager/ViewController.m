//
//  ViewController.m
//  MXImageManager
//
//  Created by kuroky on 2018/1/15.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "ViewController.h"
#import "MXImageManager.h"
#import "ImageListViewController.h"
#import "ImageTestViewController.h"

static NSString *const kCellId  =   @"cellid";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Image";
    self.dataList = @[@"images", @"cache size", @"remove", @"clearCache", @"compress"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    self.tableView.rowHeight = 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
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
        NSLog(@"size: %.2fM", [MXImageManager shareImageManager].mx_getCacheSize);
    }
    else if ([index isEqualToString:@"remove"]) {
        [[MXImageManager shareImageManager] mx_removeDiskImageForKey:@"http://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage002.jpg"];
    }
    else if ([index isEqualToString:@"clearCache"]) {
        [[MXImageManager shareImageManager] mx_clearCacheCompletion:nil];
    }
    else if ([index isEqualToString:@"compress"]) {
        [self.navigationController pushViewController:[ImageTestViewController new] animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
