//
//  TagCell.m
//  TalkingPet
//
//  Created by wangxr on 15/2/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "TagCell.h"

@implementation TagCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_titleLable];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textColor = [UIColor colorWithWhite:120/255.0 alpha:1];
        _titleLable.font = [UIFont systemFontOfSize:15];
    }
    return self;
}
@end
