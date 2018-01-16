//
//  UIImageView+MXAdd.m
//  MXImageManager
//
//  Created by kuroky on 2018/1/15.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "UIImageView+MXAdd.h"
#import <UIImageView+WebCache.h>
#import "UIImage+MXAdd.h"

@implementation UIImageView (MXAdd)

//MARK:- <#name#>
- (void)mx_setImageUrl:(NSString *)urlStr
           palceholder:(NSString *)holder {
    if (!urlStr.length) {
        self.image = [UIImage imageNamed:holder];
        return;
    }
    
    urlStr = [self urlEncode:urlStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self setImageURL:url
          placeholder:[UIImage imageNamed:holder]];
}

//MARK:- <#name#>
- (void)mx_setImageUrl:(NSString *)urlStr
            fittedSize:(CGSize)size
           palceholder:(NSString *)holder {
    if (!urlStr.length) {
        self.image = [UIImage imageNamed:holder];
        return;
    }
    urlStr = [self urlEncode:urlStr];
    NSString *sizeImagekey = [self cropFromPath:urlStr cropSize:size];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:sizeImagekey];
    if (cacheImage) {
        self.image = cacheImage;
        [self setNeedsLayout];
        return;
    }
    
    __weak __typeof(self)weakself = self;
    NSURL *url = [NSURL URLWithString:urlStr];
    [self sd_setImageWithURL:url
            placeholderImage:[UIImage imageNamed:holder]
                     options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageAvoidAutoSetImage
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (!weakself) {
                           return;
                       }
                       if (image) {
                           [weakself cropDownloadImage:image
                                            expectSize:size
                                               saveKey:sizeImagekey];
                           [[SDImageCache sharedImageCache] removeImageForKey:imageURL.absoluteString
                                                                     fromDisk:NO
                                                               withCompletion:nil];
                       }
                       else {
                           weakself.image = [UIImage imageNamed:holder];
                           [weakself setNeedsLayout];
                       }
                   }];
}

- (void)setImageURL:(NSURL *)url
        placeholder:(UIImage *)placeholder {
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

//MARK:- Url Encode
- (NSString *)urlEncode:(NSString *)str {
    NSCharacterSet *charSet = [NSCharacterSet URLFragmentAllowedCharacterSet];
    //"#%<>[\]^`{|}
    NSString *newString = [str stringByAddingPercentEncodingWithAllowedCharacters:charSet];
    if (newString) {
        return newString;
    }
    return str;
}

- (NSString *)cropFromPath:(NSString *)path
                  cropSize:(CGSize)size {
    NSString *sizeStr = [NSString stringWithFormat:@"_%.0f_%.0f",size.width,size.height];
    NSString *pathStr = [[path stringByDeletingPathExtension] stringByAppendingString:sizeStr];
    NSString *extensionStr = [path pathExtension];
    NSString *str = @"";
    if (extensionStr) {
        str = [pathStr stringByAppendingPathExtension:extensionStr];
    }
    else {
        str = pathStr;
    }
    return str;
}

//MARK:- 本地裁切图片
- (void)cropDownloadImage:(UIImage *)originImage
               expectSize:(CGSize)size
                  saveKey:(NSString *)key {
    UIImage *resizeImage = [originImage mx_imageResize:size
                                           contentMode:UIViewContentModeScaleAspectFill];
    [[SDWebImageManager sharedManager] saveImageToCache:resizeImage
                                                 forURL:[NSURL URLWithString:key]];
    self.image = resizeImage;
    [self setNeedsLayout];
}

@end
