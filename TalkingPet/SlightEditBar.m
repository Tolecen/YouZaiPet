//
//  SlightEditBar.m
//  TalkingPet
//
//  Created by wangxr on 14/11/3.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "SlightEditBar.h"
@interface SlightEditBar ()
{
    NSTimer * enlargedTime;
    NSTimer * reducedTime;
    NSTimer * rotateLeftTime;
    NSTimer * rotateRightTime;
}
@end
@implementation SlightEditBar
- (void)dealloc
{
    [self slightEditCancel];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UIButton * enlargedB = [UIButton buttonWithType:UIButtonTypeCustom];
        enlargedB.frame = CGRectMake(10, 0, 40, 40);
        [enlargedB setBackgroundImage:[UIImage imageNamed:@"enlarged"] forState:UIControlStateNormal];
        [enlargedB addTarget:self action:@selector(enlargedEnd) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [enlargedB addTarget:self action:@selector(enlargedBegin) forControlEvents:UIControlEventTouchDown];
        [enlargedB addTarget:self action:@selector(slightEditCancel) forControlEvents:UIControlEventTouchCancel];
        [self addSubview:enlargedB];
        
        UIButton * reducedB = [UIButton buttonWithType:UIButtonTypeCustom];
        reducedB.frame = CGRectMake(60, 0, 40, 40);
        [reducedB setBackgroundImage:[UIImage imageNamed:@"reduced"] forState:UIControlStateNormal];
        [reducedB addTarget:self action:@selector(reducedEnd) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [reducedB addTarget:self action:@selector(reducedBegin) forControlEvents:UIControlEventTouchDown];
        [reducedB addTarget:self action:@selector(slightEditCancel) forControlEvents:UIControlEventTouchCancel];
        [self addSubview:reducedB];
        
        UIButton * rotateLeftB = [UIButton buttonWithType:UIButtonTypeCustom];
        rotateLeftB.frame = CGRectMake(110, 0, 40, 40);
        [rotateLeftB setBackgroundImage:[UIImage imageNamed:@"rotateLeft"] forState:UIControlStateNormal];
        [rotateLeftB addTarget:self action:@selector(rotateLeftEnd) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [rotateLeftB addTarget:self action:@selector(rotateLeftBegin) forControlEvents:UIControlEventTouchDown];
        [rotateLeftB addTarget:self action:@selector(slightEditCancel) forControlEvents:UIControlEventTouchCancel];
        [self addSubview:rotateLeftB];
        
        UIButton * rotateRightB = [UIButton buttonWithType:UIButtonTypeCustom];
        rotateRightB.frame = CGRectMake(160, 0, 40, 40);
        [rotateRightB setBackgroundImage:[UIImage imageNamed:@"rotateRight"] forState:UIControlStateNormal];
        [rotateRightB addTarget:self action:@selector(rotateRightEnd) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [rotateRightB addTarget:self action:@selector(rotateRightBegin) forControlEvents:UIControlEventTouchDown];
        [rotateRightB addTarget:self action:@selector(slightEditCancel) forControlEvents:UIControlEventTouchCancel];
        [self addSubview:rotateRightB];
        
        UIButton * resetB = [UIButton buttonWithType:UIButtonTypeCustom];
        resetB.frame = CGRectMake(frame.size.width-80, 0, 80, 40);
        [resetB setTitle:@"重置" forState:UIControlStateNormal];
        resetB.titleLabel.font = [UIFont systemFontOfSize:14];
        [resetB addTarget:self action:@selector(resetCurrentAccessoryView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resetB];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SlightEditBarDelegate>)delegate
{
    self = [self initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)enlargedCurrentAccessoryView
{
    if (_delegate&&[_delegate respondsToSelector:@selector(slightEditBarEnlargedAction:)]) {
        [_delegate slightEditBarEnlargedAction:self];
    }
}
- (void)reducedCurrentAccessoryView
{
    if (_delegate&&[_delegate respondsToSelector:@selector(slightEditBarReducedAction:)]) {
        [_delegate slightEditBarReducedAction:self];
    }
}
- (void)rotateLeftCurrentAccessoryView
{
    if (_delegate&&[_delegate respondsToSelector:@selector(slightEditBarRotateLeftAction:)]) {
        [_delegate slightEditBarRotateLeftAction:self];
    }
}
- (void)rotateRightCurrentAccessoryView
{
    if (_delegate&&[_delegate respondsToSelector:@selector(slightEditBarRotateRightAction:)]) {
        [_delegate slightEditBarRotateRightAction:self];
    }
}
- (void)resetCurrentAccessoryView
{
    if (_delegate&&[_delegate respondsToSelector:@selector(slightEditBarResetAction:)]) {
        [_delegate slightEditBarResetAction:self];
    }
}
//upinside
- (void)enlargedEnd
{
    if (enlargedTime) {
        [enlargedTime invalidate];
        enlargedTime = nil;
    }
    [self enlargedCurrentAccessoryView];
}
- (void)reducedEnd
{
    if (reducedTime) {
        [reducedTime invalidate];
        reducedTime = nil;
    }
    [self reducedCurrentAccessoryView];
}
- (void)rotateLeftEnd
{
    if (rotateLeftTime) {
        [rotateLeftTime invalidate];
        rotateLeftTime = nil;
    }
    [self rotateLeftCurrentAccessoryView];
}
- (void)rotateRightEnd
{
    if (rotateRightTime) {
        [rotateRightTime invalidate];
        rotateRightTime = nil;
    }
    [self rotateRightCurrentAccessoryView];
}
//Down
- (void)enlargedBegin
{
    if (enlargedTime) {
        [enlargedTime invalidate];
        enlargedTime = nil;
    }
    enlargedTime = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(enlargedCurrentAccessoryView) userInfo:nil repeats:YES];
}
- (void)reducedBegin
{
    if (reducedTime) {
        [reducedTime invalidate];
        reducedTime = nil;
    }
    reducedTime = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reducedCurrentAccessoryView) userInfo:nil repeats:YES];
}
- (void)rotateLeftBegin
{
    if (rotateLeftTime) {
        [rotateLeftTime invalidate];
        rotateLeftTime = nil;
    }
    rotateLeftTime = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(rotateLeftCurrentAccessoryView) userInfo:nil repeats:YES];
}
- (void)rotateRightBegin
{
    if (rotateRightTime) {
        [rotateRightTime invalidate];
        rotateRightTime = nil;
    }
    rotateRightTime = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(rotateRightCurrentAccessoryView) userInfo:nil repeats:YES];
}
//cancel
- (void)slightEditCancel
{
    if (enlargedTime) {
        [enlargedTime invalidate];
        enlargedTime = nil;
    }
    if (reducedTime) {
        [reducedTime invalidate];
        reducedTime = nil;
    }
    if (rotateLeftTime) {
        [rotateLeftTime invalidate];
        rotateLeftTime = nil;
    }
    if (rotateRightTime) {
        [rotateRightTime invalidate];
        rotateRightTime = nil;
    }
}
@end
