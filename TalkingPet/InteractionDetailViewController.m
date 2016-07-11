//
//  InteractionDetailViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/30.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "InteractionDetailViewController.h"
#import "RootViewController.h"
#import "ShareSheet.h"
@interface InteractionDetailViewController ()

@end

@implementation InteractionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastId = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setShadowBackButtonWithTarget:@selector(backBtnDo:)];
    [self setRightButtonWithName:nil BackgroundImg:@"morebtn_shadow" Target:@selector(shareInteraction)];
    
    self.imageArray = [NSArray array];
    self.commentArray = [NSMutableArray array];
    
    self.detailTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50-([UIDevice currentDevice].systemVersion.floatValue < 7.0?44:0))];
    self.detailTableV.delegate = self;
    self.detailTableV.dataSource = self;
    self.detailTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.detailTableV];
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        self.title = self.titleStr;
    }
    XLHeaderView *headerView = [[XLHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)*1/2.0f)backGroudImageURL:self.bgImageUrl headerImageURL:@"http://www.qqw21.com/article/uploadpic/2012-9/2012911193026322.jpg" title:self.titleStr subTitle:self.titleStr asNavi:YES];
    //    headerView.viewController = self;
    headerView.scrollView = self.detailTableV;
    //    self.listTableV.tableHeaderView = headerView;
    [self.view addSubview:headerView];
    _headerView = headerView;
    
    self.inputView = [[InputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-navigationBarHeight-50-50, ScreenWidth, 50) BaseView:self.view Type:3];
    [self.view addSubview:self.inputView];
    self.inputView.viewH = self.view.frame.size.height;
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        self.inputView.naviH = 44;
    }
    else
        self.inputView.naviH = 0;
    [self.inputView setFrame:CGRectMake(0, self.view.frame.size.height-50-([UIDevice currentDevice].systemVersion.floatValue < 7.0?44:0), ScreenWidth, 50)];
    self.inputView.delegate = self;
    
    [self getHudongDetail];
    [self getComment];
    
    [self.detailTableV addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
    [self.detailTableV addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
    // Do any additional setup after loading the view.
}
- (void)tableViewHeaderRereshing:(UITableView *)tableView
{
    self.lastId = @"";
    [self getComment];
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
    [self getComment];
}
-(void)endRefreshing:(UITableView *)tableView
{
    [self.detailTableV footerEndRefreshing];
    [self.detailTableV headerEndRefreshing];
    [self.detailTableV reloadData];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.menuView.hidden = YES;
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
-(void)getHudongDetail
{
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"topic" forKey:@"command"];
    [usersDict setObject:@"talkOne" forKey:@"options"];
    [usersDict setObject:self.hudongId forKey:@"id"];
    if ([UserServe sharedUserServe].userID) {
        [usersDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    }
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.contentDict = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"value"]];
        self.imageArray = [[responseObject objectForKey:@"value"] objectForKey:@"pictures"];
        [self.detailTableV reloadData];
        [self endRefreshing:self.detailTableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefreshing:self.detailTableV];
    }];
    
}

-(void)getComment
{
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"topic" forKey:@"command"];
    [usersDict setObject:@"commentList" forKey:@"options"];
    [usersDict setObject:self.hudongId forKey:@"talkId"];
    [usersDict setObject:@"20" forKey:@"pageSize"];
    [usersDict setObject:self.lastId forKey:@"startId"];
    if ([UserServe sharedUserServe].userID) {
        [usersDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    }
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.commentArray = [self getModelArray:[responseObject objectForKey:@"value"]];
        if ([self.lastId isEqualToString:@""]) {
//            [self.commentHeightArray removeAllObjects];
            self.commentArray = [self getModelArray:[responseObject objectForKey:@"value"]];

//            [self getCommentAndFavorNum];
        }
        else{
            [self.commentArray addObjectsFromArray:[self getModelArray:[responseObject objectForKey:@"value"]]];
            
        }
        self.lastId = [[[responseObject objectForKey:@"value"] lastObject] objectForKey:@"id"]?[[[responseObject objectForKey:@"value"] lastObject] objectForKey:@"id"]:@"";
        [self.detailTableV reloadData];
        [self endRefreshing:self.detailTableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefreshing:self.detailTableV];
    }];
    
}

-(NSMutableArray *)getModelArray:(NSArray *)array
{
    NSMutableArray * hArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        TalkComment * talkingComment = [[TalkComment alloc] initWithHuDongCommentInfo:[array objectAtIndex:i]];
        talkingComment.cHeight = [TalkingCommentTableViewCell heightForRowWithComment:talkingComment].height;
        talkingComment.cWidth = [TalkingCommentTableViewCell heightForRowWithComment:talkingComment].width;
        
        [hArray addObject:talkingComment];
        //        [self.commentHeightArray addObject:[NSNumber numberWithFloat:[TalkingCommentTableViewCell heightForRowWithComment:talkingComment]]];
    }
    return hArray;
}

- (void)didSendTextAction:(NSString *)text
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
//        [self doingSth];
        [SVProgressHUD showWithStatus:self.replyToId?@"回复中...":@"评论中..."];
        [self makeCommentToThisTalkingWithContent:text AimPetID:self.replyToId];

}
-(void)inputViewDidResignActive
{
    self.replyToId = nil;
    self.inputView.textView.placeholder = @"评论";
}
-(void)doingSth
{
    [self.inputView dismissInputView];
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
    [mDict setObject:@"topic" forKey:@"command"];
    [mDict setObject:@"createComment" forKey:@"options"];
    [mDict setObject:self.hudongId forKey:@"talkId"];
    [mDict setObject:currentPetId forKey:@"petId"];
    if (aimPetId) {
        [mDict setObject:aimPetId forKey:@"atPetId"];
    }
    
    [mDict setObject:commentContent forKey:@"comment"];
    NSLog(@"doComment:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        [self successAction];
        self.inputView.textView.text = @"";
        [SVProgressHUD dismiss];
//        [SVProgressHUD showSuccessWithStatus:self.replyToId?@"回复成功":@"评论成功"];
        self.lastId = @"";
        [self doingSth];
        TalkComment * talkingComment = [[TalkComment alloc] initWithHuDongCommentInfo:[responseObject objectForKey:@"value"]];
        talkingComment.cHeight = [TalkingCommentTableViewCell heightForRowWithComment:talkingComment].height;
        talkingComment.cWidth = [TalkingCommentTableViewCell heightForRowWithComment:talkingComment].width;
        [self.commentArray insertObject:talkingComment atIndex:0];
        [self.detailTableV reloadData];
//        [self getComment];
//        [self getAllCommentsAndForward:nil];
        NSLog(@"comment success:%@",responseObject);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"comment error:%@",error);
        //        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"评论失败"];
//        [self failedAction];
    }];
}



-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0&&indexPath.section==0) {
        NSString * content = [self.contentDict objectForKey:@"content"];
        CGSize cSize;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
            NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle2.lineHeightMultiple = 1.2;
    //        paragraphStyle2.firstLineHeadIndent = 20;
            NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle2.copy};
            cSize = [content boundingRectWithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes2 context:nil].size;
        }
        else
            cSize = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        return 60+cSize.height+10;
    }
    else if (indexPath.section==0){
        float h = (ScreenWidth-20)/[[self.imageArray[indexPath.row-1] objectForKey:@"scaleWH"] floatValue]+10;
//        NSLog(@"hhhhhhh:%f",h);
        return h;
    }
    else{
        TalkComment * tk = [self.commentArray objectAtIndex:indexPath.row];
        return tk.cHeight;;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1+self.imageArray.count;
    }
    return self.commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0&&indexPath.section==0) {
        static NSString *cellIdentifier = @"detailcell";
        HuDongDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[HuDongDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentDict = self.contentDict;
//        cell.textLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
        return cell;
    }
    else if (indexPath.section==0){
        static NSString *cellIdentifier = @"hudongimagecell";
        HuDongImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[HuDongImageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.imageDict = self.imageArray[indexPath.row-1];
        cell.imageIndex = (int)indexPath.row-1;
        cell.imageNum = (int)self.imageArray.count;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"hudongcommentcell";
        TalkingCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[TalkingCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.delegate = self;
        }
//        cell.textLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.talkingComment = [self.commentArray objectAtIndex:indexPath.row];
        cell.needShowSepLine = YES;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        TalkComment * tk = self.commentArray[indexPath.row];
        NSString * toPetId = tk.petID;
        [self.inputView showInputViewWithAudioBtn:NO];
        self.replyToId = toPetId;
        self.inputView.textView.placeholder = [NSString stringWithFormat:@"回复@%@",tk.petNickname];
    }
    
}
-(void)commentPublisherNameClicked:(TalkComment *)talkingCommentN
{
    pushed = YES;
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingCommentN.petID;
//    pv.petAvatarUrlStr = talkingCommentN.petAvatarURL;
    pv.petNickname = talkingCommentN.petNickname;
    [self.navigationController pushViewController:pv animated:YES];
}
-(void)commentPublisherBtnClicked:(TalkComment *)talkingCommentN
{
    pushed = YES;
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingCommentN.petID;
    pv.petAvatarUrlStr = talkingCommentN.petAvatarURL;
    pv.petNickname = talkingCommentN.petNickname;
    [self.navigationController pushViewController:pv animated:YES];
}
-(void)commentAimUserNameClicked:(TalkComment *)talkingCommentN Link:(NSTextCheckingResult *)linkInfo
{
    pushed = YES;
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingCommentN.aimPetID;
    //    pv.petAvatarUrlStr = talkingCommentN.petAvatarURL;
    pv.petNickname = talkingCommentN.aimPetNickname;
    [self.navigationController pushViewController:pv animated:YES];
}
-(void)touchedUserId:(NSString *)uid
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = uid;
    pushed = YES;
    [self.navigationController pushViewController:pv animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    pushed = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (pushed) {
        [self showNaviBg];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(resetStatusforIndex:section:withStatus:commentCount:)]) {
        if (self.commentArray.count>=2) {
            [self.delegate resetStatusforIndex:self.cellIndex section:self.sectionIndex withStatus:[NSArray arrayWithObjects:self.commentArray[0],self.commentArray[1], nil] commentCount:(int)self.commentArray.count];
        }
        else if (self.commentArray.count==1){
            [self.delegate resetStatusforIndex:self.cellIndex section:self.sectionIndex withStatus:[NSArray arrayWithObjects:self.commentArray[0], nil] commentCount:(int)self.commentArray.count];
        }
        else
            [self.delegate resetStatusforIndex:self.cellIndex section:self.sectionIndex withStatus:[NSArray array] commentCount:(int)self.commentArray.count];
        
    }
    
}
-(void)viewDidDisappear:(BOOL)animated
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)shareInteraction
{
    ShareSheet * shareSheet = [[ShareSheet alloc]initWithIconArray:@[@"weiChatFriend",@"friendCircle",@"sina",@"qq"] titleArray:@[@"微信好友",@"朋友圈",@"微博",@"QQ"] action:^(NSInteger index) {
        switch (index) {
            case 0:{
                [ShareServe shareToWeixiFriendWithTitle:_titleStr Content:@"互动吧—发现更多养宠秘籍" imageUrl:_bgImageUrl webUrl:[NSString stringWithFormat:ONETOPICBASEURL,_hudongId] Succeed:nil];
            }break;
            case 1:{
                [ShareServe shareToFriendCircleWithTitle:_titleStr Content:@"互动吧—发现更多养宠秘籍" imageUrl:_bgImageUrl webUrl:[NSString stringWithFormat:ONETOPICBASEURL,_hudongId] Succeed:nil];
            }break;
            case 2:{
                [ShareServe shareToSineWithContent:[NSString stringWithFormat:@"%@"ONETOPICBASEURL,_titleStr,_hudongId] imageUrl:_bgImageUrl Succeed:nil];
            }break;
            case 3:{
                [ShareServe shareToQQWithTitle:_titleStr Content:@"互动吧—发现更多养宠秘籍" imageUrl:_bgImageUrl webUrl:[NSString stringWithFormat:ONETOPICBASEURL,_hudongId] Succeed:nil];
            }break;
            default:
                break;
        }
        
    }];
    [shareSheet show];
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
