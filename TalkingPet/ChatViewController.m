//
//  ChatViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14/12/29.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatListTableViewCell.h"
#import "UserListViewController.h"
#import "ChatMsg.h"
@interface ChatViewController ()

@end

@implementation ChatViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 0;
    self.msgArray = [NSMutableArray array];
    [self.msgArray addObjectsFromArray:[DatabaseServe getMsgArrayByPage:0]];
    
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    [self setRightButtonWithName:nil BackgroundImg:@"addchatbtn" Target:@selector(addchatBtnClicked)];

    [self buildViewWithSkintype];
    
    self.msgTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight) style:UITableViewStylePlain];
    self.msgTableV.delegate = self;
    self.msgTableV.dataSource = self;
    self.msgTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.msgTableV.backgroundColor = [UIColor clearColor];
    self.msgTableV.backgroundView = nil;
    self.msgTableV.scrollsToTop = YES;
    self.msgTableV.backgroundColor = [UIColor clearColor];
    self.msgTableV.rowHeight = 60;
    self.msgTableV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.msgTableV];
    
    g = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 100)];
    [g setText:@"这里空空的呀"];
    [g setBackgroundColor:[UIColor clearColor]];
    [g setTextAlignment:NSTextAlignmentCenter];
    [g setTextColor:[UIColor colorWithWhite:140/255.0f alpha:1]];
    [self.view addSubview:g];
    g.hidden = YES;
    
    [self.msgTableV addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalChatUserInfoGeted:) name:@"NormalChatUserInfoGeted" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalChatMsgReceived:) name:@"NormalChatMsgReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalChatMsgAdded:) name:@"NormalChatMsgAdded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalChatMsgDeleted:) name:@"NormalChatMsgDeleted" object:nil];
    
    NSLog(@"ggggmmmmm:%@",self.msgArray);
    // Do any additional setup after loading the view.
}
-(void)addchatBtnClicked
{
    UserListViewController * ul = [[UserListViewController alloc] init];
    ul.listType = UserListTypeAttention;
    ul.shouldSelectChatUser = YES;
    ul.petID = [UserServe sharedUserServe].userID;
    [self.navigationController pushViewController:ul animated:YES];
}
-(void)normalChatMsgDeleted:(NSNotification *)noti
{
    if ([noti.object isKindOfClass:[NSString class]]) {
        int a = -1;
        for (int i = 0; i<self.msgArray.count; i++) {
            ChatListMsg * cm = self.msgArray[i];
            if ([cm.sidePetId isEqualToString:noti.object]) {
                a = i;
                break;
            }
        }
        if (a!=-1) {
            [self.msgArray removeObjectAtIndex:a];
            [self.msgTableV reloadData];
        }
    }
    else
    {
        ChatMsg * chatMsg = noti.object;
        for (int i = 0; i<self.msgArray.count; i++) {
            ChatListMsg * cm = self.msgArray[i];
            if ([cm.sidePetId isEqualToString:chatMsg.fromid]) {
                cm.content = chatMsg.content;
                [self.msgArray replaceObjectAtIndex:i withObject:cm];
                break;
            }
        }
        [self.msgTableV reloadData];
    }
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
    currentPage++;
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.8];
    NSLog(@"ddddd");
}
-(void)loadMore
{
    [self.msgArray addObjectsFromArray:[DatabaseServe getMsgArrayByPage:currentPage]];
    [self.msgTableV reloadData];
    [self.msgTableV.footer endRefreshing];
}
-(void)normalChatMsgAdded:(NSNotification *)noti
{
    ChatMsg * reveicedMsg = noti.object;
    ChatListMsg * chatListMsg = [[ChatListMsg alloc] init];
    chatListMsg.type = reveicedMsg.type;
    chatListMsg.content = reveicedMsg.content;
    chatListMsg.sendTime = [NSString stringWithFormat:@"%f",reveicedMsg.date];
    chatListMsg.sidePetId = reveicedMsg.fromid;
    NSPredicate * predicate = predicate = [NSPredicate predicateWithFormat:@"petId==[c]%@",reveicedMsg.fromid];
    //    MsgPetEntity * petE = [MsgPetEntity MR_findFirstWithPredicate:predicate];
    MsgPetEntity * petE = [MsgPetEntity MR_findFirstWithPredicate:predicate];
    if (petE) {
        
        chatListMsg.sidePetNickname = petE.nickname;
        chatListMsg.sidePetAvatarUrl = petE.avatarUrl;
    }else
    {
        chatListMsg.sidePetNickname = @"user";
        chatListMsg.sidePetAvatarUrl = @"user";
    }
    
    int a = -1;
    for (int i = 0; i<self.msgArray.count; i++) {
        ChatListMsg * cm = self.msgArray[i];
        if ([cm.sidePetId isEqualToString:chatListMsg.sidePetId]) {
            a = i;
            break;
        }
    }
    
    if (a!=-1) {
        [self.msgArray removeObjectAtIndex:a];
        [self.msgArray insertObject:chatListMsg atIndex:0];
        [self.msgTableV reloadData];
    }
    else
    {
//        chatListMsg.unreadCount = 1;
        [self.msgArray insertObject:chatListMsg atIndex:0];
        [self.msgTableV reloadData];
    }
    

}
-(void)normalChatMsgReceived:(NSNotification *)noti
{
    ChatMsg * reveicedMsg = noti.object;
    ChatListMsg * chatListMsg = [[ChatListMsg alloc] init];
    chatListMsg.type = reveicedMsg.type;
    chatListMsg.content = reveicedMsg.content;
    chatListMsg.sendTime = [NSString stringWithFormat:@"%f",reveicedMsg.date];
    chatListMsg.sidePetId = reveicedMsg.fromid;
    
    NSPredicate * predicate = predicate = [NSPredicate predicateWithFormat:@"petId==[c]%@",reveicedMsg.fromid];
//    MsgPetEntity * petE = [MsgPetEntity MR_findFirstWithPredicate:predicate];
    MsgPetEntity * petE = [MsgPetEntity MR_findFirstWithPredicate:predicate];
    if (petE) {
        
        chatListMsg.sidePetNickname = petE.nickname;
        chatListMsg.sidePetAvatarUrl = petE.avatarUrl;
    }else
    {
        chatListMsg.sidePetNickname = @"user";
        chatListMsg.sidePetAvatarUrl = @"user";
    }
    
    int a = -1;
    for (int i = 0; i<self.msgArray.count; i++) {
        ChatListMsg * cm = self.msgArray[i];
        if ([cm.sidePetId isEqualToString:chatListMsg.sidePetId]) {
            a = i;
            chatListMsg.unreadCount = cm.unreadCount + 1;
            break;
        }
    }
    
    if (a!=-1) {
        [self.msgArray removeObjectAtIndex:a];
        [self.msgArray insertObject:chatListMsg atIndex:0];
        [self.msgTableV reloadData];
    }
    else
    {
        chatListMsg.unreadCount = 1;
        [self.msgArray insertObject:chatListMsg atIndex:0];
        [self.msgTableV reloadData];
    }
    

}
-(void)setUnreadCountForPet:(NSString *)petId UnreadCount:(int)unread
{
    for (int i = 0; i<self.msgArray.count; i++) {
        ChatListMsg * chatList = [self.msgArray objectAtIndex:i];
        if ([chatList.sidePetId isEqualToString:petId]) {
            chatList.unreadCount = 0;
            [self.msgArray replaceObjectAtIndex:i withObject:chatList];
            break;
        }
    }
    [self.msgTableV reloadData];
}
-(void)normalChatUserInfoGeted:(NSNotification *)noti
{
    Pet * pet = noti.object;
    for (int i = 0; i<self.msgArray.count; i++) {
        ChatListMsg * cm = self.msgArray[i];
        if ([cm.sidePetId isEqualToString:pet.petID]) {
            cm.sidePetNickname = pet.nickname;
            cm.sidePetAvatarUrl = pet.headImgURL;
            [self.msgArray replaceObjectAtIndex:i withObject:cm];
            [self.msgTableV reloadData];
            break;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.msgArray.count<=0) {
        g.hidden = NO;
    }
    else
        g.hidden = YES;
    return self.msgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"chatListCell";
    ChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[ChatListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.chatListMsg = self.msgArray[indexPath.row];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        ChatListMsg * chatMsg = self.msgArray[indexPath.row];
        [DatabaseServe deleteAllMsgForPetId:chatMsg.sidePetId];
        [self.msgArray removeObjectAtIndex:indexPath.row];
        [self.msgTableV deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatListMsg * cm = self.msgArray[indexPath.row];
    ChatDetailViewController * chatDV = [[ChatDetailViewController alloc] init];
    Pet * theP = [[Pet alloc] init];
    theP.petID = cm.sidePetId;
    theP.nickname = cm.sidePetNickname;
    theP.headImgURL = cm.sidePetAvatarUrl;
    chatDV.thePet = theP;
    chatDV.title =cm.sidePetNickname;
    chatDV.delegate = self;
    [self.navigationController pushViewController:chatDV animated:YES];
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
