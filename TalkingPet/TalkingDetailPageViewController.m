//
//  TalkingDetailPageViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "TalkingDetailPageViewController.h"
#import "RootViewController.h"
#import "ShareSheet.h"
#if TARGET_IPHONE_SIMULATOR

#elif TARGET_OS_IPHONE
#import "amrFileCodec.h"
#endif
@interface TalkingDetailPageViewController ()
{
    UIView * bottomBG;
}
@end

@implementation TalkingDetailPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.showFavorList = NO;
        self.commentStyle = commentStyleNone;
        self.textPlaceholderStr = @"评论...";
        self.title = @"详情";
        self.commentArray = [NSMutableArray array];
        self.commentHeightArray = [NSMutableArray array];
        self.favorArray = [NSMutableArray array];
        self.shouldDismiss = NO;
        tempCommentCell = nil;
        self.iamActive = YES;
        self.canEditComment = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    [self setRightButtonWithName:nil BackgroundImg:@"morebtn" Target:@selector(moreBtnClicked)];
    self.sectionBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [self.sectionBtnView setBackgroundColor:[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1]];
    self.commentNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentNumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.commentNumBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.commentNumBtn setFrame:CGRectMake(0, 0, ScreenWidth/2.0f, 40)];
    [self.commentNumBtn setTitle:@"54转发和300评论" forState:UIControlStateNormal];
    [self.sectionBtnView addSubview:self.commentNumBtn];
    [self.commentNumBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
    [self.commentNumBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.favorNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favorNumBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.favorNumBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.favorNumBtn setFrame:CGRectMake(ScreenWidth/2.0f, 0, ScreenWidth/2.0f, 40)];
    [self.favorNumBtn setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
    [self.favorNumBtn setTitle:@"670踩" forState:UIControlStateNormal];
    [self.sectionBtnView addSubview:self.favorNumBtn];
    [self.favorNumBtn addTarget:self action:@selector(favorBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomImageV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 38, ScreenWidth/2.0f-60, 2)];
    [self.bottomImageV setBackgroundColor:CommonGreenColor];
    [self.sectionBtnView addSubview:self.bottomImageV];
    
    if (self.talking) {
        self.firstRowHeight = [BrowserForwardedTalkingTableViewCell heightForRowWithTalking:self.talking CellType:1];
    }
    
    self.contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight-45)];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.backgroundView = nil;
    _contentTableView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    //    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _contentTableView.rowHeight = 520;
    //    _contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    _contentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_contentTableView];
    
    [self.contentTableView addFooterWithTarget:self action:@selector(contentTableViewFooterRereshing:)];
    
    self.bigZanImageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-20-70, self.view.frame.size.height-45-navigationBarHeight-95, 70, 70)];
    [self.bigZanImageV setImage:[UIImage imageNamed:@"newHaveZanBig"]];
    [self.view addSubview:self.bigZanImageV];
    self.bigZanImageV.hidden = YES;
    
    //    bottomBG = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-45-navigationBarHeight, ScreenWidth, 45)];
    //    [self.view addSubview:bottomBG];
    //    [bottomBG setBackgroundColor:[UIColor whiteColor]];
    
    
    UIView * linem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [linem setBackgroundColor:[UIColor colorWithWhite:230/255.0f alpha:1]];
    [bottomBG addSubview:linem];
    
    
    //    self.forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.forwardBtn setFrame:CGRectMake(0, 0, 80, 45)];
    //    [self.forwardBtn setBackgroundColor:[UIColor clearColor]];
    //    [bottomBG addSubview:self.forwardBtn];
    //    [self.forwardBtn addTarget:self action:@selector(forwardItBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    self.forwardBtn.showsTouchWhenHighlighted = YES;
    //
    //    UIImageView * forwardImgV = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 2, 25, 25)];
    //    [forwardImgV setImage:[UIImage imageNamed:@"forward-ico"]];
    //    [self.forwardBtn addSubview:forwardImgV];
    //
    //    self.forwardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 80, 20)];
    //    [self.forwardLabel setBackgroundColor:[UIColor clearColor]];
    //    [self.forwardLabel setText:@"转发"];
    //    [self.forwardLabel setFont:[UIFont systemFontOfSize:11]];
    //    [self.forwardLabel setTextColor:[UIColor whiteColor]];
    //    [self.forwardLabel setTextAlignment:NSTextAlignmentCenter];
    //    [self.forwardBtn addSubview:self.forwardLabel];
    //
    //    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(80, 10, 1, 25)];
    //    [line1 setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
    //    [bottomBG addSubview:line1];
    //
    //    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.commentBtn setFrame:CGRectMake(80, 0, 80, 45)];
    //    [self.commentBtn setBackgroundColor:[UIColor clearColor]];
    //    [bottomBG addSubview:self.commentBtn];
    //    self.commentBtn.showsTouchWhenHighlighted = YES;
    //    [self.commentBtn addTarget:self action:@selector(commentItBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    UIImageView * commentImgV = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 4, 25, 25)];
    //    [commentImgV setImage:[UIImage imageNamed:@"comment-ico"]];
    //    [self.commentBtn addSubview:commentImgV];
    //
    //    self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 80, 20)];
    //    [self.commentLabel setBackgroundColor:[UIColor clearColor]];
    //    [self.commentLabel setText:@"评论"];
    //    [self.commentLabel setFont:[UIFont systemFontOfSize:11]];
    //    [self.commentLabel setTextColor:[UIColor whiteColor]];
    //    [self.commentLabel setTextAlignment:NSTextAlignmentCenter];
    //    [self.commentBtn addSubview:self.commentLabel];
    //
    //    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(80*2, 10, 1, 25)];
    //    [line2 setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
    //    [bottomBG addSubview:line2];
    //
    //    self.favorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.favorBtn setFrame:CGRectMake(80*2, 0, 80, 45)];
    //    [self.favorBtn setBackgroundColor:[UIColor clearColor]];
    //    [bottomBG addSubview:self.favorBtn];
    //    self.favorBtn.showsTouchWhenHighlighted = YES;
    //    [self.favorBtn addTarget:self action:@selector(favorThisTalking) forControlEvents:UIControlEventTouchUpInside];
    //
    //    self.favorImgV = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 2, 25, 25)];
    //    if (self.talking.ifZan) {
    //        [_favorImgV setImage:[UIImage imageNamed:@"yizan_ico"]];
    //    }
    //    else
    //        [_favorImgV setImage:[UIImage imageNamed:@"step-ico"]];
    //    [self.favorBtn addSubview:_favorImgV];
    //
    //    self.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 80, 20)];
    //    [self.favorLabel setBackgroundColor:[UIColor clearColor]];
    //    [self.favorLabel setText:@"踩一下"];
    //    [self.favorLabel setFont:[UIFont systemFontOfSize:11]];
    //    [self.favorLabel setTextColor:[UIColor whiteColor]];
    //    [self.favorLabel setTextAlignment:NSTextAlignmentCenter];
    //    [self.favorBtn addSubview:self.favorLabel];
    //
    //    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(80*3, 10, 1, 25)];
    //    [line3 setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
    //    [bottomBG addSubview:line3];
    //
    //    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.shareBtn setFrame:CGRectMake(80*3, 0, 80, 45)];
    //    [self.shareBtn setBackgroundColor:[UIColor clearColor]];
    //    [bottomBG addSubview:self.shareBtn];
    //    [self.shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //    self.shareBtn.showsTouchWhenHighlighted = YES;
    //
    //
    //    UIImageView * shareImgV = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 3, 25, 25)];
    //    [shareImgV setImage:[UIImage imageNamed:@"share-ico"]];
    //    [self.shareBtn addSubview:shareImgV];
    //
    //    self.shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 80, 20)];
    //    [self.shareLabel setBackgroundColor:[UIColor clearColor]];
    //    [self.shareLabel setText:@"分享"];
    //    [self.shareLabel setFont:[UIFont systemFontOfSize:11]];
    //    [self.shareLabel setTextColor:[UIColor whiteColor]];
    //    [self.shareLabel setTextAlignment:NSTextAlignmentCenter];
    //    [self.shareBtn addSubview:self.shareLabel];
    
    
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentBtn setFrame:CGRectMake((ScreenWidth>320?35:25)+(ScreenWidth-50)/3+10, 4, (ScreenWidth-50)/3, 45)];
    [self.commentBtn setBackgroundColor:[UIColor clearColor]];
    [bottomBG addSubview:self.commentBtn];
    self.commentBtn.showsTouchWhenHighlighted = YES;
    [_commentBtn addTarget:self action:@selector(commentItBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * commentImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 35, 35)];
    //            [commentImgV setImage:[UIImage imageNamed:@"comment-ico"]];
    [self.commentBtn addSubview:commentImgV];
    
    self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 10, 50, 20)];
    [self.commentLabel setBackgroundColor:[UIColor clearColor]];
    [self.commentLabel setText:@"评论"];
    [self.commentLabel setFont:[UIFont systemFontOfSize:14]];
    //            [self.commentLabel setTextColor:[UIColor whiteColor]];
    [self.commentLabel setTextAlignment:NSTextAlignmentLeft];
    [self.commentBtn addSubview:self.commentLabel];
    
    //            UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(75*2, 10, 1, 25)];
    //            [line2 setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
    //            [_bottomBG addSubview:line2];
    
    self.favorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favorBtn setFrame:CGRectMake(ScreenWidth>320?35:25, 4, (ScreenWidth-50)/3, 45)];
    [self.favorBtn setBackgroundColor:[UIColor clearColor]];
    [bottomBG addSubview:self.favorBtn];
    self.favorBtn.showsTouchWhenHighlighted = YES;
    [_favorBtn addTarget:self action:@selector(favorThisTalking) forControlEvents:UIControlEventTouchUpInside];
    
    self.favorImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 35, 35)];
    //            [_favorImgV setImage:[UIImage imageNamed:@"step-ico"]];
    [self.favorBtn addSubview:_favorImgV];
    
    self.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 10, 50, 20)];
    [self.favorLabel setBackgroundColor:[UIColor clearColor]];
    [self.favorLabel setText:@"喜欢"];
    [self.favorLabel setFont:[UIFont systemFontOfSize:14]];
    //            [self.favorLabel setTextColor:[UIColor whiteColor]];
    [self.favorLabel setTextAlignment:NSTextAlignmentLeft];
    [self.favorBtn addSubview:self.favorLabel];
    
    //            UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(75*3, 10, 1, 25)];
    //            [line3 setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
    //            [_bottomBG addSubview:line3];
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareBtn setFrame:CGRectMake((ScreenWidth>320?35:25)+(ScreenWidth-50)/3+(ScreenWidth-50)/3+20, 4, (ScreenWidth-50)/3, 45)];
    [self.shareBtn setBackgroundColor:[UIColor clearColor]];
    [bottomBG addSubview:self.shareBtn];
    self.shareBtn.showsTouchWhenHighlighted = YES;
    [_shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * shareImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 35, 35)];
    //            [shareImgV setImage:[UIImage imageNamed:@"share-ico"]];
    [self.shareBtn addSubview:shareImgV];
    
    self.shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 10, 50, 20)];
    [self.shareLabel setBackgroundColor:[UIColor clearColor]];
    [self.shareLabel setText:@"分享"];
    [self.shareLabel setFont:[UIFont systemFontOfSize:14]];
    //            [self.shareLabel setTextColor:[UIColor whiteColor]];
    [self.shareLabel setTextAlignment:NSTextAlignmentLeft];
    [self.shareBtn addSubview:self.shareLabel];
    
    [commentImgV setImage:[UIImage imageNamed:@"browser_comment"]];
    [self.commentLabel setTextColor:[UIColor colorWithWhite:140/255.0f alpha:1]];
    [_favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
    [self.favorLabel setTextColor:[UIColor colorWithWhite:140/255.0f alpha:1]];
    [shareImgV setImage:[UIImage imageNamed:@"browser_forward"]];
    [self.shareLabel setTextColor:[UIColor colorWithWhite:140/255.0f alpha:1]];
    
    
    
    __block TalkingDetailPageViewController * weakSelf = self;
    self.inputView = [[InputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-navigationBarHeight-50, 320, 50) BaseView:self.view Type:1];
    [self.view addSubview:self.inputView];
    self.inputView.viewH = self.view.frame.size.height;
    self.inputView.naviH = navigationBarHeight;
    self.inputView.delegate = self;
    self.inputView.favorBtnClicked = ^(UIButton * sender)
    {
        [weakSelf favorThisTalking];
    };
    self.inputView.shareBtnClicked = ^(UIButton * sender)
    {
        [weakSelf shareBtnClicked];
    };
    
    if (self.talking.ifZan) {
        if ([UserServe sharedUserServe].account) {
            [self.inputView.favorBtn setImage:[UIImage imageNamed:@"keyboard_favored"] forState:UIControlStateNormal];
        }
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zanned"]];
    }
    else
        [self.inputView.favorBtn setImage:[UIImage imageNamed:@"keyboard_favor"] forState:UIControlStateNormal];
    
    if (self.commentStyle==commentStyleForward) {
        self.textPlaceholderStr = @"转发...";
        [self forwardItBtn:nil];
    }
    else if(self.commentStyle==commentStyleComment)
    {
        if (self.replyToId) {
            [self showCommentBarWithPetId:self.replyToId PetNickname:self.replyToName];
        }
        else
        {
            self.textPlaceholderStr = @"评论...";
            [self commentItBtn:nil];
        }
    }
    
    [self getAllCommentsAndForward:nil];
    [self getAllFavors:nil];
    
    if (!self.talking.petInfo||!self.talking.petInfo.breed||self.shouldRequestInfo) {
        [self getShuoShuoContent];
    }
    // Do any additional setup after loading the view.
    [self buildViewWithSkintype];
    
    
    
    
}
-(void)dealloc
{
    [self stopPlayTimer];
    if (btcell) {
        btcell.delegate = nil;
    }
    self.iamActive = NO;
    self.audioPlayer.delegate = nil;
    
}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];
    
}
-(NSMutableArray *)getModelArray:(NSArray *)array
{
    NSMutableArray * hArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        TalkComment * talkingComment = [[TalkComment alloc] initWithHostInfo:[array objectAtIndex:i]];
        talkingComment.cHeight = [TalkingCommentTableViewCell heightForRowWithComment:talkingComment].height;
        talkingComment.cWidth = [TalkingCommentTableViewCell heightForRowWithComment:talkingComment].width;
        
        [hArray addObject:talkingComment];
        //        [self.commentHeightArray addObject:[NSNumber numberWithFloat:[TalkingCommentTableViewCell heightForRowWithComment:talkingComment]]];
    }
    return hArray;
}
-(NSMutableArray *)getHeightArray:(NSArray *)array
{
    NSMutableArray * hArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        TalkComment * talkingComment = [[TalkComment alloc] initWithHostInfo:[array objectAtIndex:i]];
        [hArray addObject:talkingComment];
    }
    return hArray;
}
-(void)getAllCommentsAndForward:(NSString *)lastId
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"interaction" forKey:@"command"];
    [mDict setObject:@"list" forKey:@"options"];
    [mDict setObject:self.talking.theID forKey:@"petalkId"];
    if (lastId) {
        [mDict setObject:lastId forKey:@"id"];
    }
    
    [mDict setObject:@"C_R" forKey:@"type"];
    [mDict setObject:@"20" forKey:@"pageSize"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
    
    
    NSLog(@"getAllCommentsAndForward:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"getAllCommentsAndForward success:%@",responseObject);
        if (!lastId) {
            [self.commentHeightArray removeAllObjects];
            self.commentArray = [self getModelArray:[responseObject objectForKey:@"value"]];
            [self getCommentAndFavorNum];
        }
        else{
            [self.commentArray addObjectsFromArray:[self getModelArray:[responseObject objectForKey:@"value"]]];
            
        }
        [self endHotFooterRefreshing:self.contentTableView];
        [self.contentTableView reloadData];
        if (self.commentArray.count>0) {
            //            [self.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getAllCommentsAndForward error:%@",error);
    }];
    
}
-(void)getShuoShuoContent
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"one" forKey:@"options"];
    [mDict setObject:self.talking.theID forKey:@"petalkId"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"currPetId"];
    NSLog(@"oneShuoshuo:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.talking = [[TalkingBrowse alloc] initWithHostInfo:[responseObject objectForKey:@"value"]];
        self.firstRowHeight = [BrowserForwardedTalkingTableViewCell heightForRowWithTalking:self.talking CellType:1];
        [self.contentTableView reloadData];
        if ([UserServe sharedUserServe].userID) {
            if ([self.talking.petInfo.petID isEqualToString:[UserServe sharedUserServe].userID]) {
                self.canEditComment = YES;
            }
        }
        
        NSLog(@"get shuoshuo content success:%@",responseObject);
        if (self.talking.ifZan) {
            if ([UserServe sharedUserServe].account) {
                [_favorImgV setImage:[UIImage imageNamed:@"browser_zanned"]];
            }
            
        }
        else
            [_favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get shuoshuo content failed with error:%@",error);
        if ([error code]!=-1004) {
            UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"内容不存在" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            errorAlert.tag = 12;
            [errorAlert show];
        }
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==12) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag==23){
        if (buttonIndex==1) {
            [self deleteAComment];
        }
    }
}
-(void)getCommentAndFavorNum
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"counter" forKey:@"command"];
    [mDict setObject:@"petalk" forKey:@"options"];
    [mDict setObject:self.talking.theID forKey:@"petalkId"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
    NSLog(@"getCommentAndFavorNum:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"getCommentAndFavorNum success:%@",responseObject);
        NSDictionary * theDict = [responseObject objectForKey:@"value"];
        [self.commentNumBtn setTitle:[NSString stringWithFormat:@"%@转发和%@评论",[theDict objectForKey:@"relay"],[theDict objectForKey:@"comment"]] forState:UIControlStateNormal];
        [self.favorNumBtn setTitle:[NSString stringWithFormat:@"%@踩",[theDict objectForKey:@"favour"]] forState:UIControlStateNormal];
        self.caiNum = [[theDict objectForKey:@"favour"] integerValue];
        
        if ([self.delegate respondsToSelector:@selector(changeCommentArrayWithTalking:)]) {
            self.talking.commentNum = [theDict objectForKey:@"comment"];
            self.talking.favorNum = [theDict objectForKey:@"favour"];
            if (self.commentArray.count>0) {
                TalkComment * tk = self.commentArray[0];
                NSDictionary * dc = [NSDictionary dictionaryWithObjectsAndKeys:tk.content,@"comment",tk.petAvatarURL,@"petHeadPortrait",tk.petID,@"petId",tk.petNickname,@"petNickName", nil];
                if (self.talking.showCommentArray.count==0) {
                    [self.talking.showCommentArray addObject:dc];
                }
                else if (self.talking.showCommentArray.count<2){
                    [self.talking.showCommentArray insertObject:dc atIndex:0];
                }
                else
                {
                    //                    [self.talking.showCommentArray insertObject:dc atIndex:0];
                    [self.talking.showCommentArray replaceObjectAtIndex:0 withObject:dc];
                    //                    [self.talking.showCommentArray removeLastObject];
                }
                
            }
            [self.delegate changeCommentArrayWithTalking:self.talking];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getCommentAndFavorNum error:%@",error);
    }];
    
}

-(void)getAllFavors:(NSString *)lastId
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"interaction" forKey:@"command"];
    [mDict setObject:@"list" forKey:@"options"];
    if (lastId) {
        [mDict setObject:lastId forKey:@"id"];
    }
    
    [mDict setObject:self.talking.theID forKey:@"petalkId"];
    [mDict setObject:@"F" forKey:@"type"];
    [mDict setObject:@"20" forKey:@"pageSize"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
    
    
    NSLog(@"getAllFavors:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (!lastId) {
            self.favorArray = [responseObject objectForKey:@"value"];
            [self getCommentAndFavorNum];
        }
        else{
            [self.favorArray addObjectsFromArray:[responseObject objectForKey:@"value"]];
            [self endHotFooterRefreshing:self.contentTableView];
        }
        NSLog(@"getAllFavors success:%@",responseObject);
        [self.contentTableView reloadData];
        if (self.favorArray.count>0) {
            //            [self.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getAllFavors error:%@",error);
    }];
    
}
- (void)contentTableViewFooterRereshing:(UITableView *)tableView
{
    //    [self performSelector:@selector(endHotFooterRefreshing:) withObject:nil afterDelay:2];
    if (!self.showFavorList) {
        if (self.commentArray.count==0||!self.commentArray) {
            [self endHotFooterRefreshing:self.contentTableView];
            return;
        }
        TalkComment * tk = [self.commentArray lastObject];
        NSString * lastID = tk.commentId;
        [self getAllCommentsAndForward:lastID];
    }
    else
    {
        if (self.favorArray.count==0||!self.favorArray) {
            [self endHotFooterRefreshing:self.contentTableView];
            return;
        }
        NSString * lastID = [[self.favorArray lastObject] objectForKey:@"id"];
        [self getAllFavors:lastID];
    }
    
}
-(void)attentionPetWithTalkingBrowse:(TalkingBrowse *)talkingBrowse
{
    self.talking = talkingBrowse;
    [self.contentTableView reloadData];
    if (_delegate&& [_delegate respondsToSelector:@selector(attentionPetWithTalkingBrowse2:)]) {
        
        [self.delegate attentionPetWithTalkingBrowse2:self.talking];
    }
    
}
-(void)toUserPage:(NSDictionary *)petDict
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = [petDict objectForKey:@"petId"];
    pv.petAvatarUrlStr = [petDict objectForKey:@"petHeadPortrait"];
    pv.petNickname = [petDict objectForKey:@"petNickName"];
    [self.navigationController pushViewController:pv animated:YES];
}

-(void)attentionDelegate:(NSDictionary *)dict Index:(NSInteger)index
{
    [self.favorArray replaceObjectAtIndex:index withObject:dict];
    [self.contentTableView reloadData];
}
-(void)endHotFooterRefreshing:(UITableView *)tableView
{
    [self.contentTableView footerEndRefreshing];
    //    [self.contentTableView reloadData];
    
}
#pragma mark  分享按钮
-(void)shareBtnClicked
{
    ShareSheet * shareSheet = [[ShareSheet alloc]initWithIconArray:@[@"weiChatFriend",@"friendCircle",@"sina",@"qq",@"petaking"] titleArray:@[@"微信好友",@"朋友圈",@"微博",@"QQ",@"友仔"] action:^(NSInteger index) {
        switch (index) {
            case 0:{
                [ShareServe shareToWeixiFriendWithTitle:[NSString stringWithFormat:@"看%@的动态",_talking.petInfo.nickname] Content:[NSString stringWithFormat:@"分享自%@的友仔动态:\"%@\"",_talking.petInfo.nickname,_talking.descriptionContent] imageUrl:_talking.thumbImgUrl webUrl:[NSString stringWithFormat:SHAREBASEURL@"%@",_talking.theID] Succeed:^{
                    [ShareServe shareNumberUpWithPetalkId:_talking.theID];
                }];
            }break;
            case 1:{
                [ShareServe shareToFriendCircleWithTitle:[NSString stringWithFormat:@"看%@的动态",_talking.petInfo.nickname] Content:[NSString stringWithFormat:@"分享自%@的友仔动态:\"%@\"",_talking.petInfo.nickname,_talking.descriptionContent] imageUrl:_talking.thumbImgUrl webUrl:[NSString stringWithFormat:SHAREBASEURL@"%@",_talking.theID] Succeed:^{
                    [ShareServe shareNumberUpWithPetalkId:_talking.theID];
                }];
            }break;
            case 2:{
                [ShareServe shareToSineWithContent:[NSString stringWithFormat:@"分享自%@的友仔动态:\"%@\"%@%@",_talking.petInfo.nickname,_talking.descriptionContent,SHAREBASEURL,_talking.theID] imageUrl:_talking.thumbImgUrl Succeed:^{
                    [ShareServe shareNumberUpWithPetalkId:_talking.theID];
                }];
            }break;
            case 3:{
                [ShareServe shareToQQWithTitle:[NSString stringWithFormat:@"看%@的动态",_talking.petInfo.nickname] Content:[NSString stringWithFormat:@"分享自%@的友仔动态:\"%@\"",_talking.petInfo.nickname,_talking.descriptionContent] imageUrl:_talking.thumbImgUrl webUrl:[NSString stringWithFormat:SHAREBASEURL@"%@",_talking.theID] Succeed:^{
                    [ShareServe shareNumberUpWithPetalkId:_talking.theID];
                }];
            }break;
            case 4:{
                [self forwardItBtn:nil];
            }break;
            default:
                break;
        }
        
    }];
    [shareSheet show];
}

-(void)commentItBtn:(UIButton *)sender
{
    NSString * currentPetId = [UserServe sharedUserServe].userID;
    if (!currentPetId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录才能评论哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        return;
    }
    self.textPlaceholderStr= @"评论...";
    self.commentStyle = commentStyleComment;
    [self.inputView showInputViewWithAudioBtn:YES];
    [self.inputView setTextPlaceHolder:self.textPlaceholderStr];
}
-(void)forwardItBtn:(UIButton *)sender
{
    NSString * currentPetId = [UserServe sharedUserServe].userID;
    if (!currentPetId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录才能转发哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }
    self.textPlaceholderStr= @"转发...";
    self.commentStyle = commentStyleForward;
    [self.inputView showInputViewWithAudioBtn:NO];
    [self.inputView setTextPlaceHolder:self.textPlaceholderStr];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL dis = YES;
    UITouch * anyTouch = [touches anyObject];
    if ([[anyTouch view] isEqual:self.inputView]) {
        return;
    }
    for (UIView * view in self.inputView.subviews) {
        if ([[anyTouch view] isEqual:view]) {
            dis = NO;
            break;
        }
    }
    for (UIView * view in self.inputView.theEmojiView.subviews) {
        if ([[anyTouch view] isEqual:view]) {
            dis = NO;
            break;
        }
    }
    if ([[anyTouch view] isKindOfClass:[UITextView class]]) {
        dis = NO;
        return;
    }
    if (!dis) {
        return;
    }
    [self.inputView dismissInputView];
    self.replyToId = nil;
}
-(void)commentBtnClicked:(UIButton *)sender
{
    self.showFavorList = NO;
    [self getAllCommentsAndForward:nil];
    [UIView animateWithDuration:0.1 animations:^{
        [self.commentNumBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
        [self.favorNumBtn setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
        [self.bottomImageV setFrame:CGRectMake(30, 38, ScreenWidth/2.0f-60, 2)];
    } completion:^(BOOL finished) {
        [self.contentTableView reloadData];
    }];
    
}
-(void)favorBtnClicked:(UIButton *)sender
{
    
    self.showFavorList = YES;
    [self getAllFavors:nil];
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.favorNumBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
        [self.commentNumBtn setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
        [self.bottomImageV setFrame:CGRectMake(ScreenWidth/2.0f+30, 38, ScreenWidth/2.0f-60, 2)];
    } completion:^(BOOL finished) {
        [self.contentTableView reloadData];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 0;
    }
    else
        return 0;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return nil;
    }
    else
        return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return self.firstRowHeight;
    }
    else
    {
        if (self.showFavorList) {
            return 70;
        }
        else{
            TalkComment * tk = [self.commentArray objectAtIndex:indexPath.row];
            return tk.cHeight;
            //            CGSize commentSize = [[self.commentArray[indexPath.row] content]  sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 80)];
            //            return 40+10+commentSize.height;
        }
        
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else{
        if (self.showFavorList) {
            return self.favorArray.count;
        }
        else
            return self.commentArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellIdentifier = @"Cell";
        BrowserForwardedTalkingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[BrowserForwardedTalkingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle CellType:TalkCellTypeDetailPage reuseIdentifier:cellIdentifier];
            cell.talkCellType = TalkCellTypeDetailPage;
            cell.delegate = self;
        }
        btcell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.publisherAvatarV.placeholderImage = [UIImage imageNamed:@"gougouAvatar.jpeg"];
        //        cell.publisherAvatarV.imageURL = [NSURL URLWithString:@"http://img1.3lian.com/gif/more/11/201212/987fc26a2e0ad90607c999d6e2bec40b.jpg"];
        //        [cell.publisherAvatarV addTarget:self action:@selector(toPersonProfilePage:) forControlEvents:UIControlEventTouchUpInside];
        cell.talking = self.talking;
        cell.firstRowHeight = self.firstRowHeight;
        
        return cell;
    }
    else
    {
        if (self.showFavorList) {
            static NSString *cellIdentifier2 = @"FavorCell";
            FavorListTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 ];
            if (cell == nil) {
                cell = [[FavorListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier2];
                cell.delegate = self;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.favorDict = [self.favorArray objectAtIndex:indexPath.row];
            cell.cellIndex = indexPath.row;
            //            cell.commentAvatarV.placeholderImage = [UIImage imageNamed:@"gougouAvatar.jpeg"];
            //            cell.commentAvatarV.imageURL = [NSURL URLWithString:@"http://99touxiang.com/public/upload/gexing/5/16-063616_452.jpg"];
            //            [cell.commentAvatarV addTarget:self action:@selector(toPersonProfilePage:) forControlEvents:UIControlEventTouchUpInside];
            //            [cell refreshCell];
            return cell;
        }
        else{
            static NSString *cellIdentifier3 = @"CommentCell";
            TalkingCommentTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3 ];
            if (cell == nil) {
                cell = [[TalkingCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier3];
                cell.delegate = self;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.talkingComment = [self.commentArray objectAtIndex:indexPath.row];
            //            cell.commentAvatarV.placeholderImage = [UIImage imageNamed:@"gougouAvatar.jpeg"];
            //            cell.commentAvatarV.imageURL = [NSURL URLWithString:@"http://img1.3lian.com/gif/more/11/201212/987fc26a2e0ad90607c999d6e2bec40b.jpg"];
            //            [cell.commentAvatarV addTarget:self action:@selector(toPersonProfilePage:) forControlEvents:UIControlEventTouchUpInside];
            //            [cell refreshCell];
            return cell;
        }
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (!self.showFavorList) {
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
            
            TalkComment * tk = self.commentArray[indexPath.row];
            if ([tk.petID isEqualToString:currentPetId]) {
                self.currentTalkComment = tk;
                self.currentTalkCommentIndex = indexPath.row;
                UIActionSheet * act= [[UIActionSheet alloc] initWithTitle:@"删除这条评论?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
                act.tag = 3;
                [act showInView:self.view];
                //                self.replyToId = nil;
                //                self.inputView.textView.placeholder = @"";
            }
            else{
                [self.inputView showInputViewWithAudioBtn:YES];
                self.replyToId = tk.petID;
                self.inputView.textView.placeholder = [NSString stringWithFormat:@"回复@%@",tk.petNickname];
                
            }
            self.commentStyle = commentStyleComment;
            
            
        }
        else
        {
            [self toUserPage:[self.favorArray objectAtIndex:indexPath.row]];
        }
    }
    else if (indexPath.section==0){
        if ([self.talking.theModel isEqualToString:@"2"]) {
            PreviewStoryViewController * pv = [[PreviewStoryViewController alloc] init];
            [pv loadPreviewStoryViewWithDictionary:self.talking];
            [self.navigationController pushViewController:pv animated:YES];
        }
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.canEditComment) {
        if (!self.showFavorList&&indexPath.section!=0) {
            return YES;
        }
        return NO;
    }
    return NO;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        TalkComment * tk = self.commentArray[indexPath.row];
        self.currentTalkComment = tk;
        self.currentTalkCommentIndex = indexPath.row;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除这条评论吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alert.tag = 23;
        [alert show];
        
    }
}

-(void)showCommentBarWithPetId:(NSString *)petId PetNickname:(NSString *)nickname
{
    self.commentStyle = commentStyleComment;
    [self.inputView showInputViewWithAudioBtn:YES];
    self.replyToId = petId;
    self.inputView.textView.placeholder = [NSString stringWithFormat:@"回复@%@",nickname];
}
#pragma mark 标签相关
-(void)tagBtnClickedWithTagId:(NSDictionary *)tagId
{
    TagTalkListViewController * tagTlistV = [[TagTalkListViewController alloc] init];
    tagTlistV.title = [tagId objectForKey:@"name"];
    Tag * theTag = [[Tag alloc] init];
    theTag.tagID = [tagId objectForKey:@"id"];
    theTag.tagName = [tagId objectForKey:@"name"];
    theTag.backGroundURL = [tagId objectForKey:@"bgUrl"];
    tagTlistV.tag = theTag;
    //[self.navigationController pushViewController:tagTlistV animated:YES];
}
-(void)petProfileWhoPublishTalkingBrowse:(TalkingBrowse *)talkingBrowse
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingBrowse.petInfo.petID;
    pv.petAvatarUrlStr = talkingBrowse.petInfo.headImgURL;
    pv.petNickname = talkingBrowse.petInfo.nickname;
    [self.navigationController pushViewController:pv animated:YES];
}
-(void)commentPublisherBtnClicked:(TalkComment *)talkingCommentN
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingCommentN.petID;
    pv.petAvatarUrlStr = talkingCommentN.petAvatarURL;
    pv.petNickname = talkingCommentN.petNickname;
    [self.navigationController pushViewController:pv animated:YES];
}
-(void)commentAimUserNameClicked:(TalkComment *)talkingCommentN Link:(NSTextCheckingResult *)linkInfo
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingCommentN.aimPetID;
    //    pv.petAvatarUrlStr = talkingCommentN.petAvatarURL;
    pv.petNickname = talkingCommentN.aimPetNickname;
    [self.navigationController pushViewController:pv animated:YES];
}
-(void)commentPlayAudioBtnClicked:(TalkComment *)talkingCommentN Cell:(id)cell
{
    //    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *subdirectory = [documents stringByAppendingPathComponent:@"Audios"];
    //
    //    NSArray * g = [talkingCommentN.audioUrl componentsSeparatedByString:@"/"];
    //    NSString *audioPath = [subdirectory stringByAppendingPathComponent:[g lastObject]];
    //
    //    NSFileManager *fm = [NSFileManager defaultManager];
    //    if(![fm fileExistsAtPath:audioPath]){
    //        currentPlayingUrl = talkingCommentN.audioUrl;
    //        [self getAudioFromNet:talkingCommentN.audioUrl LocalPath:audioPath];
    //    }
    //    else{
    //        currentPlayingUrl = talkingCommentN.audioUrl;
    //        if ([self.audioPlayer isPlaying]) {
    //            [self.audioPlayer stopAudio];
    //        }
    //        self.audioPlayer = [XHAudioPlayerHelper shareInstance];
    //        [self.audioPlayer setDelegate:self];
    //        [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
    //    }
    int oo = 0;
    TalkingCommentTableViewCell * cella = (TalkingCommentTableViewCell *)cell;
    if ([talkingCommentN.audioUrl isEqualToString:currentPlayingUrl]) {
        oo = 1;
    }
    if ([cella.playRecordImgV isAnimating]||[self.audioPlayer isPlaying]) {
        [cella.playRecordImgV stopAnimating];
        [self.audioPlayer stopAudio];
    }
    if (oo==1) {
        currentPlayingUrl = nil;
        return;
    }
    //    else
    //    {
    tempCommentCell = cella;
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSArray * g = [talkingCommentN.audioUrl componentsSeparatedByString:@"/"];
    NSString *accessorys2 = [[documents stringByAppendingPathComponent:@"Audios"] stringByAppendingPathComponent:[g lastObject]];
    
    NSString * filePath = nil;
    if ([accessorys2 hasSuffix:@".amr"]) {
        filePath = [accessorys2 stringByReplacingOccurrencesOfString:@".amr" withString:@".caf"];
    }
    else if(![accessorys2 hasSuffix:@".caf"]&&![accessorys2 hasSuffix:@".amr"]){
        filePath = [accessorys2 stringByAppendingString:@".caf"];
    }
    else
        filePath = accessorys2;
    NSFileManager *fm = [NSFileManager defaultManager];
    currentPlayingUrl = talkingCommentN.audioUrl;
    if(![fm fileExistsAtPath:filePath]){
        
        [self getAudioFromNet:talkingCommentN.audioUrl LocalPath:filePath Type:2];
    }
    else{
        
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stopAudio];
        }
        
        self.audioPlayer = [XHAudioPlayerHelper shareInstance];
        [self.audioPlayer setDelegate:self];
        [self.audioPlayer managerAudioWithFileName:filePath toPlay:YES];
        //            [cells.aniImageV startAnimating];
        
        if (![cella.playRecordImgV isAnimating]) {
            cella.playRecordImgV.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"shengyin1.png"],[UIImage imageNamed:@"shengyin2.png"],[UIImage imageNamed:@"shengyin3.png"], nil];
            cella.playRecordImgV.animationDuration = cella.playRecordImgV.animationImages.count*0.15;
            [cella.playRecordImgV startAnimating];
        }
    }
    
    //    }
    
    
}

-(void)forwardThisTalkingWithMsg:(NSString *)forwardMsg
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
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"interaction" forKey:@"command"];
    [mDict setObject:@"create" forKey:@"options"];
    [mDict setObject:self.talking.theID forKey:@"petalkId"];
    [mDict setObject:@"R" forKey:@"type"];
    [mDict setObject:currentPetId forKey:@"userId"];
    [mDict setObject:self.talking.petInfo.petID forKey:@"aimUserId"];
    [mDict setObject:forwardMsg forKey:@"comment"];
    NSLog(@"doForward:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self successAction];
        NSLog(@"forward success:%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"forward error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"转发失败"];
        [self failedAction];
    }];
    
}

-(void)makeCommentToThisTalkingWithContent:(NSString *)commentContent AimPetID:(NSString *)aimPetId
{
    NSString * currentPetId = [UserServe sharedUserServe].userID;
    if (!currentPetId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录才能评论哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"interaction" forKey:@"command"];
    [mDict setObject:@"create" forKey:@"options"];
    [mDict setObject:self.talking.theID forKey:@"petalkId"];
    [mDict setObject:@"C" forKey:@"type"];
    [mDict setObject:currentPetId forKey:@"userId"];
    if (aimPetId) {
        [mDict setObject:aimPetId forKey:@"aimUserId"];
    }
    
    [mDict setObject:commentContent forKey:@"comment"];
    NSLog(@"doComment:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        [self successAction];
        self.inputView.textView.text = @"";
        
        [self getAllCommentsAndForward:nil];
        NSLog(@"comment success:%@",responseObject);
        if ([responseObject objectForKey:@"message"]) {
            [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"comment error:%@",error);
        //        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"评论失败"];
        [self failedAction];
    }];
}

-(void)makeAudioCommentToThisTalkingWithAudioURL:(NSString *)audioUrl AudioSeconds:(NSString *)audioSeconds AimPetID:(NSString *)aimPetId
{
    NSString * currentPetId = [UserServe sharedUserServe].userID;
    if (!currentPetId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录才能评论哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"interaction" forKey:@"command"];
    [mDict setObject:@"create" forKey:@"options"];
    [mDict setObject:self.talking.theID forKey:@"petalkId"];
    [mDict setObject:@"C" forKey:@"type"];
    [mDict setObject:currentPetId forKey:@"userId"];
    if (aimPetId) {
        [mDict setObject:aimPetId forKey:@"aimUserId"];
    }
    
    [mDict setObject:@"" forKey:@"comment"];
    [mDict setObject:audioUrl forKey:@"audioUrl"];
    [mDict setObject:audioSeconds forKey:@"audioSecond"];
    NSLog(@"doAudioComment:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.inputView.textView.text = @"";
        
        [self getAllCommentsAndForward:nil];
        NSLog(@"comment success:%@",responseObject);
        if ([responseObject objectForKey:@"message"]) {
            [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"audio comment error:%@",error);
        //        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"评论失败"];
        [self failedAction];
    }];
}

-(void)favorThisTalking
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
    if (!self.talking.ifZan) {
        [self.inputView.favorBtn setImage:[UIImage imageNamed:@"keyboard_favored"] forState:UIControlStateNormal];
        self.talking.ifZan = YES;
        self.favorBtn.enabled = NO;
        //        [self zanMakeBig];
        int n = (int)self.caiNum;
        self.talking.favorNum = [NSString stringWithFormat:@"%d",[self.talking.favorNum intValue]+1];
        [self.contentTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.favorNumBtn setTitle:[NSString stringWithFormat:@"%d踩",n+1] forState:UIControlStateNormal];
        self.caiNum++;
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"interaction" forKey:@"command"];
        [mDict setObject:@"create" forKey:@"options"];
        [mDict setObject:self.talking.theID forKey:@"petalkId"];
        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:currentPetId forKey:@"userId"];
        
        
        [self.talking.showZanArray insertObject:[NSDictionary dictionaryWithObjectsAndKeys:[UserServe sharedUserServe].userID,@"petId",[UserServe sharedUserServe].account.nickname,@"petNickName",[UserServe sharedUserServe].account.headImgURL,@"petHeadPortrait", nil] atIndex:0];
        if (_delegate&& [_delegate respondsToSelector:@selector(resetShuoShuoStatus:)]) {
            
            [self.delegate resetShuoShuoStatus:self.talking];
        }
        
        NSLog(@"doFavor:%@",mDict);
        [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [self getAllFavors:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favor error:%@",error);
            self.favorBtn.enabled = YES;
            [_favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
        }];
        
    }
    else
    {
        self.talking.ifZan = NO;
        [self.inputView.favorBtn setImage:[UIImage imageNamed:@"keyboard_favor"] forState:UIControlStateNormal];
        int n = (int)self.caiNum;
        self.talking.favorNum = [NSString stringWithFormat:@"%d",([self.talking.favorNum intValue]-1)>=0?([self.talking.favorNum intValue]-1):0];
        [self.contentTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.favorNumBtn setTitle:[NSString stringWithFormat:@"%d踩",n-1] forState:UIControlStateNormal];
        self.caiNum--;
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"interaction" forKey:@"command"];
        [mDict setObject:@"cancelFavour" forKey:@"options"];
        [mDict setObject:self.talking.theID forKey:@"petalkId"];
        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:currentPetId forKey:@"userId"];
        
        //        for (int i = 0; i<self.talking.showZanArray.count; i++) {
        //            NSDictionary * dict = self.talking.showZanArray[i];
        //            if ([UserServe sharedUserServe].userID isEqualToString:[dict objectForKey:@"petI"]) {
        //                <#statements#>
        //            }
        //        }
        
        if (_delegate&& [_delegate respondsToSelector:@selector(resetShuoShuoStatus:)]) {
            
            [self.delegate resetShuoShuoStatus:self.talking];
        }
        
        NSLog(@"cancelFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"cancel favor success:%@",responseObject);
            [self getAllFavors:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"cancel favor error:%@",error);
            
        }];
    }
}

-(void)didSendTextAction:(NSString *)text
{
    
    NSLog(@"%@",text);
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
    
    if (self.commentStyle == commentStyleForward){
        [self doingSth];
        [SVProgressHUD showWithStatus:@"正在转发..."];
        [self forwardThisTalkingWithMsg:text];
    }
    else {
        [self doingSth];
        [SVProgressHUD showWithStatus:self.replyToId?@"回复中...":@"评论中..."];
        [self makeCommentToThisTalkingWithContent:text AimPetID:self.replyToId];
    }
    self.replyToId = nil;
    
}
-(void)doingSth
{
    [self.inputView dismissInputView];
}
-(void)interactionFailed
{
    
}
-(void)successAction
{
    [SVProgressHUD dismiss];
    
    self.inputView.textView.text = @"";
    
    [self getAllCommentsAndForward:nil];
}

-(void)failedAction
{
    if (self.commentStyle==commentStyleComment) {
        [self.inputView showInputViewWithAudioBtn:YES];
    }
    else if (self.commentStyle==commentStyleForward){
        [self.inputView showInputViewWithAudioBtn:NO];
    }
}


-(void)didAudioDataRecorded:(NSData *)audioData WithDuration:(NSString *)theDuration
{
    [SVProgressHUD showWithStatus:self.replyToId?@"回复中...":@"评论中..."];
    [NetServer uploadAudio:audioData Type:@"comment" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } Success:^(id responseObject, NSString *fileURL) {
        [self makeAudioCommentToThisTalkingWithAudioURL:fileURL AudioSeconds:theDuration AimPetID:self.replyToId];
        NSLog(@"comment audio upload success Url:%@",fileURL);
    } failure:^(NSError *error) {
        
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    NSLog(@"ssssswwww");
    [self cellPlayAni:self.contentTableView];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"xxxx");
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isDecelerating]) {
        return;
    }
    [self cellPlayAni:self.contentTableView];
}
-(void)stopAudio
{
    if (self.audioPlayer) {
        
        [self.audioPlayer stopAudio];
        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
        
    }
    [self stopPlayTimer];
}
-(void)cellPlayAni:(UIScrollView *)scrollView
{
    if (!self.talking.petInfo) {
        return;
    }
    
    //    for (int i = 0; i<self.dataArray.count; i++) {
    NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:0];
    BrowserForwardedTalkingTableViewCell * cell = (BrowserForwardedTalkingTableViewCell *)[self.contentTableView cellForRowAtIndexPath:indexPathTo];
    //            tempCell = [cell copy];
    EGOImageButton * cV = cell.contentImgV;
    CGRect rect = [self.view convertRect:cV.frame fromView:cell.contentView];
    if (rect.origin.y>-10&&rect.origin.y+rect.size.height<self.view.frame.size.height-navigationBarHeight+30) {
        if ([cell.talking.theModel isEqualToString:@"1"]||[cell.talking.theModel isEqualToString:@"2"]) {
            return;
        }
        [self playOrDownloadForCell:cell PlayBtnClicked:NO];
        //        ;
        //        dispatch_queue_t queue = dispatch_queue_create("com.pet.playAni", NULL);
        //        dispatch_async(queue, ^{
        //
        //            if ([TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName]) {
        //                cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
        //                cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
        //            }
        //            else
        //            {
        //
        //                [NetServer downloadZipFileWithUrl:cell.talking.playAnimationImg.fileUrlStr ZipName:[NSString stringWithFormat:@"%@.%@",cell.talking.playAnimationImg.fileName,cell.talking.playAnimationImg.fileType] Success:^(NSString *zipfileName) {
        //                    [cell hideLoading];
        //                    cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
        //                    cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
        //                } failure:^(NSError *error) {
        //
        //                }];
        //            }
        //
        //            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
        //            NSString *subdirectory = [documents stringByAppendingPathComponent:@"Audios"];
        //
        //            //                    NSArray * g = [cell.talking.audioUrl componentsSeparatedByString:@"/"];
        //            NSString *audioPath = [subdirectory stringByAppendingPathComponent:cell.talking.audioName];
        //
        //            NSFileManager *fm = [NSFileManager defaultManager];
        //            if(![fm fileExistsAtPath:audioPath]){
        //                currentPlayingUrl = cell.talking.audioUrl;
        //                [self getAudioFromNet:cell.talking.audioUrl LocalPath:audioPath Type:1];
        //            }
        //            else{
        //                currentPlayingUrl = cell.talking.audioUrl;
        //                if ([self.audioPlayer isPlaying]) {
        //                    [self.audioPlayer stopAudio];
        //                }
        //                self.audioPlayer = [XHAudioPlayerHelper shareInstance];
        //                [self.audioPlayer setDelegate:self];
        //                [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
        //            }
        //
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                if (![cell.aniImageV isAnimating]) {
        //                    [cell.aniImageV startAnimating];
        //                }
        //
        //            });
        //        });
        
    }
    else
    {
        [cell.aniImageV stopAnimating];
        //        if (![currentPlayingUrl isEqualToString:cell.talking.audioUrl]) {
        [self.audioPlayer stopAudio];
        //        }
    }
    
    
    
    //    }
    
    
}

-(void)playOrDownloadForCell:(UITableViewCell *)cellTo PlayBtnClicked:(BOOL)playBtnClicked
{
    
    BrowserForwardedTalkingTableViewCell *cell = (BrowserForwardedTalkingTableViewCell *)cellTo;
    btcell = cell;
    //            tempCell = [cell copy];
    //    EGOImageButton * cV = cell.contentImgV;
    
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *subdirectory = [documents stringByAppendingPathComponent:@"Audios"];
    
    //                    NSArray * g = [cell.talking.audioUrl componentsSeparatedByString:@"/"];
    NSString *audioPath = [subdirectory stringByAppendingPathComponent:cell.talking.audioName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    
    
    
    
    
    if ([TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName]&&[fm fileExistsAtPath:audioPath]) {
        cell.aniImageV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
        cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
        cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
        
        if (![SystemServer sharedSystemServer].autoPlay&&!playBtnClicked) {
            return;
        }
        if (![cell.contentImgV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]]) {
            return;
            
        }
        
        [cell hideLoading];
        
        
        if (![cell.aniImageV isAnimating]) {
            [cell.aniImageV startAnimating];
        }
        
        if ([currentPlayingUrl isEqualToString:cell.talking.audioUrl]&&[self.audioPlayer isPlaying]) {
            return;
        }
        else{
            //                            [self.audioPlayer stopAudio];
        }
        currentPlayingUrl = cell.talking.audioUrl;
        cell.currentPlayingUrl = currentPlayingUrl;
        self.audioPlayer = [XHAudioPlayerHelper shareInstance];
        [self.audioPlayer setDelegate:self];
        [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
        if ([audioDurationTimer isValid]) {
            [audioDurationTimer invalidate];
        }
        audioDurationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playTimerDo) userInfo:nil repeats:YES];
        [audioDurationTimer fire];
        
        //                        dispatch_async(dispatch_get_main_queue(), ^{
        
        
        //                        });
        
        
    }
    else
    {
        if (![TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName]) {
            [NetServer downloadZipFileWithUrl:cell.talking.playAnimationImg.fileUrlStr ZipName:[NSString stringWithFormat:@"%@.%@",cell.talking.playAnimationImg.fileName,cell.talking.playAnimationImg.fileType] Success:^(NSString *zipfileName) {
                if (![[NSString stringWithFormat:@"%@.%@",cell.talking.playAnimationImg.fileName,cell.talking.playAnimationImg.fileType] isEqualToString:zipfileName]) {
                    return;
                }
                cell.aniImageV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
                cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
                cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
                cell.aniImageV.transform = CGAffineTransformIdentity;
                cell.aniImageV.layer.transform = CATransform3DIdentity;
                
                [cell.aniImageV setFrame:CGRectMake(0, 0, cell.talking.playAnimationImg.width*ScreenWidth, cell.talking.playAnimationImg.height*ScreenWidth)];
                cell.aniImageV.center = CGPointMake(cell.talking.playAnimationImg.centerX*ScreenWidth, cell.talking.playAnimationImg.centerY*ScreenWidth);
                cell.aniImageV.transform = CGAffineTransformRotate(cell.aniImageV.transform, cell.talking.playAnimationImg.rotationZ);
                if([fm fileExistsAtPath:audioPath]){
                    
                    if (![SystemServer sharedSystemServer].autoPlay&&!playBtnClicked) {
                        return;
                    }
                    if (![cell.contentImgV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]]) {
                        return;
                        
                    }
                    
                    [cell hideLoading];
                    if ([currentPlayingUrl isEqualToString:cell.talking.audioUrl]&&[self.audioPlayer isPlaying]) {
                        return;
                    }
                    else{
                        //                                        [self.audioPlayer stopAudio];
                    }
                    
                    
                    currentPlayingUrl = cell.talking.audioUrl;
                    cell.currentPlayingUrl = currentPlayingUrl;
                    self.audioPlayer = [XHAudioPlayerHelper shareInstance];
                    [self.audioPlayer setDelegate:self];
                    [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
                    if ([audioDurationTimer isValid]) {
                        [audioDurationTimer invalidate];
                    }
                    audioDurationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playTimerDo) userInfo:nil repeats:YES];
                    [audioDurationTimer fire];
                    //                                    dispatch_async(dispatch_get_main_queue(), ^{
                    if (![cell.aniImageV isAnimating]) {
                        [cell.aniImageV startAnimating];
                        
                    }
                    
                    
                    //                                    });
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        }
        
        if (![SystemServer sharedSystemServer].autoPlay&&!playBtnClicked) {
            return;
        }
        
        if(![fm fileExistsAtPath:audioPath]){
            currentPlayingUrl = cell.talking.audioUrl;
            [self getAudioFromNet:cell.talking.audioUrl LocalPath:audioPath Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                
                if ([responseObject writeToFile:audioPath atomically:YES]) {
                    if (![TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName])
                    {
                        return;
                    }
                    [cell hideLoading];
                    if ([cell.talking.audioUrl isEqualToString:currentPlayingUrl]) {
                        if ([currentPlayingUrl isEqualToString:cell.talking.audioUrl]&&[self.audioPlayer isPlaying]) {
                            return;
                        }
                        else{
                            //                                            [self.audioPlayer stopAudio];
                        }
                        if (![cell.contentImgV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]]) {
                            return;
                            
                        }
                        
                        currentPlayingUrl = cell.talking.audioUrl;
                        cell.currentPlayingUrl = currentPlayingUrl;
                        self.audioPlayer = [XHAudioPlayerHelper shareInstance];
                        [self.audioPlayer setDelegate:self];
                        [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
                        if ([audioDurationTimer isValid]) {
                            [audioDurationTimer invalidate];
                        }
                        audioDurationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playTimerDo) userInfo:nil repeats:YES];
                        [audioDurationTimer fire];
                        //                                        dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (![cell.aniImageV isAnimating]) {
                            cell.aniImageV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
                            cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
                            cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
                            cell.aniImageV.transform = CGAffineTransformIdentity;
                            cell.aniImageV.layer.transform = CATransform3DIdentity;
                            
                            [cell.aniImageV setFrame:CGRectMake(0, 0, cell.talking.playAnimationImg.width*ScreenWidth, cell.talking.playAnimationImg.height*ScreenWidth)];
                            cell.aniImageV.center = CGPointMake(cell.talking.playAnimationImg.centerX*ScreenWidth, cell.talking.playAnimationImg.centerY*ScreenWidth);
                            cell.aniImageV.transform = CGAffineTransformRotate(cell.aniImageV.transform, cell.talking.playAnimationImg.rotationZ);
                            [cell.aniImageV startAnimating];
                        }
                        
                        
                        //                                        });
                    }
                    
                }
                else
                {
                    NSLog(@"%@ write failed",audioPath);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    }
    
    //                });
    
    
}
-(void)playTimerDo
{
    
    NSLog(@"cutrrent22222 Time:%f,currentDeviceTime:%f,duration:%f",self.audioPlayer.player.currentTime,self.audioPlayer.player.deviceCurrentTime,self.audioPlayer.player.duration);
    [btcell setProgressViewProgress:(ScreenWidth/([btcell.talking.audioDuration floatValue]*10))];
}
-(void)stopPlayTimer
{
    [audioDurationTimer invalidate];
}
-(void)getAudioFromNet:(NSString *)audioURL LocalPath:(NSString *)localPath Success:(void (^)(AFHTTPRequestOperation *operation,  id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    [NetServer downloadAudioFileWithURL:audioURL TheController:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString  *localRecordPath = [NSString stringWithFormat:@"%@/%@.caf",rootRecordPath,audioID];
        //        NSData *  wavData = DecodeAMRToWAVE(responseObject);
        
        if (!self.iamActive) {
            return;
        }
        success(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
-(void)getAudioFromNet:(NSString *)audioURL LocalPath:(NSString *)localPath Type:(int)type
{
    
    [NetServer downloadAudioFileWithURL:audioURL TheController:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString  *localRecordPath = [NSString stringWithFormat:@"%@/%@.caf",rootRecordPath,audioID];
        //        NSData *  wavData = DecodeAMRToWAVE(responseObject);
        if (!self.iamActive) {
            return;
        }
        NSArray * array = [self.contentTableView indexPathsForVisibleRows];
        for (NSIndexPath * indexP in array) {
            if (indexP.section==0) {
                BrowserForwardedTalkingTableViewCell * cell = (BrowserForwardedTalkingTableViewCell *)[self.contentTableView cellForRowAtIndexPath:indexP];
                if ([cell.talking.audioUrl isEqualToString:audioURL]) {
                    [cell hideLoading];
                }
            }
            
        }
        NSData * audioData = nil;
        //        NSString * thePath = nil;
        if ([audioURL hasSuffix:@".amr"]||type==2) {
#if TARGET_IPHONE_SIMULATOR
            
#elif TARGET_OS_IPHONE
            //            NSData * data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:audioPath]];
            //            NSLog(@"LENGTH:%d",[data length]);
            //
            //            //待上传的dada1
            //            NSData * data1 =EncodeWAVEToAMR(data,1,16);
            //            NSLog(@"LENGTH2:%d",[data1 length]);
            audioData = DecodeAMRToWAVE(responseObject);
            //            thePath = [localPath stringByReplacingOccurrencesOfString:@".amr" withString:@".caf"];
#endif
        }
        else{
            audioData = responseObject;
            //            thePath = localPath;
        }
        if ([audioData writeToFile:localPath atomically:YES]) {
            if ([audioURL isEqualToString:currentPlayingUrl]) {
                currentPlayingUrl = audioURL;
                if ([self.audioPlayer isPlaying]) {
                    [self.audioPlayer stopAudio];
                }
                self.audioPlayer = [XHAudioPlayerHelper shareInstance];
                [self.audioPlayer setDelegate:self];
                [self.audioPlayer managerAudioWithFileName:localPath toPlay:YES];
                
                if (tempCommentCell) {
                    if (![tempCommentCell.playRecordImgV isAnimating]) {
                        tempCommentCell.playRecordImgV.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"shengyin1.png"],[UIImage imageNamed:@"shengyin2.png"],[UIImage imageNamed:@"shengyin3.png"], nil];
                        tempCommentCell.playRecordImgV.animationDuration = tempCommentCell.playRecordImgV.animationImages.count*0.15;
                        [tempCommentCell.playRecordImgV startAnimating];
                    }
                }
            }
            
        }
        else
        {
            NSLog(@"%@ write failed",localPath);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)storyClickedTalkingBrowse:(TalkingBrowse *)talkingBrowse
{
    PreviewStoryViewController * pv = [[PreviewStoryViewController alloc] init];
    [pv loadPreviewStoryViewWithDictionary:talkingBrowse];
    [self.navigationController pushViewController:pv animated:YES];
    //    return;
}
-(void)contentImageVClicked:(UITableViewCell *)cell CellType:(int)cellType
{
    BrowserForwardedTalkingTableViewCell * cells = (BrowserForwardedTalkingTableViewCell *)cell;
    
    if ([cells.aniImageV isAnimating]) {
        [cells.aniImageV stopAnimating];
        [cells showPlayBtn];
    }
    if ([self.audioPlayer isPlaying]&&[cells.talking.audioUrl isEqualToString:currentPlayingUrl]) {
        [self stopPlayTimer];
        [self.audioPlayer pausePlayingAudio];
        //        [self.audioPlayer stopAudio];
        cells.currentPlayingUrl = @"";
        [cells showPlayBtn];
    }
    else
    {
        [cells showLoading];
        [self playOrDownloadForCell:cells PlayBtnClicked:YES];
        //        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
        //        NSArray * g = [cells.talking.audioUrl componentsSeparatedByString:@"/"];
        //        NSString *accessorys2 = [[documents stringByAppendingPathComponent:@"Audios"] stringByAppendingPathComponent:[g lastObject]];
        //        if ([self.audioPlayer isPlaying]) {
        //            [self.audioPlayer stopAudio];
        //        }
        //        self.audioPlayer = [XHAudioPlayerHelper shareInstance];
        //        [self.audioPlayer setDelegate:self];
        //        [self.audioPlayer managerAudioWithFileName:accessorys2 toPlay:YES];
        //        //            [cells.aniImageV startAnimating];
        //
        //        if (![cells.aniImageV isAnimating]) {
        //            cells.aniImageV.animationImages = [TFileManager getAllImagesWithID:cells.talking.playAnimationImg.fileName];
        //            cells.aniImageV.animationDuration = cells.aniImageV.animationImages.count*0.15;
        //            [cells.aniImageV startAnimating];
        //        }
        
    }
    
    
    
}

-(void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer
{
    //    if ([currentTable isEqualToString:@"hot"]){
    //    for (int i = 0; i<self.dataArray.count; i++) {
    [btcell reSetProgressViewProgress];
    [self stopPlayTimer];
    NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:0];
    BrowserForwardedTalkingTableViewCell * cell = (BrowserForwardedTalkingTableViewCell *)[self.contentTableView cellForRowAtIndexPath:indexPathTo];
    [cell.aniImageV stopAnimating];
    [cell showPlayBtn];
    cell.currentPlayingUrl = @"";
    [tempCommentCell.playRecordImgV stopAnimating];
    tempCommentCell = nil;
    //    }
    
}

-(void)toPersonProfilePage:(UIButton *)sender
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    [self.navigationController pushViewController:pv animated:YES];
}
#pragma mark 地图相关
-(void)locationWithTalkingBrowse:(TalkingBrowse *)talkingBrowse
{
    MapViewController * mapV = [[MapViewController alloc] init];
    mapV.lat = talkingBrowse.location.lat;
    mapV.lon = talkingBrowse.location.lon;
    mapV.thumbImgUrl = talkingBrowse.thumbImgUrl;
    mapV.contentStr = talkingBrowse.descriptionContent;
    mapV.publisher = talkingBrowse.petInfo.nickname;
    mapV.talking = talkingBrowse;
    [self.navigationController pushViewController:mapV animated:YES];
}
-(void)moreBtnClicked
{
    UIActionSheet * act;
    if ([self.talking.petInfo.petID isEqualToString:[UserServe sharedUserServe].userID]) {
        act= [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除这条动态",@"举报这条动态", nil];
        act.tag = 1;
    }
    else{
        act= [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报这条动态", nil];
        act.tag = 2;
    }
    [act showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1) {
        if (buttonIndex==0) {
            [self deleteAShuoShuo];
        }
        if (buttonIndex==1) {
            //            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            //            [self performSelector:@selector(dismissReportHud) withObject:nil afterDelay:1];
            [self reportShuoShuo];
        }
    }
    else if (actionSheet.tag==2){
        if (buttonIndex==0) {
            //            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            //            [self performSelector:@selector(dismissReportHud) withObject:nil afterDelay:1];
            [self reportShuoShuo];
        }
    }
    else if (actionSheet.tag==3){
        if (buttonIndex==0) {
            [self deleteAComment];
        }
        
    }
}
-(void)reportShuoShuo
{
    NSMutableDictionary* dict = [NetServer commonDict];
    [dict setObject:@"message" forKey:@"command"];
    [dict setObject:@"CUP" forKey:@"options"];
    [dict setObject:self.talking.theID forKey:@"petalkId"];
    if([UserServe sharedUserServe].userID)
    {
        [dict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    }
    
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:self.talking.petInfo.petID forKey:@"reportPetId"];
    [NetServer requestWithParameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"reportSuccess:%@",responseObject);
        [self dismissReportHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络有点问题哦"];
    }];
}
-(void)deleteAShuoShuo
{
    //    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"接口还不好使呢" delegate:self cancelButtonTitle:@"哦" otherButtonTitles: nil];
    //    [alert show];
    //    return;
    [SVProgressHUD showWithStatus:@"删除中..."];
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"petalk" forKey:@"command"];
    [hotDic setObject:@"delete" forKey:@"options"];
    [hotDic setObject:self.talking.theID forKey:@"petalkId"];
    [NetServer requestWithParameters:hotDic Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"delete shuoshuo success info:%@",responseObject);
        if (_delegate&& [_delegate respondsToSelector:@selector(shuoshuoDeletedSuccessWithIndex:)]) {
            
            [self.delegate shuoshuoDeletedSuccessWithIndex:self.talking.theID];
        }
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"delete shuoshuo failed info:%@",error);
        [SVProgressHUD dismiss];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"动态删除失败，一会儿再试试吧" delegate:nil cancelButtonTitle:@"哦" otherButtonTitles: nil];
        [alert show];
        
    }];
}
-(void)deleteAComment
{
    //    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"接口还不好使呢" delegate:self cancelButtonTitle:@"哦" otherButtonTitles: nil];
    //    [alert show];
    //    return;
    [self.audioPlayer stopAudio];
    [SVProgressHUD showWithStatus:@"删除中..."];
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"interaction" forKey:@"command"];
    [hotDic setObject:@"delete" forKey:@"options"];
    [hotDic setObject:self.currentTalkComment.commentId forKey:@"id"];
    [NetServer requestWithParameters:hotDic Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.commentArray removeObjectAtIndex:self.currentTalkCommentIndex];
        //        [self.commentHeightArray removeObjectAtIndex:self.currentTalkCommentIndex];
        [self.contentTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.currentTalkCommentIndex inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
        NSLog(@"delete comment success info:%@",responseObject);
        [SVProgressHUD dismiss];
        
        [self getCommentAndFavorNum];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"delete comment failed info:%@",error);
        [SVProgressHUD dismiss];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论删除失败，一会儿再试试吧" delegate:nil cancelButtonTitle:@"哦" otherButtonTitles: nil];
        [alert show];
    }];
}

-(void)dismissReportHud
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [SVProgressHUD showSuccessWithStatus:@"感谢您的举报，我们会努力做得更好"];
}
-(void)backBtnDo:(UIButton *)sender
{
    //    [self.audioPlayer stopAudio];
    //    self.audioPlayer.delegate = nil;
    //    self.audioPlayer = nil;
    [SVProgressHUD dismiss];
    [tempCommentCell.playRecordImgV stopAnimating];
    tempCommentCell = nil;
    [self stopAudio];
    if (self.shouldDismiss) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self stopAudio];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserServe sharedUserServe].userID) {
        if ([self.talking.petInfo.petID isEqualToString:[UserServe sharedUserServe].userID]) {
            self.canEditComment = YES;
        }
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self cellPlayAni:self.contentTableView];
}


-(void)zanMakeBig
{
    self.bigZanImageV.hidden = NO;
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

@end
