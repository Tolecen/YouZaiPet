//
//  MyTaskViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "MyTaskViewController.h"
#import "BlankPageView.h"

@interface MyTaskViewController ()
{
    BlankPageView * blankPage;
}
@end

@implementation MyTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastId = @"";
    self.title = @"我的任务";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    self.listTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight-60)];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.scrollsToTop = YES;
    self.listTableV.backgroundColor = [UIColor whiteColor];
    //    _notiTableView.rowHeight = 90;
    //    _notiTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    self.listTableV.showsVerticalScrollIndicator = NO;
    self.listTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.listTableV];
    
    [self.listTableV addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
    //        [self.tableV headerBeginRefreshing];
    [self.listTableV addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
    
    
    UIView * bottomBGV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60-navigationBarHeight, ScreenWidth, 60)];
    bottomBGV.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.view addSubview:bottomBGV];
    
    EGOImageView * im = [[EGOImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    im.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [im setImageURL:[NSURL URLWithString:[UserServe sharedUserServe].account.headImgURL]];
    [bottomBGV addSubview:im];
    im.layer.cornerRadius = 20;
    im.layer.masksToBounds = YES;
    
    self.doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 7, 150, 20)];
    [self.doneLabel setBackgroundColor:[UIColor clearColor]];
    [self.doneLabel setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
    self.doneLabel.font = [UIFont systemFontOfSize:14];
    self.doneLabel.adjustsFontSizeToFitWidth = YES;
    self.doneLabel.text = @"已完成：0个";
    [bottomBGV addSubview:self.doneLabel];
    
    self.notDoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 150, 20)];
    [self.notDoneLabel setBackgroundColor:[UIColor clearColor]];
    [self.notDoneLabel setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
    self.notDoneLabel.font = [UIFont systemFontOfSize:14];
    self.notDoneLabel.adjustsFontSizeToFitWidth = YES;
    self.notDoneLabel.text = @"未完成：0个";
    [bottomBGV addSubview:self.notDoneLabel];
    
    UIButton * historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtn setFrame:CGRectMake(ScreenWidth-66-15, 19, 66, 22)];
    [historyBtn setImage:[UIImage imageNamed:@"btn_history"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(toHistoryView) forControlEvents:UIControlEventTouchUpInside];
    [bottomBGV addSubview:historyBtn];
    
    [self getMyTask];
    [self getBottomInfo];
    // Do any additional setup after loading the view.
}
-(void)getBottomInfo
{
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"awardActivity" forKey:@"command"];
    [usersDict setObject:@"myListInfo" forKey:@"options"];
    if ([UserServe sharedUserServe].userID) {
        [usersDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    }

    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.doneLabel setText:[NSString stringWithFormat: @"已完成：%d个",[[[responseObject objectForKey:@"value"] objectForKey:@"finishedActCount"] intValue]]];
        [self.notDoneLabel setText:[NSString stringWithFormat: @"未完成：%d个",[[[responseObject objectForKey:@"value"] objectForKey:@"unfinishedActCount"] intValue]]];
//        [self.listTableV reloadData];
//        [self endRefreshing:self.listTableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self endRefreshing:self.listTableV];
        
    }];

}
-(void)getMyTask
{
    [SVProgressHUD showWithStatus:@"获取任务列表..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"awardActivity" forKey:@"command"];
    [usersDict setObject:@"myList" forKey:@"options"];
    if ([UserServe sharedUserServe].userID) {
        [usersDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    }
    [usersDict setObject:self.lastId forKey:@"startId"];
    [usersDict setObject:@"20" forKey:@"pageSize"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([self.lastId isEqualToString:@""]) {
            self.actArray = [responseObject objectForKey:@"value"];
        }
        else
            [self.actArray addObjectsFromArray:[responseObject objectForKey:@"value"]];
        [self.listTableV reloadData];
        if (_actArray.count) {
            self.lastId = [[self.actArray lastObject] objectForKey:@"id"];
        }
        [self endRefreshing:self.listTableV];
        if (!_actArray.count) {
            if (!blankPage) {
                __weak UINavigationController * weakNav = self.navigationController;
                blankPage = [[BlankPageView alloc] init];
                [blankPage showWithView:self.view image:[UIImage imageNamed:@"myTask_without"] buttonImage:[UIImage imageNamed:@"myTask_toJoin"] action:^{
                    [weakNav popToRootViewControllerAnimated:YES];
                }];
            }
        }
        else if(blankPage){
            [blankPage removeFromSuperview];
            blankPage = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefreshing:self.listTableV];
        [SVProgressHUD showErrorWithStatus:@"任务列表获取失败"];
    }];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    float kkkk = (ScreenWidth-10)*0.3+5;
    NSString * des = [[[self.actArray objectAtIndex:indexPath.row] objectForKey:@"state"] intValue]==1?[[[[self.actArray objectAtIndex:indexPath.row] objectForKey:@"activityDTO"] objectForKey:@"title"] stringByAppendingString:@"(还未发布内容)"]:[[[self.actArray objectAtIndex:indexPath.row] objectForKey:@"activityDTO"] objectForKey:@"title"];
    NSString * award = [[[self.actArray objectAtIndex:indexPath.row] objectForKey:@"activityDTO"] objectForKey:@"awardName"];
    CGSize h1 = [des sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-15-5-80-10, 100) lineBreakMode:NSLineBreakByCharWrapping];
    CGSize h2 = [award sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-15-5-80-10, 100) lineBreakMode:NSLineBreakByCharWrapping];
//    if (h1.height>20) {
//        kkkk = kkkk+h1.height-20;
//    }
//    if (h2.height>20) {
//        kkkk = kkkk+h2.height-20;
//    }
    return 40+h1.height+5+h2.height+5+20+10;
//    return kkkk;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myListCell";
    MyTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[MyTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.cellIndex = (int)indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.actDict = [[self.actArray objectAtIndex:indexPath.row] objectForKey:@"activityDTO"];
    cell.status = [[[self.actArray objectAtIndex:indexPath.row] objectForKey:@"state"] intValue];
    cell.remainTime = [[self.actArray objectAtIndex:indexPath.row] objectForKey:@"countdownTime"];
    return cell;
}
-(void)resetTimeforIndex:(int)index Time:(NSString *)time
{
    if ([time doubleValue]/1000.0f<=1) {
        self.lastId = @"";
        [self getMyTask];
        return;
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[self.actArray objectAtIndex:index]];
    if ([time doubleValue]/1000.0f<=1) {
        [dict setObject:@"0" forKey:@"countdownTime"];
    }
    else
        [dict setObject:time forKey:@"countdownTime"];
    [self.actArray replaceObjectAtIndex:index withObject:dict];
    
}
-(void)toPageForType:(int)type TagId:(NSString *)tagId
{
    if (type==1||type==3) {
        TagTalkListViewController * tagTlistV = [[TagTalkListViewController alloc] init];
        Tag * theTag = [[Tag alloc] init];
        theTag.tagID = tagId;
        tagTlistV.tag = theTag;
        tagTlistV.shouldRequestTagInfo = YES;
        [self.navigationController pushViewController:tagTlistV animated:YES];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popedToRoot" object:self userInfo:nil];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PrizeDetailViewController * pd = [[PrizeDetailViewController alloc] init];
//    //    [pd removeNaviBg];
//    pd.hideNaviBg = YES;
//    [self.navigationController pushViewController:pd animated:YES];
    
//    NSDictionary * dict = self.actArray[indexPath.row];
//    if ([[dict objectForKey:@"catagory"] isEqualToString:@"3"]) {
//        WebContentViewController * vb = [[WebContentViewController alloc] init];
//        vb.urlStr =[@"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=205284163&idx=1&sn=a938e6c433f7392f51652d56e378c68f#rd" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        vb.title = @"排名规则";
//        [self.navigationController pushViewController:vb animated:YES];
//    }
    
    
    PrizeDetailViewController * pd = [[PrizeDetailViewController alloc] init];
    pd.awardId = [[[self.actArray objectAtIndex:indexPath.row] objectForKey:@"activityDTO"] objectForKey:@"id"];
    pd.fromTaskPage = YES;
    pd.hideNaviBg = YES;
    [self.navigationController pushViewController:pd animated:YES];
    
    
    
}
-(void)toTheRulePage
{
        WebContentViewController * vb = [[WebContentViewController alloc] init];
        vb.urlStr =[@"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=205284163&idx=1&sn=a938e6c433f7392f51652d56e378c68f#rd" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        vb.title = @"排名规则";
        [self.navigationController pushViewController:vb animated:YES];
}

- (void)tableViewHeaderRereshing:(UITableView *)tableView
{
    self.lastId = @"";
    [self getMyTask];
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
    [self getMyTask];
}
-(void)endRefreshing:(UITableView *)tableView
{
    [self.listTableV footerEndRefreshing];
    [self.listTableV headerEndRefreshing];
    [self.listTableV reloadData];
}
-(void)toHistoryView
{
    AllTaskHistoryViewController * allTV = [[AllTaskHistoryViewController alloc] init];
    [self.navigationController pushViewController:allTV animated:YES];
}
-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
