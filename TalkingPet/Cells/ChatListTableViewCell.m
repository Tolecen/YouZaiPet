//
//  ChatListTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 14/12/29.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ChatListTableViewCell.h"

@implementation ChatListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 60)];
        bgV.backgroundColor = [UIColor whiteColor];
        bgV.alpha = 0.7;
        [self.contentView addSubview:bgV];
        self.avatarImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.avatarImageV setPlaceholderImage:[UIImage imageNamed:@"placeholderHead"]];
        self.avatarImageV.backgroundColor = [UIColor lightGrayColor];
        self.avatarImageV.layer.cornerRadius = 20;
        self.avatarImageV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImageV];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, CGRectGetWidth([UIScreen mainScreen].bounds)-60-80, 20)];
        [self.nameL setBackgroundColor:[UIColor clearColor]];
        self.nameL.font = [UIFont systemFontOfSize:16];
        self.nameL.text = @"高圆圆";
        [self.contentView addSubview:self.nameL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)-80, 10, 70, 18)];
        [self.timeL setTextColor:[UIColor grayColor]];
        [self.timeL setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.timeL];
        [self.timeL setText:@"15分钟前"];
        self.timeL.font = [UIFont systemFontOfSize:10];
        [self.timeL setBackgroundColor:[UIColor clearColor]];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(60, 32, CGRectGetWidth([UIScreen mainScreen].bounds)-60-10, 20)];
        [self.contentL setBackgroundColor:[UIColor clearColor]];
        [self.contentL setTextColor:[UIColor grayColor]];
        [self.contentL setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.contentL];
        [self.contentL setText:@"就卡机卡萨拉大街上的了卡萨丁就撒娇的啊看来角度考虑撒旦教克里斯丁就控件的"];
        
        self.unreadBgV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 7, 26, 16)];
        [self.unreadBgV setImage:[UIImage imageNamed:@"unreadNumBg"]];
        [self.contentView addSubview:self.unreadBgV];
        
        self.unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 7, 25, 16)];
        [self.unreadLabel setTextColor:[UIColor whiteColor]];
        [self.unreadLabel setBackgroundColor:[UIColor clearColor]];
        [self.unreadLabel setText:@"1"];
        [self.unreadLabel setTextAlignment:NSTextAlignmentCenter];
        self.unreadLabel.adjustsFontSizeToFitWidth = YES;
        [self.unreadLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.unreadLabel];
        
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(5, 59, [UIScreen mainScreen].bounds.size.width-5, 1)];
        [lineV setBackgroundColor:[UIColor lightGrayColor]];
        lineV.alpha = 0.6;
        [self.contentView addSubview:lineV];
        
//        self.m
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.avatarImageV.imageURL = [NSURL URLWithString:self.chatListMsg.sidePetAvatarUrl];
    [self.nameL setText:self.chatListMsg.sidePetNickname];
    self.timeL.text = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:self.chatListMsg.sendTime];
    if ([self.chatListMsg.type isEqualToString:MSG_TYPE_TEXT]) {
        [self.contentL setText:self.chatListMsg.content];
    }
    else if ([self.chatListMsg.type isEqualToString:MSG_TYPE_AUDIO]){
        [self.contentL setText:@"[语音]"];
    }
    if (self.chatListMsg.unreadCount<=0) {
        self.unreadBgV.hidden = YES;
        self.unreadLabel.hidden = YES;
    }
    else
    {
        self.unreadBgV.hidden = NO;
        self.unreadLabel.hidden = NO;
        [self.unreadLabel setText:[NSString stringWithFormat:@"%d",self.chatListMsg.unreadCount]];
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
