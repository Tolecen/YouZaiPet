//
//  YZQuansheHeaderView.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/28.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZQuansheHeaderView.h"

@interface YZQuansheHeaderView()

@property (nonatomic, weak) UIImageView *avatar;
@property (nonatomic, weak) UILabel *titleLb;
@property (nonatomic, weak) UILabel *numberLb;

@end

@implementation YZQuansheHeaderView

- (void)dealloc {
    _quanSheModel = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dog_placeholder"]];
        avatar.layer.cornerRadius = 3.f;
        avatar.layer.masksToBounds = YES;
        [self addSubview:avatar];
        self.avatar = avatar;
        
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.font = [UIFont systemFontOfSize:14.f];
        titleLb.textColor = [UIColor blackColor];
//        titleLb.text = @"汉源犬舍";
        [self addSubview:titleLb];
        self.titleLb = titleLb;
        
        UILabel *numberLb = [[UILabel alloc] init];
        numberLb.font = [UIFont systemFontOfSize:12.f];
        numberLb.textColor = [UIColor blackColor];
//        numberLb.text = @"(87499)";
        [self addSubview:numberLb];
        self.numberLb = numberLb;
        
        [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(30);
        }];
        
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatar.mas_right).mas_offset(10);
            make.centerY.equalTo(self);
        }];
        
        [numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLb.mas_right).mas_offset(5);
            make.centerY.equalTo(self);
        }];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setQuanSheModel:(YZQuanSheModel *)quanSheModel {
    if (!quanSheModel) {
        return;
    }
    _quanSheModel = quanSheModel;
    self.titleLb.text = quanSheModel.shopName;
    self.numberLb.text = [NSString stringWithFormat:@"(%lld)", quanSheModel.shopNo];
    [self.avatar setImageWithURL:[NSURL URLWithString:quanSheModel.thumb] placeholderImage:[UIImage imageNamed:@"dog_placeholder"]];
    [self setNeedsUpdateConstraints];
}

@end
