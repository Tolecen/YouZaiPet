//
//  YZShangChengDropView.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengDropMenu.h"
#import "YZDropMenuKindView.h"
#import "YZDropMenuAgeView.h"
#import "YZDropMenuSizeView.h"
#import "YZDropMenuOtherFilterView.h"

static CGFloat RightFilterBtnWidth  = 44;
static NSInteger buttonDefaultTag   = 100;
typedef void(^YZDropDownMenuAnimateCompleteHandler)(void);

static CGFloat YZDropMenuSizeViewHeight         = 90.f;
static CGFloat YZDropMenuOtherFilterViewHeight  = 180.f;

@interface YZShangChengDropMenu()

@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, weak) UIButton *rightFilterButton;
@property (nonatomic, weak) UIButton *selectedButton;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *coverLayerView;

@property (nonatomic, assign) NSInteger currentSelectedMenuIndex;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign, getter=isShow) BOOL show;

@property (nonatomic, strong) UIView *currentDropView;
@property (nonatomic, assign) CGFloat currentDropViewHeight;

@property (nonatomic, strong) YZDropMenuKindView *kindView;
@property (nonatomic, strong) YZDropMenuAgeView *ageView;
@property (nonatomic, strong) YZDropMenuSizeView *sizeView;
@property (nonatomic, strong) YZDropMenuOtherFilterView *otherFilterView;

@property (nonatomic, strong) NSMutableDictionary *kindSelectCache;
@property (nonatomic, strong) NSMutableDictionary *ageSelectCache;
@property (nonatomic, strong) NSMutableDictionary *sizeSelectCache;
@property (nonatomic, strong) NSMutableDictionary *otherFilterCache;

@end

@implementation YZShangChengDropMenu

- (void)dealloc {
    _titleButtons = nil;
}

#pragma mark -- CurrentView

- (YZDropMenuAgeView *)ageView {
    if (!_ageView) {
        _ageView = [[YZDropMenuAgeView alloc] init];
        _ageView.backgroundColor = [UIColor redColor];
    }
    return _ageView;
}

- (YZDropMenuSizeView *)sizeView {
    if (!_sizeView) {
        _sizeView = [[YZDropMenuSizeView alloc] init];
    }
    return _sizeView;
}

- (YZDropMenuOtherFilterView *)otherFilterView {
    if (!_otherFilterView) {
        _otherFilterView = [[YZDropMenuOtherFilterView alloc] init];
    }
    return _otherFilterView;
}

- (YZDropMenuKindView *)kindView {
    if (!_kindView) {
        _kindView = [[YZDropMenuKindView alloc] init];
        _kindView.backgroundColor = [UIColor greenColor];
    }
    return _kindView;
}

- (CGRect)screenBounds {
    return [self keyWindow].bounds;
}

- (UIWindow *)keyWindow {
    return [[[UIApplication sharedApplication] windows] lastObject];
}

- (UIView *)coverLayerView {
    if (_coverLayerView == nil) {
        _coverLayerView = [[UIView alloc] init];
        _coverLayerView.frame = [self screenBounds];
        _coverLayerView.backgroundColor = [UIColor clearColor];
        _coverLayerView.hidden = YES;
        [[self keyWindow] addSubview:_coverLayerView];
    }
    return _coverLayerView;
}

#pragma mark -- Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _currentSelectedMenuIndex = -1;
        _show = NO;
        _currentDropViewHeight = 0.f;
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
        _backgroundView.opaque = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap:)];
        [_backgroundView addGestureRecognizer:tapGesture];
        
        UIButton *rightFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightFilterButton setImage:[UIImage imageNamed:@"filter_off_icon"] forState:UIControlStateNormal];
        [rightFilterButton setImage:[UIImage imageNamed:@"filter_on_icon"] forState:UIControlStateSelected];
        rightFilterButton.tag = buttonDefaultTag + 3;
        [rightFilterButton addTarget:self action:@selector(titleButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightFilterButton];
        self.rightFilterButton = rightFilterButton;
        
        [rightFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).mas_offset(-5);
            make.centerY.mas_equalTo(self).mas_equalTo(0);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(self.mas_height);
        }];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor colorWithRed:(239 / 255.f)
                                                     green:(239 / 255.f)
                                                      blue:(239 / 255.f)
                                                     alpha:1.f];
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(.5);
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
        titleButton.tag = index + buttonDefaultTag;
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

#pragma mark -- Action

- (CGFloat)inner_CurrentDropViewHeight:(NSInteger)index {
    switch (index) {
        case 0:
            return 200;
        case 1:
            return 200;
        case 2:
            return YZDropMenuSizeViewHeight;
        case 3:
            return YZDropMenuOtherFilterViewHeight;
        default:
            break;
    }
    return 0;
}

- (UIView *)inner_SelectCurrentDropView:(NSInteger)index {
    switch (index) {
        case 0:
            return self.kindView;
        case 1:
            return self.ageView;
        case 2:
            return self.sizeView;
        case 3:
            return self.otherFilterView;
        default:
            break;
    }
    return nil;
}

- (void)titleButtonDidClick:(UIButton *)sender {
    clickCount++;
    WS(weakSelf);
    NSInteger index = sender.tag - buttonDefaultTag;
    self.currentDropView = [self inner_SelectCurrentDropView:index];
    
    if (index == self.currentSelectedMenuIndex && self.isShow) {
        self.currentDropViewHeight = [self inner_CurrentDropViewHeight:self.currentSelectedMenuIndex];
        [self inner_AnimationWithTitleButton:sender
                              backgroundView:self.backgroundView
                                 currentView:self.currentDropView
                                        show:NO
                                    complete:^{
                                        weakSelf.currentSelectedMenuIndex = index;
                                        weakSelf.show = NO;
                                    }];
    } else {
        if (index != self.currentSelectedMenuIndex) {
            UIView *previousDropView = [self inner_SelectCurrentDropView:self.currentSelectedMenuIndex];
            self.currentDropViewHeight = [self inner_CurrentDropViewHeight:self.currentSelectedMenuIndex];
            [self inner_AnimationWithTitleButton:sender
                                  backgroundView:self.backgroundView
                                     currentView:previousDropView
                                            show:NO
                                        complete:^{
                                            weakSelf.show = NO;
                                        }];
        }
        self.currentSelectedMenuIndex = index;
        self.currentDropViewHeight = [self inner_CurrentDropViewHeight:self.currentSelectedMenuIndex];
        [self inner_AnimationWithTitleButton:sender
                              backgroundView:self.backgroundView
                                 currentView:self.currentDropView
                                        show:YES
                                    complete:^{
                                        weakSelf.show = YES;
                                    }];
    }
}

#pragma mark -- Animation

static NSInteger clickCount;

- (void)inner_AnimationWithTitleButton:(UIButton *)button
                        backgroundView:(UIView *)backgroundView
                           currentView:(UIView *)currentView
                                  show:(BOOL)isShow
                              complete:(YZDropDownMenuAnimateCompleteHandler)complete {
    WS(weakSelf);
    if (self.selectedButton == button) {
        button.selected = isShow;
        self.coverLayerView.hidden = NO;
    } else {
        button.selected = YES;
        self.selectedButton.selected = NO;
        self.selectedButton = button;
    }
    [self inner_AnimationWithBackgroundView:backgroundView
                                       show:isShow
                                   complete:^{
                                       [weakSelf inner_AnimationWithCurrentView:currentView
                                                                           show:isShow
                                                                       complete:nil];
                                   }];
    if (complete) {
        complete();
    }
}

- (void)inner_AnimationWithBackgroundView:(UIView *)backgroundView
                                     show:(BOOL)isShow
                                 complete:(YZDropDownMenuAnimateCompleteHandler)complete {
    WS(weakSelf);
    if (isShow) {
        if (!backgroundView.superview) {
            [self.superview addSubview:backgroundView];
            [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.mas_bottom);
                make.left.right.bottom.equalTo(weakSelf.superview);
            }];
            [backgroundView layoutIfNeeded];
        }
        [UIView animateWithDuration:.5f animations:^{
            backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        } completion:^(BOOL finished) {
        }];
    } else {
        [UIView animateWithDuration:.5f animations:^{
            backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            clickCount = 0;
        }];
    }
    if (complete) {
        complete();
    }
}

- (void)inner_AnimationWithCurrentView:(UIView *)currentView
                                  show:(BOOL)isShow
                              complete:(YZDropDownMenuAnimateCompleteHandler)complete {
    WS(weakSelf);
    if (isShow) {
        if (!currentView.superview) {
            [self.superview addSubview:currentView];
            [currentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom);
                make.left.right.equalTo(self.superview);
                make.height.mas_equalTo(0);
            }];
            [currentView layoutIfNeeded];
        } else {
            [self.superview bringSubviewToFront:currentView];
        }
        self.coverLayerView.hidden = NO;
        [UIView animateWithDuration:.5f
                         animations:^{
                             [currentView mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.height.mas_equalTo(weakSelf.currentDropViewHeight);
                             }];
                             [currentView.superview layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             weakSelf.coverLayerView.hidden = YES;
                         }];
    } else {
        [UIView animateWithDuration:.5f
                         animations:^{
                             [currentView mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.height.mas_equalTo(0);
                             }];
                             [currentView.superview layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             weakSelf.coverLayerView.hidden = YES;
                             clickCount = 0;
                         }];
    }
    if (complete) {
        complete();
    }
}

- (void)backgroundViewDidTap:(UITapGestureRecognizer *)tapGesture {
    
}

@end
