//
//  MXImageManager.m
//  MXImageManager
//
//  Created by kuroky on 2018/1/15.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "MXImageManager.h"
#import <YYWebImage/YYWebImage.h>
#import <SDWebImage/UIImageView+WebCache.h>

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
              withImageKey:(NSString *)key {
    if (!key || !key.length || !image) {
        return;
    }
    
    [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:key toDisk:YES completion:^{
        [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:NO withCompletion:nil];
    }];
}

//MARK:- 移除磁盘缓存图片
- (void)mx_removeDiskImageForKey:(NSString *)key {
    [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:YES withCompletion:nil];
}

//MARK:- 移除内存缓存图片
- (void)mx_removeMemoryImageForKey:(NSString *)key {
    //[self mx_removeImageForKey:key withCacheType:MXImageCacheTypeMemory];
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
    return [SDWebImageManager sharedManager].imageCache.getSize;
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
    if (!urlStr.length || !urlStr) {
        self.image = [UIImage imageNamed:holder];
        return;
    }
    
    urlStr = [self mx_stringByURLEncode:urlStr];
    NSString *cacheUrl = [self cropFromPath:urlStr cropSize:size];
    UIImage *cacheImg = [[MXImageManager shareImageManager] mx_getImageForKey:cacheUrl];
    if (cacheImg) {
        self.image = cacheImg;
        return;
    }
    
    /*
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
    */
    
    __weak __typeof(self)wself = self;
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr]
            placeholderImage:[UIImage imageNamed:holder]
                     options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageAvoidAutoSetImage
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       if (!wself) {
                           return;
                       }
                       if (image) {
                           wself.image = image;
                           [wself setNeedsLayout];
                           //[wself cropDownloadImage:image
                           //              expectSize:size
                           //                 saveKey:sizeImagekey];
                           [[SDWebImageManager sharedManager].imageCache removeImageForKey:imageURL.absoluteString fromDisk:NO withCompletion:nil];
                       }
                       else {
                           wself.image = [UIImage imageNamed:holder];
                           [wself setNeedsLayout];
                       }
                   }];
}

- (void)setImageURL:(NSURL *)url
        placeholder:(UIImage *)placeholder {
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (NSString *)mx_stringByURLEncode:(NSString *)str {
    NSCharacterSet *charSet = [NSCharacterSet URLFragmentAllowedCharacterSet];
    return [str stringByAddingPercentEncodingWithAllowedCharacters:charSet];
}

- (NSString *)cropFromPath:(NSString *)path
                  cropSize:(CGSize)size {
    NSString *sizeStr = [NSString stringWithFormat:@"_%.0f_%.0f",size.width,size.height];
    NSString *pathStr = [[path stringByDeletingPathExtension] stringByAppendingString:sizeStr];
    NSString *extensionStr = [path pathExtension];
    return extensionStr ? [pathStr stringByAppendingPathExtension:extensionStr] : pathStr;
}

@end
