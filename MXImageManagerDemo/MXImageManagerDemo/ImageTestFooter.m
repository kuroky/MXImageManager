//
//  ImageTestFooter.m
//  Emucoo
//
//  Created by kuroky on 2017/6/21.
//  Copyright © 2017年 Emucoo. All rights reserved.
//

#import "ImageTestFooter.h"

@interface ImageTestFooter ()

@property (strong, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation ImageTestFooter

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)em_reloadImage:(UIImage *)image {
    self.contentImageView.image = image;
}

- (void)dealloc {
    
    
}

@end
