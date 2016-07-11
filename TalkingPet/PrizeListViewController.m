//
//  PrizeListViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/6.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PrizeListViewController.h"
#import "MJRefresh.h"
@interface PrizeListViewController ()

@end

@implementation PrizeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastId = @"";
    self.title = @"奖品列表";
    firstInThisPage = YES;
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    self.headerArray = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"http://www.baidu.com",@"url",@"http://d.hiphotos.baidu.com/image/pic/item/f11f3a292df5e0feba84cf005e6034a85edf7216.jpg",@"bgurl", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"http://www.163.com",@"url",@"http://f.hiphotos.baidu.com/image/pic/item/838ba61ea8d3fd1fbc60249b334e251f95ca5f22.jpg",@"bgurl", nil], nil];
    
    self.listTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.scrollsToTop = YES;
    self.listTableV.backgroundColor = [UIColor whiteColor];
    //    _notiTableView.rowHeight = 90;
    //    _notiTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    self.listTableV.showsVerticalScrollIndicator = NO;
    self.listTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.listTableV];
    
//    self.headerScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*(1/3.0f))];
//    self.headerScrollV.contentSize = CGSizeMake(ScreenWidth, ScreenWidth*(1/3.0f)+10);
////    self.headerScrollV.backgroundColor = [UIColor redColor];
//    self.headerScrollV.scrollsToTop = NO;
//    self.headerScrollV.bounces = NO;
//    self.
//    self.listTableV.tableHeaderView = self.headerScrollV;
    
    self.headerBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*(1/4.0f))];
    [self.headerBgV setBackgroundColor:[UIColor clearColor]];
    
    self.sameView = [[PagedFlowView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-10, (ScreenWidth-10)*(1/4.0f))];
    _sameView.delegate = self;
    _sameView.dataSource = self;
    self.sameView.layer.cornerRadius = 5;
    self.sameView.layer.masksToBounds = YES;
//    _sameView.hidden = YES;
    [self.headerBgV addSubview:_sameView];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(ScreenWidth-5-35, 5, 35, 35)];
    [closeBtn setImage:[UIImage imageNamed:@"banner_button_close"] forState:UIControlStateNormal];
    [self.headerBgV addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeHeader) forControlEvents:UIControlEventTouchUpInside];
    
    UIPageControl * page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (ScreenWidth-10)*(1/4.0f)-20, ScreenWidth, 20)];
    page.currentPageIndicatorTintColor = [UIColor colorWithRed:135/255.0 green:130/255.0 blue:250/255.0 alpha:1];
    page.pageIndicatorTintColor = [UIColor colorWithWhite:200/255.0 alpha:1];
    _sameView.pageControl = page;
    [_sameView addSubview:page];
    
    
    
//    [self setHeaderContentWithArray:headerArray];
    
    [self getPrizeList];
    [self getTopContent];
    
    [self.listTableV addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
    //        [self.tableV headerBeginRefreshing];
    [self.listTableV addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
    // Do any additional setup after loading the view.
}
-(void)closeHeader
{
    self.listTableV.tableHeaderView = nil;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!firstInThisPage) {
//            [self getPrizeList];
    }
    firstInThisPage = NO;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"firstPrizelist"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"奖品大放送" message:@"宠物说这次有大活动,一堆大奖等你拿。\n只要完成简单的任务就能获得，更有神秘大奖等你来抢。" delegate:nil cancelButtonTitle:@"立刻参加" otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"firstPrizelist"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)getTopContent
{
    if (!self.squareKey) {
        return;
    }
    NSMutableDictionary* updateDict = [NetServer commonDict];
    [updateDict setObject:@"layout" forKey:@"command"];
    [updateDict setObject:@"datum" forKey:@"options"];
    [updateDict setObject:self.squareKey forKey:@"code"];
    [NetServer requestWithParameters:updateDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"GGGGGGGGGG:%@",responseObject);
        self.headerArray = [responseObject objectForKey:@"value"];
        if (self.headerArray.count>0) {
            self.listTableV.tableHeaderView = self.headerBgV;
        }
        [self.sameView reloadData];
//        [self setHeaderArray:[responseObject objectForKey:@"value"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(void)getPrizeList
{
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"awardActivity" forKey:@"command"];
    [usersDict setObject:@"list" forKey:@"options"];
    [usersDict setObject:@"20" forKey:@"pageSize"];
    [usersDict setObject:self.lastId forKey:@"startId"];
    if ([UserServe sharedUserServe].userID) {
        [usersDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    }
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"value"] count]>=1) {
            if ([self.lastId isEqualToString:@""]) {
                self.awardArary = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"value"]];
            }
            else
                [self.awardArary addObjectsFromArray:[responseObject objectForKey:@"value"]];
            self.lastId = [[self.awardArary lastObject] objectForKey:@"id"];
        }

        
        [self.listTableV reloadData];
        [self endRefreshing:self.listTableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefreshing:self.listTableV];
    }];

}

-(void)setHeaderContentWithArray:(NSArray *)headerArray
{
    for (UIView * view in self.headerScrollV.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i<headerArray.count; i++) {
        EGOImageButton * btn = [[EGOImageButton alloc] initWithFrame:CGRectMake(10+ScreenWidth*i, 5, ScreenWidth-10, (ScreenWidth-10)*(1/3.0f))];
        btn.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        btn.imageURL = [NSURL URLWithString:[headerArray[i] objectForKey:@"iconUrl"]];
        [self.headerScrollV addSubview:btn];
    }
    self.headerScrollV.contentSize = CGSizeMake(ScreenWidth*headerArray.count, ScreenWidth*(1/3.0f)+5);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenWidth-10)*0.3+5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.awardArary.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"prizeListCell";
    PrizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[PrizeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.awardDict = self.awardArary[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrizeDetailViewController * pd = [[PrizeDetailViewController alloc] init];
//    [pd removeNaviBg];
    pd.delegate = self;
    pd.awardId = [[self.awardArary objectAtIndex:indexPath.row] objectForKey:@"id"];
    pd.hideNaviBg = YES;
    [self.navigationController pushViewController:pd animated:YES];
    
}

- (void)tableViewHeaderRereshing:(UITableView *)tableView
{
    self.lastId = @"";
    [self getPrizeList];
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
    [self getPrizeList];
}
-(void)endRefreshing:(UITableView *)tableView
{
    [self.listTableV footerEndRefreshing];
    [self.listTableV headerEndRefreshing];
    [self.listTableV reloadData];
    
}
-(void)resetStatusforIndex:(int)index withStatus:(int)status
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.awardArary[index]];
    [dict setObject:[NSString stringWithFormat:@"%d",status] forKey:@"state"];
    [self.awardArary replaceObjectAtIndex:index withObject:dict];
    [self.listTableV reloadData];
}
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(ScreenWidth-10, (ScreenWidth-10)*(1/4.0f));
}
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    if (self.headerArray.count) {
        if (self.headerArray.count<=1) {
            self.sameView.pageControl.hidden = YES;
        }
        else
            self.sameView.pageControl.hidden = NO;
        return self.headerArray.count;
    }
    self.sameView.pageControl.hidden = YES;
    return 1;
}
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    if (!self.headerArray.count) {
        return [[UIView alloc]init];
    }
    EGOImageButton * imageV = (EGOImageButton*)[flowView dequeueReusableCell];
    if (!imageV) {
        imageV = [[EGOImageButton alloc] init];
        imageV.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        imageV.frame = CGRectMake(0, 0, ScreenWidth-20, (ScreenWidth-20)*(1/4.0f));
    }
    imageV.tag = 200+index;
    [imageV addTarget:self action:@selector(tagButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    imageV.imageURL = [NSURL URLWithString:[self.headerArray[index] objectForKey:@"iconUrl"]];
    return imageV;
}
-(void)tagButtonTouched:(EGOImageButton *)sender
{
    int index = (int)sender.tag-200;
    NSDictionary * d = [self.headerArray objectAtIndex:index];
    NSString * urlStr = [d objectForKey:@"key"];
    if (urlStr) {
        if (urlStr.length>1) {
            TOWebViewController * vb = [[TOWebViewController alloc] init];
            vb.url = [NSURL URLWithString:urlStr];
            [self.navigationController pushViewController:vb animated:YES];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showNaviBg];
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
