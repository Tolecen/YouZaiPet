//
//  RecordView.m
//  TalkingPet
//
//  Created by wangxr on 14-7-26.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "RecordView.h"
@interface RecordView ()
@property (nonatomic,retain)UIImageView * imageView;
@property (nonatomic,retain)UIImageView * animationView;
@end
@implementation RecordView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor whiteColor];
        _timeL.textAlignment = NSTextAlignmentCenter;
        _timeL.backgroundColor = [UIColor clearColor];
        [self addSubview: _timeL];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@"pub_recorder"];
        [self addSubview:_imageView];
        self.animationView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _animationView.animationImages = @[[UIImage imageNamed:@"pub_microphone_volume_7"],[UIImage imageNamed:@"pub_microphone_volume_8"],[UIImage imageNamed:@"pub_microphone_volume_9"],[UIImage imageNamed:@"pub_microphone_volume_10"],[UIImage imageNamed:@"pub_microphone_volume_9"],[UIImage imageNamed:@"pub_microphone_volume_8"],[UIImage imageNamed:@"pub_microphone_volume_7"],[UIImage imageNamed:@"pub_microphone_volume_6"]];
        [self addSubview:_animationView];
        _animationView.animationDuration = _animationView.animationImages.count*0.15;
        self.layer.cornerRadius = 10;
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.timeL.frame = CGRectMake(0, frame.size.height-40, 200, 20);
    self.imageView.frame = CGRectMake(0, 0, 53, 96);
    self.imageView.center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));
    self.animationView.frame = CGRectMake(0, 0, 34, 68);
    self.animationView.center = CGPointMake(CGRectGetMidX([self bounds])-0.5, CGRectGetMidY([self bounds])-14.5);
}
- (void)recordViewShow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = {{0,0},{200,200}};
    self.frame = frame;
    self.center = CGPointMake(CGRectGetMidX([window bounds]), CGRectGetMidY([window bounds])-80);
    [window addSubview:self];
    [_animationView startAnimating];
}
- (void)recordViewhidden
{
    [_animationView stopAnimating];
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
