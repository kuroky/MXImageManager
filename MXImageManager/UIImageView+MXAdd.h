//
//  UIImageView+MXAdd.h
//  MXImageManager
//
//  Created by kuroky on 2018/1/15.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MXAdd)

/**
 UIImageView 直接加载url图片
 
 @param urlStr 图片地址
 @param holder 占位图
 */
- (void)mx_setImageUrl:(NSString *)urlStr
           palceholder:(NSString *)holder;

/**
 UIImageView 加载裁剪后的url图片

 @param urlStr 图片地址
 @param size   ImageView显示size
 @param holder 占位图
 */
- (void)mx_setImageUrl:(NSString *)urlStr
            fittedSize:(CGSize)size
           palceholder:(NSString *)holder;

@end
