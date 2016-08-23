//
//  YZShoppingCarGoodsCell.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingCarGoodsCell.h"
#import "YZShoppingCarHelper.h"
#import "SVProgressHUD.h"

@interface YZShoppingCarGoodsCell()<UITextFieldDelegate>

@property (nonatomic, weak) UILabel *titleLb;

@property (nonatomic, weak) UIButton *minusBtn;

@property (nonatomic, weak) UIButton *plusBtn;

@property (nonatomic, weak) UITextField *textField;

@end

@implementation YZShoppingCarGoodsCell
@synthesize detailModel = _detailModel;

- (UIButton *)inner_CreateBtnWithNormalImage:(NSString *)normal disableImage:(NSString *)disable {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:disable] forState:UIControlStateDisabled];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(inner_MinusOrAdd:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setUpContentViewsWithSuperView:(UIView *)superView {
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLb.font = [UIFont systemFontOfSize:14.f];
    titleLb.textColor = [UIColor lightGrayColor];
    titleLb.numberOfLines = 2;
//    titleLb.text = @"英国海洋之星三文鱼配方狗粮五谷天然粮中小型犬12kg小颗粒";
    [superView addSubview:titleLb];
    self.titleLb = titleLb;
    
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(superView).mas_offset(10);
        make.left.mas_equalTo(self.thumbImageV.mas_right).mas_equalTo(5);
        make.width.lessThanOrEqualTo(@150);
        make.height.mas_equalTo(ceil(titleLb.font.lineHeight) * 2 + 2);
    }];
    
    [self.yunfeiLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thumbImageV.mas_right).mas_offset(5);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(self.priceLb);
    }];
    
    UIButton *minusBtn = [self inner_CreateBtnWithNormalImage:@"product_detail_sub_normal"
                                                 disableImage:@"product_detail_sub_no"];
    minusBtn.enabled = NO;
    [superView addSubview:minusBtn];
    self.minusBtn = minusBtn;
    
    UIButton *plusBtn = [self inner_CreateBtnWithNormalImage:@"product_detail_add_normal"
                                                disableImage:@"product_detail_add_no"];
    [superView addSubview:plusBtn];
    self.plusBtn = plusBtn;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clipsToBounds = YES;
    textField.layer.borderColor = [[UIColor colorWithHexCode:@"dddddd"] CGColor];
    textField.layer.borderWidth = 0.5;
    textField.textColor = [UIColor colorWithHexCode:@"333333"];
    textField.font = [UIFont systemFontOfSize:12];
    textField.backgroundColor = [UIColor whiteColor];
    textField.delegate = self;
    [superView addSubview:textField];
    self.textField = textField;
    
    [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLb.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.thumbImageV.mas_right).mas_equalTo(5);
        make.width.mas_equalTo(CGRectGetWidth(minusBtn.frame));
        make.height.mas_equalTo(CGRectGetHeight(minusBtn.frame));
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLb.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(minusBtn.mas_right).mas_equalTo(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(CGRectGetHeight(minusBtn.frame));
    }];
    
    [plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLb.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(textField.mas_right).mas_equalTo(0);
        make.width.mas_equalTo(CGRectGetWidth(minusBtn.frame));
        make.height.mas_equalTo(CGRectGetHeight(minusBtn.frame));
    }];
}

- (void)setDetailModel:(YZShoppingCarModel *)detailModel {
    if (!detailModel) {
        return;
    }
    _detailModel = detailModel;
    self.selectBtn.selected = detailModel.selected;
    YZShoppingCarGoodsModel *goodsModel = (YZShoppingCarGoodsModel *)detailModel;
    self.titleLb.text = [Common filterHTML:goodsModel.name];
    [self.thumbImageV setImageWithURL:[NSURL URLWithString:goodsModel.thumb] placeholderImage:[UIImage imageNamed:@"dog_goods_placeholder"]];
    self.priceLb.text = [[YZShangChengConst sharedInstance].priceNumberFormatter stringFromNumber:[NSNumber numberWithDouble:goodsModel.sellPrice]];
    self.textField.text = [NSString stringWithFormat:@"%ld", (long)detailModel.count];
    if (detailModel.count > 1) {
        self.minusBtn.enabled = YES;
    } else {
        self.minusBtn.enabled = NO;
    }
    if (detailModel.count < 101) {
        self.plusBtn.enabled = YES;
    } else {
        self.plusBtn.enabled = NO;
    }
    [self setNeedsUpdateConstraints];
}

- (void)inner_MinusOrAdd:(UIButton *)sender {
    if ([sender isEqual:self.minusBtn]) {
        if (self.detailModel.count > 1) {
            self.plusBtn.enabled = YES;
            self.detailModel.count -= 1;
            if (self.detailModel.count == 1) {
                self.minusBtn.enabled = NO;
            } else {
                self.minusBtn.enabled = YES;
            }
            [[YZShoppingCarHelper instanceManager] updateShoppingCarGoodsCountWithModel:self.detailModel];
            self.textField.text = [NSString stringWithFormat:@"%ld", (long)self.detailModel.count];
        } else {
            self.minusBtn.enabled = NO;
            self.plusBtn.enabled = YES;
        }
    } else {
        if (self.detailModel.count < 101) {
            self.minusBtn.enabled = YES;
            self.detailModel.count += 1;
            if (self.detailModel.count == 100) {
                self.plusBtn.enabled = NO;
            } else {
                self.plusBtn.enabled = YES;
            }
            [[YZShoppingCarHelper instanceManager] updateShoppingCarGoodsCountWithModel:self.detailModel];
            self.textField.text = [NSString stringWithFormat:@"%ld", (long)self.detailModel.count];
        } else {
            self.minusBtn.enabled = YES;
            self.plusBtn.enabled = NO;
        }
    }
    if (self.detailModel.selected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingCarCalcutePriceNotification
                                                            object:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger number = [textField.text integerValue];
    if (number <= 1) {
        number = 1;
        self.plusBtn.enabled = YES;
        self.minusBtn.enabled = NO;
    } else if (number >= 100) {
        number = 100;
        self.minusBtn.enabled = YES;
        self.plusBtn.enabled = NO;
    } else {
        self.plusBtn.enabled = YES;
        self.minusBtn.enabled = YES;
    }
    self.detailModel.count = number;
    textField.text = [NSString stringWithFormat:@"%ld", (long)self.detailModel.count];
    [[YZShoppingCarHelper instanceManager] updateShoppingCarGoodsCountWithModel:self.detailModel];
    if (self.detailModel.selected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingCarCalcutePriceNotification
                                                            object:nil];
    }
}

@end
