//
//  BrowserForwardedTalkingTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-12.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BrowserForwardedTalkingTableViewCell.h"
#import "Common.h"
#import "RootViewController.h"
#import "SVProgressHUD.h"
@implementation BrowserForwardedTalkingTableViewCell
+(CGFloat)heightForRowWithTalking:(TalkingBrowse *)theTalking CellType:(int)cellType
{
    CGFloat cellHeight = 0;
    
    CGSize forwardedNameSize = [theTalking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(cellType==0?(ScreenWidth-20):(ScreenWidth-20), 100)];
    if ([theTalking.descriptionContent isEqualToString:@""]) {
        forwardedNameSize.height = 0;
        cellHeight = (cellType==0?(ScreenWidth+60+5):(ScreenWidth+60+5))+5;
    }
    else
        cellHeight = (cellType==0?(ScreenWidth+60+5):(ScreenWidth+60+5))+5+forwardedNameSize.height;
    
    
    if ([theTalking.location.address isEqualToString:@""]||[theTalking.location.address isEqualToString:@" "]) {
    }
    else{
        CGPoint lastPoint;
        CGSize sz = [theTalking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 100) lineBreakMode:NSLineBreakByCharWrapping];
        
        CGSize linesSz = [theTalking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(cellType==0?(ScreenWidth-20):(ScreenWidth-20), MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        if((sz.width > linesSz.width && linesSz.height > 20)||(sz.width > linesSz.width && linesSz.height > 40))//判断是否折行
        {
            lastPoint = CGPointMake(10 + (int)sz.width % (int)linesSz.width,linesSz.height - 15+(cellType==0?(ScreenWidth+60+5):(ScreenWidth+60+5)));
        }
        else
        {
            lastPoint = CGPointMake(10 + sz.width, linesSz.height - 15+(cellType==0?(ScreenWidth+60+5):(ScreenWidth+60+5)));
            if (lastPoint.y<(cellType==0?(ScreenWidth+60+5):(ScreenWidth+60+5))) {
                cellHeight = cellHeight+15;
            }
            
        }
        //            if (lastPoint.y>40) {
        //                lastPoint = CGPointMake(280 , 30);
        //                if (_article.isTop || _article.isEute) {
        //                    lastPoint = CGPointMake(250 , 30);
        //                }
        //            }
        
        
        CGSize locationSize = [theTalking.location.address sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(120, 20)];
        if (lastPoint.x+5+22+locationSize.width+8>(ScreenWidth-10)) {
            cellHeight = cellHeight+5+15;
            //            [self.locationBtn setFrame:CGRectMake(self.contentLabel.frame.origin.x, forwardedNameSize.height+self.contentLabel.frame.origin.y+5, 22+locationSize.width+8, 15)];
        }
        else
        {
            
        }
        //            [self.locationBtn setFrame:CGRectMake(10, 60+300+5+forwardedNameSize.height+5, 22+locationSize.width+8, 20)];
        //            [self.locationBtn setFrame:CGRectMake(lastPoint.x+5, lastPoint.y, 22+locationSize.width+8, 15)];
        //        [self.locationLabel setFrame:CGRectMake(self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y, locationSize.width, 15)];
    }
    
    
    if (theTalking.tagArray.count==0) {
        //        self.tagView.hidden = YES;

    }
    else
    {
            cellHeight = cellHeight +10+20;

    }
    //        [self.tagBtn setFrame:CGRectMake(10, 60+300+5+forwardedNameSize.height+5+self.locationBtn.frame.size.height+10, 82, 20)];
    if (cellType==0) {
        cellHeight = cellHeight+5+30;
//        if ([theTalking.showZanArray count]<=0) {
//
//        }
//        else{
//
//            cellHeight = cellHeight+5+35;
//        }
//        if ([theTalking.showCommentArray count]<=0) {
//
//        }
//        else{
////            self.commentView.hidden = NO;
//            if ([theTalking.showZanArray count]<=0) {
//                if ([theTalking.showCommentArray count]<2) {
////                    [self.commentView setFrame:CGRectMake(0, self.bottomBG.frame.origin.y+30+5, ScreenWidth, 58)];
//                    cellHeight = cellHeight+5+58;
//                }
//                else
////                    [self.commentView setFrame:CGRectMake(0, self.bottomBG.frame.origin.y+30+5, ScreenWidth, 88)];
//                    cellHeight = cellHeight +5 +88;
//            }
//            else
//            {
//                if ([theTalking.showCommentArray count]<2) {
////                    [self.commentView setFrame:CGRectMake(0, self.zanView.frame.origin.y+35, ScreenWidth, 58)];
//                    cellHeight = cellHeight+5+58;
//                }
//                else
////                    [self.commentView setFrame:CGRectMake(0, self.zanView.frame.origin.y+35, ScreenWidth, 88)];
//                    cellHeight = cellHeight +5+88;
//            }
//            
//        }
//        if ([theTalking.favorNum intValue]<=0&&self.zanView.hidden) {
//            [self.bgV setFrame:CGRectMake(0, 5, 320, self.bottomBG.frame.size.height+self.bottomBG.frame.origin.y+5)];
//            [self.contentTextBgV setFrame:CGRectMake(0, 5, 320, self.bottomBG.frame.size.height+self.bottomBG.frame.origin.y+5+10)];
//        }
//        else if (self.commentView.hidden&&!self.zanView.hidden){
//            [self.bgV setFrame:CGRectMake(0, 5, 320, self.zanView.frame.size.height+self.zanView.frame.origin.y+5)];
//            [self.contentTextBgV setFrame:CGRectMake(0, 5, 320, self.zanView.frame.size.height+self.zanView.frame.origin.y+5+10)];
//        }
//        else
//        {
//            [self.bgV setFrame:CGRectMake(0, 5, 320, self.commentView.frame.size.height+self.commentView.frame.origin.y+5)];
//            [self.contentTextBgV setFrame:CGRectMake(0, 5, 320, self.commentView.frame.size.height+self.commentView.frame.origin.y+5+10)];
//        }

    }
    else
    {
        cellHeight = cellHeight+10;
    }
//    cellHeight = cellHeight+(cellType==0?(10+45+5):10);
    
    
//    if (theTalking.ifForward&&cellType==0) {
//        cellHeight = cellHeight+70+10;
//    }
//    else
//    {
        cellHeight = cellHeight;
//    }
//    NSLog(@"hhheight:%f",cellHeight);
    return cellHeight;
}
-(void)dealloc
{
    self.contentImgV.delegate = nil;
}
- (id)initWithStyle:(UITableViewCellStyle)style CellType:(TalkCellType)theCellType reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.needShowPublishTime = YES;
        self.currentPlayingUrl = @"";
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
//        UIImage * bgImage = [UIImage imageNamed:@"cellbgv"];
        ;
//        self.bgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 530+45)];
//        //        self.bgV.backgroundColor = [UIColor blackColor];
//        
//        //        [_bgV setBackgroundColor:[UIColor clearColor]];
//        [self.contentView addSubview:_bgV];
        
//        self.forwardView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 320, 75)];
//        self.forwardView.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:self.forwardView];
//        UIImageView * forwardBgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
//        [forwardBgV setBackgroundColor:[UIColor lightGrayColor]];
//        forwardBgV.alpha = 0.2;
//        [self.forwardView addSubview:forwardBgV];
//        UIImageView * lineImagv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 55, 320, 11)];
//        [lineImagv setImage:[UIImage imageNamed:@"forwardLine"]];
//        [self.forwardView addSubview:lineImagv];
//        
//        
//        self.forwardedNameL = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 20)];
//        [self.forwardedNameL setBackgroundColor:[UIColor clearColor]];
//        [self.forwardedNameL setTextColor:[UIColor whiteColor]];
//        [self.forwardedNameL setFont:[UIFont systemFontOfSize:15]];
//        [self.forwardedNameL setText:@"大包子他妈"];
//        [self.forwardView addSubview:self.forwardedNameL];
//        
//        self.forwardedNameL.userInteractionEnabled = YES;
//        
//        UITapGestureRecognizer * tapww = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardPublisherAction)];
//        [self.forwardedNameL addGestureRecognizer:tapww];
//        
//        self.forwardedText = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+20, 200, 30)];
//        [self.forwardedText setBackgroundColor:[UIColor clearColor]];
//        [self.forwardedText setTextColor:[UIColor whiteColor]];
//        [self.forwardedText setText:@"好好玩啊，哈哈"];
//        [self.forwardedText setFont:[UIFont systemFontOfSize:14]];
//        [self.forwardView addSubview:self.forwardedText];
//        
//        self.forwardedL = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 120, 20)];
//        [self.forwardedL setBackgroundColor:[UIColor clearColor]];
//        [self.forwardedL setTextColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
//        [self.forwardedL setText:@"转发"];
//        [self.forwardedL setFont:[UIFont systemFontOfSize:13]];
//        [self.forwardView addSubview:self.forwardedL];
//        
//        self.forwardedTime = [[UILabel alloc] initWithFrame:CGRectMake(315-120-10, 6, 120, 20)];
//        [self.forwardedTime setBackgroundColor:[UIColor clearColor]];
//        [self.forwardedTime setTextColor:[UIColor whiteColor]];
//        [self.forwardedTime setText:@"3小时前"];
//        [self.forwardedTime setTextAlignment:NSTextAlignmentRight];
//        [self.forwardedTime setFont:[UIFont systemFontOfSize:13]];
//        [self.forwardView addSubview:self.forwardedTime];
        
        
        self.contentTextBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 310, 535-80+45)];
        //        [_contentTextBgV setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
        [_contentTextBgV setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_contentTextBgV];
        
        
        self.contentImgV = [[EGOImageButton alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenWidth)];
        self.contentImgV.delegate = self;
        self.contentImgV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        self.contentImgV.adjustsImageWhenHighlighted = NO;
        self.contentImgV.clipsToBounds = YES;
        //        self.contentImgV.contentMode = UIViewContentModeCenter;
        //        [self.contentImgV setImage:[UIImage imageNamed:@"meizi.jpg"]];
        [self.contentTextBgV addSubview:self.contentImgV];
        [self.contentImgV addTarget:self action:@selector(clickedContentImageV:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.storyView = [[StoryCellView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        self.storyView.backgroundColor = [UIColor whiteColor];
        [self.contentImgV addSubview:self.storyView];
        self.storyView.userInteractionEnabled = YES;
//        [self.storyView addTarget:self action:@selector(storyClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storyClicked)];
        [self.storyView addGestureRecognizer:tap];
        
        
        
        self.storyView.hidden = YES;
        
        self.contentTypeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 42, 30)];
        [self.contentTextBgV addSubview:self.contentTypeImgV];
        
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth+60-2, ScreenWidth, 2)];
        [self.progressView setBackgroundColor:[UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1]];
        [self.contentTextBgV addSubview:self.progressView];
        
        
        
        self.aniImageV = [[UIImageView alloc] initWithFrame:CGRectMake(160, 100, 120, 120)];
        self.aniImageV.backgroundColor = [UIColor clearColor];
        [self.contentImgV addSubview:self.aniImageV];
        


        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 310, 290, 60)];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        self.contentLabel.numberOfLines = 0;
        [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentLabel setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
        [self.contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentLabel setText:@"阿斯顿金卡数据的拉伸的就看见克拉斯贷记卡数据"];
        [self.contentTextBgV addSubview:self.contentLabel];
        
        
        self.tagView = [[UIView alloc] initWithFrame:CGRectMake(5, 370, 300, 20)];
        self.tagView.backgroundColor = [UIColor clearColor];
        [self.contentTextBgV addSubview:self.tagView];
        
//        for (int i = 0; i<5; i++) {
            UIButton * tB = [UIButton buttonWithType:UIButtonTypeCustom];
            tB.tag = 900;
            [tB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tB.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [tB setTitleEdgeInsets:UIEdgeInsetsMake(1, 15, 0, 0)];
            [tB setFrame:CGRectMake(10, 370, 80, 20)];
            [tB addTarget:self action:@selector(tagBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.tagView addSubview:tB];
        [tB setBackgroundColor:[UIColor colorWithRed:99/255.0f green:203/255.0f blue:175/255.f alpha:0.8]];
        tB.layer.cornerRadius = 8;
        tB.layer.masksToBounds = YES;
            tB.hidden = YES;
        UIImageView * timg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 4, 14, 12)];
        [timg setImage:[UIImage imageNamed:@"tagImg"]];
        [tB addSubview:timg];
//        }
        
        
        self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.locationBtn setFrame:CGRectMake(310-87-5, 370, 82, 20)];
        [self.contentTextBgV addSubview:self.locationBtn];
        [self.locationBtn setBackgroundColor:[UIColor colorWithRed:99/255.0f green:203/255.0f blue:175/255.f alpha:0.8]];
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
        
        self.publisherAvatarV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 370+30, 50, 50)];
        [self.publisherAvatarV setBackgroundColor:[UIColor grayColor]];
        [self.contentTextBgV addSubview:self.publisherAvatarV];
        [self.publisherAvatarV setBackgroundImage:[UIImage imageNamed:@"placeholderHead"] forState:UIControlStateNormal];
        [_publisherAvatarV addTarget:self action:@selector(publisherAction) forControlEvents:UIControlEventTouchUpInside];
        _publisherAvatarV.layer.masksToBounds = YES;
        _publisherAvatarV.layer.cornerRadius = 25;
        
        self.darenV = [[UIImageView alloc] initWithFrame:CGRectMake(10+50-17, 5+50-17, 17, 17)];
        [self.darenV setImage:[UIImage imageNamed:@"daren"]];
        [self.contentTextBgV addSubview:self.darenV];
//        UIImageView * mask1 = [[UIImageView alloc] initWithFrame:self.publisherAvatarV.frame];
//        [mask1 setImage:[UIImage imageNamed:@"maskHead"]];
//        [self.contentTextBgV addSubview:mask1];
        //        UIImageView * avatarbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        //        [avatarbg setImage:[UIImage imageNamed:@"avatarbg1"]];
        //        [self.publisherAvatarV addSubview:avatarbg];
        //
        self.genderImageV = [[UIImageView alloc] initWithFrame:CGRectMake(75, 0, 16, 14)];
        [self.contentTextBgV addSubview:self.genderImageV];
        
        self.publisherNameL = [[UILabel alloc] initWithFrame:CGRectMake(75, 370+35, 200, 20)];
        [self.publisherNameL setBackgroundColor:[UIColor clearColor]];
        [self.publisherNameL setFont:[UIFont systemFontOfSize:16]];
        self.publisherNameL.textColor = CommonGreenColor;
        [self.publisherNameL setText:@"我是小黄瓜"];
        [self.contentTextBgV addSubview:self.publisherNameL];
        
        self.publisherNameL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapw = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publisherAction)];
        [self.publisherNameL addGestureRecognizer:tapw];
        //        self.publisherNameL.shadowColor = [UIColor grayColor];
        
//        self.bL = [[UILabel alloc] initWithFrame:CGRectMake(65, 370+35+20, 40, 20)];
//        [_bL setBackgroundColor:[UIColor clearColor]];
//        [_bL setText:@"发表于:"];
//        _bL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
//        [_bL setFont:[UIFont systemFontOfSize:12]];
//        [self.contentTextBgV addSubview:_bL];
        
        self.gradeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.contentTextBgV addSubview:self.gradeImageV];
        
        self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        self.gradeLabel.backgroundColor = [UIColor clearColor];
        self.gradeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentTextBgV addSubview:self.gradeLabel];
        self.gradeLabel.text = @"LV.12";
        self.gradeLabel.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        
        self.publishTime = [[UILabel alloc] initWithFrame:CGRectMake(65+45, 370+35+20, 160, 20)];
        [self.publishTime setBackgroundColor:[UIColor clearColor]];
        [self.publishTime setText:@"2014-6-20"];
        [self.publishTime setTextAlignment:NSTextAlignmentRight];
        [self.publishTime setFont:[UIFont systemFontOfSize:12]];
        [self.contentTextBgV addSubview:self.publishTime];
        
        self.relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.relationBtn setFrame:CGRectMake(ScreenWidth-10-72-10, 370+40, 72, 24.5)];
        //        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu_normal"] forState:UIControlStateNormal];
        //        [self.relationBtn setTitle:@"+关注" forState:UIControlStateNormal];
        //        [self.relationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.relationBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentTextBgV addSubview:self.relationBtn];
        [_relationBtn addTarget:self action:@selector(relationAction) forControlEvents:UIControlEventTouchUpInside];
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu2"] forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1] forState:UIControlStateNormal];
        
        self.addMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 20, 20)];
        [self.addMarkLabel setText:@"+"];
        [self.addMarkLabel setTextAlignment:NSTextAlignmentCenter];
        [self.addMarkLabel setFont:[UIFont systemFontOfSize:14]];
        [self.relationBtn addSubview:self.addMarkLabel];
        [self.addMarkLabel setBackgroundColor:[UIColor clearColor]];
        
        
        
        self.loadingBGV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-30, ScreenWidth+60-10-30, 30, 30)];
        [self.loadingBGV setImage:[UIImage imageNamed:@"loadingBGV"]];
        [self.contentTextBgV addSubview:self.loadingBGV];
        self.loadingBGV.hidden = YES;
        
        playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonTapped)];
        [self.loadingBGV addGestureRecognizer:playTap];
       
        
        self.loadingV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.loadingV setCenter:CGPointMake(15, 15)];
        [self.loadingBGV addSubview:self.loadingV];
        
        self.bigZanImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentImgV.frame.size.width-10-70, self.contentImgV.frame.size.height-10-70, 70, 70)];
        [self.bigZanImageV setImage:[UIImage imageNamed:@"newHaveZanBig"]];
        [self.contentImgV addSubview:self.bigZanImageV];
        self.bigZanImageV.hidden = YES;
        
        if (theCellType!=TalkCellTypeDetailPage) {
            self.bottomBG = [[UIView alloc] initWithFrame:CGRectMake(0, 370+30+50+5, ScreenWidth, 30)];
            [_bottomBG setBackgroundColor:[UIColor clearColor]];
            [self.contentTextBgV addSubview:_bottomBG];
            
            self.favorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.favorBtn setFrame:CGRectMake(ScreenWidth-10-30*3-30*3, 0, 60, 30)];
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
            

//            self.zanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
//            self.zanView.backgroundColor = [UIColor clearColor];
//            [self.contentTextBgV addSubview:self.zanView];
//            UIImageView * zanV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 27, 27)];
//            [zanV setImage:[UIImage imageNamed:@"browser_icon_zan"]];
//            [self.zanView addSubview:zanV];
//            
//            UIImageView * zanNumBgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30-10, 2, 30, 30)];
//            [zanNumBgV setImage:[UIImage imageNamed:@"browser_zanNumBg"]];
//            [self.zanView addSubview:zanNumBgV];
//            
//            self.zanViewzanL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-30-10, 7, 30, 20)];
//            [self.zanViewzanL setBackgroundColor:[UIColor clearColor]];
//            [self.zanViewzanL setTextAlignment:NSTextAlignmentCenter];
//            [self.zanViewzanL setFont:[UIFont systemFontOfSize:13]];
//            [self.zanViewzanL setTextColor:[UIColor whiteColor]];
//            self.zanViewzanL.adjustsFontSizeToFitWidth = YES;
//            [self.zanViewzanL setText:@"110"];
//            [self.zanView addSubview:self.zanViewzanL];
//            
//            //剩下位置能放几个头像，方程30*x+(x+1)*8 = Screenwidth-10-zanV.width-10-zanViewzanL.width
//            self.zanAvatarNum = (ScreenWidth-10-27-10-30-8)/38;
////            int d = (num-(int)num)>0.
//            for (int i = 0; i<self.zanAvatarNum; i++) {
//                EGOImageButton * zanAvatar = [[EGOImageButton alloc] initWithFrame:CGRectMake(10+27+8*(i+1)+30*i, 0, 30, 30)];
//                zanAvatar.tag = 200+i;
//                [zanAvatar setBackgroundColor:[UIColor colorWithWhite:230/255.0f alpha:1]];
//                [self.zanView addSubview:zanAvatar];
//                zanAvatar.layer.cornerRadius = 15;
//                zanAvatar.layer.masksToBounds = YES;
////                UIImageView * mask2 = [[UIImageView alloc] initWithFrame:zanAvatar.frame];
////                [mask2 setImage:[UIImage imageNamed:@"maskHead"]];
////                [self.zanView addSubview:mask2];
//            }
//            
//            self.commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
//            [self.commentView setBackgroundColor:[UIColor clearColor]];
//            [self.contentTextBgV addSubview:self.commentView];
//            
//            UIImageView * comV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 27, 27)];
//            [comV setImage:[UIImage imageNamed:@"browser_icon_comment"]];
//            [self.commentView addSubview:comV];
//            
//            self.commentViewcommentL = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, ScreenWidth-47-10, 30)];
//            [self.commentViewcommentL setBackgroundColor:[UIColor clearColor]];
//            [self.commentViewcommentL setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
//            [self.commentViewcommentL setText:@"查看所有100条评论"];
//            [self.commentViewcommentL setFont:[UIFont systemFontOfSize:13]];
//            [self.commentView addSubview:self.commentViewcommentL];
//            
//            for (int i = 0; i<2; i++) {
//                EGOImageButton * avatar = [[EGOImageButton alloc] initWithFrame:CGRectMake(45, 28+5*(i+1)+25*i, 25, 25)];
//                avatar.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
//                avatar.tag = 300+i;
//                avatar.layer.cornerRadius = 13;
//                avatar.layer.masksToBounds = YES;
//                [self.commentView addSubview:avatar];
////                UIImageView * mask3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
////                [mask3 setImage:[UIImage imageNamed:@"maskHead"]];
////                [avatar addSubview:mask3];
//                
//                UILabel * cL = [[UILabel alloc] initWithFrame:CGRectMake(80, 28+5*(i+1)+25*i, ScreenWidth-80-10, 25)];
//                [cL setBackgroundColor:[UIColor clearColor]];
//                [cL setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
//                [cL setFont:[UIFont systemFontOfSize:13]];
//                [cL setText:@"不错啊挺好的"];
//                cL.tag = 400+i;
//                [self.commentView addSubview:cL];
//            }
            
        }
        else if (theCellType==TalkCellTypeDetailPage){
            [self.bgV setImage:nil];
            self.bgV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
            self.bgV.alpha = 1;
            
            [self.contentImgV setFrame:CGRectMake(0, 60, ScreenWidth, ScreenWidth)];
//            self.contentLabel.textColor = [UIColor blackColor];
            [self.contentLabel setFrame:CGRectMake(10, ScreenWidth+20, 300, 60)];
            [self.tagView setFrame:CGRectMake(5, 370, 300, 20)];
            [self.publishTime setTextColor:[UIColor grayColor]];
            [self.relationBtn setFrame:CGRectMake(310-72-10, 370+40, 72, 24.5)];
        }
//        self.sepLineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 1)];
//        [self.sepLineV setBackgroundColor:[UIColor colorWithWhite:220/255.0f alpha:1]];
//        [self.contentTextBgV addSubview:self.sepLineV];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildWithSkinType) name:@"WXRchangeSkin" object:nil];
//        [self buildWithSkinType];
    }
    return self;
}
- (void)buildWithSkinType
{

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
    if (self.talkCellType==TalkCellTypeDetailPage) {
        self.forwardView.hidden = YES;
        CGSize forwardedNameSize = [self.talking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-20, 100)];
        if ([self.talking.descriptionContent isEqualToString:@""]) {
            forwardedNameSize.height = 0;
        }
        
        [self.contentLabel setFrame:CGRectMake(10, 60+ScreenWidth+5, ScreenWidth-20, forwardedNameSize.height)];
        
        if ([self.talking.location.address isEqualToString:@""]||[self.talking.location.address isEqualToString:@" "]) {
            self.locationBtn.hidden = YES;
        }
        else{
            CGPoint lastPoint;
            CGSize sz = [self.talking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 100) lineBreakMode:NSLineBreakByCharWrapping];
            
            CGSize linesSz = [self.talking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            if((sz.width > linesSz.width && linesSz.height > 20)||(sz.width > linesSz.width && linesSz.height > 40))//判断是否折行
            {
                lastPoint = CGPointMake(self.contentLabel.frame.origin.x + (int)sz.width % (int)linesSz.width,linesSz.height - 15+self.contentLabel.frame.origin.y);
            }
            else
            {
                lastPoint = CGPointMake(self.contentLabel.frame.origin.x + sz.width, linesSz.height - 15+self.contentLabel.frame.origin.y);
                if (lastPoint.y<60+ScreenWidth+5) {
                    lastPoint.y = 60+ScreenWidth+5;
                }
            }
            
            self.locationBtn.hidden = NO;
            CGSize locationSize = [self.talking.location.address sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(120, 20)];
            if (lastPoint.x+5+22+locationSize.width+8>ScreenWidth-10) {
                [self.locationBtn setFrame:CGRectMake(self.contentLabel.frame.origin.x, forwardedNameSize.height+self.contentLabel.frame.origin.y+5, 22+locationSize.width+8, 15)];
            }
            else
                //            [self.locationBtn setFrame:CGRectMake(10, 60+300+5+forwardedNameSize.height+5, 22+locationSize.width+8, 20)];
                [self.locationBtn setFrame:CGRectMake(lastPoint.x+5, lastPoint.y, 22+locationSize.width+8, 15)];
            [self.locationLabel setFrame:CGRectMake(self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y, locationSize.width, 15)];
        }
        
        
        if (self.talking.tagArray.count==0) {
            self.tagView.hidden = YES;
        }
        else
        {
            self.tagView.hidden = NO;
//            float w = 5.0f;
//            int h = 0;
//            for (int i = 0; i<5; i++) {
                UIButton * tB = (UIButton *)[self.tagView viewWithTag:900];
//                if (i<self.talking.tagArray.count) {
                    tB.hidden = NO;
                    [tB setTitle:[self.talking.tagArray[0] objectForKey:@"name"] forState:UIControlStateNormal];
                    
                    
                    CGSize tagSize = [[self.talking.tagArray[0] objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(120, 20)];
//                    if (w+tagSize.width+30>310) {
//                        if (h==0) {
//                            w = 5.0f;
//                            h = 9;
//                        }
                        [tB setFrame:CGRectMake(5, 0, tagSize.width+30, 20)];
//                    }
//                    else{
//                        [tB setFrame:CGRectMake(w, h==0?0:25, tagSize.width+30, 20)];
//                    }
//                    w = w+tagSize.width+30+5;
//                    
//                }
//                else{
//                    tB.hidden = YES;
//                }
//            }
//            if (h==0) {
                [self.tagView setFrame:CGRectMake(self.tagView.frame.origin.x, self.locationBtn.hidden?self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+5:self.locationBtn.frame.origin.y+15+10, ScreenWidth-20, 20)];
//            }
//            else
//                [self.tagView setFrame:CGRectMake(self.tagView.frame.origin.x, self.locationBtn.hidden?self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10:self.locationBtn.frame.origin.y+15+10, 300, 45)];
        }
        
        //        [self.tagBtn setFrame:CGRectMake(10, 60+300+5+forwardedNameSize.height+5+self.locationBtn.frame.size.height+10, 82, 20)];
        [self.publisherAvatarV setFrame:CGRectMake(10, 5, 50, 50)];
        [self.publisherNameL setFrame:CGRectMake(65,self.publisherAvatarV.frame.origin.y+5, 200, 20)];
        [self.bL setFrame:CGRectMake(65, self.publisherNameL.frame.origin.y+20, 40, 20)];
        
        [self.publishTime setFrame:CGRectMake(65+45, self.bL.frame.origin.y, 160, 20)];
        
        [self.relationBtn setFrame:CGRectMake(ScreenWidth-10-72-3, self.publisherAvatarV.frame.origin.y+5, 65, 23)];
        
        if (self.tagView.hidden) {
            if (self.locationBtn.hidden) {
                [self.bgV setFrame:CGRectMake(0, 0, ScreenWidth, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+5)];
                
                [self.contentTextBgV setFrame:CGRectMake(0, 0, ScreenWidth, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10)];
                
                //                [self.bottomBG setFrame:CGRectMake(5, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10, 300, 45)];
            }
            else{
                //                [self.bottomBG setFrame:CGRectMake(5, self.locationBtn.frame.origin.y+self.locationBtn.frame.size.height+10, 300, 45)];
                [self.bgV setFrame:CGRectMake(0, 0, ScreenWidth, self.locationBtn.frame.origin.y+self.locationBtn.frame.size.height+5)];
                
                [self.contentTextBgV setFrame:CGRectMake(0, 0, ScreenWidth, self.locationBtn.frame.origin.y+self.locationBtn.frame.size.height+10)];
            }
        }
        else{
            //            [self.bottomBG setFrame:CGRectMake(5, self.tagView.frame.origin.y+self.tagView.frame.size.height+10, 300, 45)];
            
            [self.bgV setFrame:CGRectMake(0, 0, ScreenWidth, self.tagView.frame.origin.y+self.tagView.frame.size.height+5)];
            
            [self.contentTextBgV setFrame:CGRectMake(0, 0, ScreenWidth, self.tagView.frame.origin.y+self.tagView.frame.size.height+10)];
        }
        
        [self.contentTextBgV setFrame:CGRectMake(0, 0, ScreenWidth, self.firstRowHeight-5)];
        if (!self.commentView.hidden) {
            if (self.contentTextBgV.frame.size.height - (self.commentView.frame.size.height+self.commentView.frame.origin.x)<5) {
                [self.commentView setFrame:CGRectMake(0, self.contentTextBgV.frame.size.height-self.commentView.frame.size.height-5, ScreenWidth, self.commentView.frame.size.width)];
            }
        }
        //        [self.bgV setFrame:CGRectMake(0, 0, 320, self.bottomBG.frame.size.height+self.bottomBG.frame.origin.y+5)];
        //
        //        [self.contentTextBgV setFrame:CGRectMake(0, 0, 320, self.bottomBG.frame.size.height+self.bottomBG.frame.origin.y+5)];
    }
    else{
        self.talkCellType = TalkCellTypeOrigin;
//            self.forwardView.hidden = YES;
            CGSize forwardedNameSize = [self.talking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-20, 100)];
            if ([self.talking.descriptionContent isEqualToString:@""]) {
                forwardedNameSize.height = 5;
            }
            
            [self.contentLabel setFrame:CGRectMake(10, 60+ScreenWidth+5, ScreenWidth-20, forwardedNameSize.height)];
            
            if ([self.talking.location.address isEqualToString:@""]||[self.talking.location.address isEqualToString:@" "]) {
                self.locationBtn.hidden = YES;
            }
            else{
                CGPoint lastPoint;
                CGSize sz = [self.talking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 100) lineBreakMode:NSLineBreakByCharWrapping];
                
                CGSize linesSz = [self.talking.descriptionContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
                if((sz.width > linesSz.width && linesSz.height > 20)||(sz.width > linesSz.width && linesSz.height > 40))//判断是否折行
                {
                    lastPoint = CGPointMake(self.contentLabel.frame.origin.x + (int)sz.width % (int)linesSz.width,linesSz.height - 15+self.contentLabel.frame.origin.y);
                }
                else
                {
                    lastPoint = CGPointMake(self.contentLabel.frame.origin.x + sz.width, linesSz.height - 15+self.contentLabel.frame.origin.y);
                    if (lastPoint.y<60+ScreenWidth+5) {
                        lastPoint.y = 60+ScreenWidth+5+5;
                    }
                    
                }
                self.locationBtn.hidden = NO;
                CGSize locationSize = [self.talking.location.address sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(120, 20)];
                if (lastPoint.x+5+22+locationSize.width+8>ScreenWidth-10) {
                    [self.locationBtn setFrame:CGRectMake(self.contentLabel.frame.origin.x, forwardedNameSize.height+self.contentLabel.frame.origin.y+5, 22+locationSize.width+8, 15)];
                }
                else
                    [self.locationBtn setFrame:CGRectMake(lastPoint.x+5, lastPoint.y, 22+locationSize.width+8, 15)];
                [self.locationLabel setFrame:CGRectMake(self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y, locationSize.width, 15)];
            }
            
            
            if (self.talking.tagArray.count==0) {
                self.tagView.hidden = YES;
            }
            else
            {
                self.tagView.hidden = NO;
                //            float w = 5.0f;
                //            int h = 0;
                //            for (int i = 0; i<5; i++) {
                UIButton * tB = (UIButton *)[self.tagView viewWithTag:900];
                //                if (i<self.talking.tagArray.count) {
                tB.hidden = NO;
                [tB setTitle:[self.talking.tagArray[0] objectForKey:@"name"] forState:UIControlStateNormal];
                
                
                CGSize tagSize = [[self.talking.tagArray[0] objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(120, 20)];
                [tB setFrame:CGRectMake(5, 0, tagSize.width+30, 20)];

                [self.tagView setFrame:CGRectMake(self.tagView.frame.origin.x, self.locationBtn.hidden?self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+5:self.locationBtn.frame.origin.y+15+10, 300, 20)];
            }
            
            //        [self.tagBtn setFrame:CGRectMake(10, 60+300+5+forwardedNameSize.height+5+self.locationBtn.frame.size.height+10, 82, 20)];
            [self.publisherAvatarV setFrame:CGRectMake(10, 5, 50, 50)];
            [self.publisherNameL setFrame:CGRectMake(65,self.publisherAvatarV.frame.origin.y+5, 200, 20)];
            [self.bL setFrame:CGRectMake(65, self.publisherNameL.frame.origin.y+20, 40, 20)];
            
            [self.publishTime setFrame:CGRectMake(65+45, self.bL.frame.origin.y, 160, 20)];
            
            [self.relationBtn setFrame:CGRectMake(310-72-3, self.publisherAvatarV.frame.origin.y+5, 65, 23)];

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
            
            [self.contentTextBgV setFrame:CGRectMake(0, 0, ScreenWidth, self.talking.rowHeight-5)];
            if (!self.commentView.hidden) {
                if (self.contentTextBgV.frame.size.height - (self.commentView.frame.size.height+self.commentView.frame.origin.x)<5) {
                    [self.commentView setFrame:CGRectMake(0, self.contentTextBgV.frame.size.height-self.commentView.frame.size.height-5, ScreenWidth, self.commentView.frame.size.width)];
                }
            }
    }
    self.favorLabel.text = [self.talking.favorNum intValue]>0?self.talking.favorNum:@"喜欢";
//    self.forwardLabel.text = self.talking.forwardNum;
    self.commentLabel.text = [self.talking.commentNum intValue]>0?self.talking.commentNum:@"评论";
    self.shareLabel.text = ([self.talking.shareNum intValue]+[self.talking.forwardNum intValue])>0?[NSString stringWithFormat:@"%d",[self.talking.shareNum intValue]+[self.talking.forwardNum intValue]]:@"分享";
    //    self.publisherAvatarV.imageURL = [NSURL URLWithString:@"http://www.qqcan.com/uploads/allimg/c120811/1344A300Z50-3T615.jpg"];
    //    self.aniImageV.image = [UIImage imageNamed:@"1_1"];

    self.contentLabel.text = self.talking.descriptionContent;
    self.publishTime.text = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:self.talking.publishTime];
    self.publisherAvatarV.imageURL = [NSURL URLWithString:[self.talking.petInfo.headImgURL stringByAppendingString:@"?imageView2/2/w/60"]];
    self.publisherNameL.text = self.talking.petInfo.nickname;
    self.locationLabel.text = self.talking.location.address;
    
    self.darenV.hidden = !self.talking.petInfo.ifDaren;
    
//    CGSize publishNameSizeA = [self.publisherNameL.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 20)];
    //    NSLog(@"sssss%f",forwardedNameSize.width);
 
    
    if ([self.talking.relationShip isEqualToString:@"0"]) {
        self.relationBtn.hidden = NO;
                    [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu2"] forState:UIControlStateNormal];
                    [self.relationBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];

        [self.relationBtn setTitle:@"  关注" forState:UIControlStateNormal];
        [self.addMarkLabel setTextColor:self.relationBtn.currentTitleColor];
        self.addMarkLabel.hidden = NO;
        self.relationBtn.enabled = YES;
    }
    else if ([self.talking.relationShip isEqualToString:@"1"]){
        self.relationBtn.hidden = YES;
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhued"] forState:UIControlStateNormal];
        [self.relationBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.relationBtn.enabled = NO;
    }
    else if ([self.talking.relationShip isEqualToString:@"2"]){
        self.relationBtn.hidden = YES;
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhued"] forState:UIControlStateNormal];
        [self.relationBtn setTitle:@"相互关注" forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.relationBtn.enabled = NO;
    }
    else
    {
        self.relationBtn.hidden = YES;
    }
    
    if (!self.talking.ifZan) {
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
    }
    else
    {
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zanned"]];
        
    }
   
    
    if ([self.talking.theModel isEqualToString:@"1"]) {
        self.storyView.hidden = YES;
        [self.contentImgV setImageURL:[NSURL URLWithString:[self.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]];
        self.aniImageV.hidden = YES;
        self.loadingBGV.hidden = YES;
        [self.contentTypeImgV setImage:[UIImage imageNamed:@"browser_typePic"]];
        self.contentImgV.userInteractionEnabled = NO;
        self.storyView.userInteractionEnabled = NO;
    }
    else if ([self.talking.theModel isEqualToString:@"2"]){
        self.storyView.hidden = NO;
        self.contentImgV.userInteractionEnabled = YES;
        self.storyView.userInteractionEnabled = YES;
        self.loadingBGV.hidden = YES;
        self.aniImageV.hidden = YES;
        [self.contentTypeImgV setImage:[UIImage imageNamed:@"browser_typeStory"]];
        [self.storyView.storyImageV1 setImageURL:[NSURL URLWithString:[self.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]];
        [self.storyView.storyTimeL setText:self.publishTime.text];
        [self.storyView.storyTitleL setText:self.talking.descriptionContent];
    }
    else if([self.talking.theModel isEqualToString:@"0"]){
        self.storyView.hidden = YES;
        [self.contentImgV setImageURL:[NSURL URLWithString:[self.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]];
        self.contentImgV.userInteractionEnabled = YES;
        self.storyView.userInteractionEnabled = NO;
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
            /* 3D透视变换
             
             CATransform3D tf = self.aniImageV.layer.transform;
             tf.m34 = 1.0 / -500;
             tf = CATransform3DRotate(tf, self.talking.playAnimationImg.rotationY, 0.0f, 1.0f, 0.0f);
             self.aniImageV.layer.transform = tf;
             self.aniImageV.layer.zPosition = 1000;
             
             */
            
        }
        else
        {
            self.aniImageV.hidden = YES;
        }


        [self.loadingBGV setFrame:CGRectMake(ScreenWidth-10-30, ScreenWidth+60-10-30, 30, 30)];
        
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
                //        self.loadingImgV.hidden = NO;
    //            [self.loadingBGV setFrame:CGRectMake(self.contentImgV.frame.origin.x+108, self.contentImgV.frame.origin.y+108, 84, 84)];
                
                self.loadingBGV.hidden = NO;
                //        [self.loadingImgV setFrame:CGRectMake(self.contentImgV.frame.origin.x+110, self.contentImgV.frame.origin.y+110, 84, 84)];
                if (![self.loadingV isAnimating]) {
                    
                    [self.loadingV startAnimating];
                    
                    
                }
            }
            else
            {
    //            self.loadingBGV.hidden = YES;
    //            //        self.loadingImgV.hidden = YES;
    //            [self.loadingV stopAnimating];
                
    //            self.loadingBGV.hidden = NO;
    //            [self.loadingBGV setImage:[UIImage imageNamed:@"shuoshuoPlayBtn"]];
    //            [self.loadingV stopAnimating];
            }
        }
        
        if (self.contentImgV.currentImage) {
            self.aniImageV.hidden = NO;
            
        }
        else
            self.aniImageV.hidden = YES;

    }

    //    NSLog(@"%f,%f",self.talking.animationImg.rotationY,self.talking.animationImg.rotationZ);
    int lv = [self.talking.petInfo.grade intValue];
//    NSString * blStr;
//    lv = arc4random()%12+1;
//    NSLog(@"currentLVStr:%@,currentLV:%d",self.talking.petInfo.grade,lv);
//    if (lv>0) {
//        blStr = [NSString stringWithFormat:@"%@ |",self.talking.petInfo.breed];
        self.gradeImageV.hidden = NO;
        self.gradeLabel.hidden = NO;
        
//        CGSize bls = [blStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 20) lineBreakMode:NSLineBreakByCharWrapping];
    
//        
//        [self.bL setFrame:CGRectMake(65, self.publisherNameL.frame.origin.y+23, bls.width, 20)];
//        [self.bL setText:blStr];
        self.gradeImageV.frame = CGRectMake(self.bL.frame.origin.x+self.bL.frame.size.width+5, self.publisherNameL.frame.origin.y+27, 14, 14);
        
        self.gradeImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"LV%d",lv]];
        //    self.gradeImageV.backgroundColor = [UIColor redColor];
//        self.gradeLabel.frame = CGRectMake(self.bL.frame.origin.x+self.bL.frame.size.width+5+14+3, self.publisherNameL.frame.origin.y+23, 60, 20);
    self.gradeLabel.frame = CGRectMake(65, self.publisherNameL.frame.origin.y+23, 60, 20);
        self.gradeLabel.text = [NSString stringWithFormat:@"LV.%d",lv];
//    }
//    else
//    {
//        blStr = [NSString stringWithFormat:@"%@",self.talking.petInfo.breed];
//        self.gradeLabel.hidden = YES;
//        self.gradeImageV.hidden = YES;
//        
//        CGSize bls = [blStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 20) lineBreakMode:NSLineBreakByCharWrapping];
//        
//        
//        [self.bL setFrame:CGRectMake(65, self.publisherNameL.frame.origin.y+23, bls.width, 20)];
//        [self.bL setText:blStr];
//
//    }
    

    if ([self.talking.petInfo.gender isEqualToString:@"1"]) {
        [self.genderImageV setImage:[UIImage imageNamed:@"male"]];
        [self.genderImageV setFrame:CGRectMake(63, self.publisherAvatarV.frame.origin.y+5+2, 16, 14)];
        self.genderImageV.hidden = NO;
        [self.publisherNameL setFrame:CGRectMake(81,self.publisherAvatarV.frame.origin.y+5, 150, 20)];
    }
    else if ([self.talking.petInfo.gender isEqualToString:@"0"]){
        [self.genderImageV setImage:[UIImage imageNamed:@"female"]];
        [self.genderImageV setFrame:CGRectMake(63, self.publisherAvatarV.frame.origin.y+5+2, 16, 14)];
        self.genderImageV.hidden = NO;
        [self.publisherNameL setFrame:CGRectMake(81,self.publisherAvatarV.frame.origin.y+5, 150, 20)];
    }
    else
    {
        self.genderImageV.hidden = YES;
        [self.publisherNameL setFrame:CGRectMake(65,self.publisherAvatarV.frame.origin.y+5, 160, 20)];
    }
    
    if (self.needShowPublishTime) {
//        [self.publisherNameL setFrame:CGRectMake(65,self.publisherAvatarV.frame.origin.y+5, 200, 20)];
        
        [self.publishTime setFrame:CGRectMake(ScreenWidth-10-160, self.publisherNameL.frame.origin.y+24, 160, 20)];
        self.publishTime.hidden = NO;
//        self.bL.hidden = NO;
        [self.relationBtn setFrame:CGRectMake(ScreenWidth-10-65, self.publisherAvatarV.frame.origin.y+5, 65, 23)];
        self.publishTime.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        self.publishTime.text = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:self.talking.publishTime];
    }
    else
    {
//        [self.publisherNameL setFrame:CGRectMake(65,self.publisherAvatarV.frame.origin.y+15, 200, 20)];
//        self.bL.hidden = YES;
        self.publishTime.hidden = NO;
        [self.publishTime setFrame:CGRectMake(ScreenWidth-10-160, self.publisherNameL.frame.origin.y+24, 160, 20)];
        [self.relationBtn setFrame:CGRectMake(ScreenWidth-10-65, self.publisherAvatarV.frame.origin.y+5, 65, 23)];
        self.publishTime.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        long long numv = [self.talking.browseNum longLongValue];
        NSString * bnStr = [NSString stringWithFormat:@"%lld",numv];
        if (numv>=100000000) {
            float j = (numv/100000000.0f);
            bnStr = [NSString stringWithFormat:@"%.1f亿",j];
        }
        else if (numv>=100000){
            float j = numv/100000.0f;
            bnStr = [NSString stringWithFormat:@"%.1f万",j];
        }
        self.publishTime.text = [NSString stringWithFormat:@"%@浏览",bnStr];
    }
    self.bigZanImageV.hidden = YES;
    self.favorBtn.enabled = YES;
    
    

    
    [self.sepLineV setFrame:CGRectMake(0, self.contentTextBgV.frame.size.height-1, ScreenWidth, 1)];
//    if ([self.aniImageV isAnimating]) {
//        self.loadingBGV.hidden = YES;
//    }
//    [self.playBtnImageV setFrame:self.loadingBGV.frame];
    
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
-(void)refreshCell
{
    //    CGSize forwardedNameSize = [self.forwardedNameL.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(120, 20)];
    ////    NSLog(@"sssss%f",forwardedNameSize.width);
    //    [self.forwardedNameL setFrame:CGRectMake(self.forwardedNameL.frame.origin.x, self.forwardedNameL.frame.origin.y, forwardedNameSize.width, 20)];
    ////    [self.forwardedNameL setBackgroundColor:[UIColor redColor]];
    //    [self.forwardedL setFrame:CGRectMake(self.forwardedNameL.frame.origin.x+forwardedNameSize.width+5, 16, 120, 20)];
    
    
}
-(void)storyClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(storyClickedTalkingBrowse:)]) {
        [self.delegate storyClickedTalkingBrowse:self.talking];
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
- (void)locationAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(locationWithTalkingBrowse:)]) {
        [_delegate locationWithTalkingBrowse:self.talking];
    }
}
- (void)relationAction
{
    [self doAttention];
}
- (void)publisherAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(petProfileWhoPublishTalkingBrowse:)]) {
        [_delegate petProfileWhoPublishTalkingBrowse:self.talking];
    }
}
- (void)forwardPublisherAction
{
    if (_delegate&& [_delegate respondsToSelector:@selector(petProfileWhoForwardTalkingBrowse:)]) {
        [_delegate petProfileWhoForwardTalkingBrowse:self.talking];
    }
}
- (void)forwardAction
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
    if (_delegate&& [_delegate respondsToSelector:@selector(forwardWithTalkingBrowse:)]) {
        [_delegate forwardWithTalkingBrowse:self.talking];
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
        
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
        self.talking.ifZan = NO;

        self.favorLabel.text =[NSString stringWithFormat:@"%d",[self.favorLabel.text intValue]>0?([self.favorLabel.text intValue]-1):0];
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"interaction" forKey:@"command"];
        [mDict setObject:@"cancelFavour" forKey:@"options"];
        [mDict setObject:self.talking.theID forKey:@"petalkId"];
        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
        
        
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
//        [self zanMakeBig];
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zanned"]];
        self.favorLabel.text =[NSString stringWithFormat:@"%d",[self.favorLabel.text intValue]+1];

        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"interaction" forKey:@"command"];
        [mDict setObject:@"create" forKey:@"options"];
        [mDict setObject:self.talking.theID forKey:@"petalkId"];
        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
        
        
        NSLog(@"doFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            self.favorBtn.enabled = YES;
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
            self.favorBtn.enabled = YES;
        }];
    }
}
- (void)shareAction
{
    
    if (_delegate&& [_delegate respondsToSelector:@selector(shareWithTalkingBrowse:)]) {
        [_delegate shareWithTalkingBrowse:self.talking];
    }
}
-(void)tagBtnClicked:(UIButton *)sender
{
    NSDictionary * tagDict = self.talking.tagArray[sender.tag-900];
    if (_delegate&& [_delegate respondsToSelector:@selector(tagBtnClickedWithTagId:)]) {
        [_delegate tagBtnClickedWithTagId:tagDict];
    }
}
-(void)doAttention
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
    if (_delegate&& [_delegate respondsToSelector:@selector(attentionBtnClicked:)]) {
        
        [self.delegate attentionBtnClicked:self];
    }
    self.lastIndex = self.cellIndex;
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petfans" forKey:@"command"];
    [mDict setObject:@"focus" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"fansId"];
    [mDict setObject:self.talking.petInfo.petID forKey:@"userId"];
    
    //    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    NSLog(@"focus user:%@",mDict);
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.lastIndex!=self.cellIndex) {
            return;
        }
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"200"]) {
            
            self.talking.relationShip = @"1";
//            [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhued"] forState:UIControlStateNormal];
            if ([[[responseObject objectForKey:@"value"] objectForKey:@"bothway"] isEqualToString:@"false"]) {
                self.talking.relationShip = @"1";
//                [self.relationBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }
            else{
                self.talking.relationShip = @"2";
//                [self.relationBtn setTitle:@"互相关注" forState:UIControlStateNormal];
            }
            
//            [self.relationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.relationBtn.enabled = NO;
            if ([responseObject objectForKey:@"message"]) {
                [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
            }
            //            [self.hotTableView reloadData];
        }
        [self dotransAnimation];
        NSLog(@"focus user success:%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络好像有点问题哦" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil, nil];
        [alert show];
        
        NSLog(@"focus user failed error:%@",error);
        
    }];
    
}

-(void)zanMakeBig
{
    if (self.lastIndex!=self.cellIndex) {
        if (![self.talking.relationShip isEqualToString:@"0"]) {
            self.relationBtn.hidden = YES;
        }
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

-(void)dotransAnimation
{
    if (self.lastIndex!=self.cellIndex) {
        if (![self.talking.relationShip isEqualToString:@"0"]) {
            self.relationBtn.hidden = YES;
        }
        return;
    }
    self.addMarkLabel.tag = 1;
    [self.addMarkLabel setFrame:CGRectMake(8, 0, 20, 20)];
    [self.addMarkLabel setFont:[UIFont systemFontOfSize:20]];
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setFromValue:[NSNumber numberWithFloat:M_PI*2]];
    [spin setToValue:[NSNumber numberWithFloat:M_PI * 4.25]];
    
    [spin setDuration:0.5];
    [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
    //速度控制器
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //添加动画
    self.addMarkLabel.tag = 1;
    [[self.addMarkLabel layer] addAnimation:spin forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!self) {
        return;
    }
    if (self.lastIndex!=self.cellIndex) {
        self.bigZanImageV.hidden = YES;
        if (![self.talking.relationShip isEqualToString:@"0"]) {
            self.relationBtn.hidden = YES;
        }
        return;
    }
    if (self.addMarkLabel.tag==1) {
        [UIView animateWithDuration:0.2 animations:^{
            self.relationBtn.alpha = 0;
        } completion:^(BOOL finished) {
            if (!self) {
                return;
            }
            [self.relationBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [self.relationBtn setTitle:@"√ 已关注" forState:UIControlStateNormal];
            [self.relationBtn setTitleColor:self.relationBtn.currentTitleColor forState:UIControlStateNormal];
            self.relationBtn.alpha = 1;
            self.addMarkLabel.hidden = YES;
            self.addMarkLabel.tag=2;
            [self.addMarkLabel setFrame:CGRectMake(11, 0, 20, 20)];
            [self.addMarkLabel setFont:[UIFont systemFontOfSize:14]];
            [self showHaveGuanzhu];
        }];
    }
    else if(self.addMarkLabel.tag==2)
    {
        __weak BrowserForwardedTalkingTableViewCell * weakSelf = self;
        [weakSelf performSelector:@selector(makeRelationBtnHidden) withObject:nil afterDelay:0.7];
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
        if ([self.delegate respondsToSelector:@selector(addZanToZanArray:cellIndex:)]) {
            self.talking.favorNum =[NSString stringWithFormat:@"%d",[self.talking.favorNum intValue]+1];
            [self.delegate addZanToZanArray:[NSDictionary dictionaryWithObjectsAndKeys:[UserServe sharedUserServe].userID,@"petId",[UserServe sharedUserServe].account.nickname,@"petNickName",[UserServe sharedUserServe].account.headImgURL,@"petHeadPortrait", nil] cellIndex:(int)self.cellIndex];
        }
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
-(void)makeRelationBtnHidden
{
    if (!self) {
        return;
    }
    if (self.lastIndex!=self.cellIndex) {
        if (![self.talking.relationShip isEqualToString:@"0"]) {
            self.relationBtn.hidden = YES;
        }
        return;
    }
    __block BrowserForwardedTalkingTableViewCell * weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.relationBtn.alpha = 0;
    } completion:^(BOOL finished) {
        weakSelf.addMarkLabel.tag=3;
        weakSelf.relationBtn.hidden = YES;
        weakSelf.relationBtn.alpha = 1;
//        if (self.talkCellType==TalkCellTypeDetailPage) {
//            return;
//        }
        if (_delegate&& [_delegate respondsToSelector:@selector(attentionPetWithTalkingBrowse:)]) {

            [weakSelf.delegate attentionPetWithTalkingBrowse:self.talking];
        }

        
    }];
}

-(void)showHaveGuanzhu
{
    if (self.lastIndex!=self.cellIndex) {
        if (![self.talking.relationShip isEqualToString:@"0"]) {
            self.relationBtn.hidden = YES;
        }
        return;
    }
//    [self.relationBtn setTitle:@"√ 已关注" forState:UIControlStateNormal];
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
    [self.relationBtn.layer addAnimation:animation forKey:nil];
//    [UIView commitAnimations];
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
