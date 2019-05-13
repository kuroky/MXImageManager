//
//  MXBaseTableViewController.m
//  TableViewControllerDemo
//
//  Created by kuroky on 2018/1/18.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "MXBaseTableViewController.h"
//#import "MXRefreshHeader.h"
//#import "MXRefreshFooter.h"

@interface MXBaseTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic, readwrite) UITableView *tableView;

@property (nonatomic, copy) MXCellConfigBlock cellHandler;
@property (nonatomic, copy) MXCellConfigIndexPathBlock cellIndexPathHandler;

@end

@implementation MXBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mx_setupUI];
}

- (void)mx_setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.sectionIsSingle = YES;
    self.hideFooterRefresh = YES; // 默认最开始隐藏上拉刷新
    //self.tableView.mj_header = [MXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(mx_headerRefresh)];
    //self.tableView.mj_footer = [MXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(mx_footerRefresh)];
    self.mx_count = 20;
}

- (void)setHideHeaderRefresh:(BOOL)hideHeaderRefresh {
    _hideHeaderRefresh = hideHeaderRefresh;
    //self.tableView.mj_header.hidden = hideHeaderRefresh;
}

- (void)setHideFooterRefresh:(BOOL)hideFooterRefresh {
    _hideFooterRefresh = hideFooterRefresh;
    //self.tableView.mj_footer.hidden = hideFooterRefresh;
}
/*
- (void)mx_headerRefresh {
    [self.tableView.mj_header endRefreshing];
    if (!self.hideFooterRefresh) {
        self.tableView.mj_footer.hidden = NO;
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)mx_footerRefresh {
    [self.tableView.mj_footer endRefreshing];
    if (self.mx_start % self.mx_count != 0) {
        self.tableView.mj_footer.hidden = YES;
    }
    else {
        self.tableView.mj_footer.hidden = NO;
    }
    [self.tableView.mj_footer endRefreshing];
}
*/

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
    if ([tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
