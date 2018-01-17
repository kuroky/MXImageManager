//
//  NSString+MXAdd.h
//  MXImageManager
//
//  Created by kuroky on 2018/1/16.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MXAdd)

/**
 *  URL 编码成 utf-8 string.
 *
 *  @return encoded string
 */
- (NSString *)mx_stringByURLEncode;

@end
