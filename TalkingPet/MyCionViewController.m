//
//  MyCionViewController.m
//  TalkingPet
//
//  Created by wangxr on 14/12/15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "MyCionViewController.h"
#import "EGOImageView.h"
#import "DetailTableViewCell.h"
#import "MJRefresh.h"
#import "WebContentViewController.h"

@interface MyCionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView * tableView;
@property (nonatomic,retain) NSMutableArray *dataArr;
@end

@implementation MyCionViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的仔币";
        self.dataArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(back)];
    
    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, -80,  self.view.frame.size.width, self.view.frame.size.width*0.57)];
    [bgV setImage:[UIImage imageNamed:@"otherUsercenter_topbg"]];
    [self.view addSubview:bgV];

    
    UIButton*ruleB = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleB.frame = CGRectMake(ScreenWidth-65, 10, 60, 20);
    ruleB.titleLabel.font = [UIFont systemFontOfSize:11];
    [ruleB addTarget:self action:@selector(showCionRule) forControlEvents:UIControlEventTouchUpInside];
    [ruleB setBackgroundImage:[UIImage imageNamed:@"usercenter_pearule"] forState:UIControlStateNormal];
//    [ruleB setTitle:@"宠豆规则" forState:UIControlStateNormal];
    [self.view addSubview:ruleB];
    
    UIImageView * avatarbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9,  82, 72)];
    [avatarbg setImage:[UIImage imageNamed:@"usercenter_avatarbg"]];
    avatarbg.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:avatarbg];
    
    EGOImageView*photoIB = [[EGOImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    photoIB.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
    photoIB.layer.masksToBounds=YES;
    photoIB.layer.cornerRadius = 30;
    photoIB.imageURL = [NSURL URLWithString:[UserServe sharedUserServe].account.headImgURL];
    [self.view addSubview:photoIB];
    
    UILabel*nicknameL = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 170, 20)];
    nicknameL.backgroundColor = [UIColor clearColor];
//    nicknameL.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.6];
//    nicknameL.shadowOffset = CGSizeMake(2, 2);
    nicknameL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    nicknameL.text = [UserServe sharedUserServe].account.nickname;
    [self.view addSubview:nicknameL];
    
    UIImageView*genderIV = [[UIImageView alloc] initWithFrame:CGRectMake(85, 30, 20, 20)];
    switch ([[UserServe sharedUserServe].account.gender integerValue]) {
        case 0:{
            genderIV.image = [UIImage imageNamed:@"male"];
        }break;
        case 1:{
            genderIV.image = [UIImage imageNamed:@"male"];
        }break;
        default:{
            genderIV.image = nil;
            nicknameL.frame = CGRectMake(85, 30, 170, 20);
        }break;
    }
    [self.view addSubview:genderIV];
    
    UILabel*cionL = [[UILabel alloc] initWithFrame:CGRectMake(85, 55, 100, 20)];
    cionL.backgroundColor = [UIColor clearColor];
    cionL.font = [UIFont systemFontOfSize:14];
    cionL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
//    cionL.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.6];
//    cionL.shadowOffset = CGSizeMake(2, 2);
    cionL.text = [NSString stringWithFormat:@"仔币:%@",[UserServe sharedUserServe].account.coin];
    [self.view addSubview:cionL];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, self.view.frame.size.width*0.57-60, self.view.frame.size.width-10, self.view.frame.size.height - navigationBarHeight-(self.view.frame.size.width*0.57-60+5)) style:UITableViewStylePlain];
//    _tableView.layer.masksToBounds = YES;
//    _tableView.layer.cornerRadius = 5;
    [self.view addSubview:_tableView];
//    _tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [_tableView addFooterWithTarget:self action:@selector(getCionDetail)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 35;
    
    [self buildViewWithSkintype];
    [self getCionDetail];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getCionDetail
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petCoin" forKey:@"command"];
    [mDict setObject:@"detail" forKey:@"options"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    if ([self.dataArr lastObject]) {
        [mDict setObject:[self.dataArr lastObject][@"id"] forKey:@"startId"];
    }
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.dataArr addObjectsFromArray:responseObject[@"value"]];
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView footerEndRefreshing];
    }];
    
}
- (void)showCionRule
{
    WebContentViewController * vb = [[WebContentViewController alloc] init];
    vb.urlStr =[@"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=202670540&idx=1&sn=35f8555c432bfb9df8217f8f34cff90c#rd" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    vb.title = @"宠豆规则";
    [self.navigationController pushViewController:vb animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * a = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, (ScreenWidth-20)/3, 20)];
    a.backgroundColor = [UIColor clearColor];
    a.font = [UIFont systemFontOfSize:15];
    a.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    a.text = @"日期";
    [view addSubview:a];
    UILabel * b = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-20)/3, 5, (ScreenWidth-20)/3, 20)];
    b.backgroundColor = [UIColor clearColor];
    b.textAlignment = NSTextAlignmentCenter;
    b.font = [UIFont systemFontOfSize:15];
    b.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    b.text = @"操作";
    [view addSubview:b];
    UILabel * c = [[UILabel alloc] initWithFrame:CGRectMake(((ScreenWidth-20)/3)*2, 5, (ScreenWidth-20)/3, 20)];
    c.backgroundColor = [UIColor clearColor];
    c.textAlignment = NSTextAlignmentRight;
    c.font = [UIFont systemFontOfSize:15];
    c.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    c.text = @"宠豆";
    [view addSubview:c];
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(5, 29, ScreenWidth-20, 1)];
    lineV.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
    [view addSubview:lineV];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"petListcell";
    DetailTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary * dic = _dataArr[indexPath.row];
    cell.moneL.text = dic[@"memo"];
    cell.numberL.text = [NSString stringWithFormat:@"%d",[dic[@"amount"] integerValue]*[dic[@"blsign"] integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    cell.dataL.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dic[@"createTime"] doubleValue]/1000]];
    return cell;
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
