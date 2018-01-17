//
//  UIImageView+MXAdd.m
//  MXImageManager
//
//  Created by kuroky on 2018/1/15.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "UIImageView+MXAdd.h"
#import <UIImageView+WebCache.h>
#import "UIImage+MXAdd.h"
#import "NSString+MXAdd.h"

@implementation UIImageView (MXAdd)

//MARK:- UIImageView 直接加载url图片
- (void)mx_setImageUrl:(NSString *)urlStr
           palceholder:(NSString *)holder {
    if (!urlStr.length) {
        self.image = [UIImage imageNamed:holder];
        return;
    }
    
    urlStr = [urlStr mx_stringByURLEncode];
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
    urlStr = [urlStr mx_stringByURLEncode];
    NSString *imageKey = [self urlString:urlStr appending:size];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageKey];
    if (cacheImage) {
        self.image = cacheImage;
        //[self setNeedsLayout];
        return;
    }
    
    __weak __typeof(self)weakself = self;
    NSURL *url = [NSURL URLWithString:urlStr];
    [self sd_setImageWithURL:url
            placeholderImage:[UIImage imageNamed:holder]
                     options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageAvoidAutoSetImage
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (!weakself) {
                           return;
                       }
                       if (image) {
                           [weakself cropDownloadImage:image
                                            expectSize:size
                                               saveKey:imageKey];
                           
                           [[SDImageCache sharedImageCache] removeImageForKey:imageURL.absoluteString
                                                                     fromDisk:NO
                                                               withCompletion:nil];
                            
                       }
                       else {
                           NSLog(@"fail url : %@", imageURL);
                           weakself.image = [UIImage imageNamed:holder];
                           //[weakself setNeedsLayout];
                       }
                   }];
}

- (void)setImageURL:(NSURL *)url
        placeholder:(UIImage *)placeholder {
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (NSString *)urlString:(NSString *)urlStr
              appending:(CGSize)size {
    NSString *sizeStr = [NSString stringWithFormat:@"_%.0f_%.0f",size.width, size.height];
    NSString *pathStr = [[urlStr stringByDeletingPathExtension] stringByAppendingString:sizeStr];
    NSString *extensionStr = [urlStr pathExtension];
    return extensionStr ? [pathStr stringByAppendingPathExtension:extensionStr] : pathStr;
}

//MARK:- 本地裁切图片
- (void)cropDownloadImage:(UIImage *)originImage
               expectSize:(CGSize)size
                  saveKey:(NSString *)key {
    UIImage *resizeImage = [originImage mx_imageResize:size
                                           contentMode:UIViewContentModeScaleAspectFill];
    [[SDWebImageManager sharedManager] saveImageToCache:resizeImage
                                                 forURL:[NSURL URLWithString:key]];
    self.image = resizeImage;
    [self setNeedsLayout];
}

@end
