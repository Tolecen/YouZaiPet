//
//  YZShangChengGoodsListCell.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/25.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengGoodsListCell.h"

@interface YZShangChengGoodsListCell()

@property (nonatomic, weak) UIImageView *thumbImageV;
@property (nonatomic, weak) UILabel *titleLb;
@property (nonatomic, weak) UILabel *sourceLb;
@property (nonatomic, weak) UILabel *priceLb;
@property (nonatomic, weak) UIButton *moreBtn;

@end

@implementation YZShangChengGoodsListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *cardView = [[UIView alloc] init];
        cardView.backgroundColor = [UIColor whiteColor];
        cardView.layer.cornerRadius = 5.f;
        cardView.layer.masksToBounds = YES;
        [self.contentView addSubview:cardView];
        
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
        }];
        
        UIImageView *thumbImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dog_goods_placeholder"]];
        [cardView addSubview:thumbImageV];
        self.thumbImageV = thumbImageV;
        
        [thumbImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(0);
            make.right.mas_equalTo(cardView).mas_offset(0);
            make.top.mas_equalTo(cardView).mas_offset(0);
            make.height.mas_equalTo(cardView.mas_width).mas_offset(-10);
        }];
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLb.font = [UIFont systemFontOfSize:12.f];
        titleLb.textColor = [UIColor blackColor];
        titleLb.text = @"WDJ推荐 六星级 Origen渴望";
        [cardView addSubview:titleLb];
        self.titleLb = titleLb;
        
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.top.mas_equalTo(thumbImageV.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(cardView).mas_offset(-5);
        }];
        
        UILabel *sourceLb = [[UILabel alloc] initWithFrame:CGRectZero];
        sourceLb.font = [UIFont systemFontOfSize:10.f];
        sourceLb.textColor = [UIColor grayColor];
        sourceLb.text = @"Origen渴望";
        [cardView addSubview:sourceLb];
        self.sourceLb = sourceLb;
        
        [sourceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.top.mas_equalTo(titleLb.mas_bottom).mas_offset(0);
            make.right.mas_equalTo(cardView).mas_offset(-5);
        }];

        UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLb.font = [UIFont systemFontOfSize:12.f];
        priceLb.textColor = [UIColor redColor];
        priceLb.text = @"¥ 180,000.00";
        [cardView addSubview:priceLb];
        self.priceLb = priceLb;
        
        [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.bottom.mas_equalTo(cardView).mas_offset(-10);
        }];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn setImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(inner_MoreAction:) forControlEvents:UIControlEventTouchUpInside];
        [cardView addSubview:moreBtn];
        self.moreBtn = moreBtn;
        
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cardView).mas_offset(-8);
            make.centerY.mas_equalTo(priceLb.mas_centerY).mas_offset(0);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)inner_MoreAction:(UIButton *)sender {
    
}

@end
