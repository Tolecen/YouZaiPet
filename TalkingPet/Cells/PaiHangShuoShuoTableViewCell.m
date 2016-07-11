//
//  PaiHangShuoShuoTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/14.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PaiHangShuoShuoTableViewCell.h"
#import "RootViewController.h"
#import "SVProgressHUD.h"
@implementation PaiHangShuoShuoTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:245/255.0f alpha:1];
        self.contentView.backgroundColor = [UIColor colorWithWhite:245/255.0f alpha:1];
        self.bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth+90+65)];
        self.bg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bg];
        
        
        self.contentImgV = [[EGOImageButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        self.contentImgV.delegate = self;
        self.contentImgV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        self.contentImgV.adjustsImageWhenHighlighted = NO;
        self.contentImgV.clipsToBounds = YES;
        //        self.contentImgV.contentMode = UIViewContentModeCenter;
        //        [self.contentImgV setImage:[UIImage imageNamed:@"meizi.jpg"]];
        [self.contentView addSubview:self.contentImgV];
        [self.contentImgV addTarget:self action:@selector(clickedContentImageV:) forControlEvents:UIControlEventTouchUpInside];
        
        self.storyView = [[StoryCellView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        self.storyView.backgroundColor = [UIColor whiteColor];
        [self.contentImgV addSubview:self.storyView];
        
        self.contentTypeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 30)];
        [self.contentImgV addSubview:self.contentTypeImgV];
        
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth-2, ScreenWidth, 2)];
        [self.progressView setBackgroundColor:[UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1]];
        [self.contentView addSubview:self.progressView];
        
        self.aniImageV = [[UIImageView alloc] initWithFrame:CGRectMake(160, 100, 120, 120)];
        self.aniImageV.backgroundColor = [UIColor clearColor];
        [self.contentImgV addSubview:self.aniImageV];
        
        
        self.loadingBGV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-30, ScreenWidth-10-30, 30, 30)];
        [self.loadingBGV setImage:[UIImage imageNamed:@"loadingBGV"]];
        [self.contentView addSubview:self.loadingBGV];
        self.loadingBGV.hidden = YES;
        
        playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonTapped)];
        [self.loadingBGV addGestureRecognizer:playTap];
        
        
        self.loadingV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.loadingV setCenter:CGPointMake(15, 15)];
        [self.loadingBGV addSubview:self.loadingV];
        
//        self.bigZanImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentImgV.frame.size.width-10-70, self.contentImgV.frame.size.height-10-70, 70, 70)];
//        [self.bigZanImageV setImage:[UIImage imageNamed:@"newHaveZanBig"]];
//        [self.contentImgV addSubview:self.bigZanImageV];
//        self.bigZanImageV.hidden = YES;


        
        self.bottomBG = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth, ScreenWidth, 60)];
        [_bottomBG setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_bottomBG];
        
        UIImageView * tBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60/0.7, 60)];
        [tBg setImage:[UIImage imageNamed:@"list_title_top"]];
        [self.bottomBG addSubview:tBg];
        
        self.topImagev = [[UIImageView alloc] initWithFrame:CGRectMake((60/0.7-65)/2, 15, 65, 16)];
        [self.topImagev setImage:[UIImage imageNamed:@"list_title_top1"]];
        [self.bottomBG addSubview:self.topImagev];
        
        
        self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 60/0.7, 20)];
        [self.topLabel setBackgroundColor:[UIColor clearColor]];
        [self.topLabel setFont:[UIFont boldSystemFontOfSize:23]];
        self.topLabel.textColor = [UIColor whiteColor];
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        [self.bottomBG addSubview:self.topLabel];

        self.reduLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 60/0.7, 20)];
        [self.reduLabel setBackgroundColor:[UIColor clearColor]];
        [self.reduLabel setTextColor:[UIColor whiteColor]];
        [self.reduLabel setFont:[UIFont systemFontOfSize:14]];
        [self.reduLabel setAdjustsFontSizeToFitWidth:YES];
        [self.bottomBG addSubview:self.reduLabel];
        [self.reduLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        self.publisherAvatarV = [[EGOImageButton alloc] initWithFrame:CGRectMake(60/0.7+10, 10, 40, 40)];
        [self.publisherAvatarV setBackgroundColor:[UIColor grayColor]];
        [self.bottomBG addSubview:self.publisherAvatarV];
        [self.publisherAvatarV setBackgroundImage:[UIImage imageNamed:@"placeholderHead"] forState:UIControlStateNormal];
        [_publisherAvatarV addTarget:self action:@selector(publisherAction) forControlEvents:UIControlEventTouchUpInside];
        _publisherAvatarV.layer.masksToBounds = YES;
        _publisherAvatarV.layer.cornerRadius = 20;
        
        self.publisherNameL = [[UILabel alloc] initWithFrame:CGRectMake(60/0.7+10+50, 20, ScreenWidth-(60/0.7+10+50), 20)];
        [self.publisherNameL setBackgroundColor:[UIColor clearColor]];
        [self.publisherNameL setFont:[UIFont systemFontOfSize:16]];
        self.publisherNameL.textColor = [UIColor colorWithWhite:100/255.0f alpha:1];
        [self.publisherNameL setText:@"我是小黄瓜"];
        [self.bottomBG addSubview:self.publisherNameL];
        
        self.publisherNameL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapw = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publisherAction)];
        [self.publisherNameL addGestureRecognizer:tapw];
        
        self.darenV = [[UIImageView alloc] initWithFrame:CGRectMake(60/0.7+10+40-17, 10+40-17, 17, 17)];
        [self.darenV setImage:[UIImage imageNamed:@"daren"]];
        [self.bottomBG addSubview:self.darenV];
        
//        self.favorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.favorBtn setFrame:CGRectMake(ScreenWidth-10-30*2-30*2, 15, 60, 30)];
//        [self.favorBtn setBackgroundColor:[UIColor clearColor]];
//        [_bottomBG addSubview:self.favorBtn];
//        self.favorBtn.showsTouchWhenHighlighted = YES;
//        [_favorBtn addTarget:self action:@selector(favorAction) forControlEvents:UIControlEventTouchUpInside];
//        
//        self.favorImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        //            [_favorImgV setImage:[UIImage imageNamed:@"step-ico"]];
//        [self.favorBtn addSubview:_favorImgV];
//        [self.favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
//        
//        self.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 30, 20)];
//        [self.favorLabel setBackgroundColor:[UIColor clearColor]];
//        [self.favorLabel setText:@"31"];
//        [self.favorLabel setFont:[UIFont systemFontOfSize:13]];
//        //            [self.favorLabel setTextColor:[UIColor whiteColor]];
//        [self.favorLabel setTextAlignment:NSTextAlignmentCenter];
//        [self.favorBtn addSubview:self.favorLabel];
//        [self.favorLabel setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
//        [self.favorLabel setAdjustsFontSizeToFitWidth:YES];
//        
//        
//        
//        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.commentBtn setFrame:CGRectMake(self.favorBtn.frame.origin.x+60, 15, 60, 30)];
//        [self.commentBtn setBackgroundColor:[UIColor clearColor]];
//        [_bottomBG addSubview:self.commentBtn];
//        self.commentBtn.showsTouchWhenHighlighted = YES;
//        [_commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIImageView * commentImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        //            [commentImgV setImage:[UIImage imageNamed:@"comment-ico"]];
//        [self.commentBtn addSubview:commentImgV];
//        [commentImgV setImage:[UIImage imageNamed:@"browser_comment"]];
//        
//        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 30, 20)];
//        [self.commentLabel setBackgroundColor:[UIColor clearColor]];
//        [self.commentLabel setText:@"121"];
//        [self.commentLabel setFont:[UIFont systemFontOfSize:13]];
//        //            [self.commentLabel setTextColor:[UIColor whiteColor]];
//        [self.commentLabel setTextAlignment:NSTextAlignmentCenter];
//        [self.commentBtn addSubview:self.commentLabel];
//        [self.commentLabel setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
//        [self.commentLabel setAdjustsFontSizeToFitWidth:YES];
    }
    return self;
}
-(void)setProgressViewProgress:(float)progressAdded
{
    [self.progressView setFrame:CGRectMake(self.progressView.frame.origin.x, self.progressView.frame.origin.y, self.progressView.frame.size.width+progressAdded, 2)];
    //    NSLog(@"theProgress:%f,width:%f",progressAdded);
}
-(void)reSetProgressViewProgress
{
    [self.progressView setFrame:CGRectMake(self.progressView.frame.origin.x, self.progressView.frame.origin.y, 0, 2)];
    //    NSLog(@"theProgress:%f,width:%f",progressAdded);
}
- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton
{
    if ([self.talking.theModel isEqualToString:@"0"]) {
        self.aniImageV.hidden = NO;
    }
    else
        self.aniImageV.hidden = YES;
    //    if ([SystemServer sharedSystemServer].autoPlay) {
    //        if (<#condition#>) {
    //            <#statements#>
    //        }
    //    }
    //    NSLog(@"loaded");
    if (_imgdelegate&& [_imgdelegate respondsToSelector:@selector(ImagesLoadedCellIndex:)]){
        [_imgdelegate ImagesLoadedCellIndex:(int)self.cellIndex];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
     [self.progressView setFrame:CGRectMake(self.progressView.frame.origin.x, self.progressView.frame.origin.y, 0, 2)];
    if (self.cellIndex==0||self.cellIndex==1||self.cellIndex==2) {
        if (self.cellIndex==0) {
            [self.topImagev setImage:[UIImage imageNamed:@"list_title_top1"]];
            self.topImagev.hidden = NO;
            self.topLabel.hidden = YES;
        }
        else if (self.cellIndex==1){
            [self.topImagev setImage:[UIImage imageNamed:@"list_title_top2"]];
            self.topImagev.hidden = NO;
            self.topLabel.hidden = YES;
        }
        else if (self.cellIndex==2){
            [self.topImagev setImage:[UIImage imageNamed:@"list_title_top3"]];
            self.topImagev.hidden = NO;
            self.topLabel.hidden = YES;
        }
        [self.contentImgV setFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        [self.loadingBGV setFrame:CGRectMake(ScreenWidth-10-30, ScreenWidth-10-30, 30, 30)];
        [self.bottomBG setFrame:CGRectMake(0, ScreenWidth, ScreenWidth, 60)];
        [self.progressView setFrame:CGRectMake(0, ScreenWidth-2, 0, 2)];
        [self.bg setFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth+60)];
        
    }
    else
    {
        self.topImagev.hidden = YES;
        self.topLabel.hidden = NO;
        self.topLabel.text = [NSString stringWithFormat:@"TOP%d",(int)self.cellIndex+1];
        [self.contentImgV setFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        [self.loadingBGV setFrame:CGRectMake(ScreenWidth-10-30, ScreenWidth-10-30, 30, 30)];
        [self.bottomBG setFrame:CGRectMake(0, ScreenWidth, ScreenWidth, 60)];
        [self.progressView setFrame:CGRectMake(0, ScreenWidth-2, 0, 2)];
        [self.bg setFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth+60)];
    }
//    
//    self.favorLabel.text = [self.talking.favorNum intValue]>0?self.talking.favorNum:@"踩踩";
//    //    self.forwardLabel.text = self.talking.forwardNum;
//    self.commentLabel.text = [self.talking.commentNum intValue]>0?self.talking.commentNum:@"评论";
    //    self.publisherAvatarV.imageURL = [NSURL URLWithString:@"http://www.qqcan.com/uploads/allimg/c120811/1344A300Z50-3T615.jpg"];
    //    self.aniImageV.image = [UIImage imageNamed:@"1_1"];
    [self.contentImgV setImageURL:[NSURL URLWithString:[self.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]];
    self.publisherAvatarV.imageURL = [NSURL URLWithString:[self.talking.petInfo.headImgURL stringByAppendingString:@"?imageView2/2/w/60"]];
    self.publisherNameL.text = self.talking.petInfo.nickname;
    
    self.darenV.hidden = !self.talking.petInfo.ifDaren;
    
//    if (!self.talking.ifZan) {
//        [_favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
//    }
//    else
//    {
//        [_favorImgV setImage:[UIImage imageNamed:@"browser_zanned"]];
//        
//    }
    
    if ([self.talking.theModel isEqualToString:@"1"]) {
        self.aniImageV.hidden = YES;
        self.loadingBGV.hidden = YES;
        [self.contentTypeImgV setImage:[UIImage imageNamed:@"browser_typePic"]];
        self.contentImgV.userInteractionEnabled = NO;
        self.storyView.hidden = YES;
    }
    else if ([self.talking.theModel isEqualToString:@"2"]){
        self.storyView.hidden = NO;
        self.loadingBGV.hidden = YES;
        self.aniImageV.hidden = YES;
        self.contentImgV.userInteractionEnabled = NO;
        [self.contentTypeImgV setImage:[UIImage imageNamed:@"browser_typeStory"]];
        [self.storyView.storyImageV1 setImageURL:[NSURL URLWithString:[self.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]];
        [self.storyView.storyTimeL setText:[Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:self.talking.publishTime]];
        [self.storyView.storyTitleL setText:self.talking.descriptionContent];
    }
    else if ([self.talking.theModel isEqualToString:@"0"]){
        self.contentImgV.userInteractionEnabled = YES;
        self.storyView.hidden = YES;
        [self.contentTypeImgV setImage:[UIImage imageNamed:@"browser_typeShuoshuo"]];
        if ([TFileManager ifExsitFolder:self.talking.playAnimationImg.fileName]) {
            self.aniImageV.image = [TFileManager getFristImageWithID:self.talking.playAnimationImg.fileName];
            self.aniImageV.hidden = NO;
            self.aniImageV.transform = CGAffineTransformIdentity;
            self.aniImageV.layer.transform = CATransform3DIdentity;
            
            [self.aniImageV setFrame:CGRectMake(0, 0, self.talking.playAnimationImg.width*ScreenWidth, self.talking.playAnimationImg.height*ScreenWidth)];
            self.aniImageV.center = CGPointMake(self.talking.playAnimationImg.centerX*ScreenWidth, self.talking.playAnimationImg.centerY*ScreenWidth);
            self.aniImageV.transform = CGAffineTransformRotate(self.aniImageV.transform, self.talking.playAnimationImg.rotationZ);
            
            
            if ([self.talking.audioUrl isEqualToString:self.currentPlayingUrl]) {
                [self.aniImageV startAnimating];
            }

        }
        else
        {
            self.aniImageV.hidden = YES;
        }
        
        
//        [self.loadingBGV setFrame:CGRectMake(ScreenWidth-10-30, ScreenWidth+60-10-30, 30, 30)];
        
        if (![SystemServer sharedSystemServer].autoPlay) {
            self.loadingBGV.hidden = NO;
            [self.loadingBGV setImage:[UIImage imageNamed:@"browser_play"]];
            [self.loadingV stopAnimating];
            //        self.loadingV.hidden= YES;
        }
        else
        {
            if (![TFileManager ifExsitFolder:self.talking.playAnimationImg.fileName]||![TFileManager ifExsitAudio:self.talking.audioName]) {
                [self.loadingBGV setImage:[UIImage imageNamed:@"loadingBGV"]];
                
                self.loadingBGV.hidden = NO;
                if (![self.loadingV isAnimating]) {
                    
                    [self.loadingV startAnimating];
                    
                    
                }
            }
            else
            {

            }
        }
        
        if (self.contentImgV.currentImage) {
            self.aniImageV.hidden = NO;
            
        }
        else
            self.aniImageV.hidden = YES;
        
    }

    
    
}

-(void)showPlayBtn
{
    if ([self.talking.theModel isEqualToString:@"0"]) {
        self.loadingBGV.hidden = NO;
        [self.loadingBGV setImage:[UIImage imageNamed:@"browser_play"]];
        [self.loadingV stopAnimating];
    }
    else{
        self.loadingBGV.hidden = YES;
        [self.loadingBGV setImage:[UIImage imageNamed:@"browser_play"]];
        [self.loadingV stopAnimating];
    }
}
-(void)showLoading
{
    //    [self.loadingBGV removeGestureRecognizer:playTap];
    [self.loadingBGV setImage:[UIImage imageNamed:@"loadingBGV"]];
    
    self.loadingBGV.hidden = NO;
    //        [self.loadingImgV setFrame:CGRectMake(self.contentImgV.frame.origin.x+110, self.contentImgV.frame.origin.y+110, 84, 84)];
    if (![self.loadingV isAnimating]) {
        
        [self.loadingV startAnimating];
        
        
    }
}
-(void)refreshCell
{
    
}
-(void)hideLoading
{
    self.loadingBGV.hidden = YES;
    //    self.loadingImgV.hidden = YES;
    [self.loadingV stopAnimating];
}
-(void)playButtonTapped
{
    if ([self.loadingV isAnimating]) {
        return;
    }
    else
    {
        if (_delegate&& [_delegate respondsToSelector:@selector(contentImageVClicked:CellType:)]) {
            [self.loadingBGV setImage:[UIImage imageNamed:@"loadingBGV"]];
            //        self.loadingImgV.hidden = NO;
            //            [self.loadingBGV setFrame:CGRectMake(self.contentImgV.frame.origin.x+108, self.contentImgV.frame.origin.y+108, 84, 84)];
            
            self.loadingBGV.hidden = NO;
            //        [self.loadingImgV setFrame:CGRectMake(self.contentImgV.frame.origin.x+110, self.contentImgV.frame.origin.y+110, 84, 84)];
            if (![self.loadingV isAnimating]) {
                
                [self.loadingV startAnimating];
                
                
            }
            [_delegate contentImageVClicked:self CellType:2];
        }
    }
}

-(void)clickedContentImageV:(EGOImageButton *)sender
{
    if (_delegate&& [_delegate respondsToSelector:@selector(contentImageVClicked:CellType:)]) {
        [_delegate contentImageVClicked:self CellType:2];
    }
}
- (void)forwardedAvatarAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(petProfileWhoForwardTalkingBrowse:)]) {
        [_delegate petProfileWhoForwardTalkingBrowse:self.talking];
    }
}

- (void)publisherAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(petProfileWhoPublishTalkingBrowse:)]) {
        [_delegate petProfileWhoPublishTalkingBrowse:self.talking];
    }
}

- (void)commentAction
{
    NSString * currentPetId = [UserServe sharedUserServe].userID;
    if (!currentPetId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录才能执行更多操作哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }
    if (_delegate&& [_delegate respondsToSelector:@selector(commentWithTalkingBrowse:)]) {
        [_delegate commentWithTalkingBrowse:self.talking];
    }
}
- (void)favorAction
{
    NSString * currentPetId = [UserServe sharedUserServe].userID;
    if (!currentPetId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录才能执行更多操作哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }
    //    if (_delegate&& [_delegate respondsToSelector:@selector(zanWithTalkingBrowse:)]) {
    //        [_delegate zanWithTalkingBrowse:self.talking];
    //    }
    self.lastIndex = self.cellIndex;
    if (self.talking.ifZan) {
        return;
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
        self.talking.ifZan = NO;
        
        self.favorLabel.text =[NSString stringWithFormat:@"%d",[self.favorLabel.text intValue]>0?([self.favorLabel.text intValue]-1):0];
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"interaction" forKey:@"command"];
        [mDict setObject:@"cancelFavour" forKey:@"options"];
        [mDict setObject:self.talking.theID forKey:@"petalkId"];
        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        
        
        NSLog(@"cancelFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"cancel favor success:%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"cancel favor error:%@",error);
            
        }];
    }
    else{
        self.talking.ifZan = YES;
        self.favorBtn.enabled = NO;
        
        //        [self performSelector:@selector(zanMakeBig) withObject:nil afterDelay:0.2];
        [self zanMakeBig];
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zanned"]];
        self.favorLabel.text =[NSString stringWithFormat:@"%d",[self.favorLabel.text intValue]+1];
        
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"interaction" forKey:@"command"];
        [mDict setObject:@"create" forKey:@"options"];
        [mDict setObject:self.talking.theID forKey:@"petalkId"];
        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        
        
        NSLog(@"doFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"favor success:%@",responseObject);
            if ([responseObject objectForKey:@"message"]) {
                [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favor error:%@",error);
            
        }];
    }
}

-(void)zanMakeBig
{
    if (self.lastIndex!=self.cellIndex) {
        return;
    }
    self.bigZanImageV.hidden = NO;
    [self.contentImgV bringSubviewToFront:self.bigZanImageV];
    self.bigZanImageV.tag = 1;
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.8];
    [self.bigZanImageV.layer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!self) {
        return;
    }
    if (self.lastIndex!=self.cellIndex) {
        self.bigZanImageV.hidden = YES;
        return;
    }
    
    if (self.bigZanImageV.tag==1) {
        self.bigZanImageV.tag = 2;
        //        [self.bigZanImageV setFrame:CGRectMake(8, 0, 20, 20)];
        //        [self.bigZanImageV setFont:[UIFont systemFontOfSize:20]];
        CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [spin setFromValue:[NSNumber numberWithFloat:M_PI*2]];
        [spin setToValue:[NSNumber numberWithFloat:M_PI * 4.25]];
        
        
        
        [spin setDuration:0.3];
        [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
        //速度控制器
        [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        //添加动画
        //        self.addMarkLabel.tag = 1;
        [[self.bigZanImageV layer] addAnimation:spin forKey:nil];
        
    }
    else if (self.bigZanImageV.tag==2){
        [self performSelector:@selector(makeBigZanHidden) withObject:nil afterDelay:1.2];
    }
    
}
-(void)makeBigZanHidden
{
    if (self.lastIndex!=self.cellIndex) {
        self.bigZanImageV.hidden = YES;
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bigZanImageV.alpha = 0;
    } completion:^(BOOL finished) {
        self.bigZanImageV.tag=3;
        self.bigZanImageV.alpha = 1;
        self.bigZanImageV.hidden = YES;
        self.favorBtn.enabled = YES;
        //        [self.delegate attentionPetWithTalkingBrowse:self.talking];
    }];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
