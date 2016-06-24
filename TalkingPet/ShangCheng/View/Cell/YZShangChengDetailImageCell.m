//
//  YZShangChengDetailImageCell.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengDetailImageCell.h"

@interface YZShangChengDetailImageCell()

@property (nonatomic, weak) UIImageView *imageV;

@end

@implementation YZShangChengDetailImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dog_placeholder"]];
        [self.contentView addSubview:imageV];
        self.imageV = imageV;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
        }];
    }
    return self;
}

@end
