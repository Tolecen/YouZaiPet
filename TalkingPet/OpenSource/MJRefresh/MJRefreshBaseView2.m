//
//  MJRefreshBaseView.m
//  MJRefresh
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJRefreshBaseView2.h"
#import "MJRefreshConst.h"
#import "UIView+Extension.h"
#import "UIScrollView+Extension.h"
#import <objc/message.h>

@interface  MJRefreshBaseView2()
{
    __weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
    __weak UIActivityIndicatorView *_activityView;
    __weak UIImageView * _dogImageV;
    __weak UIImageView * _qiqiuImageV;
}
@end

@implementation MJRefreshBaseView2
#pragma mark - 控件初始化
/**
 *  状态标签
 */
//- (UILabel *)statusLabel
//{
//    if (!_statusLabel) {
//        UILabel *statusLabel = [[UILabel alloc] init];
//        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        statusLabel.font = [UIFont boldSystemFontOfSize:13];
//        statusLabel.textColor = MJRefreshLabelTextColor;
//        statusLabel.backgroundColor = [UIColor clearColor];
//        statusLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:_statusLabel = statusLabel];
//    }
//    return _statusLabel;
//}

/**
 *  箭头图片
 */
//- (UIImageView *)arrowImage
//{
//    if (!_arrowImage) {
//        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arrow.png")]];
//        arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        [self addSubview:_arrowImage = arrowImage];
//    }
//    return _arrowImage;
//}

- (UIImageView *)dogImageV
{
    if (!_dogImageV) {
        UIImageView *dogImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_08.png"]];
//        [dogImageV setFrame:CGRectMake(0, 0, 320, 64)];
        dogImageV.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_dogImageV = dogImageV];
    }
    return _dogImageV;
}

- (UIImageView *)qiqiuImageV
{
    if (!_qiqiuImageV) {
        UIImageView *qiqiuImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiqiu.png"]];
        qiqiuImageV.frame = CGRectMake(200, 0, 20, 20);
        qiqiuImageV.center = CGPointMake(self.center.x-30, 20);
        //        [dogImageV setFrame:CGRectMake(0, 0, 320, 64)];
        qiqiuImageV.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_qiqiuImageV = qiqiuImageV];
    }
    return _qiqiuImageV;
}

/**
 *  状态标签
 */
//- (UIActivityIndicatorView *)activityView
//{
//    if (!_activityView) {
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        activityView.bounds = self.arrowImage.bounds;
//        activityView.autoresizingMask = self.arrowImage.autoresizingMask;
//        //        activityView.color = [UIColor orangeColor];
//        [self addSubview:_activityView = activityView];
//    }
//    return _activityView;
//}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = MJRefreshViewHeight;
    if (self = [super initWithFrame:frame]) {
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        // 2.设置默认状态
        self.state = MJRefreshStateNormal;
        self.canEndAnimation = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.箭头
//    CGFloat arrowX = self.width * 0.5 - 100;
    self.dogImageV.frame = CGRectMake(self.center.x-160, 0, 320, 64);
//    self.qiqiuImageV.frame = CGRectMake(200, 0, 13, 13);
    self.qiqiuImageV.center = CGPointMake(self.center.x-30, 20);
//    self.arrowImage.center = CGPointMake(arrowX, self.height * 0.5);
//    
//    // 2.指示器
//    self.activityView.center = self.arrowImage.center;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:MJRefreshContentOffset context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:MJRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        // 设置宽度
        self.width = newSuperview.width;
        // 设置位置
        self.x = 0;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

#pragma mark - 显示到屏幕上
- (void)drawRect:(CGRect)rect
{
    if (self.state == MJRefreshStateWillRefreshing) {
        self.state = MJRefreshStateRefreshing;
    }
}

#pragma mark - 刷新相关
#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return MJRefreshStateRefreshing == self.state;
}

#pragma mark 开始刷新
- (void)beginRefreshing
{
    if (self.window) {
        self.state = MJRefreshStateRefreshing;
    } else {
        //#warning 不能调用set方法
        _state = MJRefreshStateWillRefreshing;
        [super setNeedsDisplay];
    }
}

#pragma mark 结束刷新
- (void)endRefreshing
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.state = MJRefreshStateNormal;
        if (self.canEndAnimation) {
            if (_delegate&& [_delegate respondsToSelector:@selector(animationStopAfterRefreshing)]) {
                [_delegate animationStopAfterRefreshing];
            }
        }
    });
}

#pragma mark - 设置状态
- (void)setState:(MJRefreshState)state
{
    // 0.存储当前的contentInset
    if (self.state != MJRefreshStateRefreshing) {
        _scrollViewOriginalInset = self.scrollView.contentInset;
    }
    
    // 1.一样的就直接返回
    if (self.state == state) return;
    
    // 2.根据状态执行不同的操作
    switch (state) {
        case MJRefreshStateNormal: // 普通状态
        {
            // 显示箭头
//            self.arrowImage.hidden = NO;
//            
//            // 停止转圈圈
//            [self.activityView stopAnimating];
            break;
        }
            
        case MJRefreshStatePulling:
            break;
            
        case MJRefreshStateRefreshing:
        {
            // 开始转圈圈
//            [self.activityView startAnimating];
//            // 隐藏箭头
//            self.arrowImage.hidden = YES;
            
            // 回调
            if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
//                objc_msgSend(self.beginRefreshingTaget, self.beginRefreshingAction, self);
                ((void(*)(id, SEL,id))objc_msgSend)(self.beginRefreshingTaget, self.beginRefreshingAction, self);
            }
            
            if (self.beginRefreshingCallback) {
                self.beginRefreshingCallback();
            }
            break;
        }
        default:
            break;
    }
    
    // 3.存储状态
    _state = state;
}
@end