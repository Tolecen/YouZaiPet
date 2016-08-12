//
//  MarketDetailVC.m
//  TalkingPet
//
//  Created by cc on 16/8/7.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "MarketDetailVC.h"
#import "MarketDetailCell.h"
#import "MarketDetailHeadView.h"
#import "NetServer+Payment.h"
#import "MarketDetailModel.h"
#import "YZGoodsDetailVC.h"
#import "CommodityModel.h"
@interface MarketDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *detailTableV;
@property (nonatomic ,strong) MarketDetailHeadView * headView;
@property (nonatomic, retain) NSArray *dataArr;
@property (nonatomic ,strong)CommodityModel *hotsell;
@end

@implementation MarketDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"优质宠物粮";
    
    self.navigationController.automaticallyAdjustsScrollViewInsets=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self creatUI];
    [self reloadData];
}



-(void)reloadData
{
    
    __weak MarketDetailVC * weakSelf = self;

    
    [NetServer getMarketDetailsuccess:^(id result) {
        
        NSDictionary *resultdict=(NSDictionary*)result;
        weakSelf.hotsell=[[CommodityModel alloc] init];
        [weakSelf.hotsell setValuesForKeysWithDictionary:resultdict[@"data"][@"hotsell"]];
        weakSelf.dataArr=[MarketDetailModel infoModelWith:resultdict];
        weakSelf.headView.model=weakSelf.hotsell;
        [weakSelf.detailTableV reloadData];
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
        
        
        
    }];

    
    
    
}



-(void)creatUI
{
    
    UIImage *image = [UIImage imageNamed:@"sousuo@2x"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightMoreItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(toSearchGoods)];
    self.navigationItem.rightBarButtonItem = rightMoreItem;
    
    UIImage *image1 = [UIImage imageNamed:@"shangcheng_back_icon@2x"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image1 style:UIBarButtonItemStyleDone target:self action:@selector(toBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
    
    
    self.detailTableV=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    
    self.detailTableV.delegate=self;
    self.detailTableV.dataSource=self;
    [self.detailTableV registerClass:[MarketDetailCell class] forCellReuseIdentifier:@"MarketDetailCell"];
    _headView=[[MarketDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    self.detailTableV.tableHeaderView=_headView;
    __weak MarketDetailVC * weakSelf = self;

    self.headView.block=^(){
    
        NSLog(@"头部视图点击事件");
        YZGoodsDetailVC *detailVC = [[YZGoodsDetailVC alloc] init];
        detailVC.goodsId = weakSelf.hotsell.gid;
        detailVC.goodsName = weakSelf.hotsell.gid;
        detailVC.hideNaviBg = YES;
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
    _headView.model=self.hotsell;
    [self.view addSubview:self.detailTableV];
    
}
-(void)toSearchGoods
{
    NSLog(@"搜索预留接口");
}


-(void)toBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return  1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArr.count;
    
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"MarketDetailCell";
    MarketDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.model=_dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak MarketDetailVC * weakSelf = self;

    cell.block=^(CommodityModel *model)
    {
        if (model) {
            YZGoodsDetailVC *detailVC = [[YZGoodsDetailVC alloc] init];
            detailVC.goodsId = model.gid;
            detailVC.goodsName = model.name;
            detailVC.hideNaviBg = YES;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];

        }
        else
        {
            NSLog(@"加载更多数据");
        }
    };
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 280;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"专题cell点击事件-----");
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        MarketDetailHeadView * headView=[[MarketDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        headView.model=self.hotsell;
        return headView;;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;

    }
    return  0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
    
    

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