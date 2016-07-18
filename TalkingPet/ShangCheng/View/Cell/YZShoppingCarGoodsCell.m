//
//  YZShoppingCarGoodsCell.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingCarGoodsCell.h"

@interface YZShoppingCarGoodsCell()

@property (nonatomic, weak) UILabel *titleLb;

@end

@implementation YZShoppingCarGoodsCell
@synthesize detailModel = _detailModel;

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
        make.right.mas_equalTo(superView).mas_equalTo(-5);
        make.height.mas_equalTo(ceil(titleLb.font.lineHeight) * 2 + 2);
    }];
}

- (void)setDetailModel:(YZShoppingCarModel *)detailModel {
    if (!detailModel) {
        return;
    }
    _detailModel = detailModel;
    self.selectBtn.selected = detailModel.selected;
    YZGoodsDetailModel *goodsModel = [(YZShoppingCarGoodsModel *)detailModel shoppingCarItem];
    self.titleLb.text = goodsModel.name;
    [self.thumbImageV setImageWithURL:[NSURL URLWithString:goodsModel.thumb] placeholderImage:[UIImage imageNamed:@"dog_goods_placeholder"]];
    self.priceLb.text = [[YZShangChengConst sharedInstance].priceNumberFormatter stringFromNumber:[NSNumber numberWithDouble:goodsModel.sellPrice]];
    [self setNeedsUpdateConstraints];
}

@end
