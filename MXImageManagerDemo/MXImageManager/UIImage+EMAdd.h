//
//  UIImage+EMAdd.h
//  Emucoo
//
//  Created by kuroky on 2017/6/19.
//  Copyright © 2017年 Emucoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 图片创建
 */
@interface UIImage (EMAdd)

#pragma mark - Create image

/**
 *  根据特定颜色的1x1图片
 */
+ (nullable UIImage *)em_imageWithColor:(nullable UIColor *)color;

/**
 *  返回特定大小和颜色的图片
 */
+ (nullable UIImage *)em_imageWithColor:(nullable UIColor *)color size:(CGSize)size;

/**
 *  根据size创建新的image
 *
 *  @param size        给定size
 *  @param contentMode contentMode
 *
 *  @return 新image
 */
- (nullable UIImage *)em_imageByResizeToSize:(CGSize)size
                                 contentMode:(UIViewContentMode)contentMode;

/**
 *  复制image对应rect的image
 *
 *  @param rect  对应区域
 *
 *  @return 新的image
 */
- (nullable UIImage *)em_imageByCropToRect:(CGRect)rect;

/**
 *  旋转image
 *
 *  @param radians 旋转方向
 *  @param fitSize 是否适应size
 *
 *  @return 新的image
 */
- (nullable UIImage *)em_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/**
 生成圆角图片

 @param radius 圆角半径
 @return 新的图片
 */
- (nullable UIImage *)em_imageByRoundRadius:(CGFloat)radius;

/**
 UIView转成UIImage
 
 @param view 初始view
 @return 新的image
 */
+ (nullable UIImage *)em_imageWithView:(nullable UIView *)view;

/**
 图片合并
 
 @param combineSize 容器大小
 @param image1 图片1
 @param rect1 图片1位置
 @param image2 图片2
 @param rect2 图片2位置
 @return 新的图片
 */
+ (nullable UIImage *)em_imageCombine:(CGSize)combineSize
                                image:(nullable UIImage *)image1
                                frame:(CGRect)rect1
                            withImage:(nullable UIImage *)image2
                                frame:(CGRect)rect2;

/**
 模糊化 image 适用覆盖于白色背景.
 (类似通知中心)
 */
- (nullable UIImage *)em_imageByBlurDark;

#pragma mark - PDF图片生成
/**
 *  PDF（file data或者path）创建创建image
 *
 *  @param dataOrPath dataOrPath
 *
 *  @return image
 */
+ (nullable UIImage *)em_imageWithPDF:(nullable id)dataOrPath;

/**
 *  PDF（file data或者path）创建创建特定size的image
 *
 *  @param dataOrPath dataOrPath
 *  @param size       size
 *
 *  @return image
 */
+ (nullable UIImage *)em_imageWithPDF:(nullable id)dataOrPath size:(CGSize)size;

#pragma mark - GIf 生成

/**
 *  GIF data创建image
 *
 *  @param data  gift data
 *  @param scale 比例scale
 *
 *  @return image
 */
+ (nullable UIImage *)em_imageWithSmallGIFData:(nullable NSData *)data scale:(CGFloat)scale;

/**
 *  数据是否是GIF动画
 */
+ (BOOL)em_isAnimatedGIFData:(nullable NSData *)data;

/**
 *  path路径下file是否是GIF
 */
+ (BOOL)em_isAnimatedGIFFile:(nullable NSString *)path;

/**
 text 绘制 image

 @param text 文字
 @param attributes 文字属性
 @param rect frame
 @return UIImage
 */
+ (nullable UIImage *)em_imageFromString:(nullable NSString *)text
                              attributes:(nullable NSDictionary *)attributes
                               withFrame:(CGRect)rect;

/**
 拉伸图片

 @param imgName 图片名
 @param capInsets 上、下、左、右 边距
 @return UIImage
 */
+ (nullable UIImage *)em_resizeImage:(nullable NSString *)imgName
                       withCapInsets:(UIEdgeInsets)capInsets;

@end
