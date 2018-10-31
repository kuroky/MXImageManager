//
//  MXBaseTableViewController.m
//  TableViewControllerDemo
//
//  Created by kuroky on 2018/1/18.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "MXBaseTableViewController.h"

@interface MXBaseTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic, readwrite) UITableView *tableView;

@property (nonatomic, copy) MXCellConfigBlock cellHandler;
@property (nonatomic, copy) MXCellConfigIndexPathBlock cellIndexPathHandler;

@end

@implementation MXBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mx_setupData];
    [self mx_setupUI];
}

- (void)mx_setupData {
    _mx_pageNumber = 1;
}

- (void)mx_setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.view sendSubviewToBack:self.tableView];
    
    self.sectionIsSingle = YES;
    self.hideFooterRefresh = YES; // 默认最开始隐藏上拉刷新
}

- (void)setHideHeaderRefresh:(BOOL)hideHeaderRefresh {
    _hideHeaderRefresh = hideHeaderRefresh;
}

- (void)setHideFooterRefresh:(BOOL)hideFooterRefresh {
    _hideFooterRefresh = hideFooterRefresh;
}

- (void)mx_headerRefresh {
    if (!self.hideFooterRefresh) {
    }
}

- (void)mx_footerRefresh {
    if (self.dataList.count % self.mx_pageSize != 0) {
    }
    else {
    }
}

- (void)mx_endFootRefresh {
}

- (void)mx_reloadData:(MXCellConfigBlock)block {
    self.cellHandler = [block copy];
}

- (void)mx_reloadIndexPath:(MXCellConfigIndexPathBlock)block {
    self.cellIndexPathHandler = [block copy];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionIsSingle ? 1 : self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.sectionIsSingle) {
        return self.dataList.count;
    }
    else {
        id items = self.dataList[section];
        return [items isKindOfClass:[NSArray class]] ? ((NSArray *)items).count : 1;
    }
}

// 为每个cell自定义高度或使用同一高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.MXCellHeightBlock ? self.MXCellHeightBlock(indexPath) : self.rowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

// 为每个sectionHeader自定义高度或使用同一高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.MXHeaderHeightBlock ? self.MXHeaderHeightBlock(section) : self.sectionHeaderHeight;
}

// 为每个sectionFooter自定义高度或使用同一高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.MXFooterHeightBlock ? self.MXFooterHeightBlock(section) : self.sectionFooterHeight;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionIsSingle) {
        return self.dataList[indexPath.row];
    }
    else {
        id items = self.dataList[indexPath.section];
        return [items isKindOfClass:[NSArray class]] ? ((NSArray *)items)[indexPath.row] : items;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    if (self.cellHandler) {
        self.cellHandler(cell, item);
    }
    else if (self.cellIndexPathHandler) {
        self.cellIndexPathHandler(cell, item, indexPath);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If cell margins are derived from the width of the readableContentGuide.
    // NS_AVAILABLE_IOS(9_0)，需进行判断
    // 设置为 NO，防止在横屏时留白
    tableView.cellLayoutMarginsFollowReadableWidth = NO;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
