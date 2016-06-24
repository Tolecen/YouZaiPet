//
//  YZDogKindCollectionViewCell.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/25.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDogKindCollectionViewCell.h"

@interface YZDogKindCollectionViewCell()

@property (nonatomic, weak) UIImageView *imageV;

@end

@implementation YZDogKindCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dog_placeholder"]];
        [self.contentView addSubview:imageV];
        self.imageV = imageV;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.contentView).mas_offset(0);
            make.height.mas_equalTo(self.contentView.mas_width);
        }];
        
        UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLb.textColor = [UIColor lightGrayColor];
        nameLb.font = [UIFont systemFontOfSize:10.f];
        nameLb.text = @"拉布拉多";
        nameLb.adjustsFontSizeToFitWidth = YES;
        nameLb.textAlignment = NSTextAlignmentCenter;
        nameLb.numberOfLines = 2;
        [self.contentView addSubview:nameLb];
        
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(self.contentView).mas_offset(0);
            make.top.mas_equalTo(imageV.mas_bottom).mas_offset(0);
        }];
    }
    return self;
}

@end
