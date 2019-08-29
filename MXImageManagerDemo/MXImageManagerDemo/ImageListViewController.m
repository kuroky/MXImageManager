//
//  ImageListViewController.m
//  MXImageManager
//
//  Created by kuroky on 2018/1/18.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "ImageListViewController.h"
#import <MXImageManager/UIImageView+MXAdd.h>
#import <MXImageManager/MXImageCache.h>

static NSString *const kCellId  =   @"cellid";
static NSInteger const kLeading =   10;
static NSInteger const kImageHeight =   350;

@interface ImageListViewController ()

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation ImageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Images";
    self.dataList = [NSMutableArray array];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dataList addObject:@"https://wx4.sinaimg.cn/large/a7d296e6ly1g2zdmlrqmej20sg0sg0vh.jpg"];
        [self.dataList addObject:@"https://wx1.sinaimg.cn/large/a7d296e6ly1g2zdmm9ld5j20sg0sgwig.jpg"];
        [self.dataList addObject:@"https://wx4.sinaimg.cn/large/a7d296e6ly1g2zdmmnxloj20sg0sgq6c.jpg"];
        [self.dataList addObject:@"https://wx1.sinaimg.cn/large/a7d296e6ly1g2zdmn254kj20sg0sgn0n.jpg"];
        [self.dataList addObject:@"https://wx1.sinaimg.cn/large/a7d296e6gy1g2ze3q9lwvg20f0073npe.gif"];
        [self.dataList addObject:@"https://wx4.sinaimg.cn/large/a7d296e6ly1g2zdmnjbphj20sg0sgwhh.jpg"];
        [self.dataList addObject:@"https://wx1.sinaimg.cn/large/a7d296e6ly1g2zdmnvuuhj20sg0sgn01.jpg"];
        [self.dataList addObject:@"https://wx4.sinaimg.cn/large/a7d296e6ly1g2zdml6xg5j20sg0sgdip.jpg"];
        [self.dataList addObject:@"https://wx2.sinaimg.cn/large/a7d296e6ly1g2zdpjh3iqj20sg0sgwh4.jpg"];
        [self.dataList addObject:@"http://img.emucoo.net/1565937951473_/U53a8/U623f/U6392/U6c34/U6c9f.jpg"];
        [self.tableView reloadData];
    });
    
    [self.tableView registerClass:[TestTableCell class] forCellReuseIdentifier:kCellId];
    self.tableView.rowHeight = kImageHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    [cell setCellImage:self.dataList[indexPath.row]];
    return cell;
}

@end

@interface TestTableCell ()

@property (weak, nonatomic) UIImageView *cellImageView;
@property (assign, nonatomic) CGFloat imgWidth;
@property (assign, nonatomic) CGFloat imgHeight;

@end

@implementation TestTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imgWidth = [UIScreen mainScreen].bounds.size.width - kLeading - kLeading;
    self.imgHeight = kImageHeight - kLeading - kLeading;
    
    UIImageView *cimageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLeading, kLeading, self.imgWidth, self.imgHeight)];
    [self.contentView addSubview:cimageView];
    self.cellImageView = cimageView;
}

- (void)setCellImage:(NSString *)imgUrl {
    [self.cellImageView mx_setImageUrl:imgUrl fittedSize:CGSizeMake(self.imgWidth, self.imgHeight) palceholder:nil];
}

@end

