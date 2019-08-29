//
//  ImageTestViewController.m
//  Emucoo
//
//  Created by kuroky on 2017/6/21.
//  Copyright © 2017年 Emucoo. All rights reserved.
//

#import "ImageTestViewController.h"
#import <MXImageManager/MXImageCache.h>
#import <MXImageManager/UIImageView+MXAdd.h>

@interface ImageTestViewController ()

@property (nonatomic, copy) NSString *origralUrl;
@property (nonatomic, copy) NSString *cacheKey;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@implementation ImageTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"图片测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.width = [UIScreen mainScreen].bounds.size.width - 10 - 10;
    self.height = 350 - 10 - 10;
    
    self.origralUrl = @"http://img.emucoo.net/1565937951473_厨房排水沟.jpg";
    //@"https://wx4.sinaimg.cn/large/a7d296e6ly1g2zdmlrqmej20sg0sg0vh.jpg";
    self.cacheKey = [MXImageCache mx_cacheFromUrl:self.origralUrl forSize:CGSizeMake(self.width, self.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, self.width, self.height)];
    [self.view addSubview:imageView];
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.tag = 100;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, CGRectGetMaxY(imageView.frame) + 40, 100, 40);
    [btn setTitle:@"Clear" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(CGRectGetMaxX(btn.frame) + 40, CGRectGetMaxY(imageView.frame) + 40, 100, 40);
    [btn1 setTitle:@"Down" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clear {
    NSLog(@"clear cache for key: %@", self.cacheKey);
    [MXImageCache mx_removeDiskImageForKey:self.cacheKey];
    UIImage *image = [MXImageCache mx_getImageForKey:self.cacheKey];
    if (!image) {
        NSLog(@"clear success");
    }
}

- (void)down {
    UIImage *image = [MXImageCache mx_getImageForKey:self.cacheKey];
    if (!image) {
        NSLog(@"no image found from disk cache");
    }
    
    NSLog(@"start download from server...");
    UIImageView *imageView = [self.view viewWithTag:100];
    [imageView mx_setImageUrl:self.origralUrl
                   fittedSize:CGSizeMake(self.width, self.height)
                  placeholder:nil
                   completion:^(UIImage * _Nonnull image) {
                       NSLog(@"finish download...");
                       
                       UIImage *origralImage = [MXImageCache mx_getImageForKey:self.origralUrl];
                       if (!origralImage) {
                           NSLog(@"has clear origralImage from disk");
                       }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
