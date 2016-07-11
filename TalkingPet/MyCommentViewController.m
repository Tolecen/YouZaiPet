//
//  MyCommentViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14/12/11.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "MyCommentViewController.h"
#import "BrowseTalkingTableViewCell.h"
#import "BrowserForwardedTalkingTableViewCell.h"
#import "TalkingDetailPageViewController.h"
#import "EGOImageView.h"
#import "NewUserViewController.h"
#import "UserListViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ShareServe.h"
#import "OHAttributedLabel.h"
#import "WebContentViewController.h"
#import "RootViewController.h"
#import "NSString+Base64.h"
#import "BlankPageView.h"

#if TARGET_IPHONE_SIMULATOR

#elif TARGET_OS_IPHONE
#import "amrFileCodec.h"
#endif
@interface CommentCell : UITableViewCell<TalkingTableViewCellDelegate,OHAttributedLabelDelegate>
{
    UIButton * deleteB;
    UIView * lineV;
}
@property (nonatomic,retain)UIImageView * stateIV;
@property (nonatomic,retain)UILabel * commentL;
@property (nonatomic,retain)UILabel * timeL;
@property (nonatomic,retain)TalkComment * talkingComment;
@property (nonatomic,strong) UIButton * playRecordBtn;
@property (nonatomic,strong) UIButton * deleteCommentBtn;
@property (nonatomic,strong) UIImageView * playRecordImgV;
@property (nonatomic,strong) UILabel * recordDurationLabel;
@property (nonatomic,assign) NSInteger cellIndex;
@property (nonatomic,strong) EGOImageView * thumbImageV;
@property (nonatomic,strong) UIView * bgImageV;
@property (nonatomic,assign) id<TalkingTableViewCellDelegate> delegate;

+(CGFloat)heightForRowWithComment:(TalkComment *)comment;
@end
@implementation CommentCell
+(CGFloat)heightForRowWithComment:(TalkComment *)comment
{
    float cellHeight = 0;
    
    CGSize commentSize = [comment.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-80, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    if ([comment.contentType isEqualToString:@"AUDIO"]) {
        
        cellHeight = 15+20+5+22+5+20+5;
    }
    
    else
    {
        cellHeight = 15+commentSize.height+5+20+5;
    }
    return cellHeight;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
//        self.bgImageV = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 63)];
//        self.bgImageV.backgroundColor = [UIColor whiteColor];
//        self.bgImageV.alpha = 0.3;
//        [self.contentView addSubview:self.bgImageV];
        
        self.commentL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 240, 20)];
//        self.commentL.linkUnderlineStyle = kCTUnderlineStyleNone;
        [self.commentL setFont:[UIFont systemFontOfSize:14]];
        self.commentL.numberOfLines = 0;
        [self.commentL setLineBreakMode:NSLineBreakByWordWrapping];
        self.commentL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        _commentL.text = @"评论@Gay哎呦，不错";
        [self.contentView addSubview:_commentL];
        [self.commentL setBackgroundColor:[UIColor clearColor]];
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
        
        self.thumbImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(ScreenWidth-15-40, 15, 40, 40)];
        self.thumbImageV.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.thumbImageV];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 120, 20)];
        _timeL.text = @"今天12：01";
        _timeL.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        _timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeL];
        _timeL.backgroundColor = [UIColor clearColor];
        
        self.deleteCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteCommentBtn.frame = CGRectMake(110, 45, 11, 13);
        [self.deleteCommentBtn setBackgroundImage:[UIImage imageNamed:@"delete_normal"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteCommentBtn];
        [self.deleteCommentBtn addTarget:self action:@selector(deleteComment) forControlEvents:UIControlEventTouchUpInside];
        
        //        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 320, 1)];
        //        lineV.backgroundColor = [UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1];
        //        [self.contentView addSubview:lineV];
        lineV = [[UIView alloc] initWithFrame:CGRectMake(10, self.talkingComment.cHeight-1, ScreenWidth-10, 1)];
        [lineV setBackgroundColor:[UIColor colorWithWhite:230/255.0f alpha:1]];
        [self.contentView addSubview:lineV];
        
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.thumbImageV.imageURL = [NSURL URLWithString:self.talkingComment.talkThumbnail];
    
    //    self.commentNameL.text = self.talkingComment.petNickname;
    //    self.commentAvatarV.imageURL = [NSURL URLWithString:self.talkingComment.petAvatarURL];
    
    //        }
    
    //    }
    //    else
    //        commentContent = self.talkingComment.content;
    
    //    self.commentL.text = self.talkingComment.content;
    
    self.timeL.text = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:self.talkingComment.usercenterCommentTime];
    
    
    
    CGSize commentSize = [self.talkingComment.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-80, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    CGSize timeSize = [self.timeL.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(120, 20)];
    //    NSLog(@"content222:%@,hhhhhhh22222:%f",self.commentL.text,commentSize.height);
    [self.commentL setFrame:CGRectMake(self.commentL.frame.origin.x, self.commentL.frame.origin.y, commentSize.width, commentSize.height)];
    self.commentL.text = self.talkingComment.content;
//    self.commentL.backgroundColor = [UIColor redColor];
    if ([self.talkingComment.contentType isEqualToString:@"AUDIO"]) {
        //        if (self.talkingComment.haveAimPet) {
        //            self.commentL.hidden = NO;
        //            [self.commentL setFrame:CGRectMake(self.commentL.frame.origin.x, self.commentL.frame.origin.y, commentSize.width, 20)];
        //        self.commentL.backgroundColor = [UIColor redColor];
        [self.playRecordBtn setFrame:CGRectMake(self.commentL.frame.origin.x, self.commentL.frame.origin.y+commentSize.height+5, 86, 22)];
        //        }
        //        else {
        ////            self.commentL.hidden = YES;
        //            [self.playRecordBtn setFrame:CGRectMake(70, 39, 86, 22)];
        //        }
        [self.timeL setFrame:CGRectMake(15, self.commentL.frame.origin.y+25+22+5, 120, 20)];
        self.playRecordBtn.hidden = NO;
        self.recordDurationLabel.text = [self.talkingComment.audioDuration stringByAppendingString:@"s"];
        
        //        [self.bgImageV setFrame:CGRectMake(5, 5, 310, self.timeL.frame.origin.y+20+13)];
    }
    else
    {
        [self.commentL setFrame:CGRectMake(self.commentL.frame.origin.x, self.commentL.frame.origin.y, commentSize.width, commentSize.height)];
        [self.timeL setFrame:CGRectMake(15, self.commentL.frame.origin.y+commentSize.height+5, 120, 20)];
        //        self.commentL.hidden = NO;
        self.playRecordBtn.hidden = YES;
    }
    [self.deleteCommentBtn setFrame:CGRectMake(15+timeSize.width+10, self.timeL.frame.origin.y+4, 11, 13)];
//    [self.bgImageV setFrame:CGRectMake(5, 5, ScreenWidth-10, self.timeL.frame.origin.y+20+3)];
    
    [lineV setFrame:CGRectMake(10, 5+self.timeL.frame.origin.y+20+3-1, ScreenWidth-10, 1)];
    
    
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
    return [UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1];
}

-(void)playRecordBtnClicked:(UIButton *)sender
{
    if (_delegate&& [_delegate respondsToSelector:@selector(commentPlayAudioBtnClicked:Cell:)]) {
        [_delegate commentPlayAudioBtnClicked:self.talkingComment Cell:self];
    }
    
}
-(void)deleteComment
{
    if (_delegate&& [_delegate respondsToSelector:@selector(deleteCommentBtnClicked:CellIndex:)]) {
        [_delegate deleteCommentBtnClicked:self.talkingComment CellIndex:self.cellIndex];
    }
    
}
@end

@interface MyCommentViewController ()<UITableViewDataSource,UITableViewDelegate,TalkingTableViewCellDelegate>
{
    CommentCell * tempCommentCell;
    BlankPageView * blankPage;
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * commentArray;
@property (nonatomic, strong)TalkComment * waitingDeleteCommnet;
@property (nonatomic, assign)NSInteger waitingDeleteIndex;
@end

@implementation MyCommentViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的评论";
        self.commentArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    [self buildViewWithSkintype];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
//    _tableView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
//    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 35;
    [_tableView addHeaderWithTarget:self action:@selector(getMyComment)];
    [_tableView addFooterWithTarget:self action:@selector(loadMore)];
    [_tableView headerBeginRefreshing];
    
// Do any additional setup after loading the view.
}
-(void)getMyComment
{

    _tableView.delegate = self;
    _tableView.dataSource = self;
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"userList" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
    if ([UserServe sharedUserServe].userID) {
        [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    }
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:@"C" forKey:@"type"];
    
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.commentArray = [self getModelArray:[responseObject objectForKey:@"value"]];
        [_tableView reloadData];
        [self.tableView headerEndRefreshing];
        if (!_commentArray.count) {
            if (!blankPage) {
                __weak UINavigationController * weakNav = self.navigationController;
                blankPage = [[BlankPageView alloc] init];
                [blankPage showWithView:self.view image:[UIImage imageNamed:@"myComment_without"] buttonImage:[UIImage imageNamed:@"myComment_toCom"] action:^{
                    [weakNav popToRootViewControllerAnimated:YES];
                }];
            }
        }
        else if(blankPage){
            [blankPage removeFromSuperview];
            blankPage = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get hot shuoshuo failed error:%@",error);
        [self.tableView headerEndRefreshing];
        //        [self endHeaderRefreshing:self.tableV];
    }];
    
}
-(void)loadMore
{
    if (!self.commentArray || self.commentArray.count<=0) {
        [self.tableView footerEndRefreshing];
        return;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"userList" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
    if ([UserServe sharedUserServe].userID) {
        [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    }
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:@"C" forKey:@"type"];
    TalkComment * tk = [self.commentArray lastObject];
    [mDict setObject:tk.commentId forKey:@"id"];
    
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.commentArray addObjectsFromArray:[self getModelArray:[responseObject objectForKey:@"value"]]];
//        self.tableviewHelpeer.isRefreshing = NO;
        [self.tableView footerEndRefreshing];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get hot shuoshuo failed error:%@",error);
//        self.tableviewHelpeer.isRefreshing = NO;
        [self.tableView footerEndRefreshing];
        //        [self endHeaderRefreshing:self.tableV];
    }];
    
}

-(NSMutableArray *)getModelArray:(NSArray *)array
{
    NSMutableArray * hArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        TalkComment * talking = [[TalkComment alloc] initWithHostInfo:[array objectAtIndex:i]];
        [hArray addObject:talking];
    }
    return hArray;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.commentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CommentCellIdentifier = @"CommentCell";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier ];
        if (cell == nil) {
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CommentCellIdentifier];
            cell.delegate = self;
        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellIndex = indexPath.row;
        cell.talkingComment = self.commentArray[indexPath.row];
        return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        return [CommentCell heightForRowWithComment:self.commentArray[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    //    talkingDV.commentStyle = commentStyleComment;
    TalkComment * tk = [self.commentArray objectAtIndex:indexPath.row];
    talkingDV.talking = tk.talking;
    [self.navigationController pushViewController:talkingDV animated:YES];
}
-(void)commentAimUserNameClicked:(TalkComment *)talkingCommentN Link:(NSTextCheckingResult *)linkInfo
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingCommentN.aimPetID;
    //    pv.petAvatarUrlStr = talkingCommentN.petAvatarURL;
    pv.petNickname = talkingCommentN.aimPetNickname;
    [self.navigationController pushViewController:pv animated:YES];
}
-(void)deleteCommentBtnClicked:(TalkComment *)talkingCommentN CellIndex:(NSInteger)cellIndex
{
    self.waitingDeleteCommnet = talkingCommentN;
    self.waitingDeleteIndex = cellIndex;
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除这条评论么？" delegate:self cancelButtonTitle:@"点错了" otherButtonTitles:@"删除", nil];
    alert.tag = 236;
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==236) {
        if (buttonIndex==1) {
            [self sureToDeleteComment];
        }
    }
}
-(void)sureToDeleteComment
{
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"interaction" forKey:@"command"];
    [hotDic setObject:@"delete" forKey:@"options"];
    [hotDic setObject:self.waitingDeleteCommnet.commentId forKey:@"id"];
    [NetServer requestWithParameters:hotDic Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.commentArray removeObjectAtIndex:self.waitingDeleteIndex];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.waitingDeleteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView reloadData];
        NSLog(@"delete comment success info:%@",responseObject);
        [self.audioPlayer stopAudio];
//        [self getCountNum];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"delete comment failed info:%@",error);
    }];
}

-(void)commentPlayAudioBtnClicked:(TalkComment *)talkingCommentN Cell:(id)cell
{
    int oo = 0;
    CommentCell * cella = (CommentCell *)cell;
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
-(void)getAudioFromNet:(NSString *)audioURL LocalPath:(NSString *)localPath Type:(int)type
{
    
    [NetServer downloadAudioFileWithURL:audioURL TheController:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString  *localRecordPath = [NSString stringWithFormat:@"%@/%@.caf",rootRecordPath,audioID];
        //        NSData *  wavData = DecodeAMRToWAVE(responseObject);
        
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

-(void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer
{
    [tempCommentCell.playRecordImgV stopAnimating];
    tempCommentCell = nil;
}

-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [self.audioPlayer stopAudio];
    self.audioPlayer.delegate = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
