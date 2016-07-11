//
//  YZDetailBottomBar.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDetailBottomBar.h"
#import "UIButton+VerticalTitle.h"

@interface YZDetailBottomBar()

@end

@implementation YZDetailBottomBar

- (instancetype)initWithFrame:(CGRect)frame
                         type:(YZShangChengType)type {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(inner_Share:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [shareBtn setTitleColor:[UIColor colorWithRed:(89 / 255.f) green:(89 / 255.f) blue:(89 / 255.f) alpha:1.f] forState:UIControlStateNormal];
        [shareBtn sizeToFit];
        [shareBtn verticalImageAndTitle:5.f];
        [self addSubview:shareBtn];
        
        
        UIView *sepV = [[UIView alloc] initWithFrame:CGRectZero];
        sepV.backgroundColor = [UIColor colorWithRed:(190 / 255.f)
                                               green:(190 / 255.f)
                                                blue:(190 / 255.f)
                                               alpha:1.f];
        [self addSubview:sepV];
        
        UIButton *shoppingCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shoppingCarBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [shoppingCarBtn setTitle:@"放进狗窝" forState:UIControlStateNormal];
        [shoppingCarBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
        [shoppingCarBtn addTarget:self action:@selector(inner_AddShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shoppingCarBtn];
        
        UIButton *clearPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearPriceBtn setImage:[UIImage imageNamed:@"jiesuan_icon"] forState:UIControlStateNormal];
        clearPriceBtn.backgroundColor = CommonGreenColor;
        [clearPriceBtn addTarget:self action:@selector(inner_ClearPrice:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearPriceBtn];
        
        CGFloat width = ScreenWidth / 3;
        [clearPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(self).mas_offset(0);
            make.width.mas_offset(width);
        }];
        
        [shoppingCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self).mas_offset(0);
            make.right.mas_equalTo(clearPriceBtn.mas_left).mas_offset(0);
            make.width.mas_offset(width);
        }];
        if (type == YZShangChengType_Dog) {
            UIButton *dogHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [dogHomeBtn setImage:[UIImage imageNamed:@"quanshe_icon"] forState:UIControlStateNormal];
            [dogHomeBtn addTarget:self action:@selector(inner_EnterDogHome:) forControlEvents:UIControlEventTouchUpInside];
            [dogHomeBtn setTitle:@"进入犬舍" forState:UIControlStateNormal];
            dogHomeBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
            [dogHomeBtn setTitleColor:[UIColor colorWithRed:(89 / 255.f) green:(89 / 255.f) blue:(89 / 255.f) alpha:1.f] forState:UIControlStateNormal];
            [dogHomeBtn sizeToFit];
            [dogHomeBtn verticalImageAndTitle:5.f];
            [self addSubview:dogHomeBtn];
            
            [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self).mas_offset(0);
                make.right.mas_equalTo(shoppingCarBtn.mas_left).mas_offset(0);
                make.width.mas_equalTo(width / 2);
            }];
            
            [sepV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self).mas_offset(0);
                make.right.mas_equalTo(shareBtn.mas_right).mas_offset(0);
                make.width.mas_equalTo(.5);
            }];
            
            
            sepV = [[UIView alloc] initWithFrame:CGRectZero];
            sepV.backgroundColor = [UIColor colorWithRed:(190 / 255.f)
                                                   green:(190 / 255.f)
                                                    blue:(190 / 255.f)
                                                   alpha:1.f];
            [self addSubview:sepV];
            
            [dogHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.mas_equalTo(self).mas_offset(0);
                make.right.mas_equalTo(shareBtn.mas_left).mas_offset(0);
            }];
            
            [sepV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self).mas_offset(0);
                make.right.mas_equalTo(dogHomeBtn.mas_right).mas_offset(0);
                make.width.mas_equalTo(.5);
            }];
        } else {
            [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.mas_equalTo(self).mas_offset(0);
                make.right.mas_equalTo(shoppingCarBtn.mas_left).mas_offset(0);
            }];
            
            [sepV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self).mas_offset(0);
                make.right.mas_equalTo(shareBtn.mas_right).mas_offset(0);
                make.width.mas_equalTo(.5);
            }];
        }
        UIView *shadowV = [[UIView alloc] initWithFrame:CGRectZero];
        shadowV.backgroundColor = [UIColor colorWithRed:(190 / 255.f)
                                                  green:(190 / 255.f)
                                                   blue:(190 / 255.f)
                                                  alpha:1.f];
        [self addSubview:shadowV];
        
        [shadowV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self).mas_offset(0);
            make.height.mas_equalTo(.5);
        }];
        
        [shadowV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self).mas_offset(0);
            make.height.mas_equalTo(.5);
        }];
    }
    return self;
}

- (void)inner_EnterDogHome:(UIButton *)sender {
    
}

- (void)inner_Share:(UIButton *)sender {
    
}

- (void)inner_AddShoppingCar:(UIButton *)sender {
    
}

- (void)inner_ClearPrice:(UIButton *)sender {
    
}

@end
