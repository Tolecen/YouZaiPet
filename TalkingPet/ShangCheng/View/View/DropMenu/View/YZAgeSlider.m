//
//  YZAgeSlider.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/25.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZAgeSlider.h"

@class CustomSlider;
@protocol CustomSliderTrackingDelegate <NSObject>

- (void)slider_beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)slider_continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)slider_endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)slider_cancelTrackingWithEvent:(UIEvent *)event;

@end

@interface CustomSlider : UISlider

@property (nonatomic, weak) id<CustomSliderTrackingDelegate> trackingDelegate;

@end

@implementation CustomSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x - 10 ;
    rect.size.width = rect.size.width + 20;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 , 10);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL tracking = [super beginTrackingWithTouch:touch withEvent:event];
    [self.trackingDelegate slider_beginTrackingWithTouch:touch withEvent:event];
    return tracking;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL tracking = [super continueTrackingWithTouch:touch withEvent:event];
    [self.trackingDelegate slider_continueTrackingWithTouch:touch withEvent:event];
    return tracking;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self.trackingDelegate slider_endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    [self.trackingDelegate slider_cancelTrackingWithEvent:event];
}

@end

@interface YZAgeSlider()<CustomSliderTrackingDelegate>

@property (nonatomic, weak) UIButton *sliderNode;
@property (nonatomic, weak) CustomSlider *slider;
@property (nonatomic, weak) UIProgressView *progressView;
@property (nonatomic, strong) NSMutableArray *nodes;
@property (nonatomic, assign) YZDogAgeRange dogAgeValue;

@end

@implementation YZAgeSlider

static UIImageView *firstNodeImageV = nil;
static UIImageView *lastNodeImageV = nil;

- (void)dealloc {
    _nodes = nil;
    firstNodeImageV = nil;
    lastNodeImageV = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.nodes = [[NSMutableArray alloc] initWithCapacity:5];
        
        UIButton *sliderNode = [UIButton buttonWithType:UIButtonTypeCustom];
        [sliderNode setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        sliderNode.enabled = NO;
        sliderNode.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [sliderNode setTitle:@"未出生" forState:UIControlStateNormal];
        [sliderNode setBackgroundImage:[UIImage imageNamed:@"quanlingkuang"] forState:UIControlStateDisabled];
        sliderNode.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [self addSubview:sliderNode];
        self.sliderNode = sliderNode;
        
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView.backgroundColor = [UIColor grayColor];
        [progressView setProgressViewStyle:UIProgressViewStyleDefault];
        progressView.progressTintColor = CommonGreenColor;
        progressView.trackTintColor = [UIColor clearColor];
        progressView.userInteractionEnabled = YES;
        progressView.alpha = 0.8;
        [self addSubview:progressView];
        self.progressView = progressView;
        
        CGFloat radio = ScreenWidth / 320.f;
        CGFloat padding = (ScreenWidth - radio * 60 - 5 * 8 - 60) / 4;

        for (int i = 0; i < 5; i++) {
            UIImageView *nodeImageV = [[UIImageView alloc] init];
            nodeImageV.backgroundColor = [UIColor grayColor];
            nodeImageV.layer.cornerRadius = 4.f;
            nodeImageV.layer.masksToBounds = YES;
            [self addSubview:nodeImageV];
            [nodeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self).mas_offset(0);
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(8);
                make.left.mas_equalTo(lastNodeImageV ? lastNodeImageV.mas_right : self).mas_offset(lastNodeImageV ? padding : 30);
            }];
            lastNodeImageV = nodeImageV;
            if (i == 0) {
                firstNodeImageV = nodeImageV;
            }
            [self.nodes addObject:nodeImageV];
        }
        
        CustomSlider *slider = [[CustomSlider alloc] init];
        [slider setMaximumTrackTintColor:[UIColor clearColor]];
        [slider setMinimumTrackTintColor:CommonGreenColor];
        [slider setThumbImage:[UIImage imageNamed:@"slider_thumb_icon"]
                     forState:UIControlStateNormal];
        [slider addTarget:self action:@selector(inner_ChangeSliderValue:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(inner_TouchSliderDown:) forControlEvents:UIControlEventTouchDown];
        [slider addTarget:self action:@selector(inner_TouchSliderCancel:) forControlEvents:UIControlEventTouchCancel];
        [slider addTarget:self action:@selector(inner_TouchSliderUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [slider addTarget:self action:@selector(inner_TouchSliderUpInside:) forControlEvents:UIControlEventTouchUpInside];
        slider.trackingDelegate = self;
        [self addSubview:slider];
        self.slider = slider;
        

        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self).mas_offset(0);
            make.left.mas_equalTo(firstNodeImageV.mas_left).mas_offset(0);
            make.right.mas_equalTo(lastNodeImageV.mas_right).mas_offset(0);
        }];
        
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self).mas_offset(-1);
            make.left.mas_equalTo(firstNodeImageV.mas_left).mas_offset(0);
            make.right.mas_equalTo(lastNodeImageV.mas_right).mas_offset(0);
        }];
        
        [sliderNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(firstNodeImageV.mas_centerX).mas_offset(0);
            make.bottom.mas_equalTo(slider.mas_top).mas_offset(-5);
        }];
    }
    return self;
}

- (void)inner_ChangeSliderValue:(UISlider *)sender {
    self.progressView.progress = sender.value;
    NSInteger selectIndex = 0;
    if (sender.value < 0.25) {
        [self.sliderNode setTitle:@"未出生" forState:UIControlStateDisabled];
    } else if ((sender.value >= 0.25) && (sender.value < 0.5)) {
        selectIndex = 1;
        [self.sliderNode setTitle:@"0~3个月" forState:UIControlStateDisabled];
    } else if ((sender.value >= 0.5) && (sender.value < 0.75)) {
        selectIndex = 2;
        [self.sliderNode setTitle:@"3~6个月" forState:UIControlStateDisabled];
    } else if ((sender.value >= 0.75) && (sender.value < 1)) {
        selectIndex = 3;
        [self.sliderNode setTitle:@"6~12个月" forState:UIControlStateDisabled];
    } else {
        [self.sliderNode setTitle:@"1年以上" forState:UIControlStateDisabled];
        selectIndex = 4;
    }
    [self inner_ConfigureNodesBackgroundWithMaxIndex:selectIndex];
}

- (void)inner_TouchSliderDown:(UISlider *)sender {
    
}

- (void)inner_TouchSliderUpOutside:(UISlider *)sender {
    [self inner_ConfigureSilderProgress:sender];
}

- (void)inner_TouchSliderCancel:(UISlider *)sender {
    [self inner_ConfigureSilderProgress:sender];
}

- (void)inner_TouchSliderUpInside:(UISlider *)sender {
    [self inner_ConfigureSilderProgress:sender];
}

- (void)inner_ConfigureSilderProgress:(UISlider *)sender {
    NSInteger selectIndex = 0;
    if (sender.value < 0.125) {
        sender.value = 0;
        [self.sliderNode setTitle:@"未出生" forState:UIControlStateDisabled];
        self.dogAgeValue = YZDogAgeRange_OM;
    } else if ((sender.value >= 0.125) && (sender.value < 0.375)) {
        sender.value = 0.25;
        selectIndex = 1;
        [self.sliderNode setTitle:@"0~3个月" forState:UIControlStateDisabled];
        self.dogAgeValue = YZDogAgeRange_0_3M;
    } else if ((sender.value >= 0.375) && (sender.value < 0.625)) {
        sender.value = 0.5;
        selectIndex = 2;
        [self.sliderNode setTitle:@"3~6个月" forState:UIControlStateDisabled];
        self.dogAgeValue = YZDogAgeRange_3_6M;
    } else if ((sender.value >= 0.625) && (sender.value < 0.875)) {
        sender.value = 0.75;
        selectIndex = 3;
        [self.sliderNode setTitle:@"6~12个月" forState:UIControlStateDisabled];
        self.dogAgeValue = YZDogAgeRange_6_12M;
    } else {
        sender.value = 1.f;
        selectIndex = 4;
        [self.sliderNode setTitle:@"1年以上" forState:UIControlStateDisabled];
        self.dogAgeValue = YZDogAgeRange_1Y;
    }
    self.progressView.progress = sender.value;
    UIImageView *selectImageV = self.nodes[selectIndex];
    CGFloat offset = CGRectGetMidX(selectImageV.frame) - CGRectGetMidX(firstNodeImageV.frame);
    [self.sliderNode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(firstNodeImageV.mas_centerX).mas_offset(offset);
    }];
    
    [self.sliderDelegate sliderDidSelectAge:self.dogAgeValue];
}

- (void)inner_ConfigureNodesBackgroundWithMaxIndex:(NSInteger)index {
    [self.nodes enumerateObjectsUsingBlock:^(UIImageView *nodeImageV, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx <= index) {
            nodeImageV.backgroundColor = CommonGreenColor;
        } else {
            nodeImageV.backgroundColor = [UIColor grayColor];
        }
    }];
}

#pragma mark -- TrackingDelegate

- (void)slider_beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    NSLog(@"begin_location_self:[%@_%@]", NSStringFromCGPoint(location), NSStringFromCGRect(self.frame));
}

- (void)slider_continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    NSLog(@"continue_location_self:[%@_%@]", NSStringFromCGPoint(location), NSStringFromCGRect(self.frame));
    if (location.x <CGRectGetMidX(firstNodeImageV.frame)) {
        [self.sliderNode mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(firstNodeImageV.mas_centerX).mas_offset(0);
        }];
        return;
    }
    if (location.x > CGRectGetMidX(lastNodeImageV.frame)) {
        [self.sliderNode mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(firstNodeImageV.mas_centerX).mas_offset(CGRectGetMidX(lastNodeImageV.frame) - CGRectGetMidX(firstNodeImageV.frame));
        }];
        return;
    }
    CGFloat offsetX = location.x - CGRectGetMidX(firstNodeImageV.frame);
    [self.sliderNode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(firstNodeImageV.mas_centerX).mas_offset(offsetX);
    }];
}

- (void)slider_endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    NSLog(@"end_location_self:[%@_%@]", NSStringFromCGPoint(location), NSStringFromCGRect(self.frame));
}

- (void)slider_cancelTrackingWithEvent:(UIEvent *)event {
    
}

@end
