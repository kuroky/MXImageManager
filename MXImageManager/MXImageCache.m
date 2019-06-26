//
//  MXImageCache.m
//  MXImageManager
//
//  Created by kuroky on 2019/5/13.
//

#import "MXImageCache.h"

#if __has_include(<SDWebImage/SDWebImage.h>)
#import <SDWebImage/SDImageCache.h>
#else
#import "SDWebImage/SDImageCache.h"
#endif

@implementation MXImageCache

+ (void)mx_cancelSDMemoryCache {
    [SDImageCache sharedImageCache].config.shouldCacheImagesInMemory = NO;
}

//MARK:- 将图片缓存到磁盘
+ (void)mx_saveImageToDisk:(UIImage *)image
              withImageKey:(NSString *)key
                completion:(nullable void (^)(BOOL success))completion {
    if (!key || !key.length || !image) {
        completion ? completion(NO) : nil;
        return;
    }
    
    // 操作完成
    [[SDImageCache sharedImageCache] storeImage:image
                                      imageData:nil
                                         forKey:key
                                      cacheType:SDImageCacheTypeDisk
                                     completion:^{
                                         completion ? completion(YES) : nil;
                                     }];
}

//MARK:- 移除磁盘缓存图片
+ (void)mx_removeDiskImageForKey:(NSString *)key {
    [[SDImageCache sharedImageCache] removeImageForKey:key cacheType:SDImageCacheTypeAll completion:nil];
}

//MARK:- 将图片缓存到内存
+ (void)mx_saveImageToMemory:(UIImage *)image
                withImageKey:(NSString *)key {
    // 不考虑成功失败
    [[SDImageCache sharedImageCache] storeImage:image
                                      imageData:nil
                                         forKey:key
                                      cacheType:SDImageCacheTypeMemory completion:nil];
}

//MARK:- 移除内存缓存图片
+ (void)mx_removeMemoryImageForKey:(NSString *)key {
    [[SDImageCache sharedImageCache] removeImageForKey:key cacheType:SDImageCacheTypeAll completion:nil];
}

//MARK:- 根据key读取缓存的图片
+ (UIImage *)mx_getImageForKey:(NSString *)key {
    if (!key || !key.length) {
        return nil;
    }

    return [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
}

//MARK:- 获取WebImageManager缓存大小
+ (void)mx_getCacheSize:(nullable void (^)(CGFloat totalCost))completion {
    if (!completion) {
        return;
    }
    
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        completion(totalSize / 1024.0 / 1024.0);
    }];
}

//MARK:- 清理 WebImageManager图片缓存
+ (void)mx_clearCacheCompletion:(nullable void (^)(void))completion {
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        completion ? completion() : nil;
    }];
}

+ (NSString *)mx_cacheFromUrl:(NSString *)url forSize:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return url;
    }
    NSString *sizeStr = [NSString stringWithFormat:@"_%.0f_%.0f",size.width, size.height];
    NSString *pathStr = [[url stringByDeletingPathExtension] stringByAppendingString:sizeStr];
    NSString *extensionStr = [url pathExtension];
    return extensionStr ? [pathStr stringByAppendingPathExtension:extensionStr] : pathStr;
}

@end
