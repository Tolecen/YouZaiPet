//
//  AccessoryCell.m
//  TalkingPet
//
//  Created by wangxr on 15/2/3.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "AccessoryCell.h"

@implementation AccessoryCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView * selectedV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        selectedV.backgroundColor = [UIColor clearColor];
        UIImageView*selectedIV =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        selectedIV.image = [UIImage imageNamed:@"selected_accessory"];
        [selectedV addSubview:selectedIV];
        self.stateIV = [[UIImageView alloc]initWithFrame:CGRectMake(17, 70, 36, 15)];
        [self.contentView addSubview:_stateIV];
        self.imageV = [[EGOImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, 65, 65)];
        [self.contentView addSubview:_imageV];
        _imageV.placeholderImage = [UIImage imageNamed:@"placeHaed"];
        self.selectedBackgroundView = selectedV;
        
        self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        _activity.color = [UIColor blackColor];
        _activity.center = _imageV.center;
        [self.contentView addSubview:_activity];
    }
    return self;
}
@end