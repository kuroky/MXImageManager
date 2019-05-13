//
//  MXImageCache.h
//  MXImageManager
//
//  Created by kuroky on 2019/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 图片缓存控制
 */
@interface MXImageCache : NSObject

/**
 将图片缓存到磁盘
 
 @param image 图片
 @param key 图片key
 @param completion 回调block
 */
+ (void)mx_saveImageToDisk:(UIImage *)image
              withImageKey:(NSString *)key
                completion:(void (^)(BOOL success))completion;

/**
 将图片缓存到内存
 
 @param image 图片
 @param key 图片key
 */
+ (void)mx_saveImageToMemory:(UIImage *)image
                withImageKey:(NSString *)key;

/**
 移除磁盘缓存图片
 
 @param key 图片key
 */
+ (void)mx_removeDiskImageForKey:(NSString *)key;

/**
 移除内存缓存图片
 
 @param key 缓存key
 */
+ (void)mx_removeMemoryImageForKey:(NSString *)key;

/**
 根据key读取缓存的图片
 
 @param key 缓存key
 @return UIImage
 */
+ (UIImage *)mx_getImageForKey:(NSString *)key;

/**
 清理 WebImageManager图片缓存
 */
+ (void)mx_clearCacheCompletion:(void (^)(BOOL error))completion;

/**
 获取WebImageManager缓存大小
 */
+ (void)mx_getCacheSize:(void (^)(CGFloat totalCost))completion;

/**
 清除YYImageCahce (YYCahce缓存的是解码后的图片 占用大量磁盘空间)
 
 @param block block
 */
- (void)mx_clearYYImageCache:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
