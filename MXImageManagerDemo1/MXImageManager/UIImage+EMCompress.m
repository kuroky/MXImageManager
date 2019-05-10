//
//  UIImage+EMCompress.m
//  Emucoo
//
//  Created by kuroky on 2017/6/21.
//  Copyright © 2017年 Emucoo. All rights reserved.
//

#import "UIImage+EMCompress.h"

//static NSInteger const kMaxImageWidth   =   800; // 竖图最大宽度不能超过800
//static NSInteger const kMaxImageHeight   =   800; // 横图最大高度不能超过800

@implementation UIImage (EMCompress)

- (void)em_compressQuality:(EMImageQuality)quality
                completion:(void (^)(UIImage *pressImg))completion {
    CGFloat targetSize;
    if (quality == EMImageQualityNomal) {
        targetSize = 0.3 * 1024 * 1024;
    }
    else {
        targetSize = 0.15 * 1024 * 1024;
    }
    
    UIImage *img = [self compressToUpload];
    [self compressImg:img
             UnderKib:targetSize
           completion:^(NSData *imgData) {
               if (completion) {
                   completion([UIImage imageWithData:imgData]);
               }
           }];
}

#pragma mark - private
#pragma mark - 图片是否竖直方向长图
- (UIImage *)compressToUpload {
    //图片尺寸
    CGFloat maxImageWidth = [UIScreen mainScreen].bounds.size.width * 2;
    CGFloat maxImageHeight = [UIScreen mainScreen].bounds.size.height * 2;
    CGSize imgSize = self.size;
    CGSize inSize;
    if ([self imageIsVertical]) {
        if (imgSize.width > maxImageWidth) {
            inSize = CGSizeMake(maxImageWidth, imgSize.height*maxImageWidth/imgSize.width);
        }
        else {
            inSize = imgSize;
        }
    }
    else {
        if (imgSize.height > maxImageHeight) {
            inSize = CGSizeMake(imgSize.width*maxImageHeight/imgSize.height, maxImageHeight);
        }
        else {
            inSize = imgSize;
        }
    }
    
    CGSize newSize = [UIImage fitImageSize:imgSize fixSize:inSize];
    if (self.imageOrientation == UIImageOrientationUp){
        if (!CGSizeEqualToSize(imgSize, newSize)) {
            return  [self em_resizeImageToSize:newSize];
        }
        return self;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    NSInteger or = self.imageOrientation;
    switch (or) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (or) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, newSize.width, newSize.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,newSize.height,newSize.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,newSize.width,newSize.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (BOOL)imageIsVertical {
    CGSize imgSize = self.size;
    if (CGSizeEqualToSize(imgSize, CGSizeZero)) {
        return NO;
    }
    CGFloat rate = imgSize.height/imgSize.width;
    if (rate > 1) {
        return YES;
    }
    return NO;
}

+ (CGSize)fitImageSize:(CGSize)thisSize fixSize:(CGSize)aSize {
    CGSize newsize;
    if (thisSize.width <= aSize.width && thisSize.height <= aSize.height) {
        newsize = thisSize;
    }
    else {
        CGFloat scale;
        if (thisSize.width > aSize.width) {
            scale = aSize.width/thisSize.width;
            newsize.width = thisSize.width*scale;
            newsize.height = thisSize.height*scale;
        }
        else {
            newsize = thisSize;
        }
    }
    return newsize;
}

- (UIImage *)em_resizeImageToSize:(CGSize)toSize {
    CGContextRef ctx = CGBitmapContextCreate(NULL, toSize.width, toSize.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    
    CGContextDrawImage(ctx, CGRectMake(0,0,toSize.width,toSize.height), self.CGImage);
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)compressImg:(UIImage *)image
           UnderKib:(CGFloat)ff
         completion:(void (^)(NSData *imgData))completion {
    CGFloat const maxSize = ff;
    __block CGFloat lastParam = 0.6;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = UIImageJPEGRepresentation(image, lastParam);
        while (imgData.length > maxSize) {
            if (lastParam < 0.2) {
                break;
            }
            lastParam -= 0.05;
            imgData = UIImageJPEGRepresentation(image, lastParam);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(imgData);
        });
    });
}

@end
