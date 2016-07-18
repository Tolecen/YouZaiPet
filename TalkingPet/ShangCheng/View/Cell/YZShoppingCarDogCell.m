//
//  YZShoppingCarDogCell.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingCarDogCell.h"

@interface YZShoppingCarDogCell()

@property (nonatomic, weak) UILabel *nameLb;
@property (nonatomic, weak) UIImageView *sexImageV;

@property (nonatomic, weak) UILabel *birthdayLb;
@property (nonatomic, weak) UIImageView *birthdayImageV;
@property (nonatomic, weak) UILabel *daysNumberLb;

@end

@implementation YZShoppingCarDogCell
@synthesize detailModel = _detailModel;

- (void)setUpContentViewsWithSuperView:(UIView *)superView {
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLb.font = [UIFont systemFontOfSize:12.f];
    nameLb.textColor = [UIColor blackColor];
//    nameLb.text = @"迷你牛头梗迷你牛头梗迷你牛头梗迷你牛头梗";
    [superView addSubview:nameLb];
    self.nameLb = nameLb;
    
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thumbImageV.mas_right).mas_offset(5);
        make.top.mas_equalTo(superView).mas_offset(10);
        make.width.lessThanOrEqualTo(@150);
    }];
    
    UIImageView *sexImageV = [[UIImageView alloc] init];
    sexImageV.image = [UIImage imageNamed:@"female_icon"];
    [superView addSubview:sexImageV];
    self.sexImageV = sexImageV;
    
    [sexImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLb).mas_offset(0);
        make.left.mas_equalTo(nameLb.mas_right).mas_offset(5);
    }];
    
    UILabel *daysNumberLb = [[UILabel alloc] initWithFrame:CGRectZero];
//    daysNumberLb.text = @"降临地球111天";
    [superView addSubview:daysNumberLb];
    self.daysNumberLb = daysNumberLb;
    
    UIImageView *birthdayImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"birthday_icon"]];
    [birthdayImageV sizeToFit];
    [superView addSubview:birthdayImageV];
    self.birthdayImageV = birthdayImageV;
    
    UILabel *birthdayLb = [[UILabel alloc] initWithFrame:CGRectZero];
    birthdayLb.font = [UIFont systemFontOfSize:10.f];
    birthdayLb.textColor = [UIColor commonGrayColor];
//    birthdayLb.text = @"2016.01.11";
    [superView addSubview:birthdayLb];
    self.birthdayLb = birthdayLb;
    
    [daysNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thumbImageV.mas_right).mas_offset(5);
        make.top.mas_equalTo(nameLb.mas_bottom).mas_offset(5);
    }];
    
    [birthdayImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thumbImageV.mas_right).mas_offset(5);
        make.top.mas_equalTo(daysNumberLb.mas_bottom).mas_offset(5);
    }];
    
    [birthdayLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(birthdayImageV.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(birthdayImageV.mas_centerY).mas_offset(0);
    }];
}

- (void)setDetailModel:(YZShoppingCarModel *)detailModel {
    if (!detailModel) {
        return;
    }
    _detailModel = detailModel;
    self.selectBtn.selected = detailModel.selected;
    YZDogModel *dogModel = [(YZShoppingCarDogModel *)detailModel shoppingCarItem];
    [self.thumbImageV setImageWithURL:[NSURL URLWithString:dogModel.thumb]
                     placeholderImage:[UIImage imageNamed:@"dog_placeholder"]];
    self.nameLb.text = dogModel.name;
    self.sexImageV.image = (dogModel.sex == YZDogSex_Female) ? [UIImage imageNamed:@"female_icon"] : [UIImage imageNamed:@"male_icon"];
    self.birthdayLb.text = dogModel.birthdayString;
    self.priceLb.text = [[YZShangChengConst sharedInstance].priceNumberFormatter stringFromNumber:[NSNumber numberWithDouble:dogModel.sellPrice]];
    NSString *daysNumberString = [NSString stringWithFormat:@"降临地球 %ld 天", (unsigned long)dogModel.birtydayDays];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:daysNumberString];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName: self.daysNumberLb.textColor} range:NSMakeRange(0, 4)];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.f], NSForegroundColorAttributeName: CommonGreenColor} range:NSMakeRange(4, daysNumberString.length - 5)];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName: self.daysNumberLb.textColor} range:NSMakeRange(daysNumberString.length - 1, 1)];
    self.daysNumberLb.attributedText = attr;
    self.quansheHeaderV.quanSheModel = dogModel.shop;
    [self setNeedsUpdateConstraints];
}

@end
