//
//  YZQuanSheDetailCollectionHeaderView.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/7.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZQuanSheDetailCollectionHeaderView.h"

@interface YZQuanSheDetailCollectionHeaderView()

@property (nonatomic, weak) UILabel *nameLb;

@property (nonatomic, weak) UILabel *numberLb;

@property (nonatomic, weak) UIImageView *avatarImageV;

@property (nonatomic, weak) UIButton *favoriteBtn;

@property (nonatomic, weak) UITextView *textView;

//@property (nonatomic, weak) UIButton *zhiBaoIcon;
//
//@property (nonatomic, weak) UIButton *yiMiaoIcon;
//
//@property (nonatomic, weak) UIButton *baoZhangIcon;

@property (nonatomic, weak) UILabel *priceRangeLb;

@property (nonatomic, weak) UILabel *dogCountLb;

@end

@implementation YZQuanSheDetailCollectionHeaderView

- (void)dealloc {
    _detailModel = nil;
    _ShowQuanSheIntroBlock = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
        containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:containerView];
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self).mas_offset(0);
            make.height.mas_equalTo(180);
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inner_ShowQuanSheIntro:)];
        
        UIImageView *avatarImageV = [[UIImageView alloc] init];
        avatarImageV.backgroundColor = [UIColor redColor];
        avatarImageV.layer.cornerRadius = 5.f;
        avatarImageV.layer.masksToBounds = YES;
        avatarImageV.userInteractionEnabled = YES;
        [avatarImageV addGestureRecognizer:tapGesture];
        [containerView addSubview:avatarImageV];
        self.avatarImageV = avatarImageV;
        
        [avatarImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self).mas_offset(15);
            make.width.height.mas_equalTo(50);
        }];
        
        
        UILabel *nameLb = [[UILabel alloc] init];
        nameLb.font = [UIFont systemFontOfSize:14];
        nameLb.textColor = CommonGreenColor;
//        nameLb.text = @"汉源犬舍";
        [containerView addSubview:nameLb];
        self.nameLb = nameLb;
        
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(avatarImageV);
            make.left.mas_equalTo(avatarImageV.mas_right).mas_offset(10);
        }];
        
        UILabel *numberLb = [[UILabel alloc] init];
        numberLb.font = [UIFont systemFontOfSize:12];
        numberLb.textColor = [UIColor colorWithR:179
                                               g:179
                                               b:179
                                           alpha:1.f];
//        numberLb.text = @"(80999)";
        [containerView addSubview:numberLb];
        self.numberLb = numberLb;
        
        [numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(avatarImageV);
            make.left.mas_equalTo(nameLb.mas_right).mas_offset(5);
        }];
        
        UIButton *favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [favoriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
        favoriteBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [favoriteBtn addTarget:self action:@selector(inner_AddFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [favoriteBtn setTitleColor:CommonGreenColor
                          forState:UIControlStateNormal];
        favoriteBtn.layer.cornerRadius = 14.f;
        favoriteBtn.layer.borderColor = CommonGreenColor.CGColor;
        favoriteBtn.layer.borderWidth = 1.f;
        favoriteBtn.layer.masksToBounds = YES;
        favoriteBtn.hidden = YES;
        [containerView addSubview:favoriteBtn];
        self.favoriteBtn = favoriteBtn;
        
        [favoriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(avatarImageV);
            make.right.mas_equalTo(containerView).mas_offset(-10);
            make.height.mas_equalTo(28);
            make.width.mas_equalTo(50);
        }];
        
        UITextView *textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = NO;
//        textView.text = @"主营犬 迷你雪纳瑞";
        [containerView addSubview:textView];
        self.textView = textView;
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(avatarImageV.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(containerView).mas_offset(10);
            make.right.mas_equalTo(containerView).mas_offset(-10);
            make.height.mas_equalTo(50);
        }];
        
        UIColor *grayColor = [UIColor commonGrayColor];
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = grayColor;
        [containerView addSubview:bottomLine];
        
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textView.mas_bottom).mas_offset(0);
            make.left.right.mas_equalTo(containerView).mas_offset(0);
            make.height.mas_equalTo(.5);
        }];
        
        UIColor *introTextColor = [UIColor colorWithR:163
                                                    g:163
                                                    b:163
                                                alpha:1.f];
        
        UILabel *priceIntroLb = [[UILabel alloc] init];
        priceIntroLb.text = @"价格区间";
        priceIntroLb.font = [UIFont systemFontOfSize:10.f];
        priceIntroLb.textColor = introTextColor;
        [containerView addSubview:priceIntroLb];
        
        [priceIntroLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(containerView).mas_offset(10);
            make.top.mas_equalTo(bottomLine.mas_bottom).mas_offset(7);
        }];
        
        UIView *verticalLine = [[UIView alloc] init];
        verticalLine.backgroundColor = grayColor;
        [containerView addSubview:verticalLine];
        
        [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(containerView);
            make.top.mas_equalTo(bottomLine.mas_bottom).mas_offset(0);
            make.bottom.mas_equalTo(containerView).mas_offset(0);
            make.width.mas_equalTo(.5);
        }];

        UILabel *sellDogCountLb = [[UILabel alloc] init];
        sellDogCountLb.text = @"在售狗狗";
        sellDogCountLb.font = [UIFont systemFontOfSize:10.f];
        sellDogCountLb.textColor = introTextColor;
        [containerView addSubview:sellDogCountLb];
        
        [sellDogCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(verticalLine.mas_right).mas_offset(10);
            make.top.mas_equalTo(bottomLine.mas_bottom).mas_offset(7);
        }];
        
        UIColor *commonPriceColor = [UIColor commonPriceColor];
        CGFloat offset = ScreenWidth / 4;

        UILabel *priceRangeLb = [[UILabel alloc] init];
//        priceRangeLb.text = @"¥4000-¥100000";
        priceRangeLb.font = [UIFont systemFontOfSize:12.f];
        priceRangeLb.textColor = commonPriceColor;
        [containerView addSubview:priceRangeLb];
        self.priceRangeLb = priceRangeLb;
        
        [priceRangeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(containerView).mas_offset(-offset);
            make.top.mas_equalTo(priceIntroLb.mas_bottom).mas_offset(10);
        }];
        
        UILabel *dogCountLb = [[UILabel alloc] init];
//        dogCountLb.text = @"8只";
        dogCountLb.font = [UIFont systemFontOfSize:12.f];
        dogCountLb.textColor = commonPriceColor;
        [containerView addSubview:dogCountLb];
        self.dogCountLb = dogCountLb;
        
        [dogCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(containerView).mas_offset(offset);
            make.top.mas_equalTo(sellDogCountLb.mas_bottom).mas_offset(10);
        }];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        bottomView.backgroundColor = grayColor;
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self).mas_offset(0);
            make.top.mas_equalTo(containerView.mas_bottom).mas_offset(0);
        }];
    }
    return self;
}

- (void)setDetailModel:(YZQuanSheDetailModel *)detailModel {
    if (!detailModel || _detailModel == detailModel) {
        return;
    }
    _detailModel = detailModel;
    self.nameLb.text = detailModel.shopName;
    self.numberLb.text = [NSString stringWithFormat:@"(%lld)", detailModel.shopNo];
    self.textView.text = detailModel.dogIntro;
    self.dogCountLb.text = detailModel.sale;
    self.priceRangeLb.text = @"¥10 - ¥10000";
    [self.avatarImageV setImageWithURL:[NSURL URLWithString:detailModel.thumb] placeholderImage:[UIImage imageNamed:@"dog_placeholder"]];
    [self setNeedsUpdateConstraints];
}

- (void)inner_AddFavorite:(UIButton *)sender {
    
}

- (void)inner_ShowQuanSheIntro:(UITapGestureRecognizer *)gesture {
    self.ShowQuanSheIntroBlock();
}

@end
