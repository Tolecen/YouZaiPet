//
//  TimeLineSectionHeaderView.m
//  TalkingPet
//
//  Created by Tolecen on 15/1/31.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "TimeLineSectionHeaderView.h"

@implementation TimeLineSectionHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier showHead:(BOOL)showHead
{

    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
//        UIView * sl = [[UIView alloc] initWithFrame:self.frame];
//        sl.backgroundColor = [UIColor whiteColor];
//        sl.alpha = 0.7;
//        [self.contentView addSubview:sl];
        self.showTheHead = showHead;
        UIView * g = [[UIView alloc] initWithFrame:self.frame];
        if (showHead) {
            g.backgroundColor = [UIColor whiteColor];
            g.alpha = 0.8;
        }
        else
            g.backgroundColor = [UIColor clearColor];
        self.backgroundView = g;
        
//        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(showHead?35:23,showHead?56:0, 1, showHead?4:51)];
//        [lineV setBackgroundColor:[UIColor colorWithWhite:200/255.0f alpha:1]];
//        [self.contentView addSubview:lineV];
        
        if (showHead) {
            self.publisherAvatarV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            [self.publisherAvatarV setBackgroundColor:[UIColor grayColor]];
            [self.contentView addSubview:self.publisherAvatarV];
            [self.publisherAvatarV setBackgroundImage:[UIImage imageNamed:@"placeholderHead"] forState:UIControlStateNormal];
            [_publisherAvatarV addTarget:self action:@selector(publisherAction) forControlEvents:UIControlEventTouchUpInside];
            _publisherAvatarV.layer.masksToBounds = YES;
            _publisherAvatarV.layer.cornerRadius = 20;
        }
        else
        {
            self.publisherAvatarV = [[EGOImageButton alloc] initWithFrame:CGRectMake(13, 14, 21, 21)];
//            [self.publisherAvatarV setBackgroundColor:[UIColor grayColor]];
            [self.contentView addSubview:self.publisherAvatarV];
            [self.publisherAvatarV setBackgroundImage:[UIImage imageNamed:@"timeLine_frontImg"] forState:UIControlStateNormal];
        }
        

        

        
        if (showHead) {
//            self.genderImageV = [[UIImageView alloc] initWithFrame:CGRectMake(75, 0, 16, 14)];
//            [self.contentView addSubview:self.genderImageV];
            
            self.publisherNameL = [[UILabel alloc] initWithFrame:CGRectMake(75, 370+35, 200, 20)];
            [self.publisherNameL setBackgroundColor:[UIColor clearColor]];
            [self.publisherNameL setFont:[UIFont systemFontOfSize:14]];
            self.publisherNameL.textColor = [UIColor colorWithWhite:100/255.0f alpha:1];
            [self.publisherNameL setText:@"我是小黄瓜"];
            [self.contentView addSubview:self.publisherNameL];
            
            self.publisherNameL.userInteractionEnabled = YES;
            
            
            self.gradeL = [[UILabel alloc] initWithFrame:CGRectMake(75, 370+35, 200, 20)];
            [self.gradeL setBackgroundColor:[UIColor clearColor]];
            [self.gradeL setFont:[UIFont systemFontOfSize:12]];
            self.gradeL.textColor = [UIColor colorWithWhite:180/255.0f alpha:1];
            [self.gradeL setText:@"LV.12"];
            [self.contentView addSubview:self.gradeL];

        }
        
        
//        self.timeBgImg = image;
        
//        self.timeBgV = [[UIImageView alloc] initWithFrame:CGRectMake(showHead?65:45,showHead?33:18, 120, 20)];
//        [self.timeBgV setImage:[UIImage imageNamed:@"timeLine_timeBgV"]];
//        
//        [self.contentView addSubview:self.timeBgV];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-120, 20, 100, 20)];
        [self.timeL setBackgroundColor:[UIColor clearColor]];
        [self.timeL setTextColor:[UIColor lightGrayColor]];
        [self.timeL setTextAlignment:NSTextAlignmentRight];
        [self.timeL setText:@"2015-01-12"];
        [self.timeL setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.timeL];
        self.timeL.adjustsFontSizeToFitWidth = YES;

    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)layoutSubviews {
    // Drawing code
    [super layoutSubviews];
//    self.tintColor = [UIColor clearColor];
    if (self.showTheHead) {
        self.publisherAvatarV.imageURL = [NSURL URLWithString:[self.petInfo.headImgURL stringByAppendingString:@"?imageView2/2/w/60"]];
        [self.publisherNameL setText:self.petInfo.nickname];
        
//        if ([self.petInfo.gender isEqualToString:@"1"]) {
//            [self.genderImageV setImage:[UIImage imageNamed:@"male"]];
//            [self.genderImageV setFrame:CGRectMake(63, self.publisherAvatarV.frame.origin.y+5+2, 16, 14)];
//            self.genderImageV.hidden = NO;
//            [self.publisherNameL setFrame:CGRectMake(81,self.publisherAvatarV.frame.origin.y+3, 150, 20)];
//        }
//        else if ([self.petInfo.gender isEqualToString:@"0"]){
//            [self.genderImageV setImage:[UIImage imageNamed:@"female"]];
//            [self.genderImageV setFrame:CGRectMake(63, self.publisherAvatarV.frame.origin.y+5+2, 16, 14)];
//            self.genderImageV.hidden = NO;
//            [self.publisherNameL setFrame:CGRectMake(81,self.publisherAvatarV.frame.origin.y+3, 150, 20)];
//        }
//        else
//        {
            self.genderImageV.hidden = YES;
            [self.publisherNameL setFrame:CGRectMake(65,self.publisherAvatarV.frame.origin.y, 160, 20)];
        [self.gradeL setFrame:CGRectMake(65, CGRectGetMaxY(self.publisherNameL.frame), 200, 20)];
//        }

    }
    
    
    self.timeL.text = [Common getExDateStringWithTimestamp:self.timeStr];
    self.gradeL.text = [NSString stringWithFormat:@"LV.%@",(self.petInfo.grade&&self.petInfo.grade.length>0)?self.petInfo.grade:@"0"];
//    CGSize forwardedNameSize = [self.timeL.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(120,20)];
//    UIImage * fg = [UIImage imageNamed:@"timeLine_timeBgV"];
//    [fg resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 5.95) resizingMode:UIImageResizingModeStretch];
//    [self.timeBgV setImage:fg];
//    [self.timeBgV setFrame:CGRectMake(65, 33, forwardedNameSize.width+20, 20)];
//    [self.timeL setFrame:CGRectMake(self.timeL.frame.origin.x, self.timeL.frame.origin.y, 100, 20)];
    
//    NSLog(@"petName:%@,cellIndex:%d",self.petInfo.nickname,self.cellIndex);
   
}
- (void)publisherAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(headerClicked:)]) {
        [_delegate headerClicked:self.petInfo.petID];
    }
}

@end
