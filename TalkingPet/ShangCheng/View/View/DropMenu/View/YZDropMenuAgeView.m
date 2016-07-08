//
//  YZDropMenuAgeView.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/24.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDropMenuAgeView.h"
#import "YZAgeSlider.h"

@interface YZDropMenuAgeView()<YZAgeSliderDelegate>

@property (nonatomic, weak) UIButton *confimBtn;

@property (nonatomic, assign) YZDogAgeRange age;

@end

@implementation YZDropMenuAgeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        
        CGFloat radio = ScreenWidth / 320.f;

        YZAgeSlider *slider = [[YZAgeSlider alloc] init];
        slider.sliderDelegate = self;
        [self addSubview:slider];
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(20);
            make.left.mas_equalTo(self).mas_offset(30 * radio);
            make.right.mas_equalTo(self).mas_offset(-30 * radio);
            make.height.mas_equalTo(70);
        }];
        
        UIButton *confimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confimBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confimBtn addTarget:self action:@selector(inner_ConfimSelected:) forControlEvents:UIControlEventTouchUpInside];
        [confimBtn setBackgroundColor:CommonGreenColor];
        confimBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        confimBtn.layer.cornerRadius = 15.f;
        confimBtn.layer.masksToBounds = YES;
        [self addSubview:confimBtn];
        
        [confimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self).mas_offset(0);
            make.top.mas_equalTo(slider.mas_bottom).mas_offset(0);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)sliderDidSelectAge:(YZDogAgeRange)age {
    self.age = age;
}

- (void)inner_ConfimSelected:(UIButton *)sender {
    self.ageViewSelectedAgeBlock(self.age);
}

@end
