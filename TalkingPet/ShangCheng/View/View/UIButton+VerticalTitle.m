//
//  UIButton+VerticalTitle.m
//  ShunPaiOC
//
//  Created by LiuXiaoyu on 2016/6/3.
//  Copyright © 2016年 cn.com.uzero. All rights reserved.
//

#import "UIButton+VerticalTitle.h"

@implementation UIButton (VerticalTitle)

- (void)verticalImageAndTitle:(CGFloat)spacing {
    self.titleLabel.backgroundColor = [UIColor clearColor];
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    CGRect frame = self.frame;
    frame.size.height = totalHeight;
    self.frame = frame;
}

@end
