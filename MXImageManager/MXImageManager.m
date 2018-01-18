//
//  MXImageManager.m
//  MXImageManager
//
//  Created by kuroky on 2018/1/15.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "MXImageManager.h"
#import <UIImageView+WebCache.h>
#import <YYWebImage/YYWebImage.h>

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
    [self saveImage:image withImageKey:key withCacheType:YYImageCacheTypeDisk];
}

//MARK:- 移除磁盘缓存图片
- (void)mx_removeDiskImageForKey:(NSString *)key {
    [self mx_removeImageForKey:key withCacheType:YYImageCacheTypeDisk];
}

//MARK:- 移除内存缓存图片
- (void)mx_removeMemoryImageForKey:(NSString *)key {
    [self mx_removeImageForKey:key withCacheType:YYImageCacheTypeMemory];
}

//MARK:- 根据key读取缓存的图片
- (UIImage *)mx_getImageForKey:(NSString *)key {
    if (!key || !key.length) {
        return nil;
    }
    return [[YYWebImageManager sharedManager].cache getImageForKey:key];
}

//MARK:- 获取WebImageManager缓存大小
- (CGFloat)mx_getCacheSize {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    return cache.diskCache.totalCost * 0.001 * 0.001;
}

//MARK:- 清理 WebImageManager图片缓存
- (void)mx_clearCacheCompletion:(void (^)(BOOL error))completion {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.diskCache removeAllObjectsWithProgressBlock:nil
                                              endBlock:^(BOOL error) {
                                                  completion ? completion(error) : nil;
                                              }];
}

//MARK:- private
- (void)saveImage:(UIImage *)image
     withImageKey:(NSString *)key
    withCacheType:(YYImageCacheType)type {
    if (!key || !key.length || !image) {
        return;
    }
    [[YYWebImageManager sharedManager].cache setImage:image
                                            imageData:nil
                                               forKey:key
                                             withType:type];
}

- (void)mx_removeImageForKey:(NSString *)key
               withCacheType:(YYImageCacheType)type {
    if (!key || !key.length) {
        return;
    }
    
    [[YYWebImageManager sharedManager].cache removeImageForKey:key
                                                      withType:type];
}

@end
