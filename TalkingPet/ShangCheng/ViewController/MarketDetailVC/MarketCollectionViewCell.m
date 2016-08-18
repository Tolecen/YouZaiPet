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
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIView *cardV;

@property (nonatomic, strong) UILabel *labe;
@end
@implementation MarketCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self = [[NSBundle mainBundle]loadNibNamed:@"MarketCollectionViewCell" owner:self options:nil].lastObject;
        self.cardV.layer.borderWidth=0.6;
        self.cardV.layer.borderColor=[UIColor colorWithRed:0.89 green:0.88 blue:0.89 alpha:1.0].CGColor;
        self.backgroundColor = [UIColor clearColor];
        
        
        
        self.nameLabel.textColor=[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.00];
        
        self.labe=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        self.labe.font=[UIFont systemFontOfSize:10];
        self.labe.center=CGPointMake(frame.size.width/2, frame.size.width/2);
        self.labe.text=@"查看更多";
        self.labe.textColor=[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.00];
        self.labe.textAlignment=NSTextAlignmentCenter;
        self.labe.hidden=YES;
        [self addSubview:self.labe];
    }
    return self;
}




-(void)setModel:(CommodityModel *)model
{
    _model=model;
    
    
    
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.thumb]placeholderImage:[UIImage imageNamed:@"dog_goods_placeholder"]];
    self.nameLabel.text=model.subname;
    //    self.brandLb.text=model.addtime;
    switch (model.sale_flag) {
        case 0:
            self.priceL.text=[NSString stringWithFormat:@"￥%lld",model.sell_price];
            break;
        case 1:
            self.priceL.text=[NSString stringWithFormat:@"￥%lld",model.special_price];
            break;
        case 2:
            self.priceL.text=[NSString stringWithFormat:@"￥%lld",model.special_price];
            break;
        case 3:
            self.priceL.text=[NSString stringWithFormat:@"￥%lld",model.sell_price-model.special_price];
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
