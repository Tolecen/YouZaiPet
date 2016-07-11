//
//  ChatDetailViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14/12/30.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ChatDetailViewController.h"

#import "NetServer.h"
#if TARGET_IPHONE_SIMULATOR

#elif TARGET_OS_IPHONE
#import "amrFileCodec.h"
#endif
@interface ChatDetailViewController ()

@end

@implementation ChatDetailViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.audioPlayer stopAudio];
    self.audioPlayer.delegate = nil;
    [SystemServer sharedSystemServer].currentTalkingPet = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 0;
    canSendMsg = YES;
//    self.view.userInteractionEnabled = YES;
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    [self setRightButtonWithName:nil BackgroundImg:@"morebtn" Target:@selector(moreBtnClicked)];
    [self buildViewWithSkintype];
    currentPlayingMsgId = @"";
    self.taId = @"173";
    self.chatArray = [NSMutableArray array];
    [self.chatArray addObjectsFromArray:[DatabaseServe getDetailMsgArrayByPage:0 PetId:self.thePet.petID]];
    
//    UIView * bgvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//    [bgvv setBackgroundColor:[UIColor whiteColor]];
//    [bgvv setAlpha:0.22];
    
//    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chatPage_bg"]];
    
    self.msgTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight-50) style:UITableViewStylePlain];
    self.msgTableV.delegate = self;
    self.msgTableV.dataSource = self;
    self.msgTableV.backgroundColor = [UIColor clearColor];
    self.msgTableV.backgroundView = nil;
    self.msgTableV.scrollsToTop = YES;
//    self.msgTableV.backgroundColor = [UIColor clearColor];
    self.msgTableV.rowHeight = 60;
    self.msgTableV.showsVerticalScrollIndicator = NO;
    self.msgTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.msgTableV];
    
    self.refresh = [[UIRefreshControl alloc]init];
    //刷新图形颜色
    self.refresh.tintColor = [UIColor whiteColor];
    //刷新的标题
//    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    
    // UIRefreshControl 会触发一个UIControlEventValueChanged事件，通过监听这个事件，我们就可以进行类似数据请求的操作了
    [self.refresh addTarget:self action:@selector(refreshTableviewAction) forControlEvents:UIControlEventValueChanged];
    [self.msgTableV addSubview:self.refresh];
    
    
    self.inputView = [[InputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-navigationBarHeight-50-50, ScreenWidth, 50) BaseView:self.view Type:2];
    [self.view addSubview:self.inputView];
    self.inputView.viewH = self.view.frame.size.height;
    self.inputView.naviH = navigationBarHeight;
    [self.inputView setFrame:CGRectMake(0, self.view.frame.size.height-navigationBarHeight-50, ScreenWidth, 50)];
    self.inputView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalChatMsgReceived:) name:@"NormalChatMsgReceived" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalChatMsgSended:) name:@"NormalChatMsgSended" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalChatMsgFailed:) name:@"NormalChatMsgFailed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalChatMsgFileStatusChanged:) name:@"NormalChatMsgFileStatusChanged" object:nil];
    
    [self checkIfCanSendMsg];
    if (self.chatArray.count>0) {
        [self.msgTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    copyItem = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyMsg)];
    copyItem2 = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(deleteMsg)];
    menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:@[]];
    
    long yyy = [[NSDate date] timeIntervalSince1970]*1000;
    NSLog(@"current time :%ld",yyy);
    [SystemServer sharedSystemServer].currentTalkingPet = self.thePet.petID;
    
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 75, 32)];
    self.menuView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.menuView];
    self.bgvc = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 32)];
    [self.bgvc setImage:[UIImage imageNamed:@"chat_menu"]];
    [self.menuView addSubview:self.bgvc];
    self.msgCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.msgCopyBtn setBackgroundColor:[UIColor clearColor]];
    [self.msgCopyBtn setFrame:CGRectMake(0, 0, 38, 28)];
    [self.msgCopyBtn setTitle:@"复制" forState:UIControlStateNormal];
    [self.msgCopyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.msgCopyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.msgCopyBtn addTarget:self action:@selector(copyMsg) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:self.msgCopyBtn];
    
    self.msgMenuLineV = [[UIView alloc] initWithFrame:CGRectMake(37, 5, 1, 18)];
    [self.msgMenuLineV setBackgroundColor:[UIColor whiteColor]];
    [self.menuView addSubview:self.msgMenuLineV];
    
    self.MsgDelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.MsgDelBtn setBackgroundColor:[UIColor clearColor]];
    [self.MsgDelBtn setFrame:CGRectMake(38, 0, 38, 28)];
    [self.MsgDelBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.MsgDelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.MsgDelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.MsgDelBtn addTarget:self action:@selector(deleteMsg) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:self.MsgDelBtn];
    
    self.menuView.hidden = YES;
    
    self.cannotSendV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [self.cannotSendV setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    [self.cannotSendV setText:@"对不起，由于对方权限设置，您不能给对方发送消息"];
    [self.cannotSendV setTextAlignment:NSTextAlignmentCenter];
    [self.cannotSendV setTextColor:[UIColor grayColor]];
    [self.cannotSendV setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:self.cannotSendV];
    self.cannotSendV.hidden = YES;
//    [self.inputView showInputViewWithAudioBtn:YES];
    // Do any additional setup after loading the view.
}
-(void)refreshTableviewAction
{
    currentPage++;
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.8];
    NSLog(@"dioooo");
}
-(void)loadMore
{
//    [self.chatArray addObjectsFromArray:[DatabaseServe getDetailMsgArrayByPage:currentPage PetId:self.thePet.petID]];
    NSArray * sd = [DatabaseServe getDetailMsgArrayByPage:currentPage PetId:self.thePet.petID];
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[sd count])];
    [self.chatArray insertObjects:sd atIndexes:indexes];
    
    NSMutableArray * uu = [NSMutableArray array];
    for (int i = 0; i<sd.count; i++) {
        NSIndexPath * indexP = [NSIndexPath indexPathForRow:i inSection:0];
        [uu insertObject:indexP atIndex:0];
    }
    
    [self.msgTableV insertRowsAtIndexPaths:uu withRowAnimation:UITableViewRowAnimationNone];
//    [self.msgTableV scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndex:sd.count] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.refresh endRefreshing];
}
-(void)normalChatMsgSended:(NSNotification *)noti
{
    for (int i = 0; i<self.chatArray.count; i++) {
        ChatMsg * chatMsg = self.chatArray[i];
        if (chatMsg.tagId == [noti.object longValue]) {
            
            chatMsg.status = @"success";
            [self.chatArray replaceObjectAtIndex:i withObject:chatMsg];
            break;
        }

    }
    [self.msgTableV reloadData];
}
-(void)normalChatMsgFailed:(NSNotification *)noti
{
    for (int i = 0; i<self.chatArray.count; i++) {
        ChatMsg * chatMsg = self.chatArray[i];
        if (chatMsg.tagId == [noti.object longValue]) {
            
            chatMsg.status = @"failed";
            [self.chatArray replaceObjectAtIndex:i withObject:chatMsg];
            break;
        }
        
    }
    [self.msgTableV reloadData];

}
-(void)normalChatMsgFileStatusChanged:(NSNotification *)noti
{
    NSDictionary * fileDict = noti.object;
    for (int i = 0; i<self.chatArray.count; i++) {
        ChatMsg * chatMsg = self.chatArray[i];
        if ([chatMsg.msgid isEqualToString:[fileDict objectForKey:@"msgId"]]) {
            chatMsg.content = [fileDict objectForKey:@"path"];
            [self.chatArray replaceObjectAtIndex:i withObject:chatMsg];
            break;
        }
        
    }
    [self.msgTableV reloadData];
}
-(void)getUserInfoById
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"pet" forKey:@"command"];
    [mDict setObject:@"one" forKey:@"options"];
    [mDict setObject:self.thePet.petID forKey:@"petId"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"currPetId"];
    
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!self.thePet) {
            self.thePet = [[Pet alloc] init];
        }
        self.thePet.petID = [[responseObject objectForKey:@"value"] objectForKey:@"id"];
        self.thePet.nickname = [[responseObject objectForKey:@"value"] objectForKey:@"nickName"];
        self.thePet.headImgURL = [[responseObject objectForKey:@"value"] objectForKey:@"headPortrait"];
        self.title = self.thePet.nickname;
        [DatabaseServe saveMsgPetInfo:self.thePet];
//        [self checkIfCanSendMsg];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self checkIfCanSendMsg];
    }];
}
-(void)checkIfCanSendMsg
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"setting" forKey:@"command"];
    [mDict setObject:@"CCT" forKey:@"options"];
    [mDict setObject:self.thePet.petID forKey:@"petId"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"currPetId"];
    
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[[responseObject objectForKey:@"value"] objectForKey:@"black"] isEqualToString:@"true"]) {
            inMyBlackList = YES;
            self.cannotSendV.text = @"对方在您的黑名单里，您将收不到他的消息";
            self.cannotSendV.hidden = NO;
            [DatabaseServe AddPetToChatBlackList:self.thePet.petID];
        }
        else{
            inMyBlackList = NO;
            self.cannotSendV.hidden = YES;
            [DatabaseServe removePetFromChatBlackList:self.thePet.petID];
        }
        if ([[[responseObject objectForKey:@"value"] objectForKey:@"chat"] isEqualToString:@"true"]) {
            canSendMsg = YES;
        }
        else{
            canSendMsg = NO;
            self.cannotSendV.text = @"对不起，由于对方权限设置，您不能给对方发送消息";
            self.cannotSendV.hidden = NO;
        }
        
        [self getUserInfoById];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self getUserInfoById];
    }];
}

-(void)normalChatMsgReceived:(NSNotification *)noti
{
    ChatMsg * reveicedMsg = noti.object;
    if ([reveicedMsg.fromid isEqualToString:self.thePet.petID]) {
        [self.chatArray addObject:reveicedMsg];
        [self.msgTableV reloadData];
        [DatabaseServe setUnreadCount:0 petId:self.thePet.petID];
        if ([self.delegate respondsToSelector:@selector(setUnreadCountForPet:UnreadCount:)]) {
            [self.delegate setUnreadCountForPet:self.thePet.petID UnreadCount:0];
        }
        if (self.chatArray.count>0) {
            [self.msgTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.inputView.viewH = self.view.frame.size.height;
//    [self.inputView setFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
}
-(void)viewDidAppear:(BOOL)animated
{
    [DatabaseServe setUnreadCount:0 petId:self.thePet.petID];
    inMyBlackList = [DatabaseServe ifThisPetInMyBlackList:self.thePet.petID];
    if ([self.delegate respondsToSelector:@selector(setUnreadCountForPet:UnreadCount:)]) {
        [self.delegate setUnreadCountForPet:self.thePet.petID UnreadCount:0];
    }
    if(![[SystemServer sharedSystemServer].chatClient isAuthed])// 判断是否连接服务器
    {
        [SVProgressHUD showErrorWithStatus:@"聊天服务还没有连接呢，稍后再试吧"];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.menuView.hidden = YES;
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL needShowTime = NO;
    ChatMsg * chatMsg = [self.chatArray objectAtIndex:indexPath.row];
    
    if (indexPath.row>0) {
        ChatMsg * lastMsg = [self.chatArray objectAtIndex:indexPath.row-1];
//        NSLog(@"mmmm:%ld",chatMsg.date-lastMsg.date);
        if (chatMsg.date-lastMsg.date<60) {
            needShowTime = NO;
        }
        else
        {
            needShowTime = YES;
        }
    }
    else
        needShowTime = YES;
    return [ChatDetailTableViewCell heightForRowWithMsg:chatMsg showTime:needShowTime];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"chatDetailCell";
    ChatDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[ChatDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.chatMsg = self.chatArray[indexPath.row];
    cell.cellIndex = (int)indexPath.row;
    cell.taAvatarUrl = self.thePet.headImgURL;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row>0) {
        ChatMsg * lastMsg = [self.chatArray objectAtIndex:indexPath.row-1];
//        NSLog(@"mmmm:%ld",cell.chatMsg.date-lastMsg.date);
        if (cell.chatMsg.date-lastMsg.date<60) {
            cell.needShowTime = NO;
        }
        else
        {
            cell.needShowTime = YES;
        }
    }
    else
        cell.needShowTime = YES;
    return cell;
}
-(void)inputViewDidChangeHeightWithOriginY:(float)oy
{
    [self.msgTableV setFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-oy)];
    if (self.chatArray.count>0) {
        [self.msgTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
-(void)inputViewDidResignActive
{
    [self.msgTableV setFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-self.inputView.frame.size.height)];
}
- (void)didSendTextAction:(NSString *)text
{
    if (!canSendMsg) {
        [SVProgressHUD showErrorWithStatus:@"对不起，您不能给对方发送消息"];
        return;
    }
    if([[SystemServer sharedSystemServer].chatClient isAuthed])// 判断是否连接服务器
    {
        CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
        
        long msgTagId = arc4random();
        
        ChatMsg *msg=[[ChatMsg alloc] init];
        msg.isMe=YES;
        msg.content=text;
        msg.tagId = msgTagId;
        msg.msgid = cfuuidString;
        msg.fromid = self.thePet.petID;
        msg.type = MSG_TYPE_TEXT;
        msg.status = @"sending";
        NSDate* date = [NSDate date];
        double timeSp=[date timeIntervalSince1970];
        msg.date=timeSp;
        [self.chatArray addObject:msg];
        [self.msgTableV reloadData];
        [DatabaseServe saveNormalChatMsg:msg];
        self.inputView.textView.text=@"";
        if (self.chatArray.count>0) {
            [self.msgTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgAdded" object:msg userInfo:nil];
        
        [[SystemServer sharedSystemServer].chatClient  sendMessage:[NSString stringWithFormat:@"%@@%@",self.thePet.petID,DomainName]  content:text targetType:SINGLECHAT tag:msgTagId msgId:cfuuidString];

    }
    else{
        [SVProgressHUD showErrorWithStatus:@"网络有点问题哦，稍后再试吧"];
    }
}
- (void)didAudioDataRecorded:(NSData *)audioData WithDuration:(NSString *)theDuration AudioPath:(NSString *)audioPath
{
    if (!canSendMsg) {
        [SVProgressHUD showErrorWithStatus:@"对不起，您不能给对方发送消息"];
        return;
    }

    if([[SystemServer sharedSystemServer].chatClient isAuthed])// 判断是否连接服务器
    {
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    
//    NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *subdirectoryw = [documentsw stringByAppendingPathComponent:@"ChatFiles"];
    
    NSLog(@"local path :%@",audioPath);

    long msgTagId = arc4random();
    
    ChatMsg *msg=[[ChatMsg alloc] init];
    msg.isMe=YES;
    msg.tagId = msgTagId;
    msg.content=audioPath;
    msg.contentLength = theDuration;
    msg.msgid = cfuuidString;
    msg.fromid = self.thePet.petID;
    msg.type = MSG_TYPE_AUDIO;
    msg.status = @"sending";
    NSDate* date = [NSDate date];
    double timeSp=[date timeIntervalSince1970];
    msg.date=timeSp;
    [self.chatArray addObject:msg];
    [self.msgTableV reloadData];
    [DatabaseServe saveNormalChatMsg:msg];
    self.inputView.textView.text=@"";
    if (self.chatArray.count>0) {
        [self.msgTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgAdded" object:msg userInfo:nil];
    
    [[SystemServer sharedSystemServer].chatClient sendAudioData:audioData attrs:nil withName:@"chat.amr" toid:[NSString stringWithFormat:@"%@@%@",self.thePet.petID,DomainName] targetType:SINGLECHAT during:[theDuration intValue] tag:msgTagId msgId:cfuuidString];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"网络有点问题哦，稍后再试吧"];
    }

}
-(void)resendMsg:(ChatMsg *)chatMsg index:(int)index
{
    NSLog(@"sss:^%@",chatMsg.content);
    if (!canSendMsg) {
        [SVProgressHUD showErrorWithStatus:@"对不起，您不能给对方发送消息"];
        return;
    }

    if ([chatMsg.type isEqualToString:MSG_TYPE_TEXT]) {
        if([[SystemServer sharedSystemServer].chatClient isAuthed])// 判断是否连接服务器
        {
//            CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
//            NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
            
            long msgTagId = arc4random();
            
//            ChatMsg *msg=[[ChatMsg alloc] init];
//            msg.isMe=YES;
//            msg.content=text;
            chatMsg.tagId = msgTagId;
//            chatMsg.msgid = cfuuidString;
//            msg.fromid = self.thePet.petID;
//            msg.type = MSG_TYPE_TEXT;
            chatMsg.status = @"sending";
            NSDate* date = [NSDate date];
            double timeSp=[date timeIntervalSince1970];
            chatMsg.date=timeSp;
            [self.chatArray replaceObjectAtIndex:index withObject:chatMsg];
            [self.msgTableV reloadData];
            [DatabaseServe saveNormalChatMsg:chatMsg];
            self.inputView.textView.text=@"";
            if (self.chatArray.count>0) {
//                [self.msgTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgAdded" object:msg userInfo:nil];
            
            [[SystemServer sharedSystemServer].chatClient  sendMessage:[NSString stringWithFormat:@"%@@%@",self.thePet.petID,DomainName]  content:chatMsg.content targetType:SINGLECHAT tag:msgTagId msgId:chatMsg.msgid];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"网络有点问题哦，稍后再试吧"];
        }

    }
    else if ([chatMsg.type isEqualToString:MSG_TYPE_AUDIO]){
        if([[SystemServer sharedSystemServer].chatClient isAuthed])// 判断是否连接服务器
        {
//            CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
//            NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
            
            //    NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
            //    NSString *subdirectoryw = [documentsw stringByAppendingPathComponent:@"ChatFiles"];
            
//            NSLog(@"local path :%@",audioPath);

            
            
            long msgTagId = arc4random();
            
//            ChatMsg *msg=[[ChatMsg alloc] init];
//            msg.isMe=YES;
            chatMsg.tagId = msgTagId;
//            msg.content=audioPath;
//            msg.contentLength = theDuration;
//            msg.msgid = cfuuidString;
//            msg.fromid = self.thePet.petID;
//            msg.type = MSG_TYPE_AUDIO;
            chatMsg.status = @"sending";
            NSDate* date = [NSDate date];
            double timeSp=[date timeIntervalSince1970];
            chatMsg.date=timeSp;
            [self.chatArray replaceObjectAtIndex:index withObject:chatMsg];
            [self.msgTableV reloadData];
            [DatabaseServe saveNormalChatMsg:chatMsg];
            self.inputView.textView.text=@"";
            if (self.chatArray.count>0) {
//                [self.msgTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgAdded" object:msg userInfo:nil];
            NSString * audioPath = chatMsg.content;
            if (![audioPath hasPrefix:@"http"]) {
                NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
                
                
                NSString * audioFileName = [[audioPath componentsSeparatedByString:@"/"] lastObject];
                NSString *localAudioPath = [documents stringByAppendingPathComponent:audioFileName];
                NSData * originData = [NSData dataWithContentsOfFile:localAudioPath];
                
                NSData * data1 = nil;
#if TARGET_IPHONE_SIMULATOR
                
#elif TARGET_OS_IPHONE
//                NSData * data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:audioPath]];
//                NSLog(@"LENGTH:%d",[data length]);
                
                //待上传的dada1
                data1 =EncodeWAVEToAMR(originData,1,16);
//                NSLog(@"LENGTH2:%d",[data1 length]);

#endif
                
                //                NSData * audioData =
                if (!data1) {
                    return;
                }
                [[SystemServer sharedSystemServer].chatClient sendAudioData:data1 attrs:nil withName:@"chat.amr" toid:[NSString stringWithFormat:@"%@@%@",self.thePet.petID,DomainName] targetType:SINGLECHAT during:[chatMsg.contentLength intValue] tag:msgTagId msgId:chatMsg.msgid];
            }
            else
            {
                [[SystemServer sharedSystemServer].chatClient  sendMessage:[NSString stringWithFormat:@"%@@%@",self.thePet.petID,DomainName]  content:chatMsg.content targetType:SINGLECHAT tag:msgTagId msgId:chatMsg.msgid];
            }
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"网络有点问题哦，稍后再试吧"];
        }
        

    }
}
-(void)longPressed:(id)cell Index:(int)index
{
    self.menuView.hidden = NO;
    ChatDetailTableViewCell * ucell = (ChatDetailTableViewCell *)cell;
    CGRect rect = [self.view convertRect:ucell.bgImageV.frame fromView:ucell.contentView];
    currentMsg = ucell.chatMsg;
    currentCellIndex = index;
    NSLog(@"gghhhsssdddd:%@",NSStringFromCGRect(rect));
    if ([ucell.chatMsg.type isEqualToString:MSG_TYPE_TEXT]) {
        self.msgCopyBtn.hidden = NO;
        self.msgMenuLineV.hidden = NO;
//        [self.menuView setFrame:CGRectMake(rect.origin.x+(rect.size.width/2)-37, rect.origin.y-32, 75, 32)];
        if (rect.origin.y<35) {
            [self.menuView setFrame:CGRectMake(rect.origin.x+(rect.size.width/2)-37, rect.origin.y+rect.size.height, 75, 32)];
            [self.bgvc setFrame:CGRectMake(0, 0, 75, 32)];
            [self.bgvc setImage:[UIImage imageNamed:@"chat_menu_d"]];
            self.msgCopyBtn.frame = CGRectMake(0, 3, 38, 32);
            self.msgMenuLineV.frame = CGRectMake(37, 10, 1, 18);
            self.MsgDelBtn.frame = CGRectMake(38, 3, 38, 32);
        }
        else
        {
            [self.menuView setFrame:CGRectMake(rect.origin.x+(rect.size.width/2)-37, rect.origin.y-32, 75, 32)];
            [self.bgvc setFrame:CGRectMake(0, 0, 75, 32)];
            [self.bgvc setImage:[UIImage imageNamed:@"chat_menu"]];
            self.msgCopyBtn.frame = CGRectMake(0, 0, 38, 28);
            self.msgMenuLineV.frame = CGRectMake(37, 5, 1, 18);
            self.MsgDelBtn.frame = CGRectMake(38, 0, 38, 28);
        }
    }
    else
    {
        self.msgCopyBtn.hidden = YES;
        self.msgMenuLineV.hidden = YES;
        if (rect.origin.y<35) {
            [self.menuView setFrame:CGRectMake(rect.origin.x+(rect.size.width/2)-18, rect.origin.y+rect.size.height, 38, 32)];
            [self.bgvc setFrame:CGRectMake(0, 0, 38, 32)];
            [self.bgvc setImage:[UIImage imageNamed:@"chat_menu_2_d"]];
            self.msgCopyBtn.frame = CGRectMake(0, 3, 38, 32);
            self.msgMenuLineV.frame = CGRectMake(37, 10, 1, 18);
            self.MsgDelBtn.frame = CGRectMake(0, 3, 38, 32);
        }
        else
        {
            [self.menuView setFrame:CGRectMake(rect.origin.x+(rect.size.width/2)-18, rect.origin.y-32, 38, 32)];
            [self.bgvc setFrame:CGRectMake(0, 0, 38, 32)];
            [self.bgvc setImage:[UIImage imageNamed:@"chat_menu_2"]];
            self.msgCopyBtn.frame = CGRectMake(0, 0, 38, 28);
            self.msgMenuLineV.frame = CGRectMake(37, 5, 1, 18);
            self.MsgDelBtn.frame = CGRectMake(0, 0, 38, 28);
        }
    }
//    [self.menuView setFrame:CGRectMake(rect.origin.x+(rect.size.width/2)-37, rect.origin.y-32, 75, 32)];
    
    
}
-(void)copyMsg
{
    self.menuView.hidden = YES;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = currentMsg.content;
}
-(void)deleteMsg
{
    self.menuView.hidden = YES;
    [self.chatArray removeObjectAtIndex:currentCellIndex];
    [DatabaseServe deleteMsgById:currentMsg.msgid SidePetId:self.thePet.petID];
    [self.msgTableV deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:currentCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    
    if (self.chatArray.count==0) {
        [self.chatArray addObjectsFromArray:[DatabaseServe getDetailMsgArrayByPage:0 PetId:self.thePet.petID]];
    }
    
    [self.msgTableV reloadData];
    
    if (self.chatArray.count>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgDeleted" object:[self.chatArray lastObject] userInfo:nil];
    }
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgDeleted" object:self.thePet.petID userInfo:nil];
    
    
}
//- (BOOL)canBecomeFirstResponder{
//    return YES;
//}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    //    return (action == @selector(copyMsg));
    //    return (action == @selector(transferMsg));
    //    return (action == @selector(deleteMsg));
    if (action == @selector(copyMsg) || action == @selector(deleteMsg))
    {
        return YES;
    }
    else
        return NO;
}
-(void)audioClickedWithPath:(NSString *)path cell:(id)cell
{
    ChatDetailTableViewCell * ucell = (ChatDetailTableViewCell *)cell;
    NSLog(@"audioPath:%@",path);
    
    for (int i = 0; i<self.chatArray.count; i++) {
        ChatDetailTableViewCell * dcell = (ChatDetailTableViewCell *)[self.msgTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([dcell.chatMsg.type isEqualToString:MSG_TYPE_AUDIO]) {
            [dcell.audioImageV stopAnimating];
        }
    }
    NSLog(@"current:%@,cell:%@",currentPlayingMsgId,ucell.chatMsg.msgid);
    if ([currentPlayingMsgId isEqualToString:ucell.chatMsg.msgid]&&[self.audioPlayer isPlaying]) {
        [self.audioPlayer stopAudio];
        return;
    }
    if ([path hasPrefix:@"http"]) {
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
        NSString *subdirectory = [documents stringByAppendingPathComponent:@"Audios"];

        
        NSString * audioFileName = [[path componentsSeparatedByString:@"/"] lastObject];
        
        NSString *localAudioPath = [subdirectory stringByAppendingPathComponent:audioFileName];
        if ([TFileManager ifExsitAudio:audioFileName]) {
            self.audioPlayer = [XHAudioPlayerHelper shareInstance];
            [self.audioPlayer setDelegate:self];
            [self.audioPlayer managerAudioWithFileName:localAudioPath toPlay:YES];
            currentPlayingMsgId = ucell.chatMsg.msgid;
            if (ucell) {
                if (![ucell.audioImageV isAnimating]) {
                    if (ucell.chatMsg.isMe) {
                        ucell.audioImageV.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"audioplayme001.png"],[UIImage imageNamed:@"audioplayme002.png"],[UIImage imageNamed:@"audioplayme003.png"], nil];
                        ucell.audioImageV.animationDuration = ucell.audioImageV.animationImages.count*0.15;
                        [ucell.audioImageV startAnimating];
                    }
                    else
                    {
                        ucell.audioImageV.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"audioplay001.png"],[UIImage imageNamed:@"audioplay002.png"],[UIImage imageNamed:@"audioplay003.png"], nil];
                        ucell.audioImageV.animationDuration = ucell.audioImageV.animationImages.count*0.15;
                        [ucell.audioImageV startAnimating];
                    }
                }
            }
            return;
        }
        [NetServer downloadAudioFileWithURL:path TheController:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSData * audioData = nil;
            //        NSString * thePath = nil;
            
#if TARGET_IPHONE_SIMULATOR
//            audioData = responseObject;
#elif TARGET_OS_IPHONE
                audioData = DecodeAMRToWAVE(responseObject);
#endif
            
            
            if ([audioData writeToFile:localAudioPath atomically:YES]) {

                    self.audioPlayer = [XHAudioPlayerHelper shareInstance];
                    [self.audioPlayer setDelegate:self];
                    [self.audioPlayer managerAudioWithFileName:localAudioPath toPlay:YES];
                    currentPlayingMsgId = ucell.chatMsg.msgid;
                    if (ucell) {
                        if (![ucell.audioImageV isAnimating]) {
                            if (ucell.chatMsg.isMe) {
                                ucell.audioImageV.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"audioplayme001.png"],[UIImage imageNamed:@"audioplayme002.png"],[UIImage imageNamed:@"audioplayme003.png"], nil];
                                ucell.audioImageV.animationDuration = ucell.audioImageV.animationImages.count*0.15;
                                [ucell.audioImageV startAnimating];
                            }
                            else
                            {
                                ucell.audioImageV.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"audioplay001.png"],[UIImage imageNamed:@"audioplay002.png"],[UIImage imageNamed:@"audioplay003.png"], nil];
                                ucell.audioImageV.animationDuration = ucell.audioImageV.animationImages.count*0.15;
                                [ucell.audioImageV startAnimating];
                            }
                        }
                    }
                }
                
            
            else
            {
                NSLog(@"%@ write failed",localAudioPath);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    }
    else
    {
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
        
        
        NSString * audioFileName = [[path componentsSeparatedByString:@"/"] lastObject];
        NSString *localAudioPath = [documents stringByAppendingPathComponent:audioFileName];
        self.audioPlayer = [XHAudioPlayerHelper shareInstance];
        [self.audioPlayer setDelegate:self];
        [self.audioPlayer managerAudioWithFileName:localAudioPath toPlay:YES];
        currentPlayingMsgId = ucell.chatMsg.msgid;
        if (ucell) {
            if (![ucell.audioImageV isAnimating]) {
                if (ucell.chatMsg.isMe) {
                    ucell.audioImageV.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"audioplayme001.png"],[UIImage imageNamed:@"audioplayme002.png"],[UIImage imageNamed:@"audioplayme003.png"], nil];
                    ucell.audioImageV.animationDuration = ucell.audioImageV.animationImages.count*0.15;
                    [ucell.audioImageV startAnimating];
                }
                else
                {
                    ucell.audioImageV.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"audioplay001.png"],[UIImage imageNamed:@"audioplay002.png"],[UIImage imageNamed:@"audioplay003.png"], nil];
                    ucell.audioImageV.animationDuration = ucell.audioImageV.animationImages.count*0.15;
                    [ucell.audioImageV startAnimating];
                }
            }
        }
    
    }
}
-(void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer
{
//    currentPlayingMsgId = @"";
    for (int i = 0; i<self.chatArray.count; i++) {
        ChatDetailTableViewCell * dcell = (ChatDetailTableViewCell *)[self.msgTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([dcell.chatMsg.type isEqualToString:MSG_TYPE_AUDIO]) {
            [dcell.audioImageV stopAnimating];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"sssss:%@",NSStringFromCGPoint(scrollView.contentOffset));
}

-(void)moreBtnClicked
{
    UIActionSheet * act;
    if (!inMyBlackList) {
        act= [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"清空聊天记录",@"加入黑名单", nil];
//        act.tag = 1;
    }
    else{
        act= [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"清空聊天记录",@"取消黑名单", nil];
//        act.tag = 2;
    }
    [act showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"clear it");
        [DatabaseServe deleteAllMsgForPetId:self.thePet.petID];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgDeleted" object:self.thePet.petID userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (buttonIndex==1) {
        if (inMyBlackList) {
            [self removeThisPetFromBlackList];
        }
        else
        {
            [self addThisPetToBlackList];
        }
        NSLog(@"black list");
    }
}

-(void)headTouchedWithMsg:(ChatMsg *)chatMsg
{
    [self.audioPlayer stopAudio];
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    if (chatMsg.isMe) {
        pv.petId = [UserServe sharedUserServe].userID;
    }
    else
        pv.petId = self.thePet.petID;
//    pv.petAvatarUrlStr = talkingBrowse.forwardInfo.forwardPetAvatar;
//    pv.petNickname = talkingBrowse.forwardInfo.forwardPetNickname;
//    //    pv.relationShip = talkingBrowse.relationShip;

    [self.navigationController pushViewController:pv animated:YES];
}

-(void)addThisPetToBlackList
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"setting" forKey:@"command"];
    [mDict setObject:@"CBA" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    [mDict setObject:self.thePet.petID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        inMyBlackList = YES;
        self.cannotSendV.text = @"对方在您的黑名单里，您将收不到他的消息";
        self.cannotSendV.hidden = NO;
        [SVProgressHUD showSuccessWithStatus:@"已加入黑名单"];
        [DatabaseServe AddPetToChatBlackList:self.thePet.petID];
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
}

-(void)removeThisPetFromBlackList
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"setting" forKey:@"command"];
    [mDict setObject:@"CBD" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    [mDict setObject:self.thePet.petID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        inMyBlackList = NO;
        self.cannotSendV.hidden = YES;
        [SVProgressHUD showSuccessWithStatus:@"已从黑名单移除"];
        [DatabaseServe removePetFromChatBlackList:self.thePet.petID];
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
}

-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
