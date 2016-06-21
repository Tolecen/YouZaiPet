//
//  DetailTableViewCell.m
//  TalkingPet
//
//  Created by wangxr on 14/12/16.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(5, 34, ScreenWidth-20, 1)];
        line.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
        [self.contentView addSubview:line];
        
        self.dataL = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, (ScreenWidth-20)/3, 20)];
        _dataL.backgroundColor = [UIColor clearColor];
        _dataL.font = [UIFont systemFontOfSize:15];
        _dataL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:_dataL];
        self.moneL = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-20)/3, 5, (ScreenWidth-20)/3, 20)];
        _moneL.backgroundColor = [UIColor clearColor];
        _moneL.textAlignment = NSTextAlignmentCenter;
        _moneL.font = [UIFont systemFontOfSize:15];
        _moneL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:_moneL];
        self.numberL = [[UILabel alloc] initWithFrame:CGRectMake(((ScreenWidth-20)/3)*2, 5, (ScreenWidth-20)/3, 20)];
        _numberL.backgroundColor = [UIColor clearColor];
        _numberL.textAlignment = NSTextAlignmentRight;
        _numberL.font = [UIFont systemFontOfSize:15];
        _numberL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:_numberL];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
