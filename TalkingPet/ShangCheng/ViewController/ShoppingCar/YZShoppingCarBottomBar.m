//
//  YZShoppingCarBottomBar.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/13.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingCarBottomBar.h"

@interface YZShoppingCarBottomBar()

@property (nonatomic, weak) UILabel *priceLb;
@property (nonatomic, weak) UIButton *selectAllBtn;
@property (nonatomic, assign) YZShoppingCarBottomBarStyle style;

@end

@implementation YZShoppingCarBottomBar

- (instancetype)initWithStyle:(YZShoppingCarBottomBarStyle)style {
    if (self = [super init]) {
        UIButton *clearPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearPriceBtn setImage:[UIImage imageNamed:@"jiesuan_icon"] forState:UIControlStateNormal];
        clearPriceBtn.backgroundColor = CommonGreenColor;
        [clearPriceBtn addTarget:self action:@selector(inner_ClearPrice:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearPriceBtn];
        
        CGFloat width = ScreenWidth / 3;
        [clearPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(self).mas_offset(0);
            make.width.mas_equalTo(width);
        }];
        
        UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLb.font = [UIFont systemFontOfSize:14.f];
        priceLb.text = @"¥ 0.0";
        priceLb.textColor = [UIColor commonPriceColor];
        [self addSubview:priceLb];
        self.priceLb = priceLb;

        UILabel *totalLb = [[UILabel alloc] init];
        totalLb.font = [UIFont systemFontOfSize:12.f];
        totalLb.textColor = [UIColor commonGrayColor];
        totalLb.text = @"总计:";
        [self addSubview:totalLb];
        
        if (style == YZShoppingCarBottomBarStyle_ShoppingCar) {
            [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(clearPriceBtn.mas_left).mas_offset(-5);
                make.centerY.mas_equalTo(self);
            }];
            
            [totalLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(priceLb.mas_left).mas_offset(-5);
                make.centerY.mas_equalTo(self);
            }];
            
            UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [selectBtn setImage:[UIImage imageNamed:@"shoppingcar_unselect"] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:@"shoppingcar_select"] forState:UIControlStateSelected];
            [selectBtn addTarget:self action:@selector(inner_SelectAll:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:selectBtn];
            self.selectAllBtn = selectBtn;
            
            [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).mas_offset(10);
                make.centerY.equalTo(self);
            }];
        } else {
            [totalLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).mas_offset(10);
                make.centerY.mas_equalTo(self);
            }];
            
            [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(totalLb.mas_right).mas_offset(5);
                make.centerY.mas_equalTo(self);
            }];
        }
    }
    return self;
}

- (void)inner_ClearPrice:(UIButton *)sender {
    [self.delegate shoppingCarClearPrice];
}

- (void)inner_SelectAll:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.delegate shoppingCarSelectAllWithSelectState:sender.selected];
}

- (void)changeSelectBtnState:(BOOL)state {
    self.selectAllBtn.selected = state;
}

- (void)resetTotalPrice:(long long)totalPrice {
    self.priceLb.text = [NSString stringWithFormat:@"%lld", totalPrice];
}

@end
