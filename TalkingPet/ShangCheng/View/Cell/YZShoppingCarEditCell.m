//
//  YZShoppingCarEditCell.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/28.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingCarEditCell.h"
#import "YZShoppingCarHelper.h"

@interface YZShoppingCarEditCell()

@property (nonatomic, weak) UIView *containerView;

@end

@implementation YZShoppingCarEditCell

- (void)setUpContentViewsWithSuperView:(UIView *)superView {
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:(243 / 255.f)
                                               green:(243 / 255.f)
                                                blue:(243 / 255.f)
                                               alpha:1.f];
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:containerView];
        self.containerView = containerView;
        
        UIImageView *thumbImageV = [[UIImageView alloc] init];
        [containerView addSubview:thumbImageV];
        self.thumbImageV = thumbImageV;
        
        if ([reuseIdentifier isEqualToString:@"YZShoppingCarDogCell"]) {
            YZQuansheHeaderView *quansheHeaderV = [[YZQuansheHeaderView alloc] init];
            [quansheHeaderV addTarget:self action:@selector(inner_EnterQuanShe:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:quansheHeaderV];
            self.quansheHeaderV = quansheHeaderV;
            [quansheHeaderV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).mas_offset(10);
                make.left.right.equalTo(self.contentView);
                make.height.mas_equalTo(40);
            }];
            
            [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(quansheHeaderV.mas_bottom).mas_offset(0);
                make.left.right.equalTo(self.contentView);
                make.height.mas_equalTo(self.contentView.mas_height).mas_offset(-50);
            }];
            thumbImageV.image = [UIImage imageNamed:@"dog_placeholder"];
        } else {
            [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).mas_offset(10);
                make.left.right.equalTo(self.contentView);
                make.height.mas_equalTo(self.contentView.mas_height).mas_offset(-10);
            }];
            thumbImageV.image = [UIImage imageNamed:@"dog_goods_placeholder"];
        }
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectBtn setImage:[UIImage imageNamed:@"shoppingcar_unselect"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"shoppingcar_select"] forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(inner_Select:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:selectBtn];
        self.selectBtn = selectBtn;
        
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(containerView).mas_offset(10);
            make.centerY.equalTo(containerView);
        }];
        
        [thumbImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView);
            make.left.mas_equalTo(selectBtn.mas_right).mas_offset(10);
            make.height.mas_equalTo(containerView.mas_height);
            make.width.mas_equalTo(containerView.mas_height);
        }];
        
        UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLb.font = [UIFont systemFontOfSize:14.f];
        priceLb.textColor = [UIColor commonPriceColor];
//        priceLb.text = @"¥ 180,000.00";
        [containerView addSubview:priceLb];
        self.priceLb = priceLb;
        
        UILabel *yunfeiLb = [[UILabel alloc] initWithFrame:CGRectZero];
        yunfeiLb.font = [UIFont systemFontOfSize:12.f];
        yunfeiLb.textColor = [UIColor commonGrayColor];
        yunfeiLb.text = @"运费 免运费";
        yunfeiLb.adjustsFontSizeToFitWidth = YES;
        [containerView addSubview:yunfeiLb];
        self.yunfeiLb = yunfeiLb;
        
        [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(containerView).mas_offset(-5);
        }];
        
        [self setUpContentViewsWithSuperView:containerView];
    }
    return self;
}

- (void)inner_EnterQuanShe:(UIButton *)sender {

}

- (void)inner_Select:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.detailModel.selected = sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingCarChangeItemSelectStateNotification
                                                        object:self.detailModel];
}

@end
