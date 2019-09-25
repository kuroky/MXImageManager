//
//  UIImage+MXAdd.h
//  MXImageManager
//
//  Created by kuroky on 2019/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// UIImage分类
@interface UIImage (MXAdd)

/// 图片裁剪
/// @param size 尺寸
/// @param contentMode 显示模式
- (UIImage *)mx_imageByResizeToSize:(CGSize)size
                        contentMode:(UIViewContentMode)contentMode;

@end

NS_ASSUME_NONNULL_END
