//
//  RankingViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/3/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "RankingViewController.h"
#import "EGOImageView.h"
#import "MJRefresh.h"
#import "ExperienceViewController.h"
#import "WebContentViewController.h"
#import "PersonProfileViewController.h"
@interface RankingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * petalkB;
    UIButton * userB;
    UIScrollView * backScrollView;
    
    UITableView * petalkView;
    UITableView * userView;
    
    int page;
}
@property (nonatomic,retain)NSMutableArray * userList;
@end

@implementation RankingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"说说排行";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    [self setRightButtonWithName:nil BackgroundImg:@"nav_button_rule" Target:@selector(rankingRule)];
    [self buildViewWithSkintype];
    
    self.buttonbgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    self.buttonbgV.backgroundColor = [UIColor whiteColor];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button1 setBackgroundImage:[UIImage imageNamed:@"rank_leftbutton_selected"] forState:UIControlStateNormal];
    [self.button1 setFrame:CGRectMake((ScreenWidth-270)/2.0f, 5, 135, 30)];
    [self.buttonbgV addSubview:self.button1];
    [self.button1 setTitle:@"周排行" forState:UIControlStateNormal];
    [self.button1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button1 addTarget:self action:@selector(button1Clicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button2 setBackgroundImage:[UIImage imageNamed:@"rank_rightbutton_normal"] forState:UIControlStateNormal];
    [self.button2 setFrame:CGRectMake((ScreenWidth-270)/2.0f+135, 5, 135, 30)];
    [self.buttonbgV addSubview:self.button2];
    [self.button2 setTitle:@"总排行" forState:UIControlStateNormal];
    [self.button2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(button2Clicked) forControlEvents:UIControlEventTouchUpInside];

    
    petalkView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight)];
    [self.view addSubview:petalkView];
    petalkView.separatorStyle = UITableViewCellSeparatorStyleNone;
    petalkView.tableHeaderView = self.buttonbgV;
    
    self.paihangHelper = [[PaiHangShuoShuoTableHelper alloc] initWithController:self Tableview:petalkView SectionView:nil];
    self.paihangHelper.delegate = self;
    
    petalkView.delegate = self.paihangHelper;
    petalkView.dataSource = self.paihangHelper;

    
//    [self getHotShuoShuoFirstPage];
     [self getPaihangShuoShuoWeeklyFirstPage];
}
-(void)button1Clicked
{
    [self.button1 setBackgroundImage:[UIImage imageNamed:@"rank_leftbutton_selected"] forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:[UIImage imageNamed:@"rank_rightbutton_normal"] forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self getPaihangShuoShuoWeeklyFirstPage];
}
-(void)button2Clicked
{
    [self.button2 setBackgroundImage:[UIImage imageNamed:@"rank_rightbutton_selected"] forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button1 setBackgroundImage:[UIImage imageNamed:@"rank_leftbutton_normal"] forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self getHotShuoShuoFirstPage];
}
-(void)getHotShuoShuoFirstPage
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"rank" forKey:@"command"];
    [mDict setObject:@"petalkTotalPopRankList" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:@"1" forKey:@"pageIndex"];
    self.paihangHelper.reqDict = mDict;
    [petalkView headerBeginRefreshing];
}
-(void)getPaihangShuoShuoWeeklyFirstPage
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"rank" forKey:@"command"];
    [mDict setObject:@"petalkWeekPopRankList" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:@"1" forKey:@"pageIndex"];
    self.paihangHelper.reqDict = mDict;
    [petalkView headerBeginRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backBtnDo
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rankingRule
{
    WebContentViewController * webVC = [[WebContentViewController alloc] init];
    webVC.urlStr = @"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=205284014&idx=1&sn=7fa978b2abe59d83ccb25425a0709371#rd";
    [self.navigationController pushViewController:webVC animated:YES];
}
- (void)showPetalkView
{
    [backScrollView setContentOffset:CGPointMake(backScrollView.frame.size.width, 0) animated:YES];
}
- (void)showUserView
{
    [self.paihangHelper stopAudio];
    [backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark- UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary * petDic = _userList[indexPath.row];
    ExperienceViewController * vc = [[ExperienceViewController alloc] init];
    vc.petId = petDic[@"petId"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<3) {
        return 90 + 18 + (ScreenWidth - 20)/3;
    }else
    {
        return 70;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *petCellIdentifier = @"UserRankingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:petCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:petCellIdentifier];
    }

    return cell;
    
    
}
#pragma mark- UIScrollView Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.paihangHelper stopAudio];
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
