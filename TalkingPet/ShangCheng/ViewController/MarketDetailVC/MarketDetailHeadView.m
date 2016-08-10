//
//  MarketDetailHeadView.m
//  TalkingPet
//
//  Created by cc on 16/8/8.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "MarketDetailHeadView.h"
#import "UIImageView+WebCache.h"
@interface MarketDetailHeadView()
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIImageView *bgimg;
@property(nonatomic,strong)UILabel *titileL;
@property(nonatomic,strong)UILabel *subtitleL;
@property(nonatomic,strong)UILabel *price;
@property(nonatomic,strong)UILabel *turePrice;
@end
@implementation MarketDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        CGFloat with=150;
        _bgimg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dog_placeholder"]];
        _bgimg.frame=CGRectMake(10, 10, with, frame.size.height-20);
//        _bgimg.backgroundColor=[UIColor blueColor];
        
        
        [self addSubview:_bgimg];
        
        
        
        
        _bgimg.userInteractionEnabled=YES;
        
        
        UIButton *bgbtn=[UIButton buttonWithType:UIButtonTypeSystem];
        bgbtn.frame=CGRectMake(0, 0, 50, 50);
        bgbtn.layer.masksToBounds=YES;
        bgbtn.layer.cornerRadius=25;
        [bgbtn setTitle:@"热销" forState:UIControlStateNormal];
        [bgbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bgbtn.backgroundColor=[UIColor colorWithRed:255/255.0 green:205/255.0 blue:51/255.0 alpha:1];
        [_bgimg addSubview:bgbtn];
        
        
        
        
        
        
        _titileL=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bgimg.frame)+20, 15, ScreenWidth-190, 20)];

        _titileL.text=@"网红汪都在吃的宠物粮";
        [self addSubview:_titileL];
        
        _subtitleL=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bgimg.frame)+20, 35, ScreenWidth-190, 40)];
        _subtitleL.adjustsFontSizeToFitWidth=YES;
        _subtitleL.text=@"Natural Balance 美国雪山 L.I.D抗郭明系列 3 KG";

        _subtitleL.numberOfLines=2;
        _subtitleL.textColor=[UIColor lightGrayColor];
        _subtitleL.font=[UIFont systemFontOfSize:10];
        [self addSubview:_subtitleL];
        
        
        UILabel *titll1=[[UILabel alloc] initWithFrame:CGRectMake(_subtitleL.center.x, 80, 40, 20)];
        titll1.text=@"市场价：";
        titll1.textColor=[UIColor lightGrayColor];
        titll1.font=[UIFont systemFontOfSize:10];
        [self addSubview:titll1];
        
        
        self.price=[[UILabel alloc] initWithFrame:CGRectMake(_subtitleL.center.x+40, 80, 50, 20)];
        [self addSubview:_price];

        
        
        
        
        UILabel *titll2=[[UILabel alloc] initWithFrame:CGRectMake(_subtitleL.center.x-20, 110, 40, 20)];
        titll2.text=@"友仔价：";
        titll2.textColor=[UIColor lightGrayColor];
        titll2.font=[UIFont systemFontOfSize:10];
        [self addSubview:titll2];
        
        self.turePrice=[[UILabel alloc] initWithFrame:CGRectMake(_subtitleL.center.x+20, 105, 70, 20)];
        self.turePrice.textColor=[UIColor redColor];
        self.turePrice.font=[UIFont systemFontOfSize:18];
        [self addSubview:_turePrice];

        
        
        
        
        
        _btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
        _btn.frame=self.bounds;
        _btn.hidden=YES;
        _btn.backgroundColor=[UIColor clearColor];
        [self addSubview:_btn];
        
    }
    return self;
}
-(void)btnclick
{
    self.block();
}



-(void)setModel:(CommodityModel *)model
{
    _model=model;
    
    _titileL.text=model.name;
    _subtitleL.text=model.subname;
    
    
    
    
    
    
    NSString *oldPrice=[NSString stringWithFormat:@"￥%lld",model.sell_price];
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:oldPrice
                                  attributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:10.f],
    NSForegroundColorAttributeName:[UIColor lightGrayColor],
    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
    NSStrikethroughColorAttributeName:[UIColor lightGrayColor]}];
    [self.price setAttributedText:attrStr];
    
    
    switch (model.sale_flag) {
        case 0:
            self.turePrice.text=[NSString stringWithFormat:@"￥%lld",model.sell_price];
            break;
        case 1:
            self.turePrice.text=[NSString stringWithFormat:@"￥%lld",model.special_price];
            break;
        case 2:
            self.turePrice.text=[NSString stringWithFormat:@"￥%lld",model.special_price];
            break;
        case 3:
            self.turePrice.text=[NSString stringWithFormat:@"￥%lld",model.sell_price-model.special_price];
            break;
        default:
            break;
    }
    
    
    
    
    [self.bgimg sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"dog_placeholder"]];    
    
    _btn.hidden=NO;
    
}

@end
