//
//  UIImageView+MXAdd.m
//  MXImageManager
//
//  Created by kuroky on 2018/1/15.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "UIImageView+MXAdd.h"
#import <YYWebImage/YYWebImage.h>

@implementation UIImageView (MXAdd)

//MARK:- UIImageView 直接加载url图片
- (void)mx_setImageUrl:(NSString *)urlStr
           palceholder:(NSString *)holder {
    if (!urlStr.length) {
        self.image = [UIImage imageNamed:holder];
        return;
    }
    
    //urlStr = [urlStr mx_stringByURLEncode];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self setImageURL:url
          placeholder:[UIImage imageNamed:holder]];
}

//MARK:- UIImageView 加载裁剪后的url图片
- (void)mx_setImageUrl:(NSString *)urlStr
            fittedSize:(CGSize)size
           palceholder:(NSString *)holder {
    if (!urlStr.length) {
        self.image = [UIImage imageNamed:holder];
        return;
    }
    //urlStr = [urlStr mx_stringByURLEncode];
    
    [self yy_setImageWithURL:[NSURL URLWithString:urlStr]
                 placeholder:[UIImage imageNamed:holder]
                     options:YYWebImageOptionSetImageWithFadeAnimation
                    progress:nil
                   transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                       image = [image yy_imageByResizeToSize:size
                                                 contentMode:UIViewContentModeCenter];
                       return image;
                   }
                  completion:nil];
}

- (void)setImageURL:(NSURL *)url
        placeholder:(UIImage *)placeholder {
    [self yy_setImageWithURL:url
                     options:YYWebImageOptionSetImageWithFadeAnimation];
}

@end
