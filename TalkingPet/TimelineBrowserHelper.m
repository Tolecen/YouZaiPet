//
//  TimelineBrowserHelper.m
//  TalkingPet
//
//  Created by Tolecen on 15/1/30.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "TimelineBrowserHelper.h"
#import "AttentionViewController.h"
#import "GTScrollNavigationBar.h"
#import "ShareSheet.h"
#import "PublishServer.h"

@implementation TimelineBrowserHelper
-(id)initWithController:(UIViewController *)thexController tableview:(UITableView *)theTable withHead:(BOOL)showHead header:(UIView *)header
{
    if (self = [super init]) {
        self.needScrollTopDelegate = NO;
        self.theController = thexController;
        self.theView = thexController.view;
        self.iamActive = YES;
        self.showHead = showHead;
        self.tableV = theTable;
        self.naviH = [SystemServer sharedSystemServer].navigationBarHigh;
        //        self.dataArray = theDataArray;
        self.isInfont = YES;
        
        self.isRefreshing = NO;
        
        self.canPlay = YES;
        
        self.cellNeedShowPublishTime = YES;
        
        self.firPageLoaded = NO;
        self.footerCanRefresh = YES;
        self.headerCanRefresh = YES;
        currentPetId = @"";
        
        currentID = 1;
        
        self.footerShouldDelegateToUserCenter = NO;
        
        [self.tableV addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
        self.tableV.header.delegate = self;
        //        [self.tableV headerBeginRefreshing];
        [self.tableV addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
        self.tableV.footer.delegate = self;

    }
    return self;
}
- (void)tableViewHeaderRereshing:(UITableView *)tableView
{

    if (!self.headerCanRefresh) {
        [self.tableV headerEndRefreshing];
        return;
    }
    if (_delegate&& [_delegate respondsToSelector:@selector(refreshTableDo)]) {
        [_delegate refreshTableDo];
        return;
    }
    self.isRefreshing = YES;
    [self loadFirstDataPageWithDict:self.reqDict];
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
    if ((!self.dataArray||self.dataArray.count==0)&&!self.footerShouldDelegateToUserCenter) {
        [self.tableV footerEndRefreshing];
        return;
    }
    if (!self.footerCanRefresh) {
        [self.tableV footerEndRefreshing];
        return;
    }
    self.isRefreshing = YES;
    if (self.footerShouldDelegateToUserCenter) {
        if (_delegate&& [_delegate respondsToSelector:@selector(footerDelegateToUserCenter)]) {
            [_delegate footerDelegateToUserCenter];
        }
    }
    else{
        
        [self loadNextPage];
    }
}
-(void)endHeaderRefreshing:(UITableView *)tableView
{
    self.isRefreshing = NO;
    [self.tableV headerEndRefreshing];
    [self.tableV reloadData];
    if (self.dataArray.count>0) {
        //        [self.tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

-(void)endFooterRefreshing:(UITableView *)tableView
{
    self.isRefreshing = NO;
    [self.tableV footerEndRefreshing];
    [self.tableV reloadData];
    
}


-(void)loadFirstDataPageWithDict:(NSMutableDictionary *)theDict
{
    
    currentID = 1;
    if ([[theDict allKeys] containsObject:@"pageIndex"]) {
        [theDict setObject:[NSString stringWithFormat:@"%d",currentID] forKey:@"pageIndex"];
    }
    else
    {
        if ([[theDict allKeys] containsObject:@"id"]) {
            [theDict removeObjectForKey:@"id"];
        }
    }    
    self.reqDict = theDict;
    [NetServer requestWithParameters:theDict Controller:self.theController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"value"] isKindOfClass:[NSDictionary class]]) {
            self.dataArray = [self getModelArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
            NSDictionary * dic = _dataArray.count?@{}:nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRBrowserHelperZeroData" object:self userInfo:dic];
            self.usePage = YES;
            if ([[self.reqDict objectForKey:@"options"] isEqualToString:@"hotList"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"value"] objectForKey:@"list"] forKey:[NSString stringWithFormat:@"hotList%@",[UserServe sharedUserServe].userID]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:self.reqDict forKey:[NSString stringWithFormat:@"hotListReqDict%@",[UserServe sharedUserServe].userID]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
            }
        }
        else{
            self.dataArray = [self getModelArray:[responseObject objectForKey:@"value"]];
            self.usePage = NO;
            if ([[self.reqDict objectForKey:@"options"] isEqualToString:@"focusList"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"value"] forKey:[NSString stringWithFormat:@"focusList%@",[UserServe sharedUserServe].userID]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:self.reqDict forKey:[NSString stringWithFormat:@"focusListReqDict%@",[UserServe sharedUserServe].userID]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            NSDictionary * dic = _dataArray.count?@{}:nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRBrowserHelperZeroData" object:self userInfo:dic];
            if (self.dataArray.count==0) {
                if ([self.theController isKindOfClass:[AttentionViewController class]]) {
                    AttentionViewController * mainV = (AttentionViewController *)self.theController;
                    [mainV attentionNoContent:NO];
                    
                }
            }
            else
            {
                if ([self.theController isKindOfClass:[AttentionViewController class]]) {
                    AttentionViewController * mainV = (AttentionViewController *)self.theController;
                    [mainV attentionNoContent:YES];
                    
                }
            }
        }

        if (self.dataArray.count>0) {
            self.firPageLoaded = YES;
            //            bv.nocontentLabel2.hidden = YES;
        }
        else
        {
            //            bv.nocontentLabel2.hidden = NO;
        }
        [self endHeaderRefreshing:self.tableV];
        
//        NSLog(@"get hot shuoshuo success:%@",responseObject);
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get hot shuoshuo failed error:%@",error);
        [self endHeaderRefreshing:self.tableV];
    }];
    currentPetId = [UserServe sharedUserServe].userID;
    
}
-(void)loadNextPage
{
    if (!self.firPageLoaded) {
        [self endFooterRefreshing:self.tableV];
        return;
    }
    if (self.usePage) {
        currentID++;
        [self.reqDict setObject:[NSString stringWithFormat:@"%d",currentID] forKey:@"pageIndex"];
    }
    else
    {
        TalkingBrowse * tb = [self.dataArray lastObject];
        lastId = tb.listId;
        [self.reqDict setObject:lastId forKey:@"id"];
    }
    [NetServer requestWithParameters:self.reqDict Controller:self.theController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"value"] isKindOfClass:[NSDictionary class]]) {
//            NSLog(@"ffffffvvvvv:%@,count:%d",[self getModelArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]],[[[responseObject objectForKey:@"value"] objectForKey:@"list"] count]);
            [self.dataArray addObjectsFromArray:[self getModelArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]]];
//            NSLog(@"ffffffvvvvv2:%@,count2:%d",self.dataArray,self.dataArray.count);
        }
        else{
            [self.dataArray addObjectsFromArray:[self getModelArray:[responseObject objectForKey:@"value"]]];
        }
        NSDictionary * dic = _dataArray.count?@{}:nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRBrowserHelperZeroData" object:self userInfo:dic];
        [self endFooterRefreshing:self.tableV];
        if (self.footerShouldDelegateToUserCenter) {
            return;
        }
        //        [self cellPlayAni:self.tableV];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get attention shuoshuo failed error:%@",error);
        [self endFooterRefreshing:self.tableV];
    }];
    
    currentPetId = [UserServe sharedUserServe].userID;
    
}

-(void)getHotShuoShuoListWithMark:(int)lastMark
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"hotList" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"no" forKey:@"userId"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",lastMark] forKey:@"pageIndex"];
    //    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    NSLog(@"Get ShuoShuo:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self.theController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"200"]) {
            if (currentID==1) {
                self.dataArray = [self getModelArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
                [self endHeaderRefreshing:self.tableV];
            }
            else{
                [self.dataArray addObjectsFromArray:[self getModelArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]]];
                [self endFooterRefreshing:self.tableV];
            }
            
            NSDictionary * dic = _dataArray.count?@{}:nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRBrowserHelperZeroData" object:self userInfo:dic];
        }
        NSLog(@"get hot shuoshuo success:%@",responseObject);
        
        //        [self cellPlayAni:self.tableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get hot shuoshuo failed error:%@",error);
        if (currentID==1) {
            [self endHeaderRefreshing:self.tableV];
        }
        else
        {
            [self endFooterRefreshing:self.tableV];
        }
    }];
}
-(void)getAttentionShuoShuoListWithMark:(NSString *)lastMark
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"focusList" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"no" forKey:@"petId"];
    if (lastMark) {
        [mDict setObject:lastMark forKey:@"id"];
    }
    
    [mDict setObject:@"10" forKey:@"pageSize"];
    //    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    NSLog(@"Get attention ShuoShuo:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self.theController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"200"]) {
            //            self.dataArray = [self getModelArray:[responseObject objectForKey:@"value"]];
            //            [self.hotTableView reloadData];
            if (!lastMark) {
                self.dataArray = [self getModelArray:[responseObject objectForKey:@"value"]];
                [self endHeaderRefreshing:self.tableV];
            }
            else{
                [self.dataArray addObjectsFromArray:[self getModelArray:[responseObject objectForKey:@"value"]]];
                [self endFooterRefreshing:self.tableV];
            }
            NSDictionary * dic = _dataArray.count?@{}:nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRBrowserHelperZeroData" object:self userInfo:dic];
        }
        NSLog(@"get attention shuoshuo success:%@",responseObject);
        [self endHeaderRefreshing:self.tableV];
        //        [self cellPlayAni:self.tableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get attention shuoshuo failed error:%@",error);
        [self endHeaderRefreshing:self.tableV];
        [self endFooterRefreshing:self.tableV];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([PublishServer sharedPublishServer].publishArray.count>0){
        //        if (self.uploadTaskArray.count>0) {
        return self.dataArray.count+1;
    }
    else
        return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&[PublishServer sharedPublishServer].publishArray.count>0) {
        //            if (self.uploadArray.count>0) {
        return 60;
    }
    else{
        TalkingBrowse * theTalking = self.dataArray[[PublishServer sharedPublishServer].publishArray.count>0?(indexPath.section-1):indexPath.section];
        return theTalking.rowHeight;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.tintColor = [UIColor clearColor];

//    NSLog(@"willllllllll");
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
//    NSLog(@"enddddddddd");
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0&&[PublishServer sharedPublishServer].publishArray.count>0) {
        return 0;
    }
    else if(self.showHead){
        return 60;
    }
    else
        return 50;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0&&[PublishServer sharedPublishServer].publishArray.count>0) {
        //            if (self.uploadArray.count>0) {
        return nil;
    }
    else
    {
        static NSString *cellIdentifier3 = @"headerSectionView";
        TimeLineSectionHeaderView*header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier3];
        if (header == nil) {
            header = [[TimeLineSectionHeaderView alloc] initWithReuseIdentifier:cellIdentifier3 showHead:self.showHead];
            header.delegate = self;
//            header.delegate = self;
            
        }
        TalkingBrowse * talking = self.dataArray[[PublishServer sharedPublishServer].publishArray.count>0?(section-1):section];
        if (!talking.ifForward) {
            header.petInfo = talking.petInfo;
            header.timeStr = talking.publishTime;
            header.ifForward = NO;
        }
        else
        {
            Pet * petInfo = [[Pet alloc] init];
            petInfo.nickname = talking.forwardInfo.forwardPetNickname;
            petInfo.petID = talking.forwardInfo.forwardPetId;
            petInfo.headImgURL = talking.forwardInfo.forwardPetAvatar;
            header.petInfo = petInfo;
            header.timeStr = talking.forwardInfo.forwardTime;
            header.ifForward = NO;
        }
        
        header.cellIndex = (int)([PublishServer sharedPublishServer].publishArray.count>0?(section-1):section);
        
        return header;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (section==0&&[PublishServer sharedPublishServer].publishArray.count>0) {
            //            if (self.uploadArray.count>0) {
            return [PublishServer sharedPublishServer].publishArray.count;
        }
        else{
            return 1;
        }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&[PublishServer sharedPublishServer].publishArray.count>0) {
        static NSString *cellIdentifier2 = @"uploadCell";
        UploadTaskTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 ];
        if (cell == nil) {
            cell = [[UploadTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        Publisher * per = [[PublishServer sharedPublishServer].publishArray objectAtIndex:indexPath.row];
        cell.publishID = per.publishID;
        cell.thumbnailImageV.image = per.thum;
        [cell setProgressSizeWithScale:per.percent];
        cell.rePublishView.hidden = !per.failure;
        [cell startAnimating];
        return cell;
        
    }
    else{
        static NSString *cellIdentifier = @"timeLineCell";
        TimeLineTalkingTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[TimeLineTalkingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withHead:self.showHead];
            cell.delegate = self;
            cell.imgdelegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellIndex = (int)([PublishServer sharedPublishServer].publishArray.count>0?(indexPath.section-1):indexPath.section);
        //        NSDictionary * dict = allarray[indexPath.row];
        if (self.dataArray.count>0) {
            cell.talking = self.dataArray[[PublishServer sharedPublishServer].publishArray.count>0?(indexPath.section-1):indexPath.section];
            cell.cellIndex = (int)([PublishServer sharedPublishServer].publishArray.count>0?(indexPath.section-1):indexPath.section);
        }
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([PublishServer sharedPublishServer].publishArray.count>0&&indexPath.section==0) {
        return;
    }
//    TalkingBrowse * talking = [self.dataArray objectAtIndex:([PublishServer sharedPublishServer].publishArray.count>0?indexPath.section-1:indexPath.section)];
//    if ([talking.theModel intValue]==2) {
//        PreviewStoryViewController * pv = [[PreviewStoryViewController alloc] init];
//        [pv loadPreviewStoryViewWithDictionary:talking];
//        [self.theController.navigationController pushViewController:pv animated:YES];
//        return;
//    }
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    talkingDV.delegate = self;
    //    talkingDV.theIndex = indexPath.row;
    talkingDV.talking = [self.dataArray objectAtIndex:([PublishServer sharedPublishServer].publishArray.count>0?indexPath.section-1:indexPath.section)];
    
    [self.theController.navigationController pushViewController:talkingDV animated:YES];
}
-(void)resendThisTaskWithTaskId:(NSString *)taskId
{
    NSDictionary * failedDict = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"FailedContent%@",[UserServe sharedUserServe].userID]];
    NSDictionary * theD = [failedDict objectForKey:taskId];
    
    NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *subdirectory = [documentsw stringByAppendingPathComponent:@"FailedFiles"];
    
    UIImage * img = [UIImage imageWithContentsOfFile:[subdirectory stringByAppendingString:[theD objectForKey:@"localImgPath"]]];
    UIImage * thumbImg = [UIImage imageWithContentsOfFile:[subdirectory stringByAppendingString:[theD objectForKey:@"localThumbImgPath"]]];
    NSData * audioData = [NSData dataWithContentsOfFile:[subdirectory stringByAppendingString:[theD objectForKey:@"localAudioPath"]]];
    NSMutableDictionary * contentDict = [NSMutableDictionary dictionaryWithDictionary:theD];
    [contentDict removeObjectForKey:@"localImgPath"];
    [contentDict removeObjectForKey:@"localThumbImgPath"];
    [contentDict removeObjectForKey:@"localAudioPath"];
    
    //    [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:[theD objectForKey:@"localImgPath"]] error:nil];
    //    [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:[theD objectForKey:@"localThumbImgPath"]] error:nil];
    //    [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:[theD objectForKey:@"localAudioPath"]] error:nil];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:taskId forKey:@"taskID"];
    [dict setObject:@"taskRemove" forKey:@"taskType"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
    
    NSMutableDictionary * toSaveD = [NSMutableDictionary dictionaryWithDictionary:failedDict];
    [toSaveD removeObjectForKey:taskId];
    [[NSUserDefaults standardUserDefaults] setObject:toSaveD forKey:[NSString stringWithFormat:@"FailedContent%@",[UserServe sharedUserServe].userID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NetServer uploadFailedShuoShuoWithImage:img ThumImg:thumbImg Audio:audioData ContentDict:contentDict Progress:nil Success:^(id responseObject, NSString *fileURL) {
        
    } failure:^(NSError *error) {
        
    }];
    
    //    UIImage * img = []
}
-(void)removeThisTaskWithTaskId:(NSString *)taskId
{
    NSDictionary * failedDict = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"FailedContent%@",[UserServe sharedUserServe].userID]];
    NSDictionary * theD = [failedDict objectForKey:taskId];
    
    NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *subdirectory = [documentsw stringByAppendingPathComponent:@"FailedFiles"];
    [[NSFileManager defaultManager] removeItemAtPath:[subdirectory stringByAppendingString:[theD objectForKey:@"localImgPath"]] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[subdirectory stringByAppendingString:[theD objectForKey:@"localThumbImgPath"]] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[subdirectory stringByAppendingString:[theD objectForKey:@"localAudioPath"]] error:nil];
    
    NSMutableDictionary * toSaveD = [NSMutableDictionary dictionaryWithDictionary:failedDict];
    [toSaveD removeObjectForKey:taskId];
    [[NSUserDefaults standardUserDefaults] setObject:toSaveD forKey:[NSString stringWithFormat:@"FailedContent%@",[UserServe sharedUserServe].userID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:taskId forKey:@"taskID"];
    [dict setObject:@"taskRemove" forKey:@"taskType"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
}
-(NSMutableArray *)getModelArray:(NSArray *)array
{
    NSMutableArray * hArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        TalkingBrowse * talking = [[TalkingBrowse alloc] initWithHostInfo:[array objectAtIndex:i]];
        talking.rowHeight = [TimeLineTalkingTableViewCell heightForRowWithTalking:talking CellType:0];
        
        [hArray addObject:talking];
    }
    return hArray;
}

- (void)commentWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    talkingDV.delegate = self;
    talkingDV.commentStyle = commentStyleComment;
    talkingDV.talking = talkingBrowse;
    [self.theController.navigationController pushViewController:talkingDV animated:YES];
    NSLog(@"the talking ID:%@",talkingBrowse.theID);
}
- (void)zanWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"interaction" forKey:@"command"];
    [mDict setObject:@"create" forKey:@"options"];
    [mDict setObject:talkingBrowse.theID forKey:@"petalkId"];
    [mDict setObject:@"F" forKey:@"type"];
    [mDict setObject:currentPetId forKey:@"userId"];
    
    
    NSLog(@"doFavor:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self.theController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        talkingBrowse.ifZan = YES;
        NSLog(@"favor success:%@",responseObject);
        if ([responseObject objectForKey:@"message"]) {
            if([[responseObject objectForKey:@"message"] rangeOfString:@"("].location !=NSNotFound)
            {
                [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
            }
            else{
                
            }
            NSDictionary * dic = _dataArray.count?@{}:nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRBrowserHelperZeroData" object:self userInfo:dic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"favor error:%@",error);
        
    }];
    
}
- (void)shareWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    ShareSheet * shareSheet = [[ShareSheet alloc]initWithIconArray:@[@"weiChatFriend",@"friendCircle",@"sina",@"qq",@"petaking"] titleArray:@[@"微信好友",@"朋友圈",@"微博",@"QQ",@"宠物说"] action:^(NSInteger index) {
        switch (index) {
            case 0:{
                [ShareServe shareToWeixiFriendWithTitle:[NSString stringWithFormat:@"听%@的宠物说",talkingBrowse.petInfo.nickname] Content:[NSString stringWithFormat:@"听,爱宠有话说。分享自%@的宠物说:\"%@\"",talkingBrowse.petInfo.nickname,talkingBrowse.descriptionContent] imageUrl:talkingBrowse.thumbImgUrl webUrl:[NSString stringWithFormat:SHAREBASEURL@"%@",talkingBrowse.theID] Succeed:^{
                    [ShareServe shareNumberUpWithPetalkId:talkingBrowse.theID];
                }];
            }break;
            case 1:{
                [ShareServe shareToFriendCircleWithTitle:[NSString stringWithFormat:@"听%@的宠物说",talkingBrowse.petInfo.nickname] Content:[NSString stringWithFormat:@"听,爱宠有话说。分享自%@的宠物说:\"%@\"",talkingBrowse.petInfo.nickname,talkingBrowse.descriptionContent] imageUrl:talkingBrowse.thumbImgUrl webUrl:[NSString stringWithFormat:SHAREBASEURL@"%@",talkingBrowse.theID] Succeed:^{
                    [ShareServe shareNumberUpWithPetalkId:talkingBrowse.theID];
                }];
            }break;
            case 2:{
                [ShareServe shareToSineWithContent:[NSString stringWithFormat:@"听,爱宠有话说。分享自%@的宠物说:\"%@\"%@%@",talkingBrowse.petInfo.nickname,talkingBrowse.descriptionContent,SHAREBASEURL,talkingBrowse.theID] imageUrl:talkingBrowse.thumbImgUrl Succeed:^{
                    [ShareServe shareNumberUpWithPetalkId:talkingBrowse.theID];
                }];
            }break;
            case 3:{
                [ShareServe shareToQQWithTitle:[NSString stringWithFormat:@"听%@的宠物说",talkingBrowse.petInfo.nickname] Content:[NSString stringWithFormat:@"听,爱宠有话说。分享自%@的宠物说:\"%@\"",talkingBrowse.petInfo.nickname,talkingBrowse.descriptionContent] imageUrl:talkingBrowse.thumbImgUrl webUrl:[NSString stringWithFormat:SHAREBASEURL@"%@",talkingBrowse.theID] Succeed:^{
                    [ShareServe shareNumberUpWithPetalkId:talkingBrowse.theID];
                }];
            }break;
            case 4:{
                TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
                talkingDV.delegate = self;
                talkingDV.commentStyle = commentStyleForward;
                talkingDV.talking = talkingBrowse;
                [self.theController.navigationController pushViewController:talkingDV animated:YES];
            }break;
            default:
                break;
        }
        
    }];
    [shareSheet show];
}
-(void)tagBtnClickedWithTagId:(NSDictionary *)tagId
{
    TagTalkListViewController * tagTlistV = [[TagTalkListViewController alloc] init];
    tagTlistV.title = [tagId objectForKey:@"name"];
    Tag * theTag = [[Tag alloc] init];
    theTag.tagID = [tagId objectForKey:@"id"];
    theTag.tagName = [tagId objectForKey:@"name"];
    theTag.backGroundURL = [tagId objectForKey:@"bgUrl"];
    tagTlistV.tag = theTag;
    tagTlistV.shouldRequestTagInfo = YES;
    [self.theController.navigationController pushViewController:tagTlistV animated:YES];
}

-(void)locationWithTalkingBrowse:(TalkingBrowse *)talkingBrowse
{
    MapViewController * mapV = [[MapViewController alloc] init];
    mapV.lat = talkingBrowse.location.lat;
    mapV.lon = talkingBrowse.location.lon;
    mapV.thumbImgUrl = talkingBrowse.thumbImgUrl;
    mapV.contentStr = talkingBrowse.descriptionContent;
    mapV.publisher = talkingBrowse.petInfo.nickname;
    mapV.talking = talkingBrowse;
    [self.theController.navigationController pushViewController:mapV animated:YES];
    
}

- (void)petProfileWhoPublishTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingBrowse.petInfo.petID;
    pv.petAvatarUrlStr = talkingBrowse.petInfo.headImgURL;
    pv.petNickname = talkingBrowse.petInfo.nickname;
    pv.relationShip = talkingBrowse.relationShip;
//    pv.delegate = self;
    [self.theController.navigationController pushViewController:pv animated:YES];
}


- (void)headerClicked:(NSString *)petId
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
//    Pet * pet = [[Pet alloc] init];
//    pet.petID = petId;
    pv.petId = petId;
    //    pv.relationShip = talkingBrowse.relationShip;
    [self.theController.navigationController pushViewController:pv animated:YES];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if (!self.needScrollTopDelegate) {
        return;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
//    [self.theController.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    isDragging = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollit)]) {
        [self.delegate scrollit];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self cellPlayAni:self.tableV];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    dragging = NO;
    if ([scrollView isDecelerating]) {
        return;
    }
    [self cellPlayAni:self.tableV];
//    isDragging = NO;
}
-(void)animationStopAfterRefreshing
{
    [self cellPlayAni:self.tableV];
}
-(void)animationStopAfterRefreshingFooter
{
    [self cellPlayAni:self.tableV];
}

-(void)cellPlayAni:(UIScrollView *)scrollView
{

    if (!self.iamActive) {
        return;
    }
//    NSLog(@"isDEEEEEEEEEEEEEING:%d",scrollView.decelerating);
    for (int i = 0; i<self.dataArray.count; i++) {
        NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:[PublishServer sharedPublishServer].publishArray.count>0?(i+1):i];
        if (([PublishServer sharedPublishServer].publishArray&&[PublishServer sharedPublishServer].publishArray.count>0)&&indexPathTo.section==0) {
            return;
        }
        TimeLineTalkingTableViewCell * cell = (TimeLineTalkingTableViewCell *)[self.tableV cellForRowAtIndexPath:indexPathTo];
        //            tempCell = [cell copy];
        EGOImageButton * cV = cell.contentImageV;
        if ([cell.talking.theModel isEqualToString:@"1"]||[cell.talking.theModel isEqualToString:@"2"]) {
            return;
        }
        CGRect rect = [self.theView convertRect:cV.frame fromView:cell.contentView];
        if (rect.origin.y>0&&rect.origin.y+rect.size.height<self.theView.frame.size.height) {
            currentCellIndex = (int)indexPathTo.section;
            if (![TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName]) {
                cell.aniImageV.hidden = YES;
                [NetServer downloadZipFileWithUrl:cell.talking.playAnimationImg.fileUrlStr ZipName:[NSString stringWithFormat:@"%@.%@",cell.talking.playAnimationImg.fileName,cell.talking.playAnimationImg.fileType] Success:^(NSString *zipfileName) {
                    if (![[NSString stringWithFormat:@"%@.%@",cell.talking.playAnimationImg.fileName,cell.talking.playAnimationImg.fileType] isEqualToString:zipfileName]) {
                        return;
                    }
                    cell.aniImageV.hidden = NO;
                    cell.aniImageV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
                    cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
                    cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
                    cell.aniImageV.transform = CGAffineTransformIdentity;
                    cell.aniImageV.layer.transform = CATransform3DIdentity;
                    
                    [cell.aniImageV setFrame:CGRectMake(0, 0, cell.talking.playAnimationImg.width*cell.contentImageV.frame.size.width, cell.talking.playAnimationImg.height*cell.contentImageV.frame.size.width)];
                    cell.aniImageV.center = CGPointMake(cell.talking.playAnimationImg.centerX*cell.contentImageV.frame.size.width, cell.talking.playAnimationImg.centerY*cell.contentImageV.frame.size.width);
                    cell.aniImageV.transform = CGAffineTransformRotate(cell.aniImageV.transform, cell.talking.playAnimationImg.rotationZ);
                    
                } failure:^(NSError *error) {
                    
                }];
                
            }
            else
            {
                cell.aniImageV.hidden = NO;
                cell.aniImageV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
                cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
                cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
                cell.aniImageV.transform = CGAffineTransformIdentity;
                cell.aniImageV.layer.transform = CATransform3DIdentity;
                
                [cell.aniImageV setFrame:CGRectMake(0, 0, cell.talking.playAnimationImg.width*cell.contentImageV.frame.size.width, cell.talking.playAnimationImg.height*cell.contentImageV.frame.size.width)];
                cell.aniImageV.center = CGPointMake(cell.talking.playAnimationImg.centerX*cell.contentImageV.frame.size.width, cell.talking.playAnimationImg.centerY*cell.contentImageV.frame.size.width);
                cell.aniImageV.transform = CGAffineTransformRotate(cell.aniImageV.transform, cell.talking.playAnimationImg.rotationZ);

            }
        }
    }
}
-(void)ImagesLoadedCellIndex:(int)cellIndex
{
    if (cellIndex==currentCellIndex) {
        NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
        if (([PublishServer sharedPublishServer].publishArray&&[PublishServer sharedPublishServer].publishArray.count>0)&&indexPathTo.section==0) {
            return;
        }
        TimeLineTalkingTableViewCell * cell = (TimeLineTalkingTableViewCell *)[self.tableV cellForRowAtIndexPath:indexPathTo];
        //            tempCell = [cell copy];
        EGOImageButton * cV = cell.contentImageV;
        if ([cell.talking.theModel isEqualToString:@"1"]||[cell.talking.theModel isEqualToString:@"2"]) {
            return;
        }
        CGRect rect = [self.theView convertRect:cV.frame fromView:cell.contentView];
        if (rect.origin.y>0&&rect.origin.y+rect.size.height<self.theView.frame.size.height) {
            currentCellIndex = (int)indexPathTo.section;
            if (![TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName]) {
                cell.aniImageV.hidden = YES;
                [NetServer downloadZipFileWithUrl:cell.talking.playAnimationImg.fileUrlStr ZipName:[NSString stringWithFormat:@"%@.%@",cell.talking.playAnimationImg.fileName,cell.talking.playAnimationImg.fileType] Success:^(NSString *zipfileName) {
                    if (![[NSString stringWithFormat:@"%@.%@",cell.talking.playAnimationImg.fileName,cell.talking.playAnimationImg.fileType] isEqualToString:zipfileName]) {
                        return;
                    }
                    cell.aniImageV.hidden = NO;
                    cell.aniImageV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
                    cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
                    cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
                    cell.aniImageV.transform = CGAffineTransformIdentity;
                    cell.aniImageV.layer.transform = CATransform3DIdentity;
                    
                    [cell.aniImageV setFrame:CGRectMake(0, 0, cell.talking.playAnimationImg.width*cell.contentImageV.frame.size.width, cell.talking.playAnimationImg.height*cell.contentImageV.frame.size.width)];
                    cell.aniImageV.center = CGPointMake(cell.talking.playAnimationImg.centerX*cell.contentImageV.frame.size.width, cell.talking.playAnimationImg.centerY*cell.contentImageV.frame.size.width);
                    cell.aniImageV.transform = CGAffineTransformRotate(cell.aniImageV.transform, cell.talking.playAnimationImg.rotationZ);
                    
                } failure:^(NSError *error) {
                    
                }];
                
            }
            else
            {
                cell.aniImageV.hidden = NO;
                cell.aniImageV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
                cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
                cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
                cell.aniImageV.transform = CGAffineTransformIdentity;
                cell.aniImageV.layer.transform = CATransform3DIdentity;
                
                [cell.aniImageV setFrame:CGRectMake(0, 0, cell.talking.playAnimationImg.width*cell.contentImageV.frame.size.width, cell.talking.playAnimationImg.height*cell.contentImageV.frame.size.width)];
                cell.aniImageV.center = CGPointMake(cell.talking.playAnimationImg.centerX*cell.contentImageV.frame.size.width, cell.talking.playAnimationImg.centerY*cell.contentImageV.frame.size.width);
                cell.aniImageV.transform = CGAffineTransformRotate(cell.aniImageV.transform, cell.talking.playAnimationImg.rotationZ);
                
            }
        }
        
    }
}
-(void)changeCommentArrayWithTalking:(TalkingBrowse *)talkingBrowser
{
    //    for (int i = 0; i<self.dataArray.count; i++) {
    //        TalkingBrowse * talking = self.dataArray[i];
    //        if ([talking.theID isEqualToString:talkingBrowser.theID]) {
    //            [self.dataArray replaceObjectAtIndex:i withObject:talking];
    //        }
    //    }
    [self.tableV reloadData];
}
-(void)shuoshuoDeletedSuccessWithIndex:(NSString *)shuoshuoId
{
    int aa = -1;
    for (int i = 0; i<self.dataArray.count; i++) {
        TalkingBrowse * talking = self.dataArray[i];
        if ([talking.theID isEqualToString:shuoshuoId]) {
            aa = i;
        }
    }
    if (aa!=-1) {
        [self.dataArray removeObjectAtIndex:aa];
        [self.tableV reloadData];
    }
}
@end
