//
//  BrowserTableHelper.m
//  TalkingPet
//
//  Created by Tolecen on 14/8/14.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BrowserTableHelper.h"
#import "BrowserForwardedTalkingTableViewCell.h"
#import "EGOImageButton.h"
#import "ShareSheet.h"
#import "GTScrollNavigationBar.h"
#import "PreviewStoryViewController.h"
//#import "SQTShyNavigationBar.h"
@implementation BrowserTableHelper
-(id)initWithController:(UIViewController *)thexController Tableview:(UITableView *)theTable SectionView:(UIView *)sectionV
{
    if (self = [super init]) {
//        self.canJudgePlay = YES;
        self.needScrollTopDelegate = NO;
        footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
        footerV.backgroundColor = [UIColor clearColor];
        self.theController = thexController;
        self.theView = thexController.view;
        if (sectionV) {
            self.sectionView = sectionV;
        }
        self.iamActive = YES;
        self.needShowZanAndComment = YES;
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
        
        currentID = 0;
        
        self.footerShouldDelegateToUserCenter = NO;
        
        [self.tableV addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
        self.tableV.header.delegate = self;
        //        [self.tableV headerBeginRefreshing];
        [self.tableV addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
        self.tableV.footer.delegate = self;
        
//        if(self.tableV){
//            if (self.theController.navigationController.navigationBar.isOpaque){
//                float topInset = self.theController.navigationController.navigationBar.frame.size.height;
//                
//                self.tableV.contentInset = UIEdgeInsetsMake(topInset + self.tableV.contentInset.top,
//                                                                             self.tableV.contentInset.left,
//                                                                             self.tableV.contentInset.bottom,
//                                                                             self.tableV.contentInset.right);
//            }
//            self.originalInsets = self.tableV.contentInset;
//        }
    }
    return self;
}
-(void)animationStopAfterRefreshing
{
    [self cellPlayAni:self.tableV];
}
-(void)animationStopAfterRefreshingFooter
{
    [self cellPlayAni:self.tableV];
}
- (void)tableViewHeaderRereshing:(UITableView *)tableView
{
//    self.canJudgePlay = YES;
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
    
    //    if (self.tableViewType==TableViewTypeHot) {
    //        currentID=0;
    //        [self getHotShuoShuoListWithMark:currentID];
    //    }
    //    else
    //    {
    ////        lastId = nil;
    //        [self getAttentionShuoShuoListWithMark:nil];
    //    }
    //    [self performSelector:@selector(endHotHeaderRefreshing:) withObject:tableView afterDelay:2];
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
    //    if (self.tableViewType==TableViewTypeHot) {
    //        currentID++;
    //        [self getHotShuoShuoListWithMark:currentID];
    //    }
    //    else
    //    {
    //        TalkingBrowse * tb = [self.dataArray lastObject];
    //        lastId = tb.listId;
    //        [self getAttentionShuoShuoListWithMark:lastId];
    //    }
    //    [self loadDataWithLastMark:currentID];
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
-(void)loadDataWithLastMark:(int)lastMark
{
    if (self.tableViewType==TableViewTypeHot) {
        [self getHotShuoShuoListWithMark:lastMark];
    }
    else if (self.tableViewType==TableViewTypeAttention){
        [self getAttentionShuoShuoListWithMark:nil];
    }
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
    //    if ([theDict objectForKey:@"petId"]) {
    //        if (![[theDict objectForKey:@"petId"] isEqualToString:currentPetId]) {
    //            if ([UserServe sharedUserServe].userID) {
    //                [theDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    //            }
    //
    //        }
    //    }
    
    self.reqDict = theDict;
    [NetServer requestWithParameters:theDict Controller:self.theController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"value"] isKindOfClass:[NSDictionary class]]) {
            self.dataArray = [self getModelArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
            self.usePage = YES;
            if ([[self.reqDict objectForKey:@"options"] isEqualToString:@"hotList"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"value"] objectForKey:@"list"] forKey:[NSString stringWithFormat:@"hotList%@",[UserServe sharedUserServe].userID]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:self.reqDict forKey:[NSString stringWithFormat:@"hotListReqDict%@",[UserServe sharedUserServe].userID]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            if ([self.delegate respondsToSelector:@selector(resultCount:)]) {
                [self.delegate resultCount:(int)self.dataArray.count];
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
        }
        NSDictionary * dic = _dataArray.count?@{}:nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRBrowserHelperZeroData" object:self userInfo:dic];
        if (self.dataArray.count>0) {
            self.firPageLoaded = YES;
        }
        [self endHeaderRefreshing:self.tableV];
        
//        NSLog(@"get hot shuoshuo success:%@",responseObject);
        
        NSString * playMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"playmodeofaudio"];
        if (!playMode) {
            //                    [[NSUserDefaults standardUserDefaults] setObject:@"always" forKey:@"playmodeofaudio"];
            //                    [[NSUserDefaults standardUserDefaults] synchronize];
            NSString * fisrt = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
            if (fisrt) {
                [self showSetPlayView];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get hot shuoshuo failed error:%@",error);
        [self endHeaderRefreshing:self.tableV];
        if ([error code]==503) {
            [self loadFirstDataPageWithDict:self.reqDict];
        }
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
    //    if ([self.reqDict objectForKey:@"petId"]) {
    //        if (![[self.reqDict objectForKey:@"petId"] isEqualToString:currentPetId]) {
    //            if ([UserServe sharedUserServe].userID) {
    //                [self.reqDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    //            }
    //        }
    //    }
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
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"no" forKey:@"petId"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",lastMark] forKey:@"pageIndex"];
    //    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    NSLog(@"Get ShuoShuo:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self.theController success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"200"]) {
            if (currentID==0) {
                self.dataArray = [self getModelArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
                [self endHeaderRefreshing:self.tableV];
            }
            else{
                [self.dataArray addObjectsFromArray:[self getModelArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]]];
                [self endFooterRefreshing:self.tableV];
            }
            NSDictionary * dic = _dataArray.count?@{}:nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRBrowserHelperZeroData" object:self userInfo:dic];
            //            [self.hotTableView reloadData];
        }
        NSLog(@"get hot shuoshuo success:%@",responseObject);
        
//        [self cellPlayAni:self.tableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get hot shuoshuo failed error:%@",error);
        if (currentID==0) {
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
-(NSMutableArray *)getModelArray:(NSArray *)array
{
    NSMutableArray * hArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        TalkingBrowse * talking = [[TalkingBrowse alloc] initWithHostInfo:[array objectAtIndex:i]];
        talking.rowHeight = [BrowserForwardedTalkingTableViewCell heightForRowWithTalking:talking CellType:0];
        [hArray addObject:talking];
    }
    return hArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.canJudgePlay = YES;
    TalkingBrowse * theTalking = self.dataArray[indexPath.section];
    if (indexPath.row==0) {
        return theTalking.rowHeight;
    }
    else if (indexPath.row==1){
        if (theTalking.showZanArray.count>0) {
            return 35;
        }
        else
        {
            if (theTalking.showCommentArray.count>1) {
                return 93;
            }
            else
                return 63;
        }
    }
    else
    {
        if (theTalking.showCommentArray.count>1) {
            return 93;
        }
        else
            return 63;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return footerV;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (self.sectionView) {
//        return self.sectionView;
//    }
//    else
//        return nil;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TalkingBrowse * theTalking = self.dataArray[section];
    if (theTalking.showCommentArray.count>0&&theTalking.showZanArray.count>0&&self.needShowZanAndComment) {
        return 3;
    }
    else if ((theTalking.showCommentArray.count>0&&theTalking.showZanArray.count==0&&self.needShowZanAndComment)||(theTalking.showCommentArray.count==0&&theTalking.showZanArray.count>0&&self.needShowZanAndComment)){
        return 2;
    }
    else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkingBrowse * theTalking = self.dataArray[indexPath.section];
    if (indexPath.row==0) {
        static NSString *cellIdentifier = @"talkingCell";
        BrowserForwardedTalkingTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[BrowserForwardedTalkingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault CellType:TalkCellTypeClearColorList reuseIdentifier:cellIdentifier];
            cell.delegate = self;
            cell.imgdelegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArray.count>0) {
            cell.talking = theTalking;
            cell.cellIndex = indexPath.section;
        }
        cell.needShowPublishTime = self.cellNeedShowPublishTime;
        
        return cell;
    }
    else if (indexPath.row==1){
        if (theTalking.showZanArray.count>0) {
            static NSString *cellIdentifier2 = @"zanCell";
            BowserZanTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 ];
            if (cell == nil) {
                cell = [[BowserZanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
                cell.delegate = self;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.favorNum = theTalking.favorNum;
            cell.showZanArray = theTalking.showZanArray;
            return cell;
        }
        else
        {
            static NSString *cellIdentifier3 = @"commentGCell";
            BrowserCommentTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3 ];
            if (cell == nil) {
                cell = [[BrowserCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
                cell.delegate = self;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.commentNum = theTalking.commentNum;
            cell.showCommentArray = theTalking.showCommentArray;
            return cell;
        }
    }
    else
    {
        static NSString *cellIdentifier3 = @"commentGCell";
        BrowserCommentTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3 ];
        if (cell == nil) {
            cell = [[BrowserCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.commentNum = theTalking.commentNum;
        cell.showCommentArray = theTalking.showCommentArray;
        return cell;
    }
    

}
-(void)resendThisTaskWithTaskId:(NSString *)taskId
{
    NSDictionary * failedDict = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"FailedContent%@",[UserServe sharedUserServe].userID]];
    NSDictionary * theD = [failedDict objectForKey:taskId];
    
    NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *subdirectoryw = [documentsw stringByAppendingPathComponent:@"FailedFiles"];
    
    UIImage * img = [UIImage imageWithContentsOfFile:[subdirectoryw stringByAppendingString:[theD objectForKey:@"localImgPath"]]];
    UIImage * thumbImg = [UIImage imageWithContentsOfFile:[subdirectoryw stringByAppendingString:[theD objectForKey:@"localThumbImgPath"]]];
    NSData * audioData = [NSData dataWithContentsOfFile:[subdirectoryw stringByAppendingString:[theD objectForKey:@"localAudioPath"]]];
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
    NSString *subdirectoryw = [documentsw stringByAppendingPathComponent:@"FailedFiles"];
    [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:[theD objectForKey:@"localImgPath"]] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:[theD objectForKey:@"localThumbImgPath"]] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:[theD objectForKey:@"localAudioPath"]] error:nil];
    
    NSMutableDictionary * toSaveD = [NSMutableDictionary dictionaryWithDictionary:failedDict];
    [toSaveD removeObjectForKey:taskId];
    [[NSUserDefaults standardUserDefaults] setObject:toSaveD forKey:[NSString stringWithFormat:@"FailedContent%@",[UserServe sharedUserServe].userID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:taskId forKey:@"taskID"];
    [dict setObject:@"taskRemove" forKey:@"taskType"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskReceived" object:dict];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    isDecelerating = YES;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"ssssswwww");
    isDecelerating = NO;
    [self cellPlayAni:self.tableV];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    self.canJudgePlay = YES;
//    NSLog(@"xxxx");
//    dragging = YES;
//    isDecelerating = YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    dragging = NO;
    if ([scrollView isDecelerating]) {
        return;
    }
    [self cellPlayAni:self.tableV];
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self stopAudio];
    if (!self.needScrollTopDelegate) {
        return;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
//        if (self.theController.navigationController.scrollNavigationBar.scrollView) {
//                [self.theController.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
//        }

    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_delegate&& [_delegate respondsToSelector:@selector(scrollit)]) {
        [_delegate scrollit];
    }
    

    /*
    if (!dragging&&!isDecelerating) {
        return;
    }
    if(self.tableV != scrollView)
        return;
    if(scrollView.frame.size.height >= scrollView.contentSize.height)
        return;
    
    NSLog(@"contentOffsetY:%f",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y >= -self.theController.navigationController.navigationBar.frame.size.height && scrollView.contentOffset.y <= 0){
        NSLog(@"1111111111");
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y + [UIApplication sharedApplication].statusBarFrame.size.height,
                                                   self.originalInsets.left,
                                                   self.originalInsets.bottom, self.originalInsets.right);
    }
    else if(scrollView.contentOffset.y >= scrollView.contentInset.top)
    {
        NSLog(@"2222222222");
        scrollView.contentInset = self.originalInsets;
    }
    NSLog(@"contentInset:%@",NSStringFromUIEdgeInsets(scrollView.contentInset));
    if(lastOffsetY < scrollView.contentOffset.y && scrollView.contentOffset.y >= -self.theController.navigationController.navigationBar.frame.size.height){//moving up
//        NSLog(@"upupupup");
//        self.naviH = 0;
        if(self.theController.navigationController.navigationBar.frame.size.height + self.theController.navigationController.navigationBar.frame.origin.y  > 0){//not yet hidden
            float newY = self.theController.navigationController.navigationBar.frame.origin.y - (scrollView.contentOffset.y - lastOffsetY);
            if(newY < -self.theController.navigationController.navigationBar.frame.size.height)
                newY = -self.theController.navigationController.navigationBar.frame.size.height;
            self.theController.navigationController.navigationBar.frame = CGRectMake(self.theController.navigationController.navigationBar.frame.origin.x,
                                                                       newY,
                                                                       self.theController.navigationController.navigationBar.frame.size.width,
                                                                       self.theController.navigationController.navigationBar.frame.size.height);
        }
    }else
        if(self.theController.navigationController.navigationBar.frame.origin.y < [UIApplication sharedApplication].statusBarFrame.size.height  &&
           (self.tableV.contentSize.height > self.tableV.contentOffset.y + self.tableV.frame.size.height)){//not yet shown
//            NSLog(@"downdown");
//            self.naviH = 64;
            float newY = self.theController.navigationController.navigationBar.frame.origin.y + (lastOffsetY - scrollView.contentOffset.y);
            if(newY > [UIApplication sharedApplication].statusBarFrame.size.height)
                newY = [UIApplication sharedApplication].statusBarFrame.size.height;
            self.theController.navigationController.navigationBar.frame = CGRectMake(self.theController.navigationController.navigationBar.frame.origin.x,
                                                                       newY,
                                                                       self.theController.navigationController.navigationBar.frame.size.width,
                                                                       self.theController.navigationController.navigationBar.frame.size.height);
        }
    NSLog(@"heighttttttttt:%@",NSStringFromCGRect(self.theController.navigationController.navigationBar.frame));
    if ([self.delegate respondsToSelector:@selector(naviOriginY:)]) {
        [self.delegate naviOriginY:self.theController.navigationController.navigationBar.frame.origin.y];
    }
    lastOffsetY = scrollView.contentOffset.y;
 */
}

-(void)ImagesLoadedCellIndex:(int)cellIndex
{
    if (cellIndex==currentCellIndex) {
        if (!self.isInfont||self.isRefreshing) {
            return;
        }
//        if (![SystemServer sharedSystemServer].canPlayAudio) {
//            return;
//        }
        if (self.footerShouldDelegateToUserCenter) {
            return;
        }
        NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
        if ((self.uploadArray&&self.uploadArray.count>0)&&indexPathTo.section==0) {
            return;
        }
        BrowserForwardedTalkingTableViewCell * cell = (BrowserForwardedTalkingTableViewCell *)[self.tableV cellForRowAtIndexPath:indexPathTo];
        //            tempCell = [cell copy];
        EGOImageButton * cV = cell.contentImgV;
        CGRect rect = [self.theView convertRect:cV.frame fromView:cell.contentView];
        if (rect.origin.y>0&&rect.origin.y+rect.size.height<self.theView.frame.size.height) {
            
            currentCellIndex = (int)indexPathTo.section;
            if (![cell.aniImageV isAnimating]) {
                [self playOrDownloadForCell:cell PlayBtnClicked:NO];
            }
            
        }
    
    }
}
-(void)cellPlayAni:(UIScrollView *)scrollView
{
    if (!self.iamActive) {
        return;
    }
    if (!self.isInfont||self.isRefreshing) {
        return;
    }
//    if (![SystemServer sharedSystemServer].canPlayAudio) {
//        return;
//    }
    if (self.footerShouldDelegateToUserCenter) {
        return;
    }
    int a = 0;
    
    for (int i = 0; i<self.dataArray.count; i++) {
        NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:i];
        if ((self.uploadArray&&self.uploadArray.count>0)&&indexPathTo.section==0) {
            return;
        }
        BrowserForwardedTalkingTableViewCell * cell = (BrowserForwardedTalkingTableViewCell *)[self.tableV cellForRowAtIndexPath:indexPathTo];
        //            tempCell = [cell copy];
        EGOImageButton * cV = cell.contentImgV;
        CGRect rect = [self.theView convertRect:cV.frame fromView:cell.contentView];
        if (rect.origin.y>0&&rect.origin.y+rect.size.height<self.theView.frame.size.height) {
            //                NSLog(@"row%d",i);
            a = 1;
//            NSLog(@"recty:%f,viewFrameheight:%f,navih:%f",rect.origin.y,self.theView.frame.size.height,self.naviH);
            //                dispatch_queue_t queue = dispatch_queue_create("com.pet.playAni", NULL);
            //                dispatch_async(queue, ^{
            currentCellIndex = (int)indexPathTo.section;
            [self playOrDownloadForCell:cell PlayBtnClicked:NO];
            
            /********** 源代码，注释于2014-11-14
            
            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
            NSString *subdirectory = [documents stringByAppendingPathComponent:@"Audios"];
            
            //                    NSArray * g = [cell.talking.audioUrl componentsSeparatedByString:@"/"];
            NSString *audioPath = [subdirectory stringByAppendingPathComponent:cell.talking.audioName];
            
            NSFileManager *fm = [NSFileManager defaultManager];
            
            
            
            
            
            
            if ([TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName]&&[fm fileExistsAtPath:audioPath]) {
                cell.aniImageV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
                cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
                cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
                
                if (![SystemServer sharedSystemServer].autoPlay) {
                    return;
                }
                
                
                
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
                self.audioPlayer = [XHAudioPlayerHelper shareInstance];
                [self.audioPlayer setDelegate:self];
                [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
                
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
                        
                        [cell.aniImageV setFrame:CGRectMake(0, 0, cell.talking.playAnimationImg.width*((cell.talkCellType==TalkCellTypeDetailPage)?320:300), cell.talking.playAnimationImg.height*((cell.talkCellType==TalkCellTypeDetailPage)?320:300))];
                        cell.aniImageV.center = CGPointMake(cell.talking.playAnimationImg.centerX*((cell.talkCellType==TalkCellTypeDetailPage)?320:300), cell.talking.playAnimationImg.centerY*((cell.talkCellType==TalkCellTypeDetailPage)?320:300));
                        cell.aniImageV.transform = CGAffineTransformRotate(cell.aniImageV.transform, cell.talking.playAnimationImg.rotationZ);
                        if([fm fileExistsAtPath:audioPath]){
                            
                            if (![SystemServer sharedSystemServer].autoPlay) {
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
                            self.audioPlayer = [XHAudioPlayerHelper shareInstance];
                            [self.audioPlayer setDelegate:self];
                            [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
                            
                            //                                    dispatch_async(dispatch_get_main_queue(), ^{
                            if (![cell.aniImageV isAnimating]) {
                                [cell.aniImageV startAnimating];
                                
                            }
                            
                            //                                    });
                        }
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }
                
                if (![SystemServer sharedSystemServer].autoPlay) {
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
                                currentPlayingUrl = cell.talking.audioUrl;
                                self.audioPlayer = [XHAudioPlayerHelper shareInstance];
                                [self.audioPlayer setDelegate:self];
                                [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
                                //                                        dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (![cell.aniImageV isAnimating]) {
                                    cell.aniImageV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
                                    cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
                                    cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
                                    cell.aniImageV.transform = CGAffineTransformIdentity;
                                    cell.aniImageV.layer.transform = CATransform3DIdentity;
                                    
                                    [cell.aniImageV setFrame:CGRectMake(0, 0, cell.talking.playAnimationImg.width*((cell.talkCellType==TalkCellTypeDetailPage)?320:300), cell.talking.playAnimationImg.height*((cell.talkCellType==TalkCellTypeDetailPage)?320:300))];
                                    cell.aniImageV.center = CGPointMake(cell.talking.playAnimationImg.centerX*((cell.talkCellType==TalkCellTypeDetailPage)?320:300), cell.talking.playAnimationImg.centerY*((cell.talkCellType==TalkCellTypeDetailPage)?320:300));
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
             
             源代码，注释于2014-11-14 **********/
            
        }
        
         
        
    }
    
    if (a==0) {
        [self stopAudio];
    }
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
-(void)attentionBtnClicked:(UITableViewCell *)cell
{
    btcell = (BrowserForwardedTalkingTableViewCell *)cell;
    
}
-(void)playOrDownloadForCell:(UITableViewCell *)cellTo PlayBtnClicked:(BOOL)playBtnClicked
{

//    if (!self.canJudgePlay) {
//        return;
//    }
    BrowserForwardedTalkingTableViewCell *cell = (BrowserForwardedTalkingTableViewCell *)cellTo;
    btcell = cell;
    if ([cell.talking.theModel isEqualToString:@"1"]||[cell.talking.theModel isEqualToString:@"2"]) {
        return;
    }
    //            tempCell = [cell copy];
//    EGOImageButton * cV = cell.contentImgV;
//    if ([self.audioPlayer isPlaying]) {
//        [self.audioPlayer stopAudio];
//    }
    if (![currentPlayingUrl isEqualToString:cell.talking.audioUrl]&&[self.audioPlayer isPlaying]) {
        [self.audioPlayer stopAudio];
    }
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
        NSString *subdirectory = [documents stringByAppendingPathComponent:@"Audios"];
        
        //                    NSArray * g = [cell.talking.audioUrl componentsSeparatedByString:@"/"];
        NSString *audioPath = [subdirectory stringByAppendingPathComponent:cell.talking.audioName];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        
        
        
        
        
        if ([TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName]&&[fm fileExistsAtPath:audioPath]) {
            if (![cell.aniImageV isAnimating]) {
                cell.aniImageV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
                cell.aniImageV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
                cell.aniImageV.animationDuration = cell.aniImageV.animationImages.count*0.15;
            }
            
            
            if (![SystemServer sharedSystemServer].autoPlay&&!playBtnClicked) {
                return;
            }
            if (![cell.contentImgV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]]) {
                return;
                
            }
//            if (![cell.contentImgV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]]) {
//                return;
//                
//            }
            [cell hideLoading];
//            EGOImageButton * cV = cell.contentImgV;
//            CGRect rect = [self.theView convertRect:cV.frame fromView:cell.contentView];
//            if (rect.origin.y>(self.naviH==0?120:-10)&&rect.origin.y+rect.size.height<self.theView.frame.size.height-self.naviH) {
            
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
//            [btcell reSetProgressViewProgress];
            NSLog(@"cutrrent Time:%f,duration:%f",self.audioPlayer.player.currentTime,self.audioPlayer.player.duration);
            if ([audioDurationTimer isValid]) {
                [audioDurationTimer invalidate];
            }
            audioDurationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playTimerDo) userInfo:nil repeats:YES];
            [audioDurationTimer fire];
//            }
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
                            NSLog(@"returned111");
                            return;
                        }
                        if (![cell.contentImgV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]]) {
                            NSLog(@"returned111222");
                            return;
                            
                        }
                        
                        [cell hideLoading];
                        if ([currentPlayingUrl isEqualToString:cell.talking.audioUrl]&&[self.audioPlayer isPlaying]) {
                            NSLog(@"returned111333");
                            return;
                        }
                        else{
                            //                                        [self.audioPlayer stopAudio];
                        }
                        
//                        EGOImageButton * cV = cell.contentImgV;
//                        CGRect rect = [self.theView convertRect:cV.frame fromView:cell.contentView];
//                        if (rect.origin.y>(self.naviH==0?120:-10)&&rect.origin.y+rect.size.height<self.theView.frame.size.height-self.naviH) {
                            currentPlayingUrl = cell.talking.audioUrl;
                            cell.currentPlayingUrl = currentPlayingUrl;
                            self.audioPlayer = [XHAudioPlayerHelper shareInstance];
                            [self.audioPlayer setDelegate:self];
                        
                            [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
//                        [btcell reSetProgressViewProgress];
                        NSLog(@"cutrrent Time:%f,duration:%f",self.audioPlayer.player.currentTime,self.audioPlayer.player.duration);
                        if ([audioDurationTimer isValid]) {
                            [audioDurationTimer invalidate];
                        }
                        audioDurationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playTimerDo) userInfo:nil repeats:YES];
                        [audioDurationTimer fire];
                            //                                    dispatch_async(dispatch_get_main_queue(), ^{
                            if (![cell.aniImageV isAnimating]) {
                                [cell.aniImageV startAnimating];
                                
                            }
//                        }
                        
                        //                                    });
                    }
                    
                } failure:^(NSError *error) {
                    
                }];
                
            }
            
            if (![SystemServer sharedSystemServer].autoPlay&&!playBtnClicked) {
//                NSLog(@"returned222");
                return;
            }
            
            if(![fm fileExistsAtPath:audioPath]){
                currentPlayingUrl = cell.talking.audioUrl;
                [self getAudioFromNet:cell.talking.audioUrl LocalPath:audioPath Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    
                    
                    if ([responseObject writeToFile:audioPath atomically:YES]) {
                        if (![TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName])
                        {
                            NSLog(@"returned333");
                            return;
                        }
                        if (![cell.contentImgV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@"?imageView2/2/w/600"]]]) {
                            NSLog(@"returned333111");
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
                                NSLog(@"returned333222");
                                return;
                                
                            }
//                            EGOImageButton * cV = cell.contentImgV;
//                            CGRect rect = [self.theView convertRect:cV.frame fromView:cell.contentView];
//                            if (rect.origin.y>(self.naviH==0?120:-10)&&rect.origin.y+rect.size.height<self.theView.frame.size.height-self.naviH) {
                                currentPlayingUrl = cell.talking.audioUrl;
                                cell.currentPlayingUrl = currentPlayingUrl;
                                self.audioPlayer = [XHAudioPlayerHelper shareInstance];
                                [self.audioPlayer setDelegate:self];
                            
                                [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
//                            [btcell reSetProgressViewProgress];
                            NSLog(@"cutrrent Time:%f,duration:%f",self.audioPlayer.player.currentTime,self.audioPlayer.player.duration);
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
//                            }
                            
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
   
//    NSLog(@"cutrrent11111 Time:%f,currentDeviceTime:%f,duration:%f",self.audioPlayer.player.currentTime,self.audioPlayer.player.deviceCurrentTime,self.audioPlayer.player.duration);
    [btcell setProgressViewProgress:(ScreenWidth/([btcell.talking.audioDuration floatValue]*10))];
}
-(void)stopPlayTimer
{
    [audioDurationTimer invalidate];
//    NSLog(@"stop11111111");
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
//        cells.currentPlayingUrl = @"";
        [cells showPlayBtn];
    }
    else if ([self.audioPlayer isPlaying]&&![cells.talking.audioUrl isEqualToString:currentPlayingUrl])
    {
        [self.audioPlayer stopAudio];
        cells.currentPlayingUrl = @"";
        [cells showPlayBtn];

    }
    else
    {
        /******源代码，注释于2014-11-14
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
        NSArray * g = [cells.talking.audioUrl componentsSeparatedByString:@"/"];
        NSString *accessorys2 = [[documents stringByAppendingPathComponent:@"Audios"] stringByAppendingPathComponent:[g lastObject]];
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stopAudio];
        }
        self.audioPlayer = [XHAudioPlayerHelper shareInstance];
        [self.audioPlayer setDelegate:self];
        [self.audioPlayer managerAudioWithFileName:accessorys2 toPlay:YES];
        //            [cells.aniImageV startAnimating];
        
        if (![cells.aniImageV isAnimating]) {
            cells.aniImageV.image = [TFileManager getFristImageWithID:cells.talking.playAnimationImg.fileName];
            cells.aniImageV.animationImages = [TFileManager getAllImagesWithID:cells.talking.playAnimationImg.fileName];
            cells.aniImageV.animationDuration = cells.aniImageV.animationImages.count*0.15;
            [cells.aniImageV startAnimating];
        }
         ******/
        
        [cells showLoading];
        [self playOrDownloadForCell:cells PlayBtnClicked:YES];
        
    }
    
    
    
}
-(void)dealloc
{
    self.tableV.header.canEndAnimation = NO;
    self.tableV.footer.canEndAnimation = NO;
    [self stopPlayTimer];
    if (btcell) {
        btcell.delegate = nil;
    }
    if (self.audioPlayer) {
        
        [self.audioPlayer stopAudio];
//        cell.currentPlayingUrl = currentPlayingUrl;
        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
    }
    self.iamActive = NO;
    self.audioPlayer.delegate = nil;
    
}
-(void)stopAudio
{
//    self.canJudgePlay = NO;
    if (self.audioPlayer) {
        
        [self.audioPlayer stopAudio];
        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
        
    }
    [self stopPlayTimer];
}
-(void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer
{
    [btcell reSetProgressViewProgress];
    [self stopPlayTimer];
    for (int i = 0; i<self.dataArray.count; i++) {
        NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:i];
        if ((self.uploadArray&&self.uploadArray.count>0)&&indexPathTo.section==0) {
            return;
        }
        BrowserForwardedTalkingTableViewCell * cell = (BrowserForwardedTalkingTableViewCell *)[self.tableV cellForRowAtIndexPath:indexPathTo];
        //        if ([currentPlayingUrl isEqualToString:cell.talking.audioUrl]) {
        [cell.aniImageV stopAnimating];
        cell.currentPlayingUrl = @"";
        [cell showPlayBtn];
        //        }
        
    }
    
}
-(void)addZanToZanArray:(NSDictionary *)petDict cellIndex:(int)cellIndex
{
    if (!self.needShowZanAndComment) {
        return;
    }
    TalkingBrowse * talking = self.dataArray[cellIndex];
    [talking.showZanArray insertObject:petDict atIndex:0];
    [self.dataArray replaceObjectAtIndex:cellIndex withObject:talking];
//    [self.tableV reloadSections:[NSIndexSet indexSetWithIndex:cellIndex] withRowAnimation:UITableViewRowAnimationNone];
    if (talking.showZanArray.count>=2) {
        [self.tableV reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:cellIndex]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (talking.showZanArray.count==1){
        [self.tableV insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:cellIndex]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
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
-(void)resetShuoShuoStatus:(TalkingBrowse *)talkingBrowse
{
    for (int i = 0; i<self.dataArray.count; i++) {
        TalkingBrowse * talking = self.dataArray[i];
        if ([talking.theID isEqualToString:talkingBrowse.theID]) {
            [self.dataArray replaceObjectAtIndex:i withObject:talking];
        }
    }
    [self.tableV reloadData];
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
-(void)storyClickedTalkingBrowse:(TalkingBrowse *)talkingBrowse
{
    PreviewStoryViewController * pv = [[PreviewStoryViewController alloc] init];
    [pv loadPreviewStoryViewWithDictionary:talkingBrowse];
    [self.theController.navigationController pushViewController:pv animated:YES];
    return;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TalkingBrowse * talking = [self.dataArray objectAtIndex:indexPath.section];
//    if ([talking.theModel intValue]==2) {
//        PreviewStoryViewController * pv = [[PreviewStoryViewController alloc] init];
//        [pv loadPreviewStoryViewWithDictionary:talking];
//        [self.theController.navigationController pushViewController:pv animated:YES];
//        return;
//    }
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    talkingDV.delegate = self;
//    talkingDV.theIndex = indexPath.row;
    talkingDV.talking = [self.dataArray objectAtIndex:indexPath.section];
   
    [self.theController.navigationController pushViewController:talkingDV animated:YES];
    
}
- (void)forwardWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    talkingDV.delegate = self;
    talkingDV.commentStyle = commentStyleForward;
    talkingDV.talking = talkingBrowse;
    [self.theController.navigationController pushViewController:talkingDV animated:YES];
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
    [mDict setObject:currentPetId forKey:@"petId"];
    
    
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
- (void)attentionPetWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    for (int i = 0; i<self.dataArray.count; i++) {
        TalkingBrowse * talking = self.dataArray[i];
        if ([talking.petInfo.petID isEqualToString:talkingBrowse.petInfo.petID]) {
            talking.relationShip = talkingBrowse.relationShip;
            [self.dataArray replaceObjectAtIndex:i withObject:talking];
        }
    }
    [self.tableV reloadData];
}

- (void)attentionPetWithTalkingBrowse2: (TalkingBrowse *)talkingBrowse
{
    for (int i = 0; i<self.dataArray.count; i++) {
        TalkingBrowse * talking = self.dataArray[i];
        if ([talking.petInfo.petID isEqualToString:talkingBrowse.petInfo.petID]) {
            talking.relationShip = talkingBrowse.relationShip;
            [self.dataArray replaceObjectAtIndex:i withObject:talking];
        }
    }
    [self.tableV reloadData];
}
-(void)attentionPetWithPetId:(NSString *)petId AndRelationship:(NSString *)relationship
{
    for (int i = 0; i<self.dataArray.count; i++) {
        TalkingBrowse * talking = self.dataArray[i];
        if ([talking.petInfo.petID isEqualToString:petId]) {
            talking.relationShip = relationship;
            [self.dataArray replaceObjectAtIndex:i withObject:talking];
        }
    }
    [self.tableV reloadData];
}
- (void)petProfileWhoPublishTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    //    if ([talkingBrowse.petInfo.petID isEqualToString:[UserServe sharedUserServe].userID]) {
    //
    //    }
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingBrowse.petInfo.petID;
    pv.petAvatarUrlStr = talkingBrowse.petInfo.headImgURL;
    pv.petNickname = talkingBrowse.petInfo.nickname;
    pv.relationShip = talkingBrowse.relationShip;
    pv.delegate = self;
    [self.theController.navigationController pushViewController:pv animated:YES];
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
- (void)petProfileWhoForwardTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingBrowse.forwardInfo.forwardPetId;
    pv.petAvatarUrlStr = talkingBrowse.forwardInfo.forwardPetAvatar;
    pv.petNickname = talkingBrowse.forwardInfo.forwardPetNickname;
//    pv.relationShip = talkingBrowse.relationShip;
    [self.theController.navigationController pushViewController:pv animated:YES];
}
-(void)avatarClickedId:(NSString *)petId
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = petId;
    [self.theController.navigationController pushViewController:pv animated:YES];
}
-(void)showSetPlayView
{
    [[NSUserDefaults standardUserDefaults] setObject:@"onlywifi" forKey:@"playmodeofaudio"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIAlertView * alerty = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您可以在下面选择您需要的宠物说播放模式，如果以后需要修改，可以到“设置-播放设置”再次修改" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"仅在WIFI下自动播放",@"始终自动播放",@"禁止自动播放", nil];
    alerty.tag = 100;
    [alerty show];
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            [[NSUserDefaults standardUserDefaults] setObject:@"onlywifi" forKey:@"playmodeofaudio"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([SystemServer sharedSystemServer].systemNetStatus==SystemNetStatusReachableViaWiFi) {
                [SystemServer sharedSystemServer].autoPlay = YES;
            }
            else
                [SystemServer sharedSystemServer].autoPlay = NO;
            
        }
        else if (buttonIndex==2){
            [[NSUserDefaults standardUserDefaults] setObject:@"always" forKey:@"playmodeofaudio"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [SystemServer sharedSystemServer].autoPlay = YES;
        }
        else if (buttonIndex==3)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"never" forKey:@"playmodeofaudio"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [SystemServer sharedSystemServer].autoPlay = NO;
        }

    }
}

-(void)showPromptView
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"DistinguishShuoShuoPic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    PromptView * p = [[PromptView alloc] initWithPoint:CGPointMake(35, 80) image:[UIImage imageNamed:@"dis_prompt"] arrowDirection:2];
    [self.theController.view addSubview:p];
    [p show];
}
@end
