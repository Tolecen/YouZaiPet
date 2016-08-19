//
//  YZQuanSheSearchListCell.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/12.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZQuanSheSearchListCell.h"

@interface YZQuanSheSearchListCell()

@property (nonatomic, weak) UIImageView *thumbImageV;

@property (nonatomic, weak) UILabel *nameLb;

@property (nonatomic, weak) UILabel *numberLb;

@property (nonatomic, weak) UIButton *enterBtn;

@property (nonatomic, weak) UILabel *shopIntroLb;

@property (nonatomic, weak) UILabel *sellIntroLb;

@end

@implementation YZQuanSheSearchListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:containerView];
        containerView.layer.cornerRadius = 3.f;
        containerView.layer.masksToBounds = YES;
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        }];
        
        
        UIImageView *thumbImageV = [[UIImageView alloc] init];
        [containerView addSubview:thumbImageV];
        self.thumbImageV = thumbImageV;
        
        [thumbImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(containerView).mas_offset(10);
            make.width.height.mas_equalTo(60);
        }];
        
        UILabel *nameLb = [[UILabel alloc] init];
        nameLb.font = [UIFont systemFontOfSize:14.f];
        nameLb.textColor = [UIColor blackColor];
        [containerView addSubview:nameLb];
        self.nameLb = nameLb;
        
        UILabel *numberLb = [[UILabel alloc] init];
        numberLb.font = [UIFont systemFontOfSize:12.f];
        numberLb.textColor = [UIColor blackColor];
        [containerView addSubview:numberLb];
        self.numberLb = numberLb;
        
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(thumbImageV.mas_right).mas_offset(10);
            make.top.mas_equalTo(thumbImageV.mas_top).mas_offset(0);
        }];
        
        [numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLb.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(nameLb).mas_offset(0);
        }];
        
        
        
        UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [enterBtn setTitle:@"进入犬舍" forState:UIControlStateNormal];
        enterBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [enterBtn addTarget:self action:@selector(inner_EnterQuanShe:) forControlEvents:UIControlEventTouchUpInside];
        [enterBtn setTitleColor:CommonGreenColor
                       forState:UIControlStateNormal];
        [enterBtn sizeToFit];
        enterBtn.layer.cornerRadius = CGRectGetHeight(enterBtn.frame) / 2;
        enterBtn.layer.borderColor = CommonGreenColor.CGColor;
        enterBtn.layer.borderWidth = 1.f;
        enterBtn.layer.masksToBounds = YES;
        [containerView addSubview:enterBtn];
        self.enterBtn = enterBtn;
        
        [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(thumbImageV).mas_offset(0);
            make.right.mas_equalTo(containerView).mas_offset(-10);
            make.width.mas_equalTo(CGRectGetWidth(enterBtn.frame) + 10);
        }];
        
        UIImageView *quanSheIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quanshe_gou_icon"]];
        [quanSheIcon sizeToFit];
        [containerView addSubview:quanSheIcon];
        
        [quanSheIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(thumbImageV.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(thumbImageV).mas_offset(0);
            make.width.mas_equalTo(CGRectGetWidth(quanSheIcon.frame));
            make.height.mas_equalTo(CGRectGetHeight(quanSheIcon.frame));
        }];
        
        UILabel *shopIntroLb = [[UILabel alloc] init];
        shopIntroLb.font = [UIFont systemFontOfSize:12.f];
        shopIntroLb.textColor = [UIColor blackColor];
        [containerView addSubview:shopIntroLb];
        self.shopIntroLb = shopIntroLb;
        
        [shopIntroLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(quanSheIcon.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(quanSheIcon).mas_offset(0);
            make.right.mas_equalTo(enterBtn.mas_left).mas_offset(-5);
        }];
        
        UILabel *sellIntroLb = [[UILabel alloc] init];
        sellIntroLb.font = [UIFont systemFontOfSize:12.f];
        sellIntroLb.textColor = [UIColor blackColor];
        [containerView addSubview:sellIntroLb];
        self.sellIntroLb = sellIntroLb;
        
        [sellIntroLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(thumbImageV.mas_right).mas_offset(10);
            make.bottom.mas_equalTo(thumbImageV.mas_bottom).mas_offset(0);
        }];
    }
    return self;
}

- (void)setQuanSheModel:(YZQuanSheModel *)quanSheModel {
    if (!quanSheModel) {
        return;
    }
    _quanSheModel = quanSheModel;
    [self.thumbImageV setImageWithURL:[NSURL URLWithString:quanSheModel.thumb] placeholderImage:[UIImage imageNamed:@"dog_placeholder"]];
    self.nameLb.text = quanSheModel.shopName;
    self.numberLb.text = [NSString stringWithFormat:@"(%lld)", quanSheModel.shopNo];
    self.shopIntroLb.text = quanSheModel.dogIntro;
    self.sellIntroLb.text = @"售出N只";
    [self setNeedsUpdateConstraints];
}
-(void)inner_EnterQuanShe:(UIButton *)btn
{
    self.block();
}


@end
