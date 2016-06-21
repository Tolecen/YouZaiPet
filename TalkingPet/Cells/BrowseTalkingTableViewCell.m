//
//  BrowseTalkingTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-12.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BrowseTalkingTableViewCell.h"
#import "Common.h"
@implementation BrowseTalkingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 505)];
        [bgV setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:bgV];

        self.contentImgV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
        self.contentImgV.backgroundColor = [UIColor grayColor];
        self.contentImgV.placeholderImage = [UIImage imageNamed:@"meizi.jpg"];
        [self.contentImgV setImage:[UIImage imageNamed:@"meizi.jpg"] forState:UIControlStateNormal];
        self.contentImgV.adjustsImageWhenHighlighted = NO;
        [self.contentImgV addTarget:self action:@selector(clickedContentImageV:) forControlEvents:UIControlEventTouchUpInside];
//        self.contentImgV.contentMode = UIViewContentModeCenter;
//        [self.contentImgV setImage:[UIImage imageNamed:@"meizi.jpg"]];
        [self.contentView addSubview:self.contentImgV];
        
        
        
        self.aniImageV = [[UIImageView alloc] initWithFrame:CGRectMake(160, 100, 120, 120)];
        self.aniImageV.backgroundColor = [UIColor clearColor];
        [self.contentImgV addSubview:self.aniImageV];
//        self.aniImageV.transform = CGAffineTransformRotate(self.aniImageV.transform, -M_PI/3.5);
        
        UIView * contentTextBgV = [[UIView alloc] initWithFrame:CGRectMake(10, 315, 300, 145)];
        [contentTextBgV setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
        [self.contentView addSubview:contentTextBgV];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 315, 290, 60)];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        self.contentLabel.numberOfLines = 0;
        [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentLabel setText:@"阿斯顿金卡数据的拉伸的就看见克拉斯贷记卡数据"];
        [self.contentView addSubview:self.contentLabel];
        
        self.tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tagBtn setFrame:CGRectMake(15, 375, 80, 20)];
        [self.tagBtn setBackgroundImage:[UIImage imageNamed:@"tagBgV"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.tagBtn];
        
        self.tagImgV = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2.5, 15, 15)];
        [self.tagImgV setImage:[UIImage imageNamed:@"label"]];
        [self.tagBtn addSubview:self.tagImgV];
        
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 55, 20)];
        [self.tagLabel setText:@"我好开森"];
        [self.tagLabel setBackgroundColor:[UIColor clearColor]];
        [self.tagLabel setFont:[UIFont systemFontOfSize:12]];
        [self.tagLabel setTextColor:[UIColor grayColor]];
        [self.tagBtn addSubview:self.tagLabel];
        
        
        self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.locationBtn setFrame:CGRectMake(310-87, 375, 82, 20)];
        [self.locationBtn setBackgroundImage:[UIImage imageNamed:@"addressBG"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.locationBtn];
        [_locationBtn addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.locationImgV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3.5, 8, 13)];
        [self.locationImgV setImage:[UIImage imageNamed:@"dingwei-xiao"]];
        [self.locationBtn addSubview:self.locationImgV];
        
        self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 55, 20)];
        [self.locationLabel setText:@"北京 朝阳"];
        [self.locationLabel setBackgroundColor:[UIColor clearColor]];
        [self.locationLabel setFont:[UIFont systemFontOfSize:12]];
        [self.locationLabel setTextColor:[UIColor whiteColor]];
        [self.locationBtn addSubview:self.locationLabel];
        
        self.publisherAvatarV = [[EGOImageButton alloc] initWithFrame:CGRectMake(15, 375+30, 50, 50)];
        [self.publisherAvatarV setBackgroundColor:[UIColor grayColor]];
        [_publisherAvatarV addTarget:self action:@selector(publisherAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.publisherAvatarV];
//        self.publisherAvatarV.placeholderImage = [UIImage imageNamed:@"placeholderHead.png"];
        [self.publisherAvatarV setBackgroundImage:[UIImage imageNamed:@"placeholderHead.png"] forState:UIControlStateNormal];
        
        UIImageView * avatarbg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 375+30, 50, 50)];
        [avatarbg setImage:[UIImage imageNamed:@"avatarbg1"]];
        [self.contentView addSubview:avatarbg];
        
        self.publisherNameL = [[UILabel alloc] initWithFrame:CGRectMake(75, 375+35, 200, 20)];
        [self.publisherNameL setBackgroundColor:[UIColor clearColor]];
        [self.publisherNameL setFont:[UIFont systemFontOfSize:15]];
        [self.publisherNameL setText:@"我是小黄瓜"];
        [self.contentView addSubview:self.publisherNameL];
        
        UILabel * bL = [[UILabel alloc] initWithFrame:CGRectMake(75, 375+35+20, 40, 20)];
        [bL setText:@"发表于:"];
        [bL setBackgroundColor:[UIColor clearColor]];
        [bL setTextColor:[UIColor grayColor]];
        [bL setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:bL];
        
        self.publishTime = [[UILabel alloc] initWithFrame:CGRectMake(75+45, 375+35+20, 160, 20)];
        [self.publishTime setText:@"2014-6-20"];
        [self.publishTime setBackgroundColor:[UIColor clearColor]];
        [self.publishTime setTextColor:[UIColor grayColor]];
        [self.publishTime setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.publishTime];
        
        self.relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.relationBtn setFrame:CGRectMake(310-72-5, 375+40, 72, 24.5)];
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu_normal"] forState:UIControlStateNormal];
        [self.relationBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.relationBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.relationBtn];
        [_relationBtn addTarget:self action:@selector(relationAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * bottomBG = [[UIView alloc] initWithFrame:CGRectMake(10, 375+30+50+5, 300, 45)];
        [bottomBG setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
        [self.contentView addSubview:bottomBG];
        bottomBG.userInteractionEnabled = YES;
        
        
        self.forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.forwardBtn setFrame:CGRectMake(0, 0, 75, 45)];
        [self.forwardBtn setBackgroundColor:[UIColor clearColor]];
        [bottomBG addSubview:self.forwardBtn];
        self.forwardBtn.showsTouchWhenHighlighted = YES;
        [_forwardBtn addTarget:self action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * forwardImgV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 2, 25, 25)];
        [forwardImgV setImage:[UIImage imageNamed:@"forward-ico"]];
        [self.forwardBtn addSubview:forwardImgV];
        
        self.forwardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 75, 20)];
        [self.forwardLabel setBackgroundColor:[UIColor clearColor]];
        [self.forwardLabel setText:@"108"];
        [self.forwardLabel setFont:[UIFont systemFontOfSize:11]];
        [self.forwardLabel setTextColor:[UIColor lightGrayColor]];
        [self.forwardLabel setTextAlignment:NSTextAlignmentCenter];
        [self.forwardBtn addSubview:self.forwardLabel];
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(75, 10, 1, 25)];
        [line1 setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
        [bottomBG addSubview:line1];
        
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentBtn setFrame:CGRectMake(75, 0, 75, 45)];
        [self.commentBtn setBackgroundColor:[UIColor clearColor]];
        [bottomBG addSubview:self.commentBtn];
        self.commentBtn.showsTouchWhenHighlighted = YES;
        [_commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * commentImgV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 4, 25, 25)];
        [commentImgV setImage:[UIImage imageNamed:@"comment-ico"]];
        [self.commentBtn addSubview:commentImgV];
        
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 75, 20)];
        [self.commentLabel setBackgroundColor:[UIColor clearColor]];
        [self.commentLabel setText:@"121"];
        [self.commentLabel setFont:[UIFont systemFontOfSize:11]];
        [self.commentLabel setTextColor:[UIColor lightGrayColor]];
        [self.commentLabel setTextAlignment:NSTextAlignmentCenter];
        [self.commentBtn addSubview:self.commentLabel];
        
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(75*2, 10, 1, 25)];
        [line2 setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
        [bottomBG addSubview:line2];
        
        self.favorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.favorBtn setFrame:CGRectMake(75*2, 0, 75, 45)];
        [self.favorBtn setBackgroundColor:[UIColor clearColor]];
        [bottomBG addSubview:self.favorBtn];
        self.favorBtn.showsTouchWhenHighlighted = YES;
        [_favorBtn addTarget:self action:@selector(favorAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * favorImgV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 2, 25, 25)];
        [favorImgV setImage:[UIImage imageNamed:@"step-ico"]];
        [self.favorBtn addSubview:favorImgV];
        
        self.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 75, 20)];
        [self.favorLabel setBackgroundColor:[UIColor clearColor]];
        [self.favorLabel setText:@"31"];
        [self.favorLabel setFont:[UIFont systemFontOfSize:11]];
        [self.favorLabel setTextColor:[UIColor lightGrayColor]];
        [self.favorLabel setTextAlignment:NSTextAlignmentCenter];
        [self.favorBtn addSubview:self.favorLabel];
        
        UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(75*3, 10, 1, 25)];
        [line3 setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
        [bottomBG addSubview:line3];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareBtn setFrame:CGRectMake(75*3, 0, 75, 45)];
        [self.shareBtn setBackgroundColor:[UIColor clearColor]];
        [bottomBG addSubview:self.shareBtn];
        self.shareBtn.showsTouchWhenHighlighted = YES;
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * shareImgV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 3, 25, 25)];
        [shareImgV setImage:[UIImage imageNamed:@"share-ico"]];
        [self.shareBtn addSubview:shareImgV];
        
        self.shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 75, 20)];
        [self.shareLabel setBackgroundColor:[UIColor clearColor]];
        [self.shareLabel setText:@"98"];
        [self.shareLabel setFont:[UIFont systemFontOfSize:11]];
        [self.shareLabel setTextColor:[UIColor lightGrayColor]];
        [self.shareLabel setTextAlignment:NSTextAlignmentCenter];
        [self.shareBtn addSubview:self.shareLabel];
        
//        self.audioPlayer = [XHAudioPlayerHelper shareInstance];
//        [self.audioPlayer setDelegate:self];
        
        self.loadingBGV = [[UIImageView alloc] initWithFrame:CGRectMake(118, 108, 84, 84)];
        [self.loadingBGV setImage:[UIImage imageNamed:@"loadingBGV"]];
        [self.contentView addSubview:self.loadingBGV];
        self.loadingBGV.hidden = YES;
        
        NSMutableArray * aniArray = [NSMutableArray array];
        for (int i = 0; i<24; i++) {
            [aniArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loadingAni%d",i+1]]];
        }
        
        self.loadingImgV = [[UIImageView alloc] initWithFrame:CGRectMake(120, 110, 80, 80)];
        [self.loadingImgV setImage:[UIImage imageNamed:@"loadingAni1"]];
        [self.contentView addSubview:self.loadingImgV];
        self.loadingImgV.animationImages = aniArray;
        self.loadingImgV.animationDuration = 2;
        self.loadingImgV.animationRepeatCount = 0;
        self.loadingImgV.hidden = YES;
//        [self.loadingImgV startAnimating];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.favorLabel.text = self.talking.favorNum;
    self.forwardLabel.text = self.talking.forwardNum;
    self.commentLabel.text = self.talking.commentNum;
    self.shareLabel.text = self.talking.shareNum;
//    self.publisherAvatarV.imageURL = [NSURL URLWithString:@"http://www.qqcan.com/uploads/allimg/c120811/1344A300Z50-3T615.jpg"];
//    self.aniImageV.image = [UIImage imageNamed:@"1_1"];
    [self.contentImgV setImageURL:[NSURL URLWithString:[self.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]];
    self.publishTime.text = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:self.talking.publishTime];
    self.publisherAvatarV.imageURL = [NSURL URLWithString:self.talking.petInfo.headImgURL];
    self.publisherNameL.text = self.talking.petInfo.nickname;
//    self.contentLabel.text = self.talking.descriptionContent;
    
    
    if ([TFileManager ifExsitFolder:self.talking.playAnimationImg.fileName]) {
        self.aniImageV.image = [TFileManager getFristImageWithID:self.talking.playAnimationImg.fileName];
        self.aniImageV.transform = CGAffineTransformIdentity;
        self.aniImageV.layer.transform = CATransform3DIdentity;
        
        [self.aniImageV setFrame:CGRectMake(0, 0, self.talking.playAnimationImg.width*300, self.talking.playAnimationImg.height*300)];
        self.aniImageV.center = CGPointMake(self.talking.playAnimationImg.centerX*300, self.talking.playAnimationImg.centerY*300);
        self.aniImageV.transform = CGAffineTransformRotate(self.aniImageV.transform, self.talking.playAnimationImg.rotationZ);
        
        
        CATransform3D tf = self.aniImageV.layer.transform;
        tf.m34 = 1.0 / -500;
        tf = CATransform3DRotate(tf, self.talking.playAnimationImg.rotationY, 0.0f, 1.0f, 0.0f);
        self.aniImageV.layer.transform = tf;
        self.aniImageV.layer.zPosition = 1000;

    }
    if (![TFileManager ifExsitFolder:self.talking.playAnimationImg.fileName]||![TFileManager ifExsitAudio:self.talking.audioName]) {
        self.loadingBGV.hidden = NO;
        self.loadingImgV.hidden = NO;
        if (![self.loadingImgV isAnimating]) {
            [self.loadingImgV startAnimating];
        }
    }
    else
    {
        self.loadingBGV.hidden = YES;
        self.loadingImgV.hidden = YES;
        [self.loadingImgV stopAnimating];
    }

}

-(void)hideLoading
{
    self.loadingBGV.hidden = YES;
    self.loadingImgV.hidden = YES;
    [self.loadingImgV stopAnimating];
}

-(void)playAnimation
{
    
}

-(void)stopAnimation
{
    
}
//-(void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer
//{
//    NSLog(@"stop playing....");
//    [self.aniImageV stopAnimating];
//}
-(void)clickedContentImageV:(EGOImageButton *)sender
{
//    if ([self.aniImageV isAnimating]) {
//        [self.audioPlayer stopAudio];
//        [self.aniImageV stopAnimating];
//    }
//    else
//    {
//        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
//        NSArray * g = [self.talking.audioUrl componentsSeparatedByString:@"/"];
//        NSString *accessorys2 = [[documents stringByAppendingPathComponent:@"Accessorys"] stringByAppendingPathComponent:[g lastObject]];
//        [self.audioPlayer managerAudioWithFileName:accessorys2 toPlay:YES];
//        [self.aniImageV startAnimating];
//    }
    if (_delegate&& [_delegate respondsToSelector:@selector(contentImageVClicked:CellType:)]) {
        [_delegate contentImageVClicked:self CellType:1];
    }
}
- (void)locationAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(locationWithTalkingBrowse:)]) {
        [_delegate locationWithTalkingBrowse:self.talking];
    }
}
- (void)relationAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(attentionPetWithTalkingBrowse:)]) {
        [_delegate attentionPetWithTalkingBrowse:self.talking];
    }
//    [self doAttention];
}
- (void)publisherAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(petProfileWhoPublishTalkingBrowse:)]) {
        [_delegate petProfileWhoPublishTalkingBrowse:self.talking];
    }
}
- (void)forwardAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(forwardWithTalkingBrowse:)]) {
        [_delegate forwardWithTalkingBrowse:self.talking];
    }
}
- (void)commentAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(commentWithTalkingBrowse:)]) {
        [_delegate commentWithTalkingBrowse:self.talking];
    }
}
- (void)favorAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(zanWithTalkingBrowse:)]) {
        [_delegate zanWithTalkingBrowse:self.talking];
    }
}
- (void)shareAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(shareWithTalkingBrowse:)]) {
        [_delegate shareWithTalkingBrowse:self.talking];
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
