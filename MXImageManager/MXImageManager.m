//
//  MXImageManager.m
//  MXImageManager
//
//  Created by kuroky on 2018/1/15.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "MXImageManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+EMAdd.h"

typedef NS_ENUM(NSUInteger, MXImageCacheType) {
    MXImageCacheTypeNone   = 0,
    MXImageCacheTypeMemory = 1 << 0,
    MXImageCacheTypeDisk   = 1 << 1,
    MXImageCacheTypeAll    = MXImageCacheTypeMemory | MXImageCacheTypeDisk,
};

@implementation MXImageManager

+ (instancetype)shareImageManager {
    static MXImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [MXImageManager new];
    });
    return manager;
}

//MARK:- 将图片缓存到磁盘
- (void)mx_saveImageToDisk:(UIImage *)image
              withImageKey:(NSString *)key
                completion:(void (^)(BOOL success))completion {
    if (!key || !key.length || !image) {
        completion ? completion(NO) : nil;
        return;
    }
    
    // SD的操作也可能失败，默认成功
    [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:key toDisk:YES completion:^{
        completion ? completion(YES) : nil;
    }];
}

//MARK:- 移除磁盘缓存图片
- (void)mx_removeDiskImageForKey:(NSString *)key {
    [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:YES withCompletion:nil];
}

//MARK:- 将图片缓存到内存
- (void)mx_saveImageToMemory:(UIImage *)image
                withImageKey:(NSString *)key {
    // 不关心成功失败
    [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:key toDisk:YES completion:nil];
}

//MARK:- 移除内存缓存图片
- (void)mx_removeMemoryImageForKey:(NSString *)key {
    [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:NO withCompletion:nil];
}

//MARK:- 根据key读取缓存的图片
- (UIImage *)mx_getImageForKey:(NSString *)key {
    if (!key || !key.length) {
        return nil;
    }
    
    return [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:key];
}

//MARK:- 获取WebImageManager缓存大小
- (CGFloat)mx_getCacheSize {
    return [SDWebImageManager sharedManager].imageCache.getSize * 0.001 * 0.001;
}

//MARK:- 清理 WebImageManager图片缓存
- (void)mx_clearCacheCompletion:(void (^)(BOOL error))completion {
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
        completion ? completion(nil) : nil;
    }];
}

@end

@implementation UIImageView (MXAdd)

//MARK:- UIImageView 直接加载url图片
- (void)mx_setImageUrl:(NSString *)urlStr
           palceholder:(NSString *)holder {
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
           palceholder:(NSString *)holder {
    if (!urlStr.length || !urlStr) {
        self.image = [UIImage imageNamed:holder];
        return;
    }
    
    urlStr = [self stringByURLEncode:urlStr];
    NSString *cacheUrl = [self cropFromPath:urlStr cropSize:size];
    UIImage *cacheImg = [[MXImageManager shareImageManager] mx_getImageForKey:cacheUrl];
    if (cacheImg) {
        self.image = cacheImg;
        return;
    }
    
    __weak __typeof(self)wself = self;
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr]
            placeholderImage:[UIImage imageNamed:holder]
                     options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageAvoidAutoSetImage
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       if (!wself) {
                           return;
                       }
                       
                       if (image) {
                           UIImage *img = [self imageByResizeToSize:size withImage:image];
                           wself.image = img;
                           [wself setNeedsLayout];
                           [[SDWebImageManager sharedManager].imageCache removeImageForKey:imageURL.absoluteString
                                                                                  fromDisk:YES
                                                                            withCompletion:nil];
                           [[MXImageManager shareImageManager] mx_saveImageToDisk:img withImageKey:cacheUrl completion:nil];
                       }
                   }];
}

//MARK:- 直接加载url图片(带block)
- (void)mx_setImageStr:(NSString *)urlStr
           placeholder:(NSString *)holder
            completion:(void (^)(UIImage *image))completion {
    if (!urlStr.length || !urlStr) {
        completion ? completion(nil) : nil;
        return;
    }
    
    urlStr = [self stringByURLEncode:urlStr];
    UIImage *cacheImg = [[MXImageManager shareImageManager] mx_getImageForKey:urlStr];
    if (cacheImg) {
        completion ? completion(cacheImg) : nil;
        return;
    }
    
    __weak __typeof(self)wself = self;
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr]
            placeholderImage:[UIImage imageNamed:holder]
                     options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageAvoidAutoSetImage
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       if (!wself) {
                           completion ? completion(nil) : nil;
                           return;
                       }
                       completion ? completion(image) : nil;
                   }];
}

//MARK:- Private
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
    CGFloat scale = 2;//[UIScreen mainScreen].scale;
    CGSize resize = CGSizeMake(size.width * scale, size.height * scale);
    UIImage *resizeImage = [image em_imageByResizeToSize:resize
                                             contentMode:UIViewContentModeScaleAspectFill];
    return resizeImage;
}

@end
