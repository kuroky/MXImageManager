//
//  NSString+MXAdd.m
//  MXImageManager
//
//  Created by kuroky on 2018/1/16.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "NSString+MXAdd.h"

@implementation NSString (MXAdd)

- (NSString *)mx_stringByURLEncode {
    NSCharacterSet *charSet = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *str = [self stringByAddingPercentEncodingWithAllowedCharacters:charSet];
    return str ? str : self;
}

@end
