//
//  MXImageManager.h
//  MXImageManager
//
//  Created by kuroky on 2018/1/15.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 基于YYWebImage的图片管理类
 */
@interface MXImageManager : NSObject

+ (instancetype)shareImageManager;

/**
 将图片缓存到磁盘

 @param image 图片
 @param key 图片key
 */
- (void)mx_saveImageToDisk:(UIImage *)image
              withImageKey:(NSString *)key;

/**
 移除磁盘缓存图片

 @param key 图片key
 */
- (void)mx_removeDiskImageForKey:(NSString *)key;

/**
 移除内存缓存图片

 @param key 缓存key
 */
- (void)mx_removeMemoryImageForKey:(NSString *)key;

/**
 根据key读取缓存的图片

 @param key 缓存key
 @return UIImage
 */
- (UIImage *)mx_getImageForKey:(NSString *)key;

/**
 清理 WebImageManager图片缓存
 */
- (void)mx_clearCacheCompletion:(void (^)(BOOL error))completion;

/**
 获取WebImageManager缓存大小
 
 @return 单位:Mb
 */
- (CGFloat)mx_getCacheSize;

@end
