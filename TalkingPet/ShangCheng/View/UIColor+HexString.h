//
//  UIColor+HexString.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/7.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexCode:(NSString *)hexCode;

+ (UIColor *)commonGrayColor;

+ (UIColor *)commonPriceColor;

@end
