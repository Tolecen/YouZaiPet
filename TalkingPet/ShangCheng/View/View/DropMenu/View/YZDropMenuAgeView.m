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
            make.height.mas_equalTo(100);
        }];
    }
    return self;
}

- (void)sliderDidSelectAge:(YZDogAgeRange)age {
    self.ageViewSelectedAgeBlock(age);
}

@end
