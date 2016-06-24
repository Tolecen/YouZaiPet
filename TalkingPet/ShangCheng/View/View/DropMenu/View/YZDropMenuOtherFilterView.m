//
//  YZDropMenuOtherFilterView.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/24.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDropMenuOtherFilterView.h"

@interface YZDropMenuOtherFilterView()

@property (nonatomic, weak) UIButton *maleBtn;
@property (nonatomic, weak) UIButton *femaleBtn;
@property (nonatomic, weak) UIButton *confimBtn;

@end

@implementation YZDropMenuOtherFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.f;
        
        UILabel *sexLb = [[UILabel alloc] initWithFrame:CGRectZero];
        sexLb.font = [UIFont systemFontOfSize:12.f];
        sexLb.textColor = [UIColor grayColor];
        sexLb.text = @"性别";
        [self addSubview:sexLb];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectZero];
        sepLine.backgroundColor = [UIColor colorWithRed:(239 / 255.f)
                                                  green:(239 / 255.f)
                                                   blue:(239 / 255.f)
                                                  alpha:1.f];
        [self addSubview:sepLine];
        
        UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLb.font = [UIFont systemFontOfSize:12.f];
        priceLb.textColor = [UIColor grayColor];
        priceLb.text = @"价格";
        [self addSubview:priceLb];
        
        [sexLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.top.mas_equalTo(self).mas_offset(15);
        }];
        
        CGFloat lineHeight = 1 / [UIScreen mainScreen].scale;
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(0);
            make.top.mas_equalTo(sexLb.mas_bottom).mas_offset(15);
            make.right.mas_equalTo(self).mas_offset(0);
            make.height.mas_equalTo(lineHeight);
        }];
        
        [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.top.mas_equalTo(sepLine.mas_bottom).mas_offset(15);
        }];
        
        UIButton *maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [maleBtn setImage:[UIImage imageNamed:@"male_normal_icon"] forState:UIControlStateNormal];
        [maleBtn setImage:[UIImage imageNamed:@"male_select_icon"] forState:UIControlStateSelected];
        [maleBtn addTarget:self action:@selector(inner_SexSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:maleBtn];
        self.maleBtn = maleBtn;
        
        UIButton *femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [femaleBtn setImage:[UIImage imageNamed:@"female_normal_icon"] forState:UIControlStateNormal];
        [femaleBtn setImage:[UIImage imageNamed:@"female_select_icon"] forState:UIControlStateSelected];
        [femaleBtn addTarget:self action:@selector(inner_SexSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:femaleBtn];
        self.femaleBtn = femaleBtn;
        
        [maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sexLb.mas_right).mas_offset(40);
            make.centerY.mas_equalTo(sexLb).mas_offset(0);
        }];
        
        [femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(maleBtn.mas_right).mas_offset(20);
            make.centerY.mas_equalTo(sexLb).mas_offset(0);
        }];
    
        UIButton *firstBtn = [self inner_CreateBtnWithTitle:@"3k以下"];
        UIButton *secondBtn = [self inner_CreateBtnWithTitle:@"3k-5k"];
        UIButton *thirdBtn = [self inner_CreateBtnWithTitle:@"5k-10k"];
        UIButton *fourBtn = [self inner_CreateBtnWithTitle:@"10k以上"];
        
        CGFloat height = 20.f;
        CGFloat width = (ScreenWidth - 35 * 2 - 15 * 3) / 4;
        [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(35);
            make.top.mas_equalTo(priceLb.mas_bottom).mas_offset(20);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        
        [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(firstBtn.mas_right).mas_offset(15);
            make.top.mas_equalTo(priceLb.mas_bottom).mas_offset(20);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        
        [thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(secondBtn.mas_right).mas_offset(15);
            make.top.mas_equalTo(priceLb.mas_bottom).mas_offset(20);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        
        [fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(thirdBtn.mas_right).mas_offset(15);
            make.top.mas_equalTo(priceLb.mas_bottom).mas_offset(20);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        
        UIButton *confimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confimBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confimBtn addTarget:self action:@selector(inner_ConfimSelected:) forControlEvents:UIControlEventTouchUpInside];
        [confimBtn setBackgroundColor:CommonGreenColor];
        confimBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        confimBtn.layer.cornerRadius = 15.f;
        confimBtn.layer.masksToBounds = YES;
        [self addSubview:confimBtn];
        
        [confimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self).mas_offset(0);
            make.top.mas_equalTo(firstBtn.mas_bottom).mas_offset(20);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (UIButton *)inner_CreateBtnWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:CommonGreenColor forState:UIControlStateSelected];
    [button addTarget:self action:@selector(inner_PriceSelected:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:(197 / 255.f)
                                               green:(197 / 255.f)
                                                blue:(197 / 255.f)
                                               alpha:1.f]];
    button.titleLabel.font = [UIFont systemFontOfSize:12.f];
    button.layer.cornerRadius = 10.f;
    button.layer.masksToBounds = YES;
    [self addSubview:button];
    return button;
}

- (void)inner_SexSelected:(UIButton *)sender {
    
}

- (void)inner_PriceSelected:(UIButton *)sender {
    
}

- (void)inner_ConfimSelected:(UIButton *)sender {
    
}

@end
