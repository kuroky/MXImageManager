//
//  UIImage+MXAdd.h
//  MXImageManager
//
//  Created by kuroky on 2019/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MXAdd)

- (UIImage *)mx_imageByResizeToSize:(CGSize)size
                        contentMode:(UIViewContentMode)contentMode;

@end

NS_ASSUME_NONNULL_END
