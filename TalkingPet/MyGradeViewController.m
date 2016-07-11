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
//    self.view.backgroundColor = [UIColor grayColor];
    
    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, -50,  self.view.frame.size.width, self.view.frame.size.width*0.57)];
    [bgV setImage:[UIImage imageNamed:@"otherUsercenter_topbg"]];
    [self.view addSubview:bgV];
    
    UIButton*ruleB = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleB.frame = CGRectMake(ScreenWidth-65, 10, 60, 20);
    ruleB.titleLabel.font = [UIFont systemFontOfSize:11];
    [ruleB addTarget:self action:@selector(showGradeRule) forControlEvents:UIControlEventTouchUpInside];
    [ruleB setBackgroundImage:[UIImage imageNamed:@"usercenter_scorerule"] forState:UIControlStateNormal];
//    [ruleB setTitle:@"积分规则" forState:UIControlStateNormal];
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
            genderIV.image = [UIImage imageNamed:@"female"];
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
    
    UILabel*scoreL = [[UILabel alloc] initWithFrame:CGRectMake(85, 55, 60, 20)];
    scoreL.backgroundColor = [UIColor clearColor];
    scoreL.font = [UIFont systemFontOfSize:14];
    scoreL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
//    scoreL.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.6];
//    scoreL.shadowOffset = CGSizeMake(2, 2);
    scoreL.text = [NSString stringWithFormat:@"积分:%@",[UserServe sharedUserServe].account.score];
    [self.view addSubview:scoreL];
    
    CGSize zs = [scoreL.text sizeWithFont:scoreL.font constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByCharWrapping];
    
    [scoreL setFrame:CGRectMake(85, 55, zs.width, 20)];
    
    
    UIImageView * LVIV= [[UIImageView alloc] initWithFrame:CGRectMake(85+zs.width+5, 58, 15, 15)];
    LVIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"LV%d",(int)[[UserServe sharedUserServe].account.grade integerValue]]];
    [self.view addSubview:LVIV];
    
    UILabel * LVL = [[UILabel alloc] initWithFrame:CGRectMake(85+zs.width+5+15, 55, 60, 20)];
    LVL.backgroundColor = [UIColor clearColor];
    LVL.font = [UIFont systemFontOfSize:14];
    LVL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
//    LVL.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.6];
//    LVL.shadowOffset = CGSizeMake(2, 2);
    LVL.text = [NSString stringWithFormat:@"等级:%d",(int)[[UserServe sharedUserServe].account.grade integerValue]];
    [self.view addSubview:LVL];
    
    UILabel * gradeL = [[UILabel alloc] initWithFrame:CGRectMake(30, 82, 30, 20)];
    gradeL.backgroundColor = [UIColor clearColor];
    gradeL.font = [UIFont systemFontOfSize:12];
    gradeL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
//    gradeL.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.6];
//    gradeL.shadowOffset = CGSizeMake(2, 2);
    gradeL.text = [NSString stringWithFormat:@"LV.%d",(int)[[UserServe sharedUserServe].account.grade integerValue]];
    [self.view addSubview:gradeL];
    
    UILabel * nextGradeL = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-85, 82, 30, 20)];
    nextGradeL.backgroundColor = [UIColor clearColor];
    nextGradeL.font = [UIFont systemFontOfSize:12];
    nextGradeL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
//    nextGradeL.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.6];
//    nextGradeL.shadowOffset = CGSizeMake(2, 2);
    nextGradeL.text = [NSString stringWithFormat:@"LV.%d",(int)[[UserServe sharedUserServe].account.grade integerValue]+1];
    [self.view addSubview:nextGradeL];
    
    UIView*gradeBV = [[UIView alloc] initWithFrame:CGRectMake(60, 85, self.view.frame.size.width-150, 15)];
    [self.view addSubview:gradeBV];
    gradeBV.backgroundColor = [UIColor whiteColor];
    gradeBV.layer.masksToBounds=YES;
    gradeBV.layer.cornerRadius = 7.5;
    gradeBV.layer.borderWidth=0.5f;
    gradeBV.layer.borderColor=[UIColor whiteColor].CGColor;
    
    gradeV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    [gradeBV addSubview:gradeV];
    gradeV.backgroundColor = [UIColor colorWithRed:179/255.0 green:176/255.0 blue:251/255.0 alpha:1];
    upL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-150, 15)];
    upL.font = [UIFont systemFontOfSize:12];
    upL.textAlignment = NSTextAlignmentCenter;
    upL.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
    [gradeBV addSubview:upL];
    upL.backgroundColor = [UIColor clearColor];
    
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
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * ruleArr = responseObject[@"value"];
        if ([[UserServe sharedUserServe].account.grade integerValue]<12) {
            NSDictionary * dic = ruleArr[[[UserServe sharedUserServe].account.grade integerValue]];
            float sc = [[UserServe sharedUserServe].account.score floatValue]/[dic[@"scoreMax"] floatValue];
            gradeV.frame = CGRectMake(0, 0, (self.view.frame.size.width-150)*sc, 15);
            upL.text = [NSString stringWithFormat:@"升级还需积分:%d",[dic[@"scoreMax"] integerValue]-[[UserServe sharedUserServe].account.score integerValue]+1];
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
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.dataArr addObjectsFromArray:responseObject[@"value"]];
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView footerEndRefreshing];
    }];

}
- (void)showGradeRule
{
    WebContentViewController * vb = [[WebContentViewController alloc] init];
    vb.urlStr =[@"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=202669793&idx=1&sn=c9f5d37b4dbbb73c1455e4f502324aa9#rd" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    vb.title = @"积分规则";
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
    c.text = @"积分";
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
@end
