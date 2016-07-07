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
            make.height.mas_equalTo(cardView.mas_width).multipliedBy(0.8);
        }];
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLb.font = [UIFont systemFontOfSize:12.f];
        titleLb.textColor = [UIColor colorWithRed:(102 / 255.f)
                                            green:(102 / 255.f)
                                             blue:(102 / 255.f)
                                            alpha:1.f];
        titleLb.text = @"WDJ推荐 六星级 Origen渴望";
        [cardView addSubview:titleLb];
        self.titleLb = titleLb;
        
        CGFloat radio = ScreenWidth / 320;
        
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.top.mas_equalTo(thumbImageV.mas_bottom).mas_offset(7 * radio);
            make.right.mas_equalTo(cardView).mas_offset(-5);
        }];
        
        UILabel *sourceLb = [[UILabel alloc] initWithFrame:CGRectZero];
        sourceLb.font = [UIFont systemFontOfSize:10.f];
        sourceLb.textColor = [UIColor colorWithRed:(181 / 255.f)
                                             green:(181 / 255.f)
                                              blue:(181 / 255.f)
                                             alpha:1.f];
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
        priceLb.textColor = [UIColor colorWithRed:(252 / 255.f)
                                            green:(88 / 255.f)
                                             blue:(67 / 255.f)
                                            alpha:1.f];
        priceLb.text = @"¥ 180,000.00";
        [cardView addSubview:priceLb];
        self.priceLb = priceLb;
        
        [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.bottom.mas_equalTo(cardView).mas_offset(-7 * radio);
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
