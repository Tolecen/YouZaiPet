//
//  AllTrialViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/1/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "AllTrialViewController.h"
#import "MJRefresh.h"
#import "EGOImageView.h"
#import "GoodsDetailViewController.h"
#import "Common.h"

@interface AllTrysCell : UITableViewCell
{
    UIView * pass;
}
@property (nonatomic,retain)UILabel * ntitleLabel;
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)UILabel * desLabel;
@property (nonatomic,retain)UILabel * stateL;
@property (nonatomic,retain)UIImageView * freeFreight;
@property (nonatomic,retain)UILabel * inventoryL;
@property (nonatomic,retain)UILabel * participationL;
@property (nonatomic,retain)UILabel * endTimeL;
@end
@implementation AllTrysCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.imageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        self.imageV.placeholderImage = [UIImage imageNamed:@"package_holder"];
        [self.contentView addSubview:self.imageV];
        
        self.ntitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, ScreenWidth-110, 40)];
        [self.ntitleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.ntitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.ntitleLabel];
        self.ntitleLabel.numberOfLines = 0;
        self.ntitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.ntitleLabel.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        
        UIImageView * petPeaIV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 50, 15, 15)];
        petPeaIV.image = [UIImage imageNamed:@"peaicon_unuse"];
        [self.contentView addSubview:petPeaIV];
        
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, ScreenWidth-130, 15)];
        [self.desLabel setFont:[UIFont systemFontOfSize:15]];
        [self.desLabel setBackgroundColor:[UIColor clearColor]];
        self.desLabel.textColor = [UIColor colorWithWhite:150/255.0 alpha:1];
        [self.contentView addSubview:self.desLabel];
        
        pass = [[UIView alloc] initWithFrame:CGRectZero];
        pass.backgroundColor = [UIColor colorWithWhite:150/255.0 alpha:1];
        [self.contentView addSubview:pass];
        
        self.stateL = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 70, 19)];
        [self.stateL setFont:[UIFont systemFontOfSize:15]];
        self.stateL.layer.cornerRadius = 5;
        self.stateL.layer.masksToBounds = YES;
        self.stateL.textColor = [UIColor whiteColor];
        self.stateL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.stateL];
        
        self.freeFreight = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-15-55, 47, 55, 23)];
        _freeFreight.image = [UIImage imageNamed:@"Pay_free"];
        [self.contentView addSubview:self.freeFreight];
        
        self.inventoryL = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 90, 15)];
        [self.inventoryL setFont:[UIFont systemFontOfSize:12]];
        [self.inventoryL setBackgroundColor:[UIColor clearColor]];
        self.inventoryL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:self.inventoryL];
        self.participationL = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 90, 15)];
        [self.participationL setFont:[UIFont systemFontOfSize:12]];
        [self.participationL setBackgroundColor:[UIColor clearColor]];
        self.participationL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:self.participationL];
        self.endTimeL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-140, 100, 140, 15)];
        [self.endTimeL setFont:[UIFont systemFontOfSize:12]];
        [self.endTimeL setBackgroundColor:[UIColor clearColor]];
        self.endTimeL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:self.endTimeL];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 119, ScreenWidth, 1)];
        [lineView setBackgroundColor:[UIColor colorWithWhite:220/255.0 alpha:1]];
        [self.contentView addSubview:lineView];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [_ntitleLabel.text sizeWithFont:_ntitleLabel.font constrainedToSize:CGSizeMake(ScreenWidth-110, 40)];
    _ntitleLabel.frame = CGRectMake(100, 10, size.width, size.height);
    CGSize s = [_desLabel.text sizeWithFont:_desLabel.font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    pass.frame = CGRectMake(95, 57, 30+s.width, 1);
}
@end;
@interface AllTrialViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
}
@property (nonatomic, strong)UITableView * packageTableview;
@property (nonatomic, strong)NSMutableArray * tryArr;
@end

@implementation AllTrialViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"全部试用";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    [self buildViewWithSkintype];
    
    self.packageTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    _packageTableview.delegate = self;
    _packageTableview.dataSource = self;
    _packageTableview.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
    _packageTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _packageTableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_packageTableview];
    
    [self.packageTableview addHeaderWithTarget:self action:@selector(getFristTrialList)];
    [self.packageTableview addFooterWithTarget:self action:@selector(getTrialList)];
    
    [self.packageTableview headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getFristTrialList
{
    page = 1;
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"goods" forKey:@"command"];
    [mDict setObject:@"trialList" forKey:@"options"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        [_packageTableview headerEndRefreshing];
        self.tryArr = [[NSMutableArray alloc] initWithArray:responseObject[@"value"]];
        [_packageTableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_packageTableview headerEndRefreshing];
    }];
}
- (void)getTrialList
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"goods" forKey:@"command"];
    [mDict setObject:@"trialList" forKey:@"options"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        [_packageTableview footerEndRefreshing];
        [_tryArr addObjectsFromArray:responseObject[@"value"]];
        [_packageTableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_packageTableview footerEndRefreshing];
    }];
}
-(void)backBtnDo
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tryArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *goodsCellIdentifier = @"goodsCell";
    NSDictionary * dic = _tryArr[indexPath.row];
    AllTrysCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellIdentifier];
    if (cell == nil) {
        cell = [[AllTrysCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:goodsCellIdentifier];
    }
    cell.imageV.imageURL = [NSURL URLWithString:dic[@"coverUrl"]];
    cell.ntitleLabel.text = dic[@"description"];
    cell.desLabel.text = dic[@"price"];
    cell.inventoryL.text = [NSString stringWithFormat:@"试用数:%@",dic[@"inventory"]];
    cell.participationL.text = [NSString stringWithFormat:@"参与数:%@",dic[@"apply"]];
    
    if ([dic[@"state"] intValue] == 20)//即将开始
    {
        cell.stateL.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        cell.stateL.text = @"即将开始";
        cell.endTimeL.text = @"即将开始";
    }else if ([dic[@"state"] intValue] == 21)//进行中
    {
        cell.endTimeL.text = [NSString stringWithFormat:@"距离结束:%@",[Common dateStringBetweenNewToTimestamp:dic[@"endTime"]]];
        if([dic[@"orderState"] isEqualToString:@""])
        {
            cell.stateL.backgroundColor = [UIColor colorWithRed:173/255.0 green:169/255.0 blue:1 alpha:1];
            cell.stateL.text = @"我要试用";
        }
    }else if([dic[@"state"] intValue] == 22) {
        cell.endTimeL.text = @"活动结束";
        if([dic[@"orderState"] isEqualToString:@""])//未参加
        {
            cell.stateL.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
            cell.stateL.text = @"活动结束";
        }
    }
    if([dic[@"orderState"] intValue]==41)//已参加
    {
        cell.stateL.backgroundColor = [UIColor colorWithRed:173/255.0 green:169/255.0 blue:1 alpha:1];
        cell.stateL.text = @"申请中";
    }else if([dic[@"orderState"] intValue]==43)//已拒绝
    {
        cell.stateL.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        cell.stateL.text = @"申请拒接";
    }
    else if([dic[@"orderState"] intValue]==42)//已通过
    {
        cell.stateL.backgroundColor = [UIColor colorWithRed:173/255.0 green:169/255.0 blue:1 alpha:1];
        cell.stateL.text = @"申请通过";
    }else if([dic[@"orderState"] intValue]==44)//已通过
    {
        cell.stateL.backgroundColor = [UIColor colorWithRed:173/255.0 green:169/255.0 blue:1 alpha:1];
        cell.stateL.text = @"申请通过";
    }
    if ([dic[@"postageType"] intValue]) {
        cell.freeFreight.hidden = YES;
    }else{
        cell.freeFreight.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GoodsDetailViewController * goodVC = [[GoodsDetailViewController alloc] init];
    goodVC.title = @"试用详情";
    goodVC.goodsDic = _tryArr[indexPath.row];
    goodVC.type = GoodsDetailTyepTrial;
    goodVC.trialSuccess = ^{
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:_tryArr[indexPath.row]];
        [dic setObject:@"41" forKey:@"orderState"];
        [_tryArr removeObjectAtIndex:indexPath.row];
        [_tryArr insertObject:dic atIndex:indexPath.row];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRTrialSuccess" object:self userInfo:dic];
    };
    [self.navigationController pushViewController:goodVC animated:YES];
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
