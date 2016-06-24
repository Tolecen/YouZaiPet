//
//  YZDropMenuOtherFilterView.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/24.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDropMenuOtherFilterView.h"

@interface YZDropMenuOtherFilterView()

@end

@implementation YZDropMenuOtherFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *sexLb = [[UILabel alloc] initWithFrame:CGRectZero];
        sexLb.font = [UIFont systemFontOfSize:12.f];
        sexLb.textColor = [UIColor grayColor];
        sexLb.text = @"性别";
        [self addSubview:sexLb];
        
        UIImageView *sepLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        sepLine.backgroundColor = [UIColor grayColor];
        [self addSubview:sepLine];
        
        UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLb.font = [UIFont systemFontOfSize:12.f];
        priceLb.textColor = [UIColor grayColor];
        priceLb.text = @"价格";
        [self addSubview:priceLb];
        
        [sexLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.top.mas_equalTo(self).mas_offset(10);
        }];
        
        CGFloat lineHeight = 1 / [UIScreen mainScreen].scale;
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(0);
            make.top.mas_equalTo(sexLb.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(self).mas_offset(0);
            make.height.mas_equalTo(lineHeight);
        }];
        
        [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.top.mas_equalTo(sepLine.mas_bottom).mas_offset(10);
        }];
    }
    return self;
}

@end
