//
//  NotificationTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-17.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "TalkComment.h"
@implementation NotificationTableViewCell
+(CGFloat)heightForRowWithComment:(NSDictionary *)noti
{
    //    float cellHeight = 0;
    
    //||[[noti objectForKey:@"type"] isEqualToString:@"F"]||[[noti objectForKey:@"type"] isEqualToString:@""]
    
    if ([[noti objectForKey:@"type"] isEqualToString:@"C"]) {
        if (![noti objectForKey:@"contentAudioUrl"]||[[noti objectForKey:@"contentAudioUrl"] isEqualToString:@""]) {
            CGSize commentSize = [[noti objectForKey:@"content"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-140, 80)];
            return 15+20+commentSize.height+5+20+5;
        }
        else
        {
            return 15+20+5+22+5+20+5;
        }
    }
    else if([[noti objectForKey:@"type"] isEqualToString:@"R"]){
        CGSize commentSize = [[noti objectForKey:@"content"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-140, 80)];
        return 15+20+commentSize.height+5+20+5;
    }
    else{
        return 15+20+5+22+5+20+5;
    }
}
+(CGFloat)heightForRowWithSysNoti:(NSDictionary *)noti
{
        CGSize commentSize = [[noti objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-140, 80)];
        return 15+20+commentSize.height+5+20+5;

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.userAvatarV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [self.userAvatarV setBackgroundColor:[UIColor grayColor]];
        //        [self.commentAvatarV setImage:[UIImage imageNamed:@"gougouAvatar.jpeg"]];
        self.userAvatarV.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
        [self.contentView addSubview:self.userAvatarV];
        self.userAvatarV.layer.cornerRadius = 25;
        self.userAvatarV.layer.masksToBounds = YES;
        [self.userAvatarV addTarget:self action:@selector(publisherAction) forControlEvents:UIControlEventTouchUpInside];
        
        //        UIImageView * avatarbg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        //        [avatarbg setImage:[UIImage imageNamed:@"avatarbg2"]];
        //        [self.contentView addSubview:avatarbg];
        
        self.userNameL = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 200, 20)];
        [self.userNameL setBackgroundColor:[UIColor clearColor]];
        [self.userNameL setFont:[UIFont systemFontOfSize:15]];
        [self.userNameL setText:@"我是小黄瓜"];
        self.userNameL.textColor = [UIColor colorWithRed:0.027 green:0.58 blue:0.757 alpha:1];
        [self.contentView addSubview:self.userNameL];
        
        self.userNameL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapw = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publisherAction)];
        [self.userNameL addGestureRecognizer:tapw];
        
        self.actionStyleL = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 120, 20)];
        [self.actionStyleL setBackgroundColor:[UIColor clearColor]];
        [self.actionStyleL setTextColor:[UIColor grayColor]];
        [self.actionStyleL setText:@"转发"];
        [self.actionStyleL setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.actionStyleL];
        
        self.actionContentL = [[UILabel alloc] initWithFrame:CGRectMake(70, 38, ScreenWidth-140, 20)];
        [self.actionContentL setBackgroundColor:[UIColor clearColor]];
        [self.actionContentL setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
        [self.actionContentL setFont:[UIFont systemFontOfSize:14]];
        [self.actionContentL setNumberOfLines:0];
        [self.actionContentL setLineBreakMode:NSLineBreakByWordWrapping];
        [self.actionContentL setText:@"呦呦切克闹，煎饼果子来一套"];
        [self.contentView addSubview:self.actionContentL];
        
        self.playRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playRecordBtn setFrame:CGRectMake(70, 39, 86, 22)];
        [self.playRecordBtn setBackgroundImage:[UIImage imageNamed:@"shengyin_bg"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.playRecordBtn];
        [self.playRecordBtn addTarget:self action:@selector(playRecordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.playRecordImgV = [[UIImageView alloc] initWithFrame:CGRectMake(65, 5, 10, 11)];
        [self.playRecordImgV setImage:[UIImage imageNamed:@"shengyin3"]];
        [self.playRecordBtn addSubview:self.playRecordImgV];
        
        self.recordDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, 40, 20)];
        [self.recordDurationLabel setBackgroundColor:[UIColor clearColor]];
        [self.recordDurationLabel setFont:[UIFont systemFontOfSize:14]];
        [self.recordDurationLabel setText:@"6s"];
        [self.recordDurationLabel setAdjustsFontSizeToFitWidth:YES];
        [self.recordDurationLabel setTextColor:[UIColor grayColor]];
        [self.playRecordBtn addSubview:self.recordDurationLabel];
        
        
        self.actionTimeL = [[UILabel alloc] initWithFrame:CGRectMake(70, 60, 120, 20)];
        [self.actionTimeL setBackgroundColor:[UIColor clearColor]];
        [self.actionTimeL setTextAlignment:NSTextAlignmentLeft];
        [self.actionTimeL setText:@"2014-6-20"];
        [self.actionTimeL setTextColor:[UIColor grayColor]];
        [self.actionTimeL setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.actionTimeL];
        
        self.actionImgV = [[EGOImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-50, 10, 50, 50)];
        [self.actionImgV setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:self.actionImgV];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.notiStyle==notiStyleSystem) {
        NSString * theName = @"宠物说助手";
        [self.userAvatarV setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
//        self.userAvatarV.enabled = NO;
        CGSize forwardedNameSize = [theName sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(120, 20)];
        //    NSLog(@"sssss%f",forwardedNameSize.width);
        [self.userNameL setFrame:CGRectMake(self.userNameL.frame.origin.x, self.userNameL.frame.origin.y, forwardedNameSize.width, 20)];
        //    [self.forwardedNameL setBackgroundColor:[UIColor redColor]];
        [self.actionStyleL setFrame:CGRectMake(self.userNameL.frame.origin.x+forwardedNameSize.width+5, 16, 50, 20)];
        self.userNameL.text = theName;
        CGSize commentSize = [[self.notiDict objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-140, 80)];
        [self.actionContentL setFrame:CGRectMake(self.actionContentL.frame.origin.x, self.actionContentL.frame.origin.y, ScreenWidth-140, commentSize.height)];
        self.actionContentL.hidden = NO;
        self.playRecordBtn.hidden = YES;
        self.actionContentL.text = [self.notiDict objectForKey:@"title"];
        [self.actionTimeL setFrame:CGRectMake(70, self.actionContentL.frame.origin.y+commentSize.height+5, 120, 20)];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.actionImgV.hidden = YES;
        self.actionStyleL.text = @"发布";
        self.actionTimeL.text = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:[NSString stringWithFormat:@"%f",[[self.notiDict objectForKey:@"createTime"] doubleValue]/1000]];
        return;
    }
//    self.userAvatarV.enabled =YES;
    CGSize forwardedNameSize = [[self.notiDict objectForKey:@"petNickname"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(120, 20)];
    //    NSLog(@"sssss%f",forwardedNameSize.width);
    [self.userNameL setFrame:CGRectMake(self.userNameL.frame.origin.x, self.userNameL.frame.origin.y, forwardedNameSize.width, 20)];
    //    [self.forwardedNameL setBackgroundColor:[UIColor redColor]];
    [self.actionStyleL setFrame:CGRectMake(self.userNameL.frame.origin.x+forwardedNameSize.width+5, 16, 50, 20)];
    self.userNameL.text = [self.notiDict objectForKey:@"petNickname"];
    self.actionImgV.imageURL = [NSURL URLWithString:[[self.notiDict objectForKey:@"thumbUrl"] stringByAppendingString:@"?imageView2/2/w/100"]];
    self.userAvatarV.imageURL = [NSURL URLWithString:[[self.notiDict objectForKey:@"petHeadPortrait"] stringByAppendingString:@"?imageView2/2/w/80"]];
    if ([[self.notiDict objectForKey:@"type"] isEqualToString:@"C"]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.actionImgV.hidden = NO;
        self.actionStyleL.text = @"评论";
        if (![self.notiDict objectForKey:@"contentAudioUrl"]||[[self.notiDict objectForKey:@"contentAudioUrl"] isEqualToString:@""]) {
            CGSize commentSize = [[self.notiDict objectForKey:@"content"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-140, 80)];
            [self.actionContentL setFrame:CGRectMake(self.actionContentL.frame.origin.x, self.actionContentL.frame.origin.y, ScreenWidth-140, commentSize.height)];
            self.actionContentL.hidden = NO;
            self.playRecordBtn.hidden = YES;
            self.actionContentL.text = [self.notiDict objectForKey:@"content"];
            [self.actionTimeL setFrame:CGRectMake(70, self.actionContentL.frame.origin.y+commentSize.height+5, 120, 20)];
        }
        else
        {
            self.actionContentL.hidden = YES;
            self.playRecordBtn.hidden = NO;
            self.recordDurationLabel.text = [self.notiDict objectForKey:@"contentAudioSecond"];
            [self.actionTimeL setFrame:CGRectMake(70, 65, 120, 20)];
            
        }
    }
    else if([[self.notiDict objectForKey:@"type"] isEqualToString:@"R"]){
        self.accessoryType = UITableViewCellAccessoryNone;
        self.actionImgV.hidden = NO;
        self.actionStyleL.text = @"转发";
        self.playRecordBtn.hidden = YES;
        CGSize commentSize = [[self.notiDict objectForKey:@"content"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-140, 80)];
        [self.actionContentL setFrame:CGRectMake(self.actionContentL.frame.origin.x, self.actionContentL.frame.origin.y, ScreenWidth-140, commentSize.height)];
        self.actionContentL.hidden = NO;
        self.playRecordBtn.hidden = YES;
        self.actionContentL.text = [self.notiDict objectForKey:@"content"];
        [self.actionTimeL setFrame:CGRectMake(70, self.actionContentL.frame.origin.y+commentSize.height+5, 120, 20)];
    }
    else if([[self.notiDict objectForKey:@"type"] isEqualToString:@"F"]){
        self.accessoryType = UITableViewCellAccessoryNone;
        self.actionImgV.hidden = NO;
        self.playRecordBtn.hidden = YES;
        self.actionStyleL.text = @"";
        self.actionContentL.text = @"踩了你的说说";
        self.actionContentL.hidden = NO;
        [self.actionTimeL setFrame:CGRectMake(70, 60, 120, 20)];
        [self.actionContentL setFrame:CGRectMake(self.actionContentL.frame.origin.x, self.actionContentL.frame.origin.y, ScreenWidth-140, 20)];
    }
    else
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.actionImgV.hidden = YES;
        self.playRecordBtn.hidden = YES;
        self.actionStyleL.text = @"";
        self.actionContentL.text = @"关注了你";
        self.actionContentL.hidden = NO;
        [self.actionTimeL setFrame:CGRectMake(70, 60, 120, 20)];
        [self.actionContentL setFrame:CGRectMake(self.actionContentL.frame.origin.x, self.actionContentL.frame.origin.y, ScreenWidth-140, 20)];
    }
    
    self.actionTimeL.text = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:[NSString stringWithFormat:@"%f",[[self.notiDict objectForKey:@"createTime"] doubleValue]/1000]];
    
    
}
- (void)publisherAction
{
    if (self.notiStyle==notiStyleSystem){
        return;
    }
    if (_delegate&& [_delegate respondsToSelector:@selector(commentPublisherBtnClicked:)]) {
        TalkComment * tk = [[TalkComment alloc] init];
        tk.petID = [self.notiDict objectForKey:@"petId"];
        [_delegate commentPublisherBtnClicked:tk];
    }
}
-(void)playRecordBtnClicked:(UIButton *)sender
{
    if (_delegate&& [_delegate respondsToSelector:@selector(commentPlayAudioBtnClicked:Cell:)]) {
        TalkComment * tk = [[TalkComment alloc] init];
        tk.audioUrl = [self.notiDict objectForKey:@"contentAudioUrl"];
        [_delegate commentPlayAudioBtnClicked:tk Cell:self];
    }
    
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
