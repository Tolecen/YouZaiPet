//
//  DiaryPageViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/5/27.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "DiaryPageViewController.h"
#import "DiaryLayouter.h"

@implementation DiaryView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview: _imageView];
        
        shadowView = [[UIImageView alloc] init];
        [self addSubview:shadowView];
        [self bringSubviewToFront:shadowView];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _imageView.frame = self.bounds;
}
-(void)addSubview:(UIView *)view
{
    [super addSubview:view];
    if ([view isKindOfClass:[UIImageView class]]) {
        [self sendSubviewToBack:view];
    }
}
-(void)setImage:(UIImage*)image
{
    _imageView.image = image;
}
-(void)layoutLeftShadowView
{
    shadowView.frame = CGRectMake(self.frame.size.width-self.frame.size.height*121/560, 0, self.frame.size.height*121/560, self.frame.size.height);
    shadowView.image = [UIImage imageNamed:@"leftPageShadow"];
}
-(void)layoutRightShadowView
{
    shadowView.frame = CGRectMake(0, 0, self.frame.size.height*68/560, self.frame.size.height);
    shadowView.image = [UIImage imageNamed:@"rightPageShadow"];
}
@end
@interface DiaryPageViewController ()

@end
@implementation DiaryPageViewController
-(void)loadView
{
    DiaryView * view = [[DiaryView alloc] init];
    self.view = view;
}
-(void)setIndex:(NSInteger)index
{
    _index = index;
    if (_layouter) {
        [_layouter layoutDiaryViewWithIndex:_index];
    }
}
-(void)setLayouter:(DiaryLayouter *)layouter
{
    _layouter = layouter;
    [_layouter setLayouterView:self.view];
}
@end
