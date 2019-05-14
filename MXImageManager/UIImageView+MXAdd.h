//
//  UIImageView+MXAdd.h
//  Pods-MXImageManagerDemo
//
//  Created by kuroky on 2019/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 UIImageView 分类
 */
@interface UIImageView (MXAdd)

/**
 UIImageView 直接加载url图片 (图片下载完会直接显示)
 
 @param urlStr 图片地址
 @param holder 占位图 name
 */
- (void)mx_setImageUrl:(NSString *)urlStr
           placeholder:(nullable NSString *)holder;

/**
 UIImageView 加载裁剪后的url图片 (图片下载完，先裁剪再移除内存缓存，保存到磁盘)
 
 @param urlStr 图片地址
 @param size   ImageView显示size
 @param holder 占位图name
 */
- (void)mx_setImageUrl:(NSString *)urlStr
            fittedSize:(CGSize)size
           palceholder:(nullable NSString *)holder;

/**
 UIImageView 直接加载url图片(带block)
 
 @param urlStr 图片地址(NSString)
 @param size   ImageView显示size
 @param holder 占位图name
 @param completion 图片下载完成回调
 */
- (void)mx_setImageUrl:(NSString *)urlStr
            fittedSize:(CGSize)size
           placeholder:(nullable NSString *)holder
            completion:(nullable void (^)(UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
