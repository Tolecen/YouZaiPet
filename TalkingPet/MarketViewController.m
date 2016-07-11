//
//  MarketViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14/12/15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "MarketViewController.h"
#import "EGOImageView.h"
#import "AllTrialViewController.h"
#import "MJRefresh.h"
#import "GoodsDetailViewController.h"
#import "ExchangeRecordViewController.h"
#import <objc/message.h>
@interface FooterView : UITableViewHeaderFooterView
@property (nonatomic,retain)UILabel * titleL;
@property (nonatomic,assign)id delegate;
@end
@implementation FooterView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        [self.contentView addSubview:_titleL];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.text = @"查看全部试用";
        _titleL.backgroundColor = [UIColor whiteColor];
        _titleL.textColor = [UIColor colorWithRed:1 green:186/255.0 blue:0 alpha:1];
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 1)];
        lineV.backgroundColor = [UIColor colorWithWhite:220/255.0 alpha:1];
        [self.contentView addSubview:lineV];
        UIButton * actionB = [UIButton buttonWithType:UIButtonTypeCustom];
        actionB.frame = CGRectMake(0, 0, ScreenWidth, 40);
        [actionB addTarget:self action:@selector(allTrail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:actionB];
    }
    return self;
}
- (void)allTrail
{
    if (_delegate) {
        ((void(*)(id, SEL))objc_msgSend)(self.delegate, @selector(allTrail));
    }
}
@end;
@interface HeaderView : UITableViewHeaderFooterView
@property (nonatomic,retain)UILabel * titleL;
@end
@implementation HeaderView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
        [self.contentView addSubview:_titleL];
        self.contentView.backgroundColor = [UIColor whiteColor];
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        lineV.backgroundColor = [UIColor colorWithWhite:220/255.0 alpha:1];
        [self.contentView addSubview:lineV];
    }
    return self;
}

@end;
@interface TrysCell : UITableViewCell
{
    UIView * pass;
}
@property (nonatomic,retain)UIView * lineView;
@property (nonatomic,retain)UILabel * ntitleLabel;
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)UILabel * desLabel;
@property (nonatomic,retain)UILabel * stateL;
@property (nonatomic,retain)UIImageView * freeFreight;
@end
@implementation TrysCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UILabel * bgv = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
        [bgv setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:bgv];
        
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
        
        self.freeFreight = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-70, 47, 55, 23)];
        _freeFreight.image = [UIImage imageNamed:@"Pay_free"];
        [self.contentView addSubview:self.freeFreight];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, ScreenWidth, 1)];
        [_lineView setBackgroundColor:[UIColor colorWithWhite:220/255.0 alpha:1]];
        [self.contentView addSubview:_lineView];
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
@interface GoodsCell : UITableViewCell
@property (nonatomic,retain)UILabel * ntitleLabel;
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)UILabel * desLabel;
@property (nonatomic,retain)UIImageView * freeFreight;
@end
@implementation GoodsCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UILabel * bgv = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
        [bgv setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:bgv];
        
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
        petPeaIV.image = [UIImage imageNamed:@"peaicon"];
        [self.contentView addSubview:petPeaIV];
        
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, ScreenWidth-130, 15)];
        [self.desLabel setFont:[UIFont systemFontOfSize:15]];
        [self.desLabel setBackgroundColor:[UIColor clearColor]];
        self.desLabel.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:self.desLabel];
        
        self.freeFreight = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-70, 47, 55, 23)];
        _freeFreight.image = [UIImage imageNamed:@"Pay_free"];
        [self.contentView addSubview:self.freeFreight];
        
        UILabel * stateL = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 70, 19)];
        [stateL setFont:[UIFont systemFontOfSize:15]];
        stateL.layer.cornerRadius = 5;
        stateL.layer.masksToBounds = YES;
        stateL.textColor = [UIColor whiteColor];
        stateL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:stateL];
        stateL.backgroundColor = [UIColor colorWithRed:173/255.0 green:169/255.0 blue:1 alpha:1];;
        stateL.text = @"我要兑换";
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, ScreenWidth, 1)];
        [lineView setBackgroundColor:[UIColor colorWithWhite:220/255.0 alpha:1]];
        [self.contentView addSubview:lineView];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [_ntitleLabel.text sizeWithFont:_ntitleLabel.font constrainedToSize:CGSizeMake(ScreenWidth-110, 50)];
    _ntitleLabel.frame = CGRectMake(100, 10, size.width, size.height);
}
@end;

@interface MarketViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel * petPeaL;
    int page;
}
@property (nonatomic, strong)UITableView * packageTableview;
@property (nonatomic, strong)NSMutableArray * tryArr;
@property (nonatomic, strong)NSMutableArray * commodityArr;
@end

@implementation MarketViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"商城";
        page = 0;
        self.tryArr = [NSMutableArray array];
        self.commodityArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    [self buildViewWithSkintype];
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    headView.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
    [self.view addSubview:headView];
    
    UIImageView * petPeaIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2.5, 15, 15)];
    petPeaIV.image = [UIImage imageNamed:@"peaicon"];
    [headView addSubview:petPeaIV];
    
    petPeaL = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 20)];
    [headView addSubview:petPeaL];
    petPeaL.backgroundColor = [UIColor clearColor];
    petPeaL.font = [UIFont systemFontOfSize:13];
    petPeaL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    petPeaL.text = [NSString stringWithFormat:@"宠豆:%@",[UserServe sharedUserServe].account.coin];
    
    [self setRightButtonWithName:@"兑换记录" BackgroundImg:nil Target:@selector(ExchangeRecordAction)];

    self.packageTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, self.view.frame.size.height-navigationBarHeight-20)];
    _packageTableview.delegate = self;
    _packageTableview.dataSource = self;
    _packageTableview.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
    _packageTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _packageTableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_packageTableview];
    
    [self.packageTableview addFooterWithTarget:self action:@selector(getCommodityList)];
    
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"goods" forKey:@"command"];
    [mDict setObject:@"trialTop2" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_tryArr addObjectsFromArray:responseObject[@"value"]];
        [_packageTableview reloadData];
    } failure:nil];
    [self getCommodityList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trialSuccess:) name:@"WXRTrialSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeSuccess:) name:@"WXRExchangeSuccess" object:nil];
    
    // Do any additional setup after loading the view.
}
- (void)exchangeSuccess:(NSNotification*)notification
{
    petPeaL.text = [NSString stringWithFormat:@"宠豆:%@",[UserServe sharedUserServe].account.coin];
}
- (void)trialSuccess:(NSNotification*)notification
{
    NSString * code = notification.userInfo[@"code"];
    int i = 0;
    NSDictionary * dic;
    for (;i<_tryArr.count;i++) {
        dic = _tryArr[i];
        if ([dic[@"code"] isEqualToString:code]) {
            [_tryArr removeObjectAtIndex:i];
            [_tryArr insertObject:notification.userInfo atIndex:i];
            [_packageTableview reloadData];
            break;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        if (_tryArr.count) {
            return 40;
        }else{
            return 0;
        }
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (_tryArr.count) {
            return 40;
        }else{
            return 0;
        }
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _tryArr.count;
    }
    return _commodityArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *trysCellIdentifier = @"trysCell";
        NSDictionary * dic = _tryArr[indexPath.row];
        TrysCell *cell = [tableView dequeueReusableCellWithIdentifier:trysCellIdentifier];
        if (cell == nil) {
            cell = [[TrysCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:trysCellIdentifier];
        }
        cell.imageV.imageURL = [NSURL URLWithString:dic[@"coverUrl"]];
        cell.ntitleLabel.text = dic[@"description"];
        cell.desLabel.text = dic[@"price"];
        if ([dic[@"state"] intValue] == 20)//即将开始
        {
            cell.stateL.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
            cell.stateL.text = @"即将开始";
        }else if ([dic[@"state"] intValue] == 21)//进行中
        {
            if([dic[@"orderState"] isEqualToString:@""])
            {
                cell.stateL.backgroundColor = [UIColor colorWithRed:173/255.0 green:169/255.0 blue:1 alpha:1];
                cell.stateL.text = @"我要试用";
            }
        }else if([dic[@"state"] intValue] == 22) {
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
        }else if([dic[@"orderState"] intValue]==42)//已通过
        {
            cell.stateL.backgroundColor = [UIColor colorWithRed:173/255.0 green:169/255.0 blue:1 alpha:1];
            cell.stateL.text = @"申请通过";
        }else if([dic[@"orderState"] intValue]==43)//已拒绝
        {
            cell.stateL.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
            cell.stateL.text = @"申请拒接";
        }else if([dic[@"orderState"] intValue]==44)//已通过
        {
            cell.stateL.backgroundColor = [UIColor colorWithRed:173/255.0 green:169/255.0 blue:1 alpha:1];
            cell.stateL.text = @"申请通过";
        }
        if (indexPath.row == _tryArr.count - 1) {
            cell.lineView.hidden = YES;
        }else{
            cell.lineView.hidden = NO;
        }
        if ([dic[@"postageType"] intValue]) {
            cell.freeFreight.hidden = YES;
        }else{
            cell.freeFreight.hidden = NO;
        }
        return cell;
    }else{
        static NSString *goodsCellIdentifier = @"goodsCell";
         NSDictionary * dic = _commodityArr[indexPath.row];
        GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellIdentifier];
        if (cell == nil) {
            cell = [[GoodsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:goodsCellIdentifier];
        }
        cell.imageV.imageURL = [NSURL URLWithString:dic[@"coverUrl"]];
        cell.ntitleLabel.text = dic[@"description"];
        cell.desLabel.text = dic[@"price"];
        if ([dic[@"postageType"] intValue]) {
            cell.freeFreight.hidden = YES;
        }else{
            cell.freeFreight.hidden = NO;
        }
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * header = @"header";
    HeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    if (view == nil) {
        view = [[HeaderView alloc] initWithReuseIdentifier:header];
    }
    if (section == 0) {
        view.titleL.text = @"免费试用";
    }
    if (section == 1) {
        view.titleL.text = @"宠豆商城";
    }
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        static NSString * header = @"header";
        FooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
        if (view == nil) {
            view = [[FooterView alloc] initWithReuseIdentifier:header];
            view.delegate = self;
        }
        return view;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GoodsDetailViewController * goodVC = [[GoodsDetailViewController alloc] init];
    switch (indexPath.section) {
        case 0:{
            goodVC.title = @"试用详情";
            goodVC.goodsDic = _tryArr[indexPath.row];
            goodVC.type = GoodsDetailTyepTrial;
            goodVC.trialSuccess = ^{
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:_tryArr[indexPath.row]];
                [dic setObject:@"41" forKey:@"orderState"];
                [_tryArr removeObjectAtIndex:indexPath.row];
                [_tryArr insertObject:dic atIndex:indexPath.row];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
        }break;
        case 1:{
            goodVC.title = @"商品详情";
            goodVC.goodsDic = _commodityArr[indexPath.row];
            goodVC.type = GoodsDetailTyepExchange;
        }break;
        default:
            break;
    }
    [self.navigationController pushViewController:goodVC animated:YES];
}
-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getCommodityList
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"goods" forKey:@"command"];
    [mDict setObject:@"exchangeList" forKey:@"options"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        [_commodityArr addObjectsFromArray:responseObject[@"value"]];
        [_packageTableview reloadData];
        [self.packageTableview footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.packageTableview footerEndRefreshing];
    }];
}
-(void)allTrail
{
    AllTrialViewController * allTrailVC = [[AllTrialViewController alloc] init];
    [self.navigationController pushViewController:allTrailVC animated:YES];
}
-(void)ExchangeRecordAction
{
    ExchangeRecordViewController * exchangeVC = [[ExchangeRecordViewController alloc] init];
    [self.navigationController pushViewController:exchangeVC animated:YES];
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
