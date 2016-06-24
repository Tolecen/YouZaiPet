//
//  YZShangChengDropView.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengDropMenu.h"

@interface YZShangChengDropMenu()

@property (nonatomic, assign) NSInteger currentSelectedMenuIndex;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *coverLayerView;
@property (nonatomic, assign, getter=isShow) BOOL show;

@property (nonatomic, strong) UIView *currentDropView;

@end

@implementation YZShangChengDropMenu

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _currentSelectedMenuIndex = -1;
        _show = NO;
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
        _backgroundView.opaque = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap:)];
        [_backgroundView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)backgroundViewDidTap:(UITapGestureRecognizer *)tapGesture {
    
}

@end
