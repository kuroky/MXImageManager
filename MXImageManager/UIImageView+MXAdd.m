//
//  UIImageView+MXAdd.m
//  Pods-MXImageManagerDemo
//
//  Created by kuroky on 2019/5/13.
//

#import "UIImageView+MXAdd.h"
#import "MXImageCache.h"
#import "UIImage+MXAdd.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    
    urlStr = [self stringByURLEncode:urlStr];
    NSString *cacheUrl = [self cropFromPath:urlStr cropSize:size];
    UIImage *cacheImg = [MXImageCache  mx_getImageForKey:cacheUrl];
    if (cacheImg) {
        self.image = cacheImg;
        return;
    }
    
    __weak __typeof(self)wself = self;
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr]
            placeholderImage:[UIImage imageNamed:holder]
                     options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageAvoidAutoSetImage
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       if (!wself || !image) {
                           return;
                       }
                       
                       if (image) {
                           UIImage *img = [self imageByResizeToSize:size withImage:image];
                           wself.image = img;
                           [wself setNeedsLayout];
                           [[SDWebImageManager sharedManager].imageCache removeImageForKey:imageURL.absoluteString
                                                                                  fromDisk:YES
                                                                            withCompletion:nil];
                           [MXImageCache  mx_saveImageToDisk:img withImageKey:cacheUrl completion:nil];
                       }
                   }];
}

//MARK:- 直接加载url图片(带block)
- (void)mx_setImageUrl:(NSString *)urlStr
           placeholder:(nullable NSString *)holder
            completion:(nullable void (^)(UIImage *image))completion {
    if (!urlStr.length || !urlStr) {
        completion ? completion(nil) : nil;
        return;
    }
    
    urlStr = [self stringByURLEncode:urlStr];
    UIImage *cacheImg = [MXImageCache mx_getImageForKey:urlStr];
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
                           wself.image = image;
                           [wself setNeedsLayout];
                           [[SDWebImageManager sharedManager].imageCache removeImageForKey:imageURL.absoluteString
                                                                                  fromDisk:YES
                                                                            withCompletion:nil];
                           [MXImageCache mx_saveImageToDisk:image withImageKey:urlStr completion:nil];
                       }
                       completion ? completion(image) : nil;
                   }];
}


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

- (NSString *)cropFromPath:(NSString *)path
                  cropSize:(CGSize)size {
    NSString *sizeStr = [NSString stringWithFormat:@"_%.0f_%.0f",size.width, size.height];
    NSString *pathStr = [[path stringByDeletingPathExtension] stringByAppendingString:sizeStr];
    NSString *extensionStr = [path pathExtension];
    return extensionStr ? [pathStr stringByAppendingPathExtension:extensionStr] : pathStr;
}

- (UIImage *)imageByResizeToSize:(CGSize)size
                       withImage:(UIImage *)image {
    // SDWebImage在缓存的时候自动处理了scale
    CGFloat scale = 1;//[UIScreen mainScreen].scale;
    CGSize resize = CGSizeMake(size.width * scale, size.height * scale);
    UIImage *resizeImage = [image mx_imageByResizeToSize:resize
                                             contentMode:UIViewContentModeScaleAspectFill];
    return resizeImage;
}



@end
