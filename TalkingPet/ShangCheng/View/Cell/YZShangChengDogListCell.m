//
//  YZShangChengListCell.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengDogListCell.h"

@interface YZShangChengDogListCell()

@property (nonatomic, weak) UIImageView *thumbImageV;
@property (nonatomic, weak) UILabel *nameLb;
@property (nonatomic, weak) UIImageView *sexImageV;
@property (nonatomic, weak) UILabel *daysNumberLb;
@property (nonatomic, weak) UILabel *priceLb;
@property (nonatomic, weak) UIImageView *birthdayImageV;
@property (nonatomic, weak) UILabel *birthdayLb;
@property (nonatomic, weak) UILabel *areaLb;

@end

@implementation YZShangChengDogListCell

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
        
        UIImageView *thumbImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dog_placeholder"]];
        [cardView addSubview:thumbImageV];
        self.thumbImageV = thumbImageV;
        
        [thumbImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(0);
            make.right.mas_equalTo(cardView).mas_offset(0);
            make.top.mas_equalTo(cardView).mas_offset(0);
            make.height.mas_equalTo(cardView.mas_width);
        }];
        
        UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLb.font = [UIFont systemFontOfSize:12.f];
        nameLb.textColor = [UIColor blackColor];
        nameLb.text = @"迷你牛头梗迷你牛头梗迷你牛头梗";
        [cardView addSubview:nameLb];
        self.nameLb = nameLb;
        
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.top.mas_equalTo(thumbImageV.mas_bottom).mas_offset(5);
            make.width.mas_lessThanOrEqualTo(cardView.mas_width).mas_offset(-27);
        }];
        
        UIImageView *sexImageV = [[UIImageView alloc] init];
        sexImageV.image = [UIImage imageNamed:@"female_icon"];
        [cardView addSubview:sexImageV];
        self.sexImageV = sexImageV;

        [sexImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLb).mas_offset(0);
            make.left.mas_equalTo(nameLb.mas_right).mas_offset(5);
        }];
        
        UILabel *daysNumberLb = [[UILabel alloc] initWithFrame:CGRectZero];
        daysNumberLb.font = [UIFont systemFontOfSize:10.f];
        daysNumberLb.text = @"降临地球111天";
        [cardView addSubview:daysNumberLb];
        self.daysNumberLb = daysNumberLb;
        
        [daysNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.top.mas_equalTo(nameLb.mas_bottom).mas_offset(0);
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
        
        UIImageView *birthdayImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"birthday_icon"]];
        [birthdayImageV sizeToFit];
        [cardView addSubview:birthdayImageV];
        self.birthdayImageV = birthdayImageV;
        
        UILabel *birthdayLb = [[UILabel alloc] initWithFrame:CGRectZero];
        birthdayLb.font = [UIFont systemFontOfSize:10.f];
        birthdayLb.textColor = [UIColor grayColor];
        birthdayLb.text = @"2016.01.11";
        [cardView addSubview:birthdayLb];
        self.birthdayLb = birthdayLb;
        
        UILabel *areaLb = [[UILabel alloc] initWithFrame:CGRectZero];
        areaLb.font = [UIFont systemFontOfSize:10.f];
        areaLb.textColor = [UIColor grayColor];
        areaLb.text = @"华威西里6号楼1011";
        [cardView addSubview:areaLb];
        self.areaLb = areaLb;
        
        [birthdayLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cardView).mas_offset(-5);
            make.centerY.mas_equalTo(priceLb).mas_offset(5);
        }];
        
        [areaLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cardView).mas_offset(-5);
            make.bottom.mas_equalTo(birthdayLb.mas_top).mas_offset(0);
        }];
        
        [birthdayImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(birthdayLb.mas_left).mas_offset(-5);
            make.centerY.mas_equalTo(birthdayLb).mas_offset(0);
        }];
    }
    return self;
}

@end
