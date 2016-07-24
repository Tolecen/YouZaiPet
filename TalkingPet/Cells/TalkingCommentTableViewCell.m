//
//  TalkingCommentTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "TalkingCommentTableViewCell.h"
#import "RootViewController.h"
#import "NSString+Base64.h"

@implementation TalkingCommentTableViewCell
+(CGSize)heightForRowWithComment:(TalkComment *)comment
{
//    CGSize commentSize = [comment.contentStr sizeConstrainedToSize:CGSizeMake(ScreenWidth-80, MAXFLOAT)];
    CGSize commentSize = [comment.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-80, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    if ([comment.contentType isEqualToString:@"AUDIO"]) {
        return CGSizeMake(commentSize.width, 40+10+commentSize.height+10);

    }
    else
        return CGSizeMake(commentSize.width, 40+10+commentSize.height+5);
}
//+(CGFloat)widthForRowWithComment:(TalkComment *)comment
//{
//    CGSize commentSize = [comment.contentStr sizeConstrainedToSize:CGSizeMake(240, 80)];
//    return commentSize.width;
//}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.commentAvatarV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [self.commentAvatarV setBackgroundColor:[UIColor grayColor]];
//        [self.commentAvatarV setImage:[UIImage imageNamed:@"gougouAvatar.jpeg"]];
        [self.commentAvatarV setBackgroundImage:[UIImage imageNamed:@"placeholderHead.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.commentAvatarV];
        [self.commentAvatarV addTarget:self action:@selector(publisherAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIImageView * avatarbg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [avatarbg setImage:[UIImage imageNamed:@"avatarbg2"]];
        [self.contentView addSubview:avatarbg];
        
        self.commentNameL = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 200, 20)];
        [self.commentNameL setBackgroundColor:[UIColor clearColor]];
        [self.commentNameL setFont:[UIFont systemFontOfSize:15]];
        self.commentNameL.textColor = CommonGreenColor;
        [self.contentView addSubview:self.commentNameL];
        self.commentNameL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapw = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publisherAction)];
        [self.commentNameL addGestureRecognizer:tapw];
        
        
        self.forwardedL = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 120, 20)];
        [self.forwardedL setBackgroundColor:[UIColor clearColor]];
        [self.forwardedL setTextColor:[UIColor grayColor]];
        [self.forwardedL setText:@"转发"];
        [self.forwardedL setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.forwardedL];
        
        self.commentL = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, ScreenWidth-80, 20)];
//        self.commentL.linkUnderlineStyle = kCTUnderlineStyleNone;
        [self.commentL setBackgroundColor:[UIColor clearColor]];
        [self.commentL setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
        [self.commentL setFont:[UIFont systemFontOfSize:14]];
        [self.commentL setNumberOfLines:0];
        [self.commentL setLineBreakMode:NSLineBreakByWordWrapping];
        [self.commentL setText:@"呦呦切克闹，煎饼果子来一套"];
        [self.contentView addSubview:self.commentL];
//        self.commentL.delegate = self;
        
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
        
        self.commentTimeL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-120, 15, 120, 20)];
        [self.commentTimeL setBackgroundColor:[UIColor clearColor]];
        [self.commentTimeL setTextAlignment:NSTextAlignmentRight];
        [self.commentTimeL setText:@"2014-6-20"];
        [self.commentTimeL setTextColor:[UIColor grayColor]];
        [self.commentTimeL setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.commentTimeL];
        
//        self.darenV = [[UIImageView alloc] initWithFrame:CGRectMake(10+50-17, 10+50-17, 17, 17)];
//        [self.darenV setImage:[UIImage imageNamed:@"daren"]];
//        [self.contentView addSubview:self.darenV];
        
        self.sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        [self.sepLine setBackgroundColor:[UIColor colorWithWhite:240/255.0f alpha:1]];
        [self.contentView addSubview:self.sepLine];
        self.sepLine.hidden = YES;

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.commentNameL.text = self.talkingComment.petNickname;
    self.commentAvatarV.imageURL = [NSURL URLWithString:[self.talkingComment.petAvatarURL stringByAppendingString:@"?imageView2/2/w/60"]];

    self.commentTimeL.text = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:self.talkingComment.commentTime];
    
    if ([self.talkingComment.commentType isEqualToString:@"R"]) {
        self.forwardedL.text = @"转发";
    }
    else
        self.forwardedL.text = @"评论";
    
    CGSize forwardedNameSize = [self.commentNameL.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(120, 20)];
    //    NSLog(@"sssss%f",forwardedNameSize.width);
    [self.commentNameL setFrame:CGRectMake(self.commentNameL.frame.origin.x, self.commentNameL.frame.origin.y, forwardedNameSize.width, 20)];
    //    [self.forwardedNameL setBackgroundColor:[UIColor redColor]];
    [self.forwardedL setFrame:CGRectMake(self.commentNameL.frame.origin.x+forwardedNameSize.width+5, 16, 50, 20)];
    
//    CGSize commentSize = [self.commentL.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 80)];
    
        CGSize commentSize = CGSizeMake(self.talkingComment.cWidth, self.talkingComment.cHeight);
    if ([self.talkingComment.contentType isEqualToString:@"AUDIO"]) {
        [self.commentL setFrame:CGRectMake(self.commentL.frame.origin.x, self.commentL.frame.origin.y, commentSize.width, commentSize.height-60)];
    }
    else
        [self.commentL setFrame:CGRectMake(self.commentL.frame.origin.x, self.commentL.frame.origin.y, commentSize.width, commentSize.height-55)];
    
    self.commentL.text = self.talkingComment.content;
    
    if ([self.talkingComment.contentType isEqualToString:@"AUDIO"]) {
        if (self.talkingComment.haveAimPet) {
            self.commentL.hidden = NO;
            [self.playRecordBtn setFrame:CGRectMake(70+commentSize.width, 39, 86, 22)];
            if (commentSize.width>=154) {
                [self.commentL setFrame:CGRectMake(self.commentL.frame.origin.x, self.commentL.frame.origin.y, 154, commentSize.height)];
                [self.playRecordBtn setFrame:CGRectMake(70+154, 40, 86, 22)];
            }
        }
        else {
            self.commentL.hidden = YES;
            [self.playRecordBtn setFrame:CGRectMake(70, 39, 86, 22)];
        }
        
        self.playRecordBtn.hidden = NO;
        self.recordDurationLabel.text = [self.talkingComment.audioDuration stringByAppendingString:@"s"];
    }
    else
    {
        self.commentL.hidden = NO;
        self.playRecordBtn.hidden = YES;
    }
    
    if (self.needShowSepLine) {
        self.sepLine.hidden = NO;
        [self.sepLine setFrame:CGRectMake(0, self.talkingComment.cHeight-1, ScreenWidth, 1)];
    }
    else
        self.sepLine.hidden = YES;
    
    
}

#pragma mark - OHAttributedLabelDelegate
-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
    NSLog(@"vvvvvvvv%@",linkInfo.URL);
    NSString * urlStr = [NSString stringWithFormat:@"%@",linkInfo.URL];
    if ([urlStr hasPrefix:@"http://"]) {
        WebContentViewController * webV = [[WebContentViewController alloc] init];
        webV.title = @"网页";
        webV.urlStr = urlStr;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:webV];
        [[RootViewController sharedRootViewController] presentViewController:nav animated:YES completion:^{
            
        }];
        return NO;
    }
    urlStr = [urlStr base64DecodedString];
    NSLog(@"vvvvvvvv%@",urlStr);
    if (urlStr) {
        if ([urlStr hasPrefix:@"@"]) {
            if (_delegate&& [_delegate respondsToSelector:@selector(commentAimUserNameClicked:Link:)]) {
                [_delegate commentAimUserNameClicked:self.talkingComment Link:linkInfo];
            }
        }
    }

    return YES;
}
-(UIColor*)attributedLabel:(OHAttributedLabel*)attributedLabel colorForLink:(NSTextCheckingResult*)linkInfo underlineStyle:(int32_t*)underlineStyle
{
    UIColor * textColor;
    textColor = [UIColor colorWithRed:60/255.0 green:198/255.0 blue:255/255.0 alpha:1];
    return textColor;
}
-(void)refreshCell
{
    CGSize forwardedNameSize = [self.commentNameL.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(120, 20)];
    //    NSLog(@"sssss%f",forwardedNameSize.width);
    [self.commentNameL setFrame:CGRectMake(self.commentNameL.frame.origin.x, self.commentNameL.frame.origin.y, forwardedNameSize.width, 20)];
    //    [self.forwardedNameL setBackgroundColor:[UIColor redColor]];
    [self.forwardedL setFrame:CGRectMake(self.commentNameL.frame.origin.x+forwardedNameSize.width+5, 16, 50, 20)];
    
    
}
- (void)publisherAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(commentPublisherBtnClicked:)]) {
        [_delegate commentPublisherBtnClicked:self.talkingComment];
    }
}
-(void)commentedNameClicked
{
    if (_delegate&& [_delegate respondsToSelector:@selector(commentPublisherNameClicked:)]) {
        [_delegate commentPublisherNameClicked:self.talkingComment];
    }
}
-(void)playRecordBtnClicked:(UIButton *)sender
{
    if (_delegate&& [_delegate respondsToSelector:@selector(commentPlayAudioBtnClicked:Cell:)]) {
        [_delegate commentPlayAudioBtnClicked:self.talkingComment Cell:self];
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
