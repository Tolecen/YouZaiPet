//
//  YZQuanSheDetailIntroView.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/7.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZQuanSheDetailIntroView.h"

@interface YZQuanSheDetailIntroView()

@property (nonatomic, weak) UIView *containerView;

@end

@implementation YZQuanSheDetailIntroView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3f];
        self.alpha = 0.f;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inner_HideQuanSheIntro:)];

        UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
        containerView.backgroundColor = [UIColor redColor];
        containerView.layer.cornerRadius = 5.f;
        containerView.layer.masksToBounds = YES;
        [self addSubview:containerView];
        self.containerView = containerView;
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.mas_equalTo(self).mas_offset(-290);
            make.width.mas_equalTo(self).mas_offset(-40);
            make.height.mas_equalTo(self).mas_offset(-290);
        }];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)inner_HideQuanSheIntro:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:.5
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 0.f;
                         [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                             make.centerY.mas_equalTo(self).mas_offset(-290);
                         }];
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)show {
    [UIView animateWithDuration:.5
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 1.f;
                         [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                             make.centerY.mas_equalTo(self).mas_offset(0);
                         }];
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

@end
