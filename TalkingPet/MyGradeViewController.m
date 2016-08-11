//
//  MyGradeViewController.m
//  TalkingPet
//
//  Created by wangxr on 14/12/15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "MyGradeViewController.h"
#import "EGOImageView.h"
#import "DetailTableViewCell.h"
#import "MJRefresh.h"
#import "WebContentViewController.h"

@interface MyGradeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView * gradeV;
    UILabel * upL;
}
@property(nonatomic,retain)UITableView * tableView;
@property (nonatomic,retain) NSMutableArray *dataArr;
@end
@implementation MyGradeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(back)];
#pragma mark右边圆角问号
    UIButton*ruleB = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleB.frame = CGRectMake(ScreenWidth-28, 10, 20, 20);
    ruleB.titleLabel.font = [UIFont systemFontOfSize:10];
    [ruleB setTitle:@"?" forState:UIControlStateNormal];
    [ruleB setTintColor:[UIColor whiteColor]];
    ruleB.layer.cornerRadius = 10;
    ruleB.layer.masksToBounds =YES;
    ruleB.backgroundColor =[UIColor colorWithR:164 g:164 b:164 alpha:1];
    [self.view addSubview:ruleB];
    
    UIImageView * avatarbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9,  82, 72)];
    [avatarbg setImage:[UIImage imageNamed:@"usercenter_avatarbg"]];
    avatarbg.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:avatarbg];
    
#pragma mark积分相关
    UILabel*scoreL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-100, 80, 60, 20)];
    scoreL.backgroundColor = [UIColor clearColor];
    scoreL.font = [UIFont systemFontOfSize:14];
    scoreL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    scoreL.text = [NSString stringWithFormat:@"积分 %@",[UserServe sharedUserServe].account.score];
    [self.view addSubview:scoreL];
    
    CGSize zs = [scoreL.text sizeWithFont:scoreL.font constrainedToSize:CGSizeMake(100, 20) lineBreakMode:NSLineBreakByCharWrapping];
    
    [scoreL setFrame:CGRectMake(50+zs.width+30, navigationBarHeight+10, zs.width, 20)];
    
#pragma mark默认上方等级图标
    UIButton *LVIV = [[UIButton alloc]initWithFrame:CGRectMake(50+zs.width+5, navigationBarHeight-30, 100, 30)];
    
    
    [LVIV setTitleColor:CommonGreenColor forState:UIControlStateNormal];
    [LVIV setTitle:[NSString stringWithFormat:@"LV%d",(int)[[UserServe sharedUserServe].account.grade integerValue]]forState:UIControlStateNormal];
    LVIV.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:LVIV];
    LVIV.layer.borderColor = CommonGreenColor.CGColor;
    LVIV.layer.borderWidth = 1.f;
    LVIV.layer.cornerRadius = CGRectGetHeight(LVIV.frame) / 2;
    LVIV.layer.masksToBounds = YES;
    
#pragma mark左边默认等级
    UILabel * gradeL = [[UILabel alloc] initWithFrame:CGRectMake(10,scoreL.frame.origin.y+30, 30, 8)];
    gradeL.backgroundColor = [UIColor clearColor];
    gradeL.font = [UIFont systemFontOfSize:14];
    gradeL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    gradeL.text = [NSString stringWithFormat:@"LV.%d",(int)[[UserServe sharedUserServe].account.grade integerValue]];
    [self.view addSubview:gradeL];
#pragma marak右边等级
    UILabel * nextGradeL = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30,scoreL.frame.origin.y+28, 30, 8)];
    nextGradeL.backgroundColor = [UIColor clearColor];
    nextGradeL.font = [UIFont systemFontOfSize:14];
    nextGradeL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    nextGradeL.text = [NSString stringWithFormat:@"LV.%d",(int)[[UserServe sharedUserServe].account.grade integerValue]+1];
    [self.view addSubview:nextGradeL];
#pragma mark整个进度条背景颜色
    UIView*gradeBV = [[UIView alloc] initWithFrame:CGRectMake(40, scoreL.frame.origin.y+28, self.view.frame.size.width-80, 8)];
    [self.view addSubview:gradeBV];
    gradeBV.backgroundColor = [UIColor grayColor];
    gradeBV.layer.masksToBounds=YES;
    gradeBV.layer.cornerRadius = 5;
    gradeBV.layer.borderWidth=0.5f;
    gradeBV.layer.borderColor=[UIColor whiteColor].CGColor;
#pragma makr选中进度条颜色
    gradeV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    [gradeBV addSubview:gradeV];
    gradeV.backgroundColor = CommonGreenColor;
#pragma mark 升级还需要
    upL = [[UILabel  alloc] initWithFrame:CGRectMake(0, gradeBV.frame.origin.y+10, self.view.frame.size.width-50, 35)];
    upL.font = [UIFont systemFontOfSize:12];
    upL.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:upL];
    upL.backgroundColor = [UIColor clearColor];
#pragma mark表的相关操作
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, self.view.frame.size.width*0.57-40, self.view.frame.size.width-10, self.view.frame.size.height - navigationBarHeight-(self.view.frame.size.width*0.57-40+5)) style:UITableViewStylePlain];
    //    _tableView.layer.masksToBounds = YES;
    //    _tableView.layer.cornerRadius = 5;
    [self.view addSubview:_tableView];
    //    _tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [_tableView addFooterWithTarget:self action:@selector(getGradeDetail)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 35;
    
    [self buildViewWithSkintype];
    [self getGradeRule];
    [self getGradeDetail];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getGradeRule
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petGrade" forKey:@"command"];
    [mDict setObject:@"rule" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * ruleArr = responseObject[@"value"];
        if ([[UserServe sharedUserServe].account.grade integerValue]<12) {
            NSDictionary * dic = ruleArr[[[UserServe sharedUserServe].account.grade integerValue]];
            float sc = [[UserServe sharedUserServe].account.score floatValue]/[dic[@"scoreMax"] floatValue];
            gradeV.frame = CGRectMake(0, 0, (self.view.frame.size.width-150)*sc, 15);
            upL.text = [NSString stringWithFormat:@"还需%d积分升级",[dic[@"scoreMax"] intValue]-[[UserServe sharedUserServe].account.score intValue]+1];
        }else
        {
            gradeV.frame = CGRectMake(0, 0, 170, 15);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)getGradeDetail
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petScore" forKey:@"command"];
    [mDict setObject:@"detail" forKey:@"options"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    if ([self.dataArr lastObject]) {
        [mDict setObject:[self.dataArr lastObject][@"id"] forKey:@"startId"];
    }
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.dataArr addObjectsFromArray:responseObject[@"value"]];
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView footerEndRefreshing];
    }];
    
}
//- (void)showGradeRule
//{
//    WebContentViewController * vb = [[WebContentViewController alloc] init];
//    vb.urlStr =[@"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=202669793&idx=1&sn=c9f5d37b4dbbb73c1455e4f502324aa9#rd" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    vb.title = @"积分规则";
//    [self.navigationController pushViewController:vb animated:YES];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * c = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, (ScreenWidth-20)/3, 20)];
    c.backgroundColor = [UIColor clearColor];
    c.textAlignment = NSTextAlignmentRight;
    c.font = [UIFont systemFontOfSize:15];
    c.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    c.text = @"积分日志";
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
    cell.numberL.text = [NSString stringWithFormat:@"%ld",[dic[@"amount"] integerValue]*[dic[@"blsign"] integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    cell.dataL.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dic[@"createTime"] doubleValue]/1000]];
    return cell;
}
@end
