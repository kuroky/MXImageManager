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
 <#Description#>

 @param urlStr <#urlStr description#>
 @param holder <#holder description#>
 */
- (void)mx_setImageUrl:(NSString *)urlStr
           palceholder:(NSString *)holder;

/**
 <#Description#>

 @param urlStr <#urlStr description#>
 @param size <#size description#>
 @param holder <#holder description#>
 */
- (void)mx_setImageUrl:(NSString *)urlStr
            fittedSize:(CGSize)size
           palceholder:(NSString *)holder;

@end
