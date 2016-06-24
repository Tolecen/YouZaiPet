//
//  YZDropMenuSizeView.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/24.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDropMenuSizeView.h"

@interface YZDropMenuSizeView()

@property (nonatomic, weak) UIImageView *smallDogV;
@property (nonatomic, weak) UIImageView *middleDogV;
@property (nonatomic, weak) UIImageView *bigDogV;

@end

@implementation YZDropMenuSizeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.f;
        
        UIImageView *smallDogV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small_dog_icon"]];
        smallDogV.userInteractionEnabled = YES;
        smallDogV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:smallDogV];
        self.smallDogV = smallDogV;
        
        UIImageView *middleDogV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"middle_dog_icon"]];
        middleDogV.userInteractionEnabled = YES;
        middleDogV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:middleDogV];
        self.middleDogV = middleDogV;
        
        UIImageView *bigDogV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"big_dog_icon"]];
        bigDogV.userInteractionEnabled = YES;
        bigDogV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:bigDogV];
        self.bigDogV = bigDogV;
        
        UILabel *smallDogLb = [[UILabel alloc] initWithFrame:CGRectZero];
        smallDogLb.font = [UIFont systemFontOfSize:11.f];
        smallDogLb.text = @"小型犬";
        [self addSubview:smallDogLb];
        
        UILabel *middleDogLb = [[UILabel alloc] initWithFrame:CGRectZero];
        middleDogLb.font = [UIFont systemFontOfSize:11.f];
        middleDogLb.text = @"中型犬";
        [self addSubview:middleDogLb];
        
        UILabel *bigDogLb = [[UILabel alloc] initWithFrame:CGRectZero];
        bigDogLb.font = [UIFont systemFontOfSize:11.f];
        bigDogLb.text = @"大型犬";
        [self addSubview:bigDogLb];
        
        CGFloat width = ScreenWidth / 3;
        [smallDogV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(0);
            make.top.mas_equalTo(self).mas_offset(10);
            make.width.mas_equalTo(width);
        }];
        
        [middleDogV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(smallDogV.mas_right);
            make.centerY.mas_equalTo(smallDogV);
            make.width.mas_equalTo(width);
        }];
        
        [bigDogV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(middleDogV.mas_right);
            make.centerY.mas_equalTo(smallDogV);
            make.width.mas_equalTo(width);
        }];
        
        [smallDogLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(smallDogV.mas_bottom).mas_offset(10);
            make.centerX.mas_equalTo(smallDogV).mas_offset(0);
        }];
        
        [middleDogLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(middleDogV.mas_bottom).mas_offset(10);
            make.centerX.mas_equalTo(middleDogV).mas_offset(0);
        }];
        
        [bigDogLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bigDogV.mas_bottom).mas_offset(10);
            make.centerX.mas_equalTo(bigDogV).mas_offset(0);
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inner_SelectSize:)];
        [smallDogV addGestureRecognizer:tapGesture];
        [middleDogV addGestureRecognizer:tapGesture];
        [bigDogV addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)inner_SelectSize:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self];
    if (CGRectContainsPoint(self.smallDogV.frame, touchPoint)) {
        NSLog(@"小");
    } else if (CGRectContainsPoint(self.middleDogV.frame, touchPoint)) {
        NSLog(@"中");
    } else if (CGRectContainsPoint(self.bigDogV.frame, touchPoint)) {
        NSLog(@"大");
    }
}

@end
