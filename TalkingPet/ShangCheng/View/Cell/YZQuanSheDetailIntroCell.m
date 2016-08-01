//
//  YZQuanSheDetailIntroCell.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/29.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZQuanSheDetailIntroCell.h"
#import "Common.h"
@interface YZQuanSheDetailIntroCell()

@property (nonatomic, weak) UIImageView *thumb;
@property (nonatomic, weak) UILabel *nameLb;
@property (nonatomic, weak) UILabel *sexLb;
@property (nonatomic, weak) UILabel *ckuLb;
@property (nonatomic, weak) UILabel *introLb;

@end

@implementation YZQuanSheDetailIntroCell

- (UILabel *)inner_CreateLbWithFont:(CGFloat)fontSize textColor:(UIColor *)color {
    UILabel *lb = [[UILabel alloc] init];
    lb.font = [UIFont systemFontOfSize:fontSize];
    lb.textColor = color;
    return lb;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *thumb = [[UIImageView alloc] init];
        [self.contentView addSubview:thumb];
        self.thumb = thumb;
        
        UIColor *commonGrayColor = [UIColor colorWithRed:(173 / 255.f)
                                                   green:(173 / 255.f)
                                                    blue:(173 / 255.f)
                                                   alpha:1.f];
        UILabel *nameLb = [self inner_CreateLbWithFont:13
                                             textColor:commonGrayColor];
        [self.contentView addSubview:nameLb];
        self.nameLb = nameLb;
        
        UILabel *sexLb = [self inner_CreateLbWithFont:12
                                             textColor:commonGrayColor];
        [self.contentView addSubview:sexLb];
        self.sexLb = sexLb;
        
        UILabel *ckuLb = [self inner_CreateLbWithFont:12
                                             textColor:commonGrayColor];
        [self.contentView addSubview:ckuLb];
        self.ckuLb = ckuLb;
        
        UILabel *introLb = [self inner_CreateLbWithFont:12
                                             textColor:commonGrayColor];
        introLb.numberOfLines = 3;
        [self.contentView addSubview:introLb];
        self.introLb = introLb;
        
        UIImageView *ckuIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cku_icon"]];
        [ckuIcon sizeToFit];
        [self.contentView addSubview:ckuIcon];
        
        [thumb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self.contentView).mas_offset(10);
            make.width.mas_equalTo(95);
            make.height.mas_equalTo(55);
        }];
        
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(thumb.mas_top).mas_offset(2);
            make.left.mas_equalTo(thumb.mas_right).mas_offset(10);
        }];
        
        [sexLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(nameLb.mas_bottom).mas_offset(0);
            make.left.mas_equalTo(nameLb.mas_right).mas_offset(5);
        }];
        
        [ckuIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLb.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(thumb.mas_right).mas_offset(10);
        }];
        
        [ckuLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ckuIcon.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(ckuIcon);
        }];
        
        [introLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(thumb.mas_right).mas_offset(10);
            make.top.mas_equalTo(ckuIcon.mas_bottom).mas_offset(5);
            make.right.mas_equalTo(self.contentView).mas_offset(-10);
            make.height.mas_lessThanOrEqualTo(ceil([UIFont systemFontOfSize:12].lineHeight * 3) + 1);
        }];
    }
    return self;
}

- (void)setParents:(YZDogParents *)parents {
    if (!parents) {
        return;
    }
    _parents = parents;
    self.nameLb.text = parents.name;
    [self.thumb setImageWithURL:[NSURL URLWithString:parents.photos] placeholderImage:[UIImage imageNamed:@"dog_placeholder"]];
    self.ckuLb.text = parents.boodNo;
    self.sexLb.text = parents.sex == YZDogSex_Female ? @"妈妈" : @"爸爸";
    self.introLb.text = [Common filterHTML:parents.details];
    [self setNeedsUpdateConstraints];
}

@end
