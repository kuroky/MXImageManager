//
//  ImageTestViewController.m
//  Emucoo
//
//  Created by kuroky on 2017/6/21.
//  Copyright © 2017年 Emucoo. All rights reserved.
//

#import "ImageTestViewController.h"
#import "UIImage+EMCompress.h"
#import "ImageTestFooter.h"
#import "UIImage+EMAdd.h"
#import <MXImageManager/MXImageCache.h>


static NSString *const kImageCellId =   @"imageTblCellId";

@interface ImageTestViewController ()

@property (nonatomic, strong) ImageTestFooter *footerView;

@end

@implementation ImageTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    self.dataList = [NSMutableArray array];
    [self.dataList addObjectsFromArray:@[@"图片压缩", @"图片圆角", @"颜色->图片", @"图片截取"]];
}

- (void)setupUI {
    self.navigationItem.title = @"图片测试";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    
    __weak __typeof(self)wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself.tableView reloadData];
        [wself mx_reloadData:^(UITableViewCell *cell, NSString *item) {
            cell.textLabel.text = item;
        }];
    });
}

- (void)setupTableView {
    self.rowHeight = 49.0;
    self.cellIdentifier = kImageCellId;
    self.hideHeaderRefresh = YES;
    self.hideFooterRefresh = YES;
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kImageCellId];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"ImageTestFooter" owner:self options:nil] lastObject];
    self.footerView.frame = CGRectMake(0, 0, screenWidth, 400);
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.dataList[indexPath.row];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"2014120107280906" ofType:@"jpg"];
    if ([title isEqualToString:@"图片压缩"]) {
        __block UIImage *img = nil;
        UIImage *originalImg = [UIImage imageWithContentsOfFile:path];
        [originalImg em_compressQuality:EMImageQualityNomal
                             completion:^(UIImage *pressImg) {
                                 img = pressImg;
                                 [self.footerView em_reloadImage:img];
                             }];
    }
    else if ([title isEqualToString:@"图片圆角"]) {
        __block UIImage *img = nil;
        UIImage *originalImg = [UIImage imageWithContentsOfFile:path];
        [originalImg em_compressQuality:EMImageQualityNomal
                             completion:^(UIImage *pressImg) {
                                 img = [pressImg em_imageByRoundRadius:100.0];
                                 [self.footerView em_reloadImage:img];
                             }];
    }
    else if ([title isEqualToString:@"颜色->图片"]) {
        UIImage *img = nil;
        UIColor *color = [UIColor redColor];
        img = [UIImage em_imageWithColor:color];
        [self.footerView em_reloadImage:img];
    }
    else if ([title isEqualToString:@"图片截取"]) {
        __block UIImage *img = nil;
        UIImage *originalImg = [UIImage imageWithContentsOfFile:path];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        img = [originalImg em_imageByResizeToSize:CGSizeMake(screenWidth, 400)
                                      contentMode:UIViewContentModeScaleAspectFit];
        [self.footerView em_reloadImage:img];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
