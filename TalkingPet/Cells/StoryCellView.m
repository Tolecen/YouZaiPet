//
//  StoryCellView.m
//  TalkingPet
//
//  Created by Tolecen on 15/7/21.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "StoryCellView.h"

@implementation StoryCellView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView * l1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        l1.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        [self addSubview:l1];
        
        UIView * l2 = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        l2.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        [self addSubview:l2];
        
        self.storyTimeL = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, frame.size.width-10-30, 20)];
        self.storyTimeL.backgroundColor = [UIColor clearColor];
        self.storyTimeL.textColor = [UIColor orangeColor];
        self.storyTimeL.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.storyTimeL];
        
        self.storyTitleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, frame.size.width-10-30, 20)];
        self.storyTitleL.backgroundColor = [UIColor clearColor];
        self.storyTitleL.textColor = [UIColor orangeColor];
        self.storyTitleL.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:self.storyTitleL];
        
        self.storyImageV1 = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 105, frame.size.width-10-10, (frame.size.width-10-10)*0.57)];
        self.storyImageV1.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        [self addSubview:self.storyImageV1];
        
//        self.storyImageV2 = [[EGOImageView alloc] initWithFrame:CGRectMake(frame.size.width-30, 10, 30, frame.size.width-20)];
//        self.storyImageV2.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
//        [self addSubview:self.storyImageV2];
    }
    return self;
}
@end
