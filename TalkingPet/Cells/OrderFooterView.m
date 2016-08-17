//
//  OrderFooterView.m
//  TalkingPet
//
//  Created by TaoXinle on 16/7/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "OrderFooterView.h"

@implementation OrderFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier WithButton:(BOOL)haveBtn
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        //        self.backgroundColor = [UIColor colorWithWhite:245/255.f alpha:1];
        //        self.contentView.backgroundColor = [UIColor colorWithWhite:245/255.f alpha:1];
        
        haveBtn = NO;
        
        _bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        _bgV.backgroundColor = [UIColor colorWithWhite:245/255.f alpha:1];
        [self.contentView addSubview:_bgV];
        
        self.desL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 30)];
        [self.contentView addSubview:_desL];
        self.contentView.backgroundColor = [UIColor whiteColor];
        _desL.backgroundColor = [UIColor clearColor];
        _desL.adjustsFontSizeToFitWidth = YES;
        _desL.textAlignment = NSTextAlignmentRight;
        _desL.textColor = [UIColor colorWithWhite:150/255.0 alpha:1];
        _desL.text = @"共1件 合计：￥11000（含运费 ￥0.00）";
        _desL.font = [UIFont systemFontOfSize:13];
        
        [_bgV setFrame:CGRectMake(0, 35, ScreenWidth, 10)];
        
        if (haveBtn) {
            UIView * linev = [[UIView alloc] initWithFrame:CGRectMake(10, 34, ScreenWidth-20, 1)];
            linev.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
            [self.contentView addSubview:linev];
            
            self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.btn1 setFrame:CGRectMake(ScreenWidth-10-70-10-70, CGRectGetMaxY(linev.frame)+10, 70, 20)];
            self.btn1.layer.cornerRadius = 3;
            self.btn1.layer.borderWidth = 1;
            self.btn1.layer.borderColor = [[UIColor colorWithWhite:180/255.f alpha:1] CGColor];
            self.btn1.layer.masksToBounds = YES;
            [self.contentView addSubview:self.btn1];
            [self.btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
            self.btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.btn1 setTitleColor:[UIColor colorWithWhite:180/255.f alpha:1] forState:UIControlStateNormal];
            [self.btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.btn2 setFrame:CGRectMake(ScreenWidth-10-70, CGRectGetMaxY(linev.frame)+10, 70, 20)];
            self.btn2.layer.cornerRadius = 3;
            self.btn2.layer.borderWidth = 1;
            self.btn2.layer.borderColor = [CommonGreenColor CGColor];
            self.btn2.layer.masksToBounds = YES;
            [self.contentView addSubview:self.btn2];
            [self.btn2 setTitle:@"立刻付款" forState:UIControlStateNormal];
            self.btn2.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.btn2 setTitleColor:CommonGreenColor forState:UIControlStateNormal];
            [self.btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [_bgV setFrame:CGRectMake(0, 75, ScreenWidth, 10)];
            haveBtn = YES;
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.haveBtn) {
        [_bgV setFrame:CGRectMake(0, 75, ScreenWidth, 10)];
    }
    else
        [_bgV setFrame:CGRectMake(0, 35, ScreenWidth, 10)];
}

-(void)btnClicked:(UIButton *)btn
{
    if (self.buttonClicked) {
        self.buttonClicked(btn.currentTitle);
    }
}

@end
