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
            make.height.mas_equalTo(cardView.mas_width).multipliedBy(0.8);//图片 w / h = 5 / 4;
        }];
        
        UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLb.font = [UIFont systemFontOfSize:12.f];
        nameLb.textColor = [UIColor colorWithRed:(102 / 255.f)
                                           green:(102 / 255.f)
                                            blue:(102 / 255.f)
                                           alpha:1.f];
        nameLb.text = @"迷你牛头梗迷你牛头梗迷你牛头梗";
        [cardView addSubview:nameLb];
        self.nameLb = nameLb;
        
        CGFloat radio = ScreenWidth / 320;
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.top.mas_equalTo(thumbImageV.mas_bottom).mas_offset(7 * radio);
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
        daysNumberLb.textColor = [UIColor colorWithRed:(181 / 255.f)
                                                 green:(181 / 255.f)
                                                  blue:(181 / 255.f)
                                                 alpha:1.f];
        daysNumberLb.text = @"降临地球111天";
        [cardView addSubview:daysNumberLb];
        self.daysNumberLb = daysNumberLb;
        
        [daysNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.top.mas_equalTo(nameLb.mas_bottom).mas_offset(0);
        }];
        
        UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLb.font = [UIFont systemFontOfSize:12.f];
        priceLb.adjustsFontSizeToFitWidth = YES;
        priceLb.textColor = [UIColor colorWithRed:(252 / 255.f)
                                            green:(88 / 255.f)
                                             blue:(67 / 255.f)
                                            alpha:1.f];
        priceLb.text = @"¥ 180,000";
        [cardView addSubview:priceLb];
        self.priceLb = priceLb;
        
        [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.bottom.mas_equalTo(cardView).mas_offset(-7 * radio);
            make.width.mas_equalTo(cardView).multipliedBy(0.5);
        }];
        
        UIImageView *birthdayImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"birthday_icon"]];
        [birthdayImageV sizeToFit];
        [cardView addSubview:birthdayImageV];
        self.birthdayImageV = birthdayImageV;
        
        UILabel *birthdayLb = [[UILabel alloc] initWithFrame:CGRectZero];
        birthdayLb.font = [UIFont systemFontOfSize:10.f];
        birthdayLb.textColor = [UIColor colorWithRed:(188 / 255.f)
                                               green:(188 / 255.f)
                                                blue:(188 / 255.f)
                                               alpha:1.f];
        birthdayLb.adjustsFontSizeToFitWidth = YES;
        birthdayLb.text = @"2016.01.11";
        [cardView addSubview:birthdayLb];
        self.birthdayLb = birthdayLb;
        
        UILabel *areaLb = [[UILabel alloc] initWithFrame:CGRectZero];
        areaLb.font = [UIFont systemFontOfSize:10.f];
        areaLb.textColor = [UIColor colorWithRed:(188 / 255.f)
                                           green:(188 / 255.f)
                                            blue:(188 / 255.f)
                                           alpha:1.f];
        areaLb.textAlignment = NSTextAlignmentRight;
        areaLb.text = @"华威西里6号楼1011";
        [cardView addSubview:areaLb];
        self.areaLb = areaLb;
        
        [birthdayLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(priceLb.mas_bottom).mas_offset(1);
            make.right.mas_equalTo(cardView.mas_right).mas_offset(-5);
            make.width.mas_lessThanOrEqualTo(cardView).multipliedBy(0.5);
        }];
        
        [areaLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cardView.mas_right).mas_offset(-5);
            make.width.mas_lessThanOrEqualTo(cardView).multipliedBy(0.5);
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
