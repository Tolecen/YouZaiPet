//
//  TimeLineTalkingTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/1/30.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "TimeLineTalkingTableViewCell.h"
#import "RootViewController.h"
#import "TFileManager.h"
#import "SVProgressHUD.h"

@implementation TimeLineTalkingTableViewCell
+(CGFloat)heightForRowWithTalking:(TalkingBrowse *)theTalking CellType:(int)cellType
{
    CGFloat cellHeight = 0;
    
    CGSize forwardedNameSize = [theTalking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(cellType==0?(ScreenWidth-45-10-10):(ScreenWidth-20), 100)];
    if ([theTalking.descriptionContent isEqualToString:@""]) {
        forwardedNameSize.height = 0;
        cellHeight = (cellType==0?(ScreenWidth-45-10):(ScreenWidth+60+5))+5;
    }
    else
        cellHeight = (cellType==0?(ScreenWidth-45-10):(ScreenWidth+60+5))+5+forwardedNameSize.height;
    
    if ([theTalking.location.address isEqualToString:@""]||[theTalking.location.address isEqualToString:@" "]) {
    }
    else{
        CGPoint lastPoint;
        CGSize sz = [theTalking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 100) lineBreakMode:NSLineBreakByCharWrapping];
        
        CGSize linesSz = [theTalking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(cellType==0?(ScreenWidth-45-10-10):(ScreenWidth-20), MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        if((sz.width > linesSz.width && linesSz.height > 20)||(sz.width > linesSz.width && linesSz.height > 40))//判断是否折行
        {
            lastPoint = CGPointMake(45+5 + (int)sz.width % (int)linesSz.width,linesSz.height - 15+(cellType==0?(ScreenWidth-45-10+5):(ScreenWidth+60+5)));
        }
        else
        {
            lastPoint = CGPointMake(45+5 + sz.width, linesSz.height - 15+(cellType==0?(ScreenWidth-45-10+5):(ScreenWidth+60+5)));
            if (lastPoint.y<(cellType==0?(ScreenWidth-45-10+5):(ScreenWidth+60+5))) {
                cellHeight = cellHeight+15;
            }
            
        }

        CGSize locationSize = [theTalking.location.address sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(120, 20)];
        if (lastPoint.x+5+22+locationSize.width+8>(ScreenWidth-15)) {
            cellHeight = cellHeight+5+15;
        }
        else
        {
            
        }

    }

    if (theTalking.tagArray.count==0) {
        //        self.tagView.hidden = YES;
        
    }
    else
    {
        cellHeight = cellHeight +10+20;
        
    }
        cellHeight = cellHeight+5+30;
        cellHeight = cellHeight+5;
    if (theTalking.ifForward) {
        CGSize forwardNameSize = [theTalking.forwardInfo.forwardDescription sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(cellType==0?(ScreenWidth-45-10):(ScreenWidth-20), 100)];
        cellHeight = cellHeight+20+forwardNameSize.height+5;
    }
    return cellHeight+20;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHead:(BOOL)showHead
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.showTheHead = showHead;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.dotImageV = [[UIImageView alloc] initWithFrame:CGRectMake(showHead?30:18, 0, 10, 10)];
        [self.dotImageV setImage:[UIImage imageNamed:@"timeLine_dot"]];
        [self.contentView addSubview:self.dotImageV];
        
        self.underDotLineV = [[UIView alloc] initWithFrame:CGRectMake(showHead?35:23, 11, 1, 100)];
        [self.underDotLineV setBackgroundColor:[UIColor colorWithWhite:200/255.0f alpha:1]];
        [self.contentView addSubview:self.underDotLineV];
        

        
        self.leftLineV = [[UIView alloc] initWithFrame:CGRectMake(44, 0, 1, 100)];
        [self.leftLineV setBackgroundColor:[UIColor colorWithWhite:200/255.0f alpha:1]];
        [self.contentView addSubview:self.leftLineV];
        
        self.bottomLineV = [[UIView alloc] initWithFrame:CGRectMake(45, 0, ScreenWidth-45-10, 1)];
        [self.bottomLineV setBackgroundColor:[UIColor colorWithWhite:200/255.0f alpha:1]];
        [self.contentView addSubview:self.bottomLineV];
        

        
        self.rightLineV = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-10, 0, 1, 100)];
        [self.rightLineV setBackgroundColor:[UIColor colorWithWhite:200/255.0f alpha:1]];
        [self.contentView addSubview:self.rightLineV];
        
        self.contentImageV = [[EGOImageButton alloc] initWithFrame:CGRectMake(45, 0, ScreenWidth-45-10,ScreenWidth-45-10)];
        [self.contentImageV setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
        [self.contentView addSubview:self.contentImageV];
        self.contentImageV.userInteractionEnabled = NO;
        self.contentImageV.delegate = self;
        self.contentImageV.clipsToBounds = YES;
        
        
        self.storyView = [[StoryCellView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-45-10, ScreenWidth-45-10)];
        self.storyView.backgroundColor = [UIColor whiteColor];
        [self.contentImageV addSubview:self.storyView];
        self.storyView.hidden = YES;
//        self.storyView.userInteractionEnabled = YES;
//        //        [self.storyView addTarget:self action:@selector(storyClicked) forControlEvents:UIControlEventTouchUpInside];
//        
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storyClicked)];
//        [self.storyView addGestureRecognizer:tap];
        
        
        self.contentTypeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 42, 30)];
        [self.contentImageV addSubview:self.contentTypeImgV];
        
        self.topLineV = [[UIView alloc] initWithFrame:CGRectMake(45, 0, ScreenWidth-45-10, 1)];
        [self.topLineV setBackgroundColor:[UIColor colorWithWhite:200/255.0f alpha:1]];
        [self.contentView addSubview:self.topLineV];
        
        self.bigZanImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentImageV.frame.size.width-10-70, self.contentImageV.frame.size.height-70-10, 70, 70)];
        [self.bigZanImageV setImage:[UIImage imageNamed:@"newHaveZanBig"]];
        [self.contentImageV addSubview:self.bigZanImageV];
        self.bigZanImageV.hidden = YES;
        
        self.aniImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        self.aniImageV.backgroundColor = [UIColor clearColor];
        [self.contentImageV addSubview:self.aniImageV];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45+5, ScreenWidth-45-10+5, ScreenWidth-45-10-10, 60)];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        self.contentLabel.numberOfLines = 0;
        [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentLabel setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
        [self.contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentLabel setText:@"阿斯顿金卡数据的拉伸的就看见克拉斯贷记卡数据"];
        [self.contentView addSubview:self.contentLabel];
        
        
        self.tagView = [[UIView alloc] initWithFrame:CGRectMake(45+5, 370, ScreenWidth-45-10-10, 20)];
        self.tagView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.tagView];
        
        //        for (int i = 0; i<5; i++) {
        UIButton * tB = [UIButton buttonWithType:UIButtonTypeCustom];
        tB.tag = 900;
        [tB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tB.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [tB setFrame:CGRectMake(10, 370, 80, 20)];
        [tB setTitleEdgeInsets:UIEdgeInsetsMake(1, 15, 0, 0)];
        [tB setBackgroundColor:[UIColor colorWithRed:133/255.0 green:203/255.0 blue:252/255.0 alpha:0.7]];
        tB.layer.cornerRadius = 8;
        tB.layer.masksToBounds = YES;
        [tB addTarget:self action:@selector(tagBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.tagView addSubview:tB];
        tB.hidden = YES;
        UIImageView * timg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 4, 14, 12)];
        [timg setImage:[UIImage imageNamed:@"tagImg"]];
        [tB addSubview:timg];

        //        }
        
        
        self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.locationBtn setFrame:CGRectMake(310-87-5, 370, 82, 20)];
        [self.contentView addSubview:self.locationBtn];
        [self.locationBtn setBackgroundColor:[UIColor colorWithRed:133/255.0 green:203/255.0 blue:252/255.0 alpha:0.7]];
        self.locationBtn.layer.cornerRadius = 5;
        self.locationBtn.layer.masksToBounds = YES;
        [_locationBtn addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.locationImgV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 2, 7, 11)];
        [self.locationImgV setImage:[UIImage imageNamed:@"dingwei-xiao"]];
        [self.locationBtn addSubview:self.locationImgV];
        
        self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 55, 20)];
        [self.locationLabel setBackgroundColor:[UIColor clearColor]];
        [self.locationLabel setText:@"北京 朝阳"];
        [self.locationLabel setFont:[UIFont systemFontOfSize:11]];
        [self.locationLabel setTextColor:[UIColor whiteColor]];
        [self.locationBtn addSubview:self.locationLabel];
        
        self.bottomBG = [[UIView alloc] initWithFrame:CGRectMake(0, 370+30+50+5, ScreenWidth-45-10, 30)];
        [_bottomBG setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_bottomBG];
        
        self.favorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.favorBtn setFrame:CGRectMake(45+(ScreenWidth-45-10-30*3-30*3), 0, 60, 30)];
        [self.favorBtn setBackgroundColor:[UIColor clearColor]];
        [_bottomBG addSubview:self.favorBtn];
        self.favorBtn.showsTouchWhenHighlighted = YES;
        [_favorBtn addTarget:self action:@selector(favorAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.favorImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        //            [_favorImgV setImage:[UIImage imageNamed:@"step-ico"]];
        [self.favorBtn addSubview:_favorImgV];
        [self.favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
        
        self.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 30, 20)];
        [self.favorLabel setBackgroundColor:[UIColor clearColor]];
        [self.favorLabel setText:@"31"];
        [self.favorLabel setFont:[UIFont systemFontOfSize:13]];
        //            [self.favorLabel setTextColor:[UIColor whiteColor]];
        [self.favorLabel setTextAlignment:NSTextAlignmentCenter];
        [self.favorBtn addSubview:self.favorLabel];
        [self.favorLabel setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
        [self.favorLabel setAdjustsFontSizeToFitWidth:YES];
        
        
        
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentBtn setFrame:CGRectMake(self.favorBtn.frame.origin.x+60, 0, 60, 30)];
        [self.commentBtn setBackgroundColor:[UIColor clearColor]];
        [_bottomBG addSubview:self.commentBtn];
        self.commentBtn.showsTouchWhenHighlighted = YES;
        [_commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * commentImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        //            [commentImgV setImage:[UIImage imageNamed:@"comment-ico"]];
        [self.commentBtn addSubview:commentImgV];
        [commentImgV setImage:[UIImage imageNamed:@"browser_comment"]];
        
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 30, 20)];
        [self.commentLabel setBackgroundColor:[UIColor clearColor]];
        [self.commentLabel setText:@"121"];
        [self.commentLabel setFont:[UIFont systemFontOfSize:13]];
        //            [self.commentLabel setTextColor:[UIColor whiteColor]];
        [self.commentLabel setTextAlignment:NSTextAlignmentCenter];
        [self.commentBtn addSubview:self.commentLabel];
        [self.commentLabel setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
        [self.commentLabel setAdjustsFontSizeToFitWidth:YES];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareBtn setFrame:CGRectMake(self.commentBtn.frame.origin.x+60, 0, 60, 30)];
        [self.shareBtn setBackgroundColor:[UIColor clearColor]];
        [_bottomBG addSubview:self.shareBtn];
        self.shareBtn.showsTouchWhenHighlighted = YES;
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * shareImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        //            [shareImgV setImage:[UIImage imageNamed:@"share-ico"]];
        [self.shareBtn addSubview:shareImgV];
        [shareImgV setImage:[UIImage imageNamed:@"browser_forward"]];
        
        self.shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 30, 20)];
        [self.shareLabel setBackgroundColor:[UIColor clearColor]];
        [self.shareLabel setText:@"98"];
        [self.shareLabel setFont:[UIFont systemFontOfSize:13]];
        //            [self.shareLabel setTextColor:[UIColor whiteColor]];
        [self.shareLabel setTextAlignment:NSTextAlignmentCenter];
        [self.shareBtn addSubview:self.shareLabel];
        [self.shareLabel setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
        [self.shareLabel setAdjustsFontSizeToFitWidth:YES];
        
        self.forwardView = [[UIView alloc] initWithFrame:CGRectMake(45, 0, ScreenWidth-45-10,60)];
        self.forwardView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.forwardView];
        UILabel * hg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        [hg setBackgroundColor:[UIColor clearColor]];
        hg.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
        hg.font = [UIFont boldSystemFontOfSize:13];
        hg.text = @"转自:";
        [self.forwardView addSubview:hg];
        
        self.forwardNameL = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, ScreenWidth-45-10-30, 20)];
        self.forwardNameL.backgroundColor = [UIColor clearColor];
        self.forwardNameL.textColor = [UIColor colorWithRed:182/255.0 green:178/255.0 blue:251/255.0 alpha:1];
        self.forwardNameL.font = [UIFont boldSystemFontOfSize:13];
        [self.forwardView addSubview:self.forwardNameL];
        self.forwardNameL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapw = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publisherAction)];
        [self.forwardNameL addGestureRecognizer:tapw];
        
        self.forwardContentL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-45-10, 20)];
        self.forwardContentL.backgroundColor = [UIColor clearColor];
        self.forwardContentL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
        self.forwardContentL.numberOfLines = 0;
        self.forwardContentL.lineBreakMode = NSLineBreakByCharWrapping;
        self.forwardContentL.font = [UIFont systemFontOfSize:13];
        [self.forwardView addSubview:self.forwardContentL];
        
        self.lastbottomLineV = [[UIView alloc] initWithFrame:CGRectMake(36, 0, ScreenWidth-45-10, 1)];
        [self.lastbottomLineV setBackgroundColor:[UIColor colorWithWhite:200/255.0f alpha:1]];
        [self.contentView addSubview:self.lastbottomLineV];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize forwardedNameSize = [self.talking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-45-10-10, 100)];
    if ([self.talking.descriptionContent isEqualToString:@""]) {
        forwardedNameSize.height = 0;
    }
    
    if (!self.talking.ifZan) {
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
       
    }
    else
    {
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zanned"]];
        
    }
    
    if ([self.talking.theModel isEqualToString:@"1"]) {
        self.aniImageV.hidden = YES;
        self.storyView.hidden = YES;
        [self.contentTypeImgV setImage:[UIImage imageNamed:@"browser_typePic"]];
        [_dotImageV setImage:[UIImage imageNamed:@"timeLine_dot"]];
        self.contentImageV.userInteractionEnabled = NO;
    }
    else if ([self.talking.theModel isEqualToString:@"2"]){
        self.aniImageV.hidden = YES;
        self.storyView.hidden = NO;
        [self.contentTypeImgV setImage:[UIImage imageNamed:@"browser_typeStory"]];
        [self.storyView.storyImageV1 setImageURL:[NSURL URLWithString:[self.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/400"]]];
        [self.storyView.storyTimeL setText:[Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:self.talking.publishTime]];
        [self.storyView.storyTitleL setText:self.talking.descriptionContent];
    }

    else if([self.talking.theModel isEqualToString:@"0"]){
        self.storyView.hidden = YES;
        self.contentImageV.userInteractionEnabled = NO;
        [self.contentTypeImgV setImage:[UIImage imageNamed:@"browser_typeShuoshuo"]];
        [_dotImageV setImage:[UIImage imageNamed:@"timeLine_dot"]];
        if ([TFileManager ifExsitFolder:self.talking.playAnimationImg.fileName]) {
            self.aniImageV.image = [TFileManager getFristImageWithID:self.talking.playAnimationImg.fileName];
            self.aniImageV.hidden = NO;
            self.aniImageV.transform = CGAffineTransformIdentity;
            self.aniImageV.layer.transform = CATransform3DIdentity;
            
            [self.aniImageV setFrame:CGRectMake(0, 0, self.talking.playAnimationImg.width*self.contentImageV.frame.size.width, self.talking.playAnimationImg.height*self.contentImageV.frame.size.width)];
            self.aniImageV.center = CGPointMake(self.talking.playAnimationImg.centerX*self.contentImageV.frame.size.width, self.talking.playAnimationImg.centerY*self.contentImageV.frame.size.width);
            self.aniImageV.transform = CGAffineTransformRotate(self.aniImageV.transform, self.talking.playAnimationImg.rotationZ);
            
            
        }
        else
        {
            self.aniImageV.hidden = YES;
        }
        
        
        
        if ([self.contentImageV ifExsitUrl:[NSURL URLWithString:[self.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/400"]]]) {
            self.aniImageV.hidden = NO;
            
        }
        else
            self.aniImageV.hidden = YES;
    }
    self.bigZanImageV.hidden = YES;
    self.favorBtn.enabled = YES;
    self.favorLabel.text = [self.talking.favorNum intValue]>0?self.talking.favorNum:@"踩踩";
    //    self.forwardLabel.text = self.talking.forwardNum;
    self.commentLabel.text = [self.talking.commentNum intValue]>0?self.talking.commentNum:@"评论";
    self.shareLabel.text = ([self.talking.shareNum intValue]+[self.talking.forwardNum intValue])>0?[NSString stringWithFormat:@"%d",[self.talking.shareNum intValue]+[self.talking.forwardNum intValue]]:@"分享";
    [self.contentImageV setImageURL:[NSURL URLWithString:[self.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/400"]]];
    [self.underDotLineV setFrame:CGRectMake(self.showTheHead?35:23, 10, 1, self.talking.rowHeight-10)];
    [self.contentLabel setText:self.talking.descriptionContent];
    [self.contentLabel setFrame:CGRectMake(45+5, ScreenWidth-45-10+5, ScreenWidth-45-10-10, forwardedNameSize.height)];
    
    if ([self.talking.location.address isEqualToString:@""]||[self.talking.location.address isEqualToString:@" "]) {
        self.locationBtn.hidden = YES;
    }
    else{
        CGPoint lastPoint;
        CGSize sz = [self.talking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 100) lineBreakMode:NSLineBreakByCharWrapping];
        
        CGSize linesSz = [self.talking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-45-10-10, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        if((sz.width > linesSz.width && linesSz.height > 20)||(sz.width > linesSz.width && linesSz.height > 40))//判断是否折行
        {
            lastPoint = CGPointMake(self.contentLabel.frame.origin.x + (int)sz.width % (int)linesSz.width,linesSz.height - 15+self.contentLabel.frame.origin.y);
        }
        else
        {
            lastPoint = CGPointMake(self.contentLabel.frame.origin.x + sz.width, linesSz.height - 15+self.contentLabel.frame.origin.y);
            if (lastPoint.y<ScreenWidth-45-10+5) {
                lastPoint.y = ScreenWidth-45-10+5;
            }
        }
        
        self.locationBtn.hidden = NO;
//        UIImage * dwbgImage = [[UIImage imageNamed:@"addressBG"]
//                               stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//        [self.locationBtn setBackgroundImage:dwbgImage forState:UIControlStateNormal];
        CGSize locationSize = [self.talking.location.address sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(120, 20)];
        if (lastPoint.x+5+22+locationSize.width+8>ScreenWidth-15) {
            [self.locationBtn setFrame:CGRectMake(self.contentLabel.frame.origin.x, forwardedNameSize.height+self.contentLabel.frame.origin.y+5, 22+locationSize.width+8, 15)];
        }
        else
            //            [self.locationBtn setFrame:CGRectMake(10, 60+300+5+forwardedNameSize.height+5, 22+locationSize.width+8, 20)];
            [self.locationBtn setFrame:CGRectMake(lastPoint.x+5, lastPoint.y, 22+locationSize.width+8, 15)];
        [self.locationLabel setFrame:CGRectMake(self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y, locationSize.width, 15)];
        [self.locationLabel setText:self.talking.location.address];
    }
    
    
    if (self.talking.tagArray.count==0) {
        self.tagView.hidden = YES;
    }
    else
    {
        self.tagView.hidden = NO;
        UIButton * tB = (UIButton *)[self.tagView viewWithTag:900];
        //                if (i<self.talking.tagArray.count) {
        tB.hidden = NO;
        [tB setTitle:[self.talking.tagArray[0] objectForKey:@"name"] forState:UIControlStateNormal];
        
        
        CGSize tagSize = [[self.talking.tagArray[0] objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(120, 20)];

        [tB setFrame:CGRectMake(5, 0, tagSize.width+30, 20)];

//        UIImage * tagImage = [[UIImage imageNamed:@"tagBlueBG"]
//                              stretchableImageWithLeftCapWidth:20 topCapHeight:10];
//        [tB setBackgroundImage:tagImage forState:UIControlStateNormal];
        [self.tagView setFrame:CGRectMake(self.tagView.frame.origin.x, self.locationBtn.hidden?self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+5:self.locationBtn.frame.origin.y+15+10, ScreenWidth-45-10-10, 20)];

    }
    
    if (self.tagView.hidden&&self.locationBtn.hidden) {
        [self.bottomBG setFrame:CGRectMake(0, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+5, ScreenWidth, 30)];
    }
    else if (self.tagView.hidden&&!self.locationBtn.hidden){
        [self.bottomBG setFrame:CGRectMake(0, self.locationBtn.frame.origin.y+self.locationBtn.frame.size.height+5, ScreenWidth, 30)];
    }
    else if (!self.tagView.hidden&&self.locationBtn.hidden){
        [self.bottomBG setFrame:CGRectMake(0, self.tagView.frame.origin.y+self.tagView.frame.size.height+5, ScreenWidth, 30)];
    }
    else
    {
        [self.bottomBG setFrame:CGRectMake(0, self.tagView.frame.origin.y+self.tagView.frame.size.height+5, ScreenWidth, 30)];
    }
    
    [self.bottomLineV setFrame:CGRectMake(45, self.bottomBG.frame.origin.y+self.bottomBG.frame.size.height+5, ScreenWidth-45-10, 1)];
    [self.leftLineV setFrame:CGRectMake(44, 0, 1, self.bottomBG.frame.origin.y+self.bottomBG.frame.size.height+6)];
    [self.rightLineV setFrame:CGRectMake(ScreenWidth-10, 0, 1, self.bottomBG.frame.origin.y+self.bottomBG.frame.size.height+6)];
    
    if (self.talking.ifForward) {
        self.forwardView.hidden = NO;
        [self.forwardView setFrame:CGRectMake(45, self.bottomLineV.frame.origin.y+6, ScreenWidth-45-10,60)];
        self.forwardNameL.text = self.talking.petInfo.nickname;
        CGSize forwardNameSize = [self.talking.forwardInfo.forwardDescription sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenWidth-45-10, 100)];
        [self.forwardContentL setFrame:CGRectMake(0, 20, ScreenWidth-45-10, forwardNameSize.height)];
        self.forwardContentL.text = self.talking.forwardInfo.forwardDescription;
        [self.forwardView setFrame:CGRectMake(45, self.bottomLineV.frame.origin.y+6, ScreenWidth-45-10,20+forwardNameSize.height)];
        [self.lastbottomLineV setFrame:CGRectMake(self.lastbottomLineV.frame.origin.x, self.forwardView.frame.origin.y+self.forwardView.frame.size.height+5, ScreenWidth-45-10, 1)];
        self.lastbottomLineV.hidden = NO;
    }
    else
    {
        self.forwardView.hidden = YES;
        self.lastbottomLineV.hidden = YES;
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
                if([[responseObject objectForKey:@"message"] rangeOfString:@"("].location !=NSNotFound)
                {
                    [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
                }
                else{
                    
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favor error:%@",error);
            
        }];
    }
}


- (void)shareAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(shareWithTalkingBrowse:)]) {
        [_delegate shareWithTalkingBrowse:self.talking];
    }
}

- (void)locationAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(locationWithTalkingBrowse:)]) {
        [_delegate locationWithTalkingBrowse:self.talking];
    }
}

-(void)tagBtnClicked:(UIButton *)sender
{
    NSDictionary * tagDict = self.talking.tagArray[0];
    if (_delegate&& [_delegate respondsToSelector:@selector(tagBtnClickedWithTagId:)]) {
        [_delegate tagBtnClickedWithTagId:tagDict];
    }
}

-(void)zanMakeBig
{
    if (self.lastIndex!=self.cellIndex) {
        return;
    }
    self.bigZanImageV.hidden = NO;
    [self.contentImageV bringSubviewToFront:self.bigZanImageV];
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

- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton
{
    if (_imgdelegate&& [_imgdelegate respondsToSelector:@selector(ImagesLoadedCellIndex:)]){
        [_imgdelegate ImagesLoadedCellIndex:self.cellIndex];
    }
}
-(void)publisherAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(petProfileWhoPublishTalkingBrowse:)]) {
        [_delegate petProfileWhoPublishTalkingBrowse:self.talking];
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
