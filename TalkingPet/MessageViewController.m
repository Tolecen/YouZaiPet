//
//  MessageViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-14.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "MessageViewController.h"
#import "MJRefresh.h"
#if TARGET_IPHONE_SIMULATOR

#elif TARGET_OS_IPHONE
#import "amrFileCodec.h"
#endif
@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"消息";
        self.startId = @"";
        self.needRefreshMsg = NO;
        
        sysNoti_page = 1;
    }
    return self;
}
-(void)dealloc
{
    self.notiTableView.header.canEndAnimation = NO;
    self.notiTableView.footer.canEndAnimation = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    //    self.view.backgroundColor = [UIColor whiteColor];
    UIView * uu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight-5)];
    [uu setBackgroundColor:[UIColor whiteColor]];
    [uu setAlpha:0.8];
    
    
    
    self.notiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    _notiTableView.delegate = self;
    _notiTableView.dataSource = self;
    _notiTableView.backgroundView = uu;
    _notiTableView.scrollsToTop = YES;
    _notiTableView.backgroundColor = [UIColor clearColor];
    //    _notiTableView.rowHeight = 90;
//    _notiTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    _notiTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_notiTableView];
    
    [self.notiTableView addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
    //        [self.tableV headerBeginRefreshing];
    [self.notiTableView addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
    
    //    noContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    //    [noContentView setBackgroundColor:[UIColor whiteColor]];
    //    [noContentView setAlpha:0.8];
    //    [self.view addSubview:noContentView];
    g = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 100)];
    [g setText:@"暂时没有消息"];
    [g setBackgroundColor:[UIColor clearColor]];
    [g setTextAlignment:NSTextAlignmentCenter];
    [g setTextColor:[UIColor colorWithRed:0.027 green:0.58 blue:0.757 alpha:1]];
    [self.view addSubview:g];
    
//    [self.view bringSubviewToFront:self.menuBar];
    
    if (self.msgType==MsgTypeC_R) {
        msgTypeStr = @"C_R";
    }
    else if (self.msgType==MsgTypeF){
        msgTypeStr = @"F";
    }
    else if (self.msgType==MsgTypeFans){
        msgTypeStr = @"Fans";
    }
    else if (self.msgType==MsgTypeSys){
        msgTypeStr = @"Sys";
    }
    
    
    NSArray * msgA = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"receivedMsgArray%@%@",msgTypeStr,[UserServe sharedUserServe].userID]];
    if (msgA) {
        self.msgArray = [NSMutableArray arrayWithArray:msgA];
    }
    if (self.msgType==MsgTypeSys) {
        [self getSysNoti];
    }
    else{
        [self getMyMsg];
    }
    // Do any additional setup after loading the view.
    [self buildViewWithSkintype];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (self.needRefreshMsg) {
    if (self.msgType==MsgTypeSys) {
        [self getSysNoti];
    }
    else{
        [self getMyMsg];
    }//        self.needRefreshMsg = NO;
//    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.msgArray&&self.msgArray.count>0) {
        g.hidden = YES;
    }
}
- (void)tableViewHeaderRereshing:(UITableView *)tableView
{
    self.startId = @"";
    
    if (self.msgType==MsgTypeSys) {
        sysNoti_page = 1;
        [self getSysNoti];
    }
    else
    {
        [self getMyMsg];
    }
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
    if (!self.msgArray||self.msgArray.count==0) {
        return;
    }
    if (self.msgType==MsgTypeSys) {
        [self getSysNoti];
    }
    else{
        [self getMyMsg];
    }
}
-(void)endRefreshing:(UITableView *)tableView
{
    //    self.isRefreshing = NO;
    [self.notiTableView footerEndRefreshing];
    [self.notiTableView headerEndRefreshing];
    [self.notiTableView reloadData];
    
}
-(void)getSysNoti
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"announcement" forKey:@"command"];
    [mDict setObject:@"list" forKey:@"options"];
    [mDict setObject:[NSString stringWithFormat:@"%d",sysNoti_page] forKey:@"pageIndex"];
    
    [mDict setObject:@"20" forKey:@"pageSize"];
    //    [mDict setObject:self.searchTF.text forKey:@"keyword"];
    
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (sysNoti_page==1) {
            self.msgArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
            if (self.msgArray.count>0) {
                [[NSUserDefaults standardUserDefaults] setObject:self.msgArray forKey:[NSString stringWithFormat:@"receivedMsgArray%@%@",msgTypeStr,[UserServe sharedUserServe].userID]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        }
        else
        {
            [self.msgArray addObjectsFromArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
        }
        if ([[responseObject objectForKey:@"value"] objectForKey:@"list"]&&[[[responseObject objectForKey:@"value"] objectForKey:@"list"] count]>0) {
            sysNoti_page++;
        }
        if (self.msgArray.count==0) {
            //            self.notiTableView.hidden = YES;
            g.hidden = NO;
        }
        else{
            //            self.notiTableView.hidden = NO;
            g.hidden = YES;
        }
        [self endRefreshing:self.notiTableView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefreshing:self.notiTableView];
    }];
}
-(void)getMyMsg
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"message" forKey:@"command"];
    [mDict setObject:@"UML" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
    if (self.msgType==MsgTypeC_R) {
        [mDict setObject:@"C_R" forKey:@"type"];
    }
    else if (self.msgType==MsgTypeF){
        [mDict setObject:@"F" forKey:@"type"];
    }
    else if (self.msgType==MsgTypeFans){
        [mDict setObject:@"fans" forKey:@"type"];
    }
    if (![self.startId isEqualToString:@""]) {
        [mDict setObject:self.startId forKey:@"startId"];
    }
    
    [mDict setObject:@"20" forKey:@"pageSize"];
    //    [mDict setObject:self.searchTF.text forKey:@"keyword"];
    
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self.startId isEqualToString:@""]) {
            self.msgArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"value"]];
            if (self.msgArray.count>0) {
                [[NSUserDefaults standardUserDefaults] setObject:self.msgArray forKey:[NSString stringWithFormat:@"receivedMsgArray%@%@",msgTypeStr,[UserServe sharedUserServe].userID]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        }
        else
        {
            [self.msgArray addObjectsFromArray:[responseObject objectForKey:@"value"]];
        }
        if (self.msgArray&&self.msgArray.count>0) {
            self.startId = [[self.msgArray lastObject] objectForKey:@"id"];
        }
        if (self.msgArray.count==0) {
            //            self.notiTableView.hidden = YES;
            g.hidden = NO;
        }
        else{
            //            self.notiTableView.hidden = NO;
            g.hidden = YES;
        }
        [self endRefreshing:self.notiTableView];
        //            self.tagArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
        //        [self.notiTableView reloadData];
        
        
        //            [self cellPlayAni:self.tableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefreshing:self.notiTableView];
        //            NSLog(@"get hot shuoshuo failed error:%@",error);
        //            [self endHeaderRefreshing:self.tableV];
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.msgType==MsgTypeSys) {
        return [NotificationTableViewCell heightForRowWithSysNoti:self.msgArray[indexPath.row]];
    }
    return [NotificationTableViewCell heightForRowWithComment:self.msgArray[indexPath.row]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"talkingCell";
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    if (self.msgType==MsgTypeSys) {
        cell.notiStyle = notiStyleSystem;
    }
    cell.notiDict = self.msgArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dict = [self.msgArray objectAtIndex:indexPath.row];
    if (self.msgType==MsgTypeSys) {
        WXRTextViewController * controller = [[WXRTextViewController alloc] init];
        controller.title = [[self.msgArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        controller.content = [[self.msgArray objectAtIndex:indexPath.row] objectForKey:@"content"];

        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    if ([[dict objectForKey:@"type"] isEqualToString:@"R"]||[[dict objectForKey:@"type"] isEqualToString:@"F"]||[[dict objectForKey:@"type"] isEqualToString:@"C"]) {
        TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
        TalkingBrowse * tb = [[TalkingBrowse alloc] init];
        tb.theID = [dict objectForKey:@"petalkId"];
        talkingDV.talking = tb;
        if ([dict objectForKey:@"petId"]&&[dict objectForKey:@"petNickName"]) {
            talkingDV.commentStyle = commentStyleComment;
            talkingDV.replyToId = [dict objectForKey:@"petId"];
            talkingDV.replyToName = [dict objectForKey:@"petNickName"];
        }
        [self.navigationController pushViewController:talkingDV animated:YES];
    }
    else if ([[dict objectForKey:@"type"] isEqualToString:@"fans"])
    {
        PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
        pv.petId = [dict objectForKey:@"petId"];
        [self.navigationController pushViewController:pv animated:YES];
    }
    
}
-(void)commentPublisherBtnClicked:(TalkComment *)talkingCommentN
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingCommentN.petID;
    [self.navigationController pushViewController:pv animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)commentPlayAudioBtnClicked:(TalkComment *)talkingCommentN Cell:(id)cell
{
    int oo = 0;
    NotificationTableViewCell * cella = (NotificationTableViewCell *)cell;
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
    NSArray * gs = [talkingCommentN.audioUrl componentsSeparatedByString:@"/"];
    NSString *accessorys2 = [[documents stringByAppendingPathComponent:@"Audios"] stringByAppendingPathComponent:[gs lastObject]];
    
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
    //    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (self.audioPlayer) {
        [self.audioPlayer stopAudio];
        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
    }
    
}
-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
