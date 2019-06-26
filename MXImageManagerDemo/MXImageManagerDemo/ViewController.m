//
//  ViewController.m
//  MXImageManagerDemo
//
//  Created by kuroky on 2019/5/10.
//  Copyright © 2019 Emucoo. All rights reserved.
//

#import "ViewController.h"
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
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", paths.firstObject);
    
    self.dataList = @[@"images", @"cache cost", @"clearCache", @"read from cache", @"1234"];
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
    __weak typeof(self) weakself = self;
    NSString *index = self.dataList[indexPath.row];
    if ([index isEqualToString:@"images"]) {
        [self.navigationController pushViewController:[ImageListViewController new] animated:YES];
    }
    else if ([index isEqualToString:@"cache cost"]) {
        
        [MXImageCache mx_getCacheSize:^(CGFloat totalCost) {
            NSString *title = [NSString stringWithFormat:@"size: %.1fM", totalCost];
            [weakself showAlert:title];
        }];
    }
    else if ([index isEqualToString:@"clearCache"]) {
        [MXImageCache mx_clearCacheCompletion:^() {
            [MXImageCache mx_getCacheSize:^(CGFloat totalCost) {
                NSString *title = [NSString stringWithFormat:@"after clear size: %.1fM", totalCost];
                [weakself showAlert:title];
            }];
        }];
    }
    else if ([index isEqualToString:@"read from cache"]) {
        [self.navigationController pushViewController:[ImageTestViewController new] animated:YES];
    }
    else {
        NSInteger count = 2;
        for (NSInteger i = 0; i < count; i++) {
            NSString *file = [[NSBundle mainBundle] pathForResource:@"12345" ofType:@"jpg"];
            UIImage *image = [UIImage imageWithContentsOfFile:file];
            NSString *key = [NSString stringWithFormat:@"key-%@", @(i).stringValue];
            [MXImageCache mx_saveImageToDisk:image withImageKey:key completion:nil];
        }
    }
}
    
- (void)showAlert:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"message"
                                                                   message:title
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
