//
//  MXImageCache.m
//  MXImageManager
//
//  Created by kuroky on 2019/5/13.
//

#import "MXImageCache.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <YYWebImage/YYImageCache.h>
#import <YYCache/YYCache.h>

@implementation MXImageCache

+ (void)mx_cancelSDMemoryCache {
    [SDWebImageManager sharedManager].imageCache.config.shouldCacheImagesInMemory = NO;
}

//MARK:- 将图片缓存到磁盘
+ (void)mx_saveImageToDisk:(UIImage *)image
              withImageKey:(NSString *)key
                completion:(nullable void (^)(BOOL success))completion {
    if (!key || !key.length || !image) {
        completion ? completion(NO) : nil;
        return;
    }
    
    // SD的操作也可能失败，默认成功
    [[SDWebImageManager sharedManager].imageCache storeImage:image
                                                      forKey:key
                                                      toDisk:YES
                                                  completion:^{
                                                      completion ? completion(YES) : nil;
                                                  }];
}

//MARK:- 移除磁盘缓存图片
+ (void)mx_removeDiskImageForKey:(NSString *)key {
    [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:YES withCompletion:nil];
    [[YYImageCache sharedCache] removeImageForKey:key withType:YYImageCacheTypeDisk];
}

//MARK:- 将图片缓存到内存
+ (void)mx_saveImageToMemory:(UIImage *)image
                withImageKey:(NSString *)key {
    // 不关心成功失败
    [[SDWebImageManager sharedManager].imageCache storeImage:image
                                                      forKey:key
                                                      toDisk:YES
                                                  completion:nil];
}

//MARK:- 移除内存缓存图片
+ (void)mx_removeMemoryImageForKey:(NSString *)key {
    [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:NO withCompletion:nil];
    [[YYImageCache sharedCache] removeImageForKey:key withType:YYImageCacheTypeMemory];
}

//MARK:- 根据key读取缓存的图片
+ (UIImage *)mx_getImageForKey:(NSString *)key {
    if (!key || !key.length) {
        return nil;
    }
    
    return [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:key];
}

//MARK:- 获取WebImageManager缓存大小
+ (void)mx_getCacheSize:(nullable void (^)(CGFloat totalCost))completion {
    CGFloat size = [SDWebImageManager sharedManager].imageCache.getSize / 1024.0 / 1024.0; // sd

    [[YYImageCache sharedCache].diskCache totalCostWithBlock:^(NSInteger totalCost) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion ? completion(size + totalCost / 1000.0 / 1000.0) : nil; // yy
        });
    }];
}

//MARK:- 清理 WebImageManager图片缓存
+ (void)mx_clearCacheCompletion:(nullable void (^)(BOOL error))completion {
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self mx_clearYYImageCache:^{
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_enter(serviceGroup);
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        completion ? completion(NO) : nil;
    });
}

+ (void)mx_clearYYImageCache:(nullable void (^)(void))block {
    [[YYImageCache sharedCache].diskCache removeAllObjectsWithBlock:^{
        block ? block() : nil;
    }];
}

@end
