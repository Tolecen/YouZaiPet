//
//  BlankPageView.m
//  TalkingPet
//
//  Created by 王潇然 on 15/8/18.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BlankPageView.h"

@interface BlankPageView()
{
    UIImageView * imageView;
    UIButton * button;
    BOOL haveImage;
}
@property (nonatomic,copy)void(^action) ();
@end
@implementation BlankPageView
-(void)showWithWithView:(UIView*)view Title:(NSString *)title action:(void(^)())action
{
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.action = action;
    [view addSubview:self];
    [view addSubview:button];
    self.frame = view.bounds;
}
-(void)showWithView:(UIView*)view image:(UIImage*)image buttonImage:(UIImage*)bImage action:(void(^)())action
{
    imageView.image = image;
    [button setImage:bImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.action = action;
    [view addSubview:self];
    [view addSubview:button];
    self.frame = view.bounds;
}
- (instancetype)initWithNoImage
{
    self = [super init];
    if (self) {
        /*
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
         */
//        button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(ScreenWidth, 0, button.currentImage.size.width, button.currentImage.size.width);
//        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button];
        haveImage = NO;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((ScreenWidth-100)/2, ScreenHeight/2-70, 100, 30);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 15;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [CommonGreenColor CGColor];
        button.layer.masksToBounds = YES;
        [button setTitleColor:CommonGreenColor forState:UIControlStateNormal];
        [button setTitle:@"立刻登录" forState:UIControlStateNormal];
        [self addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        self.userInteractionEnabled = NO;
    }
    return self;
}
- (instancetype)initWithImage
{
    self = [super init];
    if (self) {
        haveImage = YES;
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.userInteractionEnabled = NO;
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (haveImage) {
        imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.width*imageView.image.size.height/imageView.image.size.width);
        button.frame = CGRectMake(0, 0, button.currentImage.size.width, button.currentImage.size.width);
        imageView.center = CGPointMake(imageView.center.x, CGRectGetMidY(frame)-50);
        button.center = CGPointMake(imageView.center.x, CGRectGetMaxY(imageView.frame)+40);

    }
}
-(void)removeFromSuperview
{
    [button removeFromSuperview];
    [super removeFromSuperview];
}
-(void)buttonAction
{
    if (_action) {
        _action();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
