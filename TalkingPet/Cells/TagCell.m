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
        self.frame=frame;
        self.backgroundColor=[UIColor clearColor];
        
        if (!_titleLable) {
            self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [self.contentView addSubview:_titleLable];
            //
            _titleLable.layer.masksToBounds=YES;
            _titleLable.layer.cornerRadius=10;
            _titleLable.layer.borderWidth=1;
            //        _titleLable.font=[UIFont systemFontOfSize:18];
            _titleLable.layer.borderColor=CommonGreenColor.CGColor;
            _titleLable.textAlignment = NSTextAlignmentCenter;
            _titleLable.backgroundColor = [UIColor clearColor];
            _titleLable.textColor = CommonGreenColor;
            _titleLable.font = [UIFont systemFontOfSize:15];
        }
        _titleLable.frame = CGRectMake(CGRectGetMinX(self.contentView.frame), CGRectGetMinY(self.contentView.frame), self.frame.size.width, self.frame.size.height);
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        
        for (UIView *view in [self.contentView subviews])
        {
            if ([view.class isSubclassOfClass:[UILabel class]]) {
                UILabel *label=(UILabel *)view;
                label.textColor=[UIColor whiteColor];
                label.backgroundColor=CommonGreenColor;
            }
        }
        
        
    }else{
        
        for (UIView *view in [self.contentView subviews])
        {
            if ([view.class isSubclassOfClass:[UILabel class]]) {
                if ([view.class isSubclassOfClass:[UILabel class]]) {
                    UILabel *label=(UILabel *)view;
                    label.textColor=CommonGreenColor;
                    label.backgroundColor=[UIColor clearColor];
                }
            }
        }
    }
    
    // Configure the view for the selected state
}
- (void)prepareForReuse{
    [super prepareForReuse];
    _titleLable.frame = self.contentView.frame;
    
}

@end
