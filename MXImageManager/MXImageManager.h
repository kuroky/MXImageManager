//
//  MXImageManager.h
//  MXImageManager
//
//  Created by kuroky on 2018/1/15.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 基于SDWebImage的图片管理类
 */
@interface MXImageManager : NSObject

/**
 图片处理单例

 @return MXImageManager
 */
+ (instancetype)shareImageManager;

/**
 将图片缓存到磁盘

 @param image 图片
 @param key 图片key
 @param completion 回调block
 */
- (void)mx_saveImageToDisk:(UIImage *)image
              withImageKey:(NSString *)key
                completion:(void (^)(BOOL success))completion;

/**
 将图片缓存到内存
 
 @param image 图片
 @param key 图片key
 */
- (void)mx_saveImageToMemory:(UIImage *)image
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

@interface UIImageView (MXAdd)

/**
 UIImageView 直接加载url图片 (图片下载完会直接显示)
 
 @param urlStr 图片地址
 @param holder 占位图 name
 */
- (void)mx_setImageUrl:(NSString *)urlStr
           palceholder:(NSString *)holder;

/**
 UIImageView 加载裁剪后的url图片 (图片下载完，先裁剪再移除内存缓存，保存到磁盘)
 
 @param urlStr 图片地址
 @param size   ImageView显示size
 @param holder 占位图name
 */
- (void)mx_setImageUrl:(NSString *)urlStr
            fittedSize:(CGSize)size
           palceholder:(NSString *)holder;

/**
 UIImageView 直接加载url图片(带block)
 
 @param urlStr 图片地址(NSString)
 @param holder 占位图name
 @param completion 图片下载完成回调
 */
- (void)mx_setImageStr:(NSString *)urlStr
           placeholder:(NSString *)holder
            completion:(void (^)(UIImage *image))completion;

@end
