//
//  OrderHeaderView.m
//  TalkingPet
//
//  Created by TaoXinle on 16/7/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "OrderHeaderView.h"
#import "OrderYZList.h"

@implementation OrderHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 160, 30)];
        [self.contentView addSubview:_timeL];
        self.contentView.backgroundColor = [UIColor whiteColor];
        _timeL.backgroundColor = [UIColor clearColor];
        _timeL.adjustsFontSizeToFitWidth = YES;
        _timeL.textColor = [UIColor colorWithWhite:120/255.0 alpha:1];
        _timeL.text =_YZList.time;
        
        _timeL.font = [UIFont systemFontOfSize:14];
        
        self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-160, 0, 160, 30)];
        [self.contentView addSubview:_statusL];
        self.contentView.backgroundColor = [UIColor whiteColor];
        _statusL.backgroundColor = [UIColor clearColor];
        _statusL.adjustsFontSizeToFitWidth = YES;
        _statusL.textColor = CommonGreenColor;
        _statusL.textAlignment = NSTextAlignmentRight;
        _statusL.text = @"待付款";
        _statusL.font = [UIFont systemFontOfSize:13];
        
    }
    return self;
}

@end
