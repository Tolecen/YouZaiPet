//
//  MyBagListViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14/12/13.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "MyBagListViewController.h"
#import "GiftPackageViewController.h"
@interface MyBagListViewController ()

@end

@implementation MyBagListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的礼包";
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentIndex = 0;
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    self.packageTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    _packageTableview.delegate = self;
    _packageTableview.dataSource = self;
    _packageTableview.backgroundView = nil;
    _packageTableview.scrollsToTop = YES;
    _packageTableview.backgroundColor = [UIColor whiteColor];
    _packageTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _notiTableView.rowHeight = 90;
    //    _notiTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    _packageTableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_packageTableview];
    
    [self.packageTableview addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
    //        [self.tableV headerBeginRefreshing];
    [self.packageTableview addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
    // Do any additional setup after loading the view.
    [self.packageTableview headerBeginRefreshing];
    [self buildViewWithSkintype];
    
    self.nocontentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 20)];
    [self.nocontentLabel setText:@"亲，您还没有礼包哦"];
    [self.nocontentLabel setBackgroundColor:[UIColor clearColor]];
    [self.nocontentLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.nocontentLabel];
    [self.nocontentLabel setTextColor:[UIColor colorWithWhite:140/255.0f alpha:1]];
    self.nocontentLabel.hidden = YES;
}
-(void)getmyBag
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"giftBag" forKey:@"command"];
    [mDict setObject:@"mine" forKey:@"options"];
//    [mDict setObject:@"DJ" forKey:@"code"];
    [mDict setObject:[UserServe sharedUserServe].currentPet.petID?[UserServe sharedUserServe].currentPet.petID:@"no" forKey:@"petId"];
    [mDict setObject:@"20" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",currentIndex] forKey:@"pageIndex"];
    //    [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    NSLog(@"Get ShuoShuo:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"200"]) {
            if (currentIndex==0) {
                self.dataArray = [self getModelArray:[responseObject objectForKey:@"value"]];
                //               self.dataArray = [self getModelArray:self.dataArray];
            }
            else{
                [self.dataArray addObjectsFromArray:[self getModelArray:[responseObject objectForKey:@"value"]]];
                //                [self endRefreshing:self.packageTableview];
            }
            currentIndex++;
            if (self.dataArray.count>0) {
                self.nocontentLabel.hidden = YES;
            }
            else
                self.nocontentLabel.hidden = NO;
            //            [self.hotTableView reloadData];
        }
        [self endRefreshing:self.packageTableview];
        NSLog(@"get package success:%@",responseObject);
        //        [self.packageTableview headerEndRefreshing];
        //        [self cellPlayAni:self.tableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get package error:%@",error);
        [self endRefreshing:self.packageTableview];
        //        [self.packageTableview headerEndRefreshing];
        //        if (currentID==0) {
        //            [self endHeaderRefreshing:self.tableV];
        //        }
        //        else
        //        {
        //            [self endFooterRefreshing:self.tableV];
        //        }
    }];

}
-(NSMutableArray *)getModelArray:(NSArray *)array
{
    /*
     NSMutableArray * uu = [NSMutableArray array];
     for (int i = 0; i<20; i++) {
     NSString * stated = [NSString stringWithFormat:@"%d",arc4random()%6];
     int b = arc4random()%2;
     NSString * preV;
     if (b==0) {
     preV = @"false";
     }
     else
     preV = @"true";
     NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:stated,@"state",preV,@"preview",@"是解放军上岛咖啡风纪扣数据发送多晶硅开发刻录机来喀什的骄傲是房管局房管局快乐到死飓风桑迪啊花间傻傻的接啊山东矿机撒旦会撒娇的啊接口山东矿机啊稍等",@"description",@"角度考虑就是的可乐鸡",@"name",@"DJ12001",@"code",@"ddd",@"icon", nil];
     [uu addObject:dic];
     }
     array = uu;
     */
    NSMutableArray * hArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        PackageInfo * pInfo = [[PackageInfo alloc] initWithHostInfo:[array objectAtIndex:i]];
        
        //        TalkingBrowse * talking = [[TalkingBrowse alloc] initWithHostInfo:[array objectAtIndex:i]];
        [hArray addObject:pInfo];
    }
    return hArray;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"packageCell";
    PackageInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[PackageInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        //        cell.delegate = self;
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.packageInfo = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PackageInfoTableViewCell *cell = (PackageInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [UIView animateWithDuration:0.1 animations:^{
        cell.bgV.alpha = 0.8;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            cell.bgV.alpha = 0.22;
        } completion:^(BOOL finished) {
            
        }];
    }];
    PackageInfo * pInfo = self.dataArray[indexPath.row];
    if (pInfo.canPreview||pInfo.canGet||pInfo.haveGot) {
        [self presentPopup:pInfo];
    }
    else if (pInfo.haveExpirdate){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不好意思，礼包已经过期了" delegate:self cancelButtonTitle:@"好吧，知道了" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不好意思，您还没有权限预览这个礼包哦" delegate:self cancelButtonTitle:@"好吧，知道了" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)tableViewHeaderRereshing:(UITableView *)tableView
{
    currentIndex=0;
//    [self getPackageByType:0];
    [self getmyBag];
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
//    [self getPackageByType:0];
    [self getmyBag];
}
-(void)endRefreshing:(UITableView *)tableView
{
    //    self.isRefreshing = NO;
    [self.packageTableview footerEndRefreshing];
    [self.packageTableview headerEndRefreshing];
    [self.packageTableview reloadData];
    
}
- (void)presentPopup:(PackageInfo *)package {
    MJDetailViewController *detailViewController = [[MJDetailViewController alloc] init];
    detailViewController.delegate = self;
    detailViewController.packageInfo = package;
    [self presentPopupViewController:detailViewController animationType:4];
}

-(void)cancelButtonClicked:(MJDetailViewController *)detailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
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
