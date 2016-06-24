//
//  YZShangChengDropView.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengDropMenu.h"

static CGFloat RightFilterBtnWidth = 44;

@interface YZShangChengDropMenu()

@property (nonatomic, assign) NSInteger currentSelectedMenuIndex;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *coverLayerView;
@property (nonatomic, assign, getter=isShow) BOOL show;

@property (nonatomic, strong) UIView *currentDropView;

@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, weak) UIButton *rightFilterButton;
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation YZShangChengDropMenu

- (void)dealloc {
    _titleButtons = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _currentSelectedMenuIndex = -1;
        _show = NO;
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
        _backgroundView.opaque = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap:)];
        [_backgroundView addGestureRecognizer:tapGesture];
        
        UIButton *rightFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightFilterButton setImage:[UIImage imageNamed:@"filter_off_icon"] forState:UIControlStateNormal];
        [rightFilterButton setImage:[UIImage imageNamed:@"filter_on_icon"] forState:UIControlStateSelected];
        [rightFilterButton addTarget:self action:@selector(titleButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightFilterButton];
        self.rightFilterButton = rightFilterButton;
        
        [rightFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).mas_offset(-5);
            make.centerY.mas_equalTo(self).mas_equalTo(0);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(self.mas_height);
        }];
    }
    return self;
}

#pragma mark -- DataSource

- (void)setDataSource:(id<YZDropMenuDataSource>)dataSource
{
    _dataSource = dataSource;
    NSAssert([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)], @"does not respond 'numberOfColumnsInMenu:' method");
    _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    
    CGFloat width = (ScreenWidth - RightFilterBtnWidth) / _numOfMenu;
    _titleButtons = [NSMutableArray arrayWithCapacity:_numOfMenu];
    UIButton *lastTitleButton = nil;
    for (NSInteger index = 0; index < _numOfMenu; index++) {

        NSString *titleString = [_dataSource menu:self titleForColumn:index];
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:CommonGreenColor forState:UIControlStateSelected];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [titleButton setTitle:titleString forState:UIControlStateNormal];
        [self addSubview:titleButton];
        [_titleButtons addObject:titleButton];
        [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self).mas_offset(0);
            make.width.mas_equalTo(width);
            make.left.equalTo(lastTitleButton ? lastTitleButton.mas_right : self);
        }];
        
        lastTitleButton = titleButton;
        [titleButton addTarget:self action:@selector(titleButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)titleButtonDidClick:(UIButton *)sender {
    if (self.selectedButton == sender) {
        sender.selected = NO;
        self.coverLayerView.hidden = NO;
        self.selectedButton = nil;
    } else {
        sender.selected = YES;
        self.selectedButton.selected = NO;
        self.selectedButton = sender;
    }
}

- (void)backgroundViewDidTap:(UITapGestureRecognizer *)tapGesture {
    
}

@end
