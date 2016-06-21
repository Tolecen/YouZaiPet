//
//  ITTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 14/10/23.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ITTableViewCell.h"

@implementation ITTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 25, 25)];
        [self.contentView addSubview:self.imageV];
        
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(55,15, 260, 20)];
        self.desLabel.backgroundColor = [UIColor clearColor];
        self.desLabel.font = [UIFont boldSystemFontOfSize:14];
        self.desLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.desLabel];
        
        self.unreadBgV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 9, 26, 16)];
        [self.unreadBgV setImage:[UIImage imageNamed:@"unreadNumBg"]];
        [self.contentView addSubview:self.unreadBgV];
        
        self.unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 9, 25, 16)];
        [self.unreadLabel setTextColor:[UIColor whiteColor]];
        [self.unreadLabel setBackgroundColor:[UIColor clearColor]];
        [self.unreadLabel setTextAlignment:NSTextAlignmentCenter];
        self.unreadLabel.adjustsFontSizeToFitWidth = YES;
        [self.unreadLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.unreadLabel];
    }
    return self;
}
-(void)setUnreadNum:(NSString *)unreadNum
{
    int unread = [unreadNum intValue];
    if (unread>0) {
        self.unreadBgV.hidden = NO;
        self.unreadLabel.hidden = NO;
        if (unread<=99) {
            [self.unreadLabel setText:unreadNum];
        }
        else
        {
            [self.unreadLabel setText:@"99+"];
        }
        
    }
    else
    {
        self.unreadBgV.hidden = YES;
        self.unreadLabel.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
