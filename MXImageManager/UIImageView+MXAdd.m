//
//  UIImageView+MXAdd.m
//  Pods-MXImageManagerDemo
//
//  Created by kuroky on 2019/5/13.
//

#import "UIImageView+MXAdd.h"
#import "MXImageCache.h"
#import "UIImage+MXAdd.h"

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#else
#import "UIImageView+WebCache.h"
#import "SDWebImage/SDImageCache.h"
#endif

@implementation UIImageView (MXAdd)

//MARK:- UIImageView 直接加载url图片
- (void)mx_setImageUrl:(NSString *)urlStr
           placeholder:(nullable NSString *)holder {
    if (!urlStr.length || !urlStr) {
        self.image = [UIImage imageNamed:holder];
        return;
    }
    
    urlStr = [self stringByURLEncode:urlStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self setImageURL:url
          placeholder:[UIImage imageNamed:holder]];
}

//MARK:- UIImageView 加载裁剪后的url图片
- (void)mx_setImageUrl:(NSString *)urlStr
            fittedSize:(CGSize)size
           palceholder:(nullable NSString *)holder {
    if (!urlStr.length || !urlStr) {
        self.image = [UIImage imageNamed:holder];
        return;
    }
    
    // 1. 图片地址格式化
    urlStr = [self stringByURLEncode:urlStr];
    // 2. 优先读取磁盘缓存
    
    NSString *cacheUrl = [MXImageCache mx_cacheFromUrl:urlStr forSize:size];
    UIImage *cacheImg = [MXImageCache  mx_getImageForKey:cacheUrl];
    if (cacheImg) {
        self.image = cacheImg;
        return;
    }
    
    // 3. 缓存不存在，进行下载
    __weak __typeof(self)wself = self;
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr]
            placeholderImage:[UIImage imageNamed:holder]
                     options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageAvoidAutoSetImage
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       if (!wself || !image) {
                           return;
                       }
                       
                       if (image) {
                           // 4. 图片裁剪后加载
                           UIImage *img = [self imageByResizeToSize:size withImage:image];
                           wself.image = img;
                           [wself setNeedsLayout];
                           // 5. 移除原始图片的磁盘缓存
                           [[SDImageCache sharedImageCache] removeImageForKey:imageURL.absoluteString
                                                                    cacheType:SDImageCacheTypeAll
                                                                   completion:nil];
                           // 6. 把裁剪后的图片存入磁盘
                           [MXImageCache  mx_saveImageToDisk:img withImageKey:cacheUrl completion:nil];
                       }
                   }];
}

//MARK:- 直接加载url图片(带block)
- (void)mx_setImageUrl:(NSString *)urlStr
            fittedSize:(CGSize)size
           placeholder:(nullable NSString *)holder
            completion:(nullable void (^)(UIImage *image))completion {
    if (!urlStr.length || !urlStr) {
        completion ? completion(nil) : nil;
        return;
    }
    
    urlStr = [self stringByURLEncode:urlStr];
    NSString *cacheUrl = [MXImageCache mx_cacheFromUrl:urlStr forSize:size];
    UIImage *cacheImg = [MXImageCache mx_getImageForKey:cacheUrl];
    if (cacheImg) {
        self.image = cacheImg;
        completion ? completion(cacheImg) : nil;
        return;
    }
    
    __weak __typeof(self)wself = self;
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr]
            placeholderImage:[UIImage imageNamed:holder]
                     options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageAvoidAutoSetImage
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       if (!wself || !image) {
                           completion ? completion(nil) : nil;
                           return;
                       }
                       
                       if (image) {
                           UIImage *img = [self imageByResizeToSize:size withImage:image];
                           wself.image = img;
                           [wself setNeedsLayout];
                           
                           [[SDImageCache sharedImageCache] removeImageForKey:imageURL.absoluteString
                                                                    cacheType:SDImageCacheTypeAll
                                                                   completion:nil];
                           [MXImageCache mx_saveImageToDisk:img withImageKey:cacheUrl completion:nil];
                       }
                       completion ? completion(image) : nil;
                   }];
}

//MARK:- 通过sd加载图片
- (void)setImageURL:(NSURL *)url
        placeholder:(UIImage *)placeholder {
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (NSString *)stringByURLEncode:(NSString *)str {
    NSCharacterSet *charSet = [NSCharacterSet URLFragmentAllowedCharacterSet];
    return [str stringByAddingPercentEncodingWithAllowedCharacters:charSet];
} 

- (UIImage *)imageByResizeToSize:(CGSize)size
                       withImage:(UIImage *)image {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(image.size.width, image.size.height);
    }

    CGFloat scale = [UIScreen mainScreen].scale;
    scale = scale > 2 ? 2 : scale;
    CGSize resize = CGSizeMake(size.width * scale, size.height * scale);
    UIImage *resizeImage = [image mx_imageByResizeToSize:resize
                                             contentMode:UIViewContentModeScaleAspectFill];
    return resizeImage;
}

@end
