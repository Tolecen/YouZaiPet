//
//  UIColor+HexString.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/7.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red / 255.f)
                           green:(green / 255.f)
                            blue:(blue / 255.f)
                           alpha:alpha];
}

+(UIColor *) colorWithHexCode:(NSString *)hexCode
{
    NSString *cleanString = [hexCode stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)commonGrayColor {
    return [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.f];
}

+ (UIColor *)commonPriceColor {
    return [UIColor colorWithRed:(252 / 255.f)
                           green:(88 / 255.f)
                            blue:(67 / 255.f)
                           alpha:1.f];
}

@end
