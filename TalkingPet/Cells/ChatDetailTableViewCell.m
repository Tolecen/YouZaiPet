//
//  ChatDetailTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/1/4.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ChatDetailTableViewCell.h"

@implementation ChatDetailTableViewCell
+(CGFloat)heightForRowWithMsg:(ChatMsg *)msg showTime:(BOOL)showTime
{
    float h = 0;
    if ([msg.type isEqualToString:MSG_TYPE_AUDIO]) {
        h = 60;
    }
    else if ([msg.type isEqualToString:MSG_TYPE_TEXT]){
        CGSize sizeT = [msg.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-55-20-20-40, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        if (sizeT.height<20) {
            sizeT.height = 20;
        }
//        if (sizeT.width<20) {
//            sizeT.width = 20;
//        }
        h = sizeT.height + 40;
    }
    if (showTime) {
        h = h+10;
    }
    else
        h = h;
    return h;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width, 10)];
        [self.timeL setBackgroundColor:[UIColor clearColor]];
        [self.timeL setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
        [self.timeL setFont:[UIFont systemFontOfSize:10]];
        [self.timeL setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.timeL];
        self.timeL.text = @"昨天中午";
        
        self.avatarImgV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.avatarImgV setPlaceholderImage:[UIImage imageNamed:@"placeholderHead"]];
        self.avatarImgV.layer.cornerRadius = 20;
        self.avatarImgV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImgV];
        [self.avatarImgV addTarget:self action:@selector(headTouched) forControlEvents:UIControlEventTouchUpInside];
        
        self.bgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(55, 10, 100, 40)];
//        [self.bgImageV setImage:[UIImage imageNamed:@"chatbubbleta"]];
        self.bgImageV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgImageV];
        self.bgImageV.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapped:)];
        [self.bgImageV addGestureRecognizer:tap1];
        
        UILongPressGestureRecognizer * press2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bgLongPress)];
        [self.bgImageV addGestureRecognizer:press2];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(55+20, 20, 170, 20)];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentLabel setText:@"京哈圣诞节撒按时大大卡精神科是骄傲的"];
        [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        self.audioImageV = [[UIImageView alloc] initWithFrame:CGRectMake(55+20, 21, 18, 18)];
        [self.audioImageV setImage:[UIImage imageNamed:@"audioplay003"]];
        [self.contentView addSubview:self.audioImageV];
        
        self.audioDurationL = [[UILabel alloc] initWithFrame:CGRectMake(55+20+30, 20, 50, 20)];
        [self.audioDurationL setBackgroundColor:[UIColor clearColor]];
        [self.audioDurationL setText:@"60''"];
        [self.audioDurationL setTextColor:[UIColor whiteColor]];
        [self.audioDurationL setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:self.audioDurationL];
        
        self.statusIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.contentView addSubview:self.statusIndicator];
        
        self.failedImageV = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.failedImageV setFrame:CGRectMake(0, 0, 35, 35)];
        [self.failedImageV setBackgroundImage:[UIImage imageNamed:@"chatsendfailed"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.failedImageV];
        [self.failedImageV addTarget:self action:@selector(resendMsg) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.needShowTime) {
        self.timeL.hidden = NO;
        self.timeL.text = [Common CurrentTime:0 AndMessageTime:self.chatMsg.date];
    }
    else
        self.timeL.hidden = YES;
    CGSize contentSize = CGSizeZero;
    if ([self.chatMsg.type isEqualToString:MSG_TYPE_TEXT]) {
        contentSize = [self.chatMsg.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-55-20-20-40, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        self.audioImageV.hidden  = YES;
        self.audioDurationL.hidden = YES;
        self.contentLabel.hidden = NO;
    }
    else if ([self.chatMsg.type isEqualToString:MSG_TYPE_AUDIO]){
        self.audioImageV.hidden  = NO;
        self.audioDurationL.hidden = NO;
        if ([self.chatMsg.contentLength intValue]<=4) {
            contentSize = CGSizeMake(60, 20);
            
        }
        else
        {
            contentSize = CGSizeMake(((([self.chatMsg.contentLength intValue]-4)>56?56:([self.chatMsg.contentLength intValue]-4))/60.0f)*([UIScreen mainScreen].bounds.size.width-55-20-20-40-60)+60, 20);
        }
        
        self.contentLabel.hidden = YES;
    }
    else
    {
        self.audioImageV.hidden  = YES;
        self.audioDurationL.hidden = YES;
        self.contentLabel.hidden = YES;
    }
//    NSLog(@"eeerrrrtrrrrr:%@",NSStringFromCGSize(fg.size));
    if (self.chatMsg.isMe) {
//        self.contentLabel.hidden = NO;
        self.contentLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        self.avatarImgV.imageURL = [NSURL URLWithString:[[UserServe sharedUserServe].currentPet.headImgURL stringByAppendingString:@"?imageView2/2/w/50"]];
        UIImage * fg = [UIImage imageNamed:@"chatbubbleme"];
        UIImage *image=[fg resizableImageWithCapInsets:UIEdgeInsetsMake(fg.size.height * (1.28/1.91f), fg.size.width * 0.20, fg.size.height * 0.19, fg.size.width * (0.85/2.33f)) resizingMode:UIImageResizingModeStretch];
        [self.bgImageV setImage:image];
        
        if (self.needShowTime) {
            [self.contentLabel setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-55-20-contentSize.width, 20+10, contentSize.width, contentSize.height<20?20:contentSize.height)];
        }
        else
            [self.contentLabel setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-55-20-contentSize.width, 20, contentSize.width, contentSize.height<20?20:contentSize.height)];
        [self.contentLabel setText:self.chatMsg.content];
        
        if (self.needShowTime) {
            [self.bgImageV setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-55-20-contentSize.width-10, 10+10, contentSize.width+30, (contentSize.height<20?20:contentSize.height)+20)];
        }
        else
            [self.bgImageV setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-55-20-contentSize.width-10, 10, contentSize.width+30, (contentSize.height<20?20:contentSize.height)+20)];
        
        if (self.needShowTime) {
            [self.avatarImgV setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-10-40, 10+10, 40, 40)];
        }
        else
            [self.avatarImgV setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-10-40, 10, 40, 40)];
        
        if ([self.chatMsg.status isEqualToString:@"sending"]) {
            self.statusIndicator.hidden = NO;
            self.failedImageV.hidden = YES;
            if (self.needShowTime) {
                self.statusIndicator.center = CGPointMake(self.bgImageV.frame.origin.x-15, self.bgImageV.frame.origin.y+(self.bgImageV.frame.size.height/2));
            }
            else
                self.statusIndicator.center = CGPointMake(self.bgImageV.frame.origin.x-15, self.bgImageV.frame.origin.y+(self.bgImageV.frame.size.height/2));
            [self.statusIndicator startAnimating];
            self.audioDurationL.hidden = YES;
        }
        else if ([self.chatMsg.status isEqualToString:@"failed"]){
            self.failedImageV.hidden = NO;
            self.statusIndicator.hidden = YES;
            self.audioDurationL.hidden = YES;
            self.failedImageV.center = CGPointMake(self.bgImageV.frame.origin.x-15, self.bgImageV.frame.origin.y+(self.bgImageV.frame.size.height/2));
        }
        else
        {
            self.failedImageV.hidden = YES;
            self.statusIndicator.hidden = YES;
            if ([self.chatMsg.type isEqualToString:MSG_TYPE_AUDIO]){
                self.audioDurationL.hidden = NO;
                
            }
            else
            {
                self.audioDurationL.hidden = YES;
            }
        }
        [self.audioImageV setImage:[UIImage imageNamed:@"audioplayme003"]];
        if (self.needShowTime) {
            [self.audioImageV setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-55-20-20, 21+10, 18, 18)];
            [self.audioDurationL setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-55-20-contentSize.width-10-50-5, 20+10, 50, 20)];
        }
        else{
            [self.audioImageV setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-55-20-20, 21, 18, 18)];
            [self.audioDurationL setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-55-20-contentSize.width-10-50-5, 20, 50, 20)];
        }
        [self.audioDurationL setTextAlignment:NSTextAlignmentRight];
        [self.audioDurationL setText:[NSString stringWithFormat:@"%d''",[self.chatMsg.contentLength intValue]]];
        
    }
    else{
        self.contentLabel.textColor = [UIColor blackColor];
        self.failedImageV.hidden = YES;
        if ([self.chatMsg.type isEqualToString:MSG_TYPE_AUDIO]){
            self.audioDurationL.hidden = NO;
            if (self.needShowTime) {
                [self.audioImageV setFrame:CGRectMake(75, 21+10, 18, 18)];
                [self.audioDurationL setFrame:CGRectMake(contentSize.width+30+55+5, 20+10, 50, 20)];
            }
            else{
                [self.audioImageV setFrame:CGRectMake(75, 21, 18, 18)];
                [self.audioDurationL setFrame:CGRectMake(contentSize.width+30+55+5, 20, 50, 20)];
            }
            [self.audioDurationL setTextAlignment:NSTextAlignmentLeft];
            [self.audioDurationL setText:[NSString stringWithFormat:@"%d''",[self.chatMsg.contentLength intValue]]];
        }
        else
        {
            self.audioDurationL.hidden = YES;
        }
        [self.statusIndicator stopAnimating];
        self.statusIndicator.hidden = YES;
        self.avatarImgV.imageURL = [NSURL URLWithString:[self.taAvatarUrl stringByAppendingString:@"?imageView2/2/w/50"]];
        UIImage * fg = [UIImage imageNamed:@"chatbubbleta"];
        UIImage *image=[fg resizableImageWithCapInsets:UIEdgeInsetsMake(fg.size.height * (1.30/1.91f), fg.size.width * (0.85/2.33f), fg.size.height * 0.2, fg.size.width * 0.21) resizingMode:UIImageResizingModeStretch];
        [self.bgImageV setImage:image];
        if (self.needShowTime) {
            [self.contentLabel setFrame:CGRectMake(55+20, 20+10, contentSize.width, contentSize.height<20?20:contentSize.height)];
            [self.bgImageV setFrame:CGRectMake(55, 10+10, contentSize.width+30, (contentSize.height<20?20:contentSize.height)+20)];
            
            [self.avatarImgV setFrame:CGRectMake(10, 10+10, 40, 40)];
        }
        else{
            [self.contentLabel setFrame:CGRectMake(55+20, 20, contentSize.width, contentSize.height<20?20:contentSize.height)];
            
            
            [self.bgImageV setFrame:CGRectMake(55, 10, contentSize.width+30, (contentSize.height<20?20:contentSize.height)+20)];
            
            [self.avatarImgV setFrame:CGRectMake(10, 10, 40, 40)];
        }
        [self.contentLabel setText:self.chatMsg.content];
        [self.audioImageV setImage:[UIImage imageNamed:@"audioplay003"]];
    }
    
//    image = [image stretchableImageWithLeftCapWidth:image.size.width * (0.85/2.33f) topCapHeight:image.size.height * (1.38/1.91f)];
    
    

}
-(void)headTouched
{
    if ([self.delegate respondsToSelector:@selector(headTouchedWithMsg:)]) {
        [self.delegate headTouchedWithMsg:self.chatMsg];
    }
}
-(void)resendMsg
{
    if ([self.delegate respondsToSelector:@selector(resendMsg:index:)]) {
        [self.delegate resendMsg:self.chatMsg index:self.cellIndex];
    }
}
-(void)bgTapped:(UIGestureRecognizer *)tap
{
    NSLog(@"tapped");
    if ([self.chatMsg.type isEqualToString:MSG_TYPE_AUDIO]) {
        if ([self.delegate respondsToSelector:@selector(audioClickedWithPath:cell:)]) {
            [self.delegate audioClickedWithPath:self.chatMsg.content cell:self];
        }
    }
}
-(void)bgLongPress
{
    NSLog(@"longPressed");
    if ([self.delegate respondsToSelector:@selector(longPressed:Index:)]) {
        [self.delegate longPressed:self Index:self.cellIndex];
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
