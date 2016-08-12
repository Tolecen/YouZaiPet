//
//  MarketCollectionViewCell.m
//  TalkingPet
//
//  Created by cc on 16/8/8.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "MarketCollectionViewCell.h"

#import "UIImageView+WebCache.h"

@interface MarketCollectionViewCell()

@property (nonatomic, weak) UIImageView *thumbImageV;
@property (nonatomic, weak) UILabel *titleLb;
@property (nonatomic, weak) UILabel *brandLb;
@property (nonatomic, weak) UILabel *priceLb;
@property (nonatomic, strong) UILabel *labe;
@end
@implementation MarketCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.labe=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        self.labe.font=[UIFont systemFontOfSize:15];
        self.labe.center=CGPointMake(frame.size.width/2, frame.size.height/2);
        self.labe.text=@"加载更多";
        self.labe.textAlignment=NSTextAlignmentCenter;
        self.labe.hidden=YES;
        [self addSubview:self.labe];
        
        
        
        UIView *cardView = [[UIView alloc] init];
        cardView.backgroundColor = [UIColor whiteColor];
        cardView.layer.cornerRadius = 5.f;
        cardView.layer.masksToBounds = YES;
        cardView.layer.masksToBounds=YES;
        cardView.layer.borderWidth=1;
        
        cardView.layer.borderColor=[UIColor colorWithRed:240/250.0 green:240/250.0 blue:240/250.0 alpha:1].CGColor;
        [self.contentView addSubview:cardView];
        
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
        }];
        
        UIImageView *thumbImageV = [[UIImageView alloc] init];
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
        [cardView addSubview:titleLb];
        self.titleLb = titleLb;
        
        CGFloat radio = ScreenWidth / 320;
        
        //        CGFloat height = ceil(titleLb.font.lineHeight * 2) + 1;
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.top.mas_equalTo(thumbImageV.mas_bottom).mas_offset(7 * radio);
            make.right.mas_equalTo(cardView).mas_offset(-5);
            //            make.height.mas_lessThanOrEqualTo(height);
        }];
        
        UILabel *brandLb = [[UILabel alloc] initWithFrame:CGRectZero];
        brandLb.font = [UIFont systemFontOfSize:10.f];
        brandLb.textColor = [UIColor colorWithRed:(181 / 255.f)
                                            green:(181 / 255.f)
                                             blue:(181 / 255.f)
                                            alpha:1.f];
        //        brandLb.text = @"Origen渴望";
        [cardView addSubview:brandLb];
        self.brandLb = brandLb;
        
        [brandLb mas_makeConstraints:^(MASConstraintMaker *make) {
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
        //        priceLb.text = @"¥ 180,000.00";
        [cardView addSubview:priceLb];
        self.priceLb = priceLb;
        
        [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView).mas_offset(5);
            make.bottom.mas_equalTo(cardView).mas_offset(-7 * radio);
        }];
        
    }
    return self;
}




-(void)setModel:(CommodityModel *)model
{
    _model=model;
    
    [self.thumbImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb]placeholderImage:[UIImage imageNamed:@"dog_goods_placeholder"]];
    self.titleLb.text=model.subname;
    //    self.brandLb.text=model.addtime;
    
    switch (model.sale_flag) {
        case 0:
            self.priceLb.text=[NSString stringWithFormat:@"￥%lld",model.sell_price];
            break;
        case 1:
            self.priceLb.text=[NSString stringWithFormat:@"￥%lld",model.special_price];
            break;
        case 2:
            self.priceLb.text=[NSString stringWithFormat:@"￥%lld",model.special_price];
            break;
        case 3:
            self.priceLb.text=[NSString stringWithFormat:@"￥%lld",model.sell_price-model.special_price];
            break;
            
            
            
            
            
            
        default:
            break;
    }
}
-(void)hiedenLabel
{
    self.labe.hidden=NO;
    
}

@end
