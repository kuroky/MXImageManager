//
//  ImageListViewController.m
//  MXImageManager
//
//  Created by kuroky on 2018/1/18.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "ImageListViewController.h"
#import <Masonry.h>
#import "MXImageManager.h"
#import <YYImage/YYImage.h>

static NSString *const kCellId  =   @"cellid";

@interface ImageListViewController ()

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation ImageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Images";
    self.dataList = [NSMutableArray array];
    NSInteger index = 40;
    for (NSInteger i = 0; i < index; i++) {
        NSString *url = [NSString stringWithFormat:@"http://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage0%02ld.jpg", (long)i];
        [self.dataList addObject:url];
    }
    
    [self.tableView registerClass:[TestTableCell class] forCellReuseIdentifier:kCellId];
    self.tableView.rowHeight = 350;
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

@property (strong, nonatomic) UIImageView *cellImageView;
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
    self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.cellImageView];
    self.cellImageView.backgroundColor = [UIColor lightGrayColor];
    [self.cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets = UIEdgeInsetsMake(10, 10, 10, 10);
    }];
    self.imgWidth = [UIScreen mainScreen].bounds.size.width - 20;
    self.imgHeight = 350 - 20;
}

- (void)setCellImage:(NSString *)imgUrl {
    [self.cellImageView mx_setImageUrl:imgUrl
                            fittedSize:CGSizeMake(self.imgWidth, self.imgHeight)
                           palceholder:nil];
}

@end
