//
//  RankingViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/3/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PetRankingViewController.h"
#import "EGOImageView.h"
#import "MJRefresh.h"
#import "ExperienceViewController.h"
#import "WebContentViewController.h"
#import "PersonProfileViewController.h"
@interface BigUserRankingCell : UITableViewCell
{
    UIView * view;
}
@property (nonatomic,retain)UIImageView * rankingIV;
@property (nonatomic,retain)EGOImageButton * headIV;
@property (nonatomic,retain)UIImageView * genderIV;
@property (nonatomic,retain)UILabel * nameL;
@property (nonatomic,retain)UILabel * scoreL;
@property (nonatomic,retain)EGOImageView * themIV1;
@property (nonatomic,retain)EGOImageView * themIV2;
@property (nonatomic,retain)EGOImageView * themIV3;
@property (nonatomic,copy)void(^headerAction)();
@end
@implementation BigUserRankingCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90 + 13 + (ScreenWidth - 20)/3)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        self.rankingIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 35.5, 45)];
        [self.contentView addSubview:_rankingIV];
        self.headIV = [[EGOImageButton alloc] initWithFrame:CGRectMake(ScreenWidth/2-22.5, 17, 45, 45)];
        _headIV.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
        [_headIV addTarget:self action:@selector(headerButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _headIV.layer.cornerRadius = 22.5;
        _headIV.layer.masksToBounds = YES;
        [self.contentView addSubview:_headIV];
        self.genderIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 67, 16, 16)];
        [self.contentView addSubview:_genderIV];
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, 200, 20)];
        _nameL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _nameL.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameL];
        
        self.scoreL = [[UILabel alloc] initWithFrame:CGRectMake(60, 65, 100, 20)];
        _scoreL.textColor = [UIColor colorWithRed:133/255.0 green:204/255.0 blue:1 alpha:1];
        _scoreL.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_scoreL];
        
        self.themIV1 = [[EGOImageView alloc] initWithFrame:CGRectMake(5, 90, (ScreenWidth - 20)/3, (ScreenWidth - 20)/3)];
        _themIV1.placeholderImage = [UIImage imageNamed:@"Placeholder"];
        [self.contentView addSubview:_themIV1];
        
        self.themIV2 = [[EGOImageView alloc] initWithFrame:CGRectMake(10+(ScreenWidth - 20)/3, 90, (ScreenWidth - 20)/3, (ScreenWidth - 20)/3)];
        _themIV2.placeholderImage = [UIImage imageNamed:@"Placeholder"];
        [self.contentView addSubview:_themIV2];
        
        self.themIV3 = [[EGOImageView alloc] initWithFrame:CGRectMake(15+(ScreenWidth - 20)*2/3, 90, (ScreenWidth - 20)/3, (ScreenWidth - 20)/3)];
        _themIV3.placeholderImage = [UIImage imageNamed:@"Placeholder"];
        [self.contentView addSubview:_themIV3];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [_nameL.text sizeWithFont:_nameL.font constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize sizeA = [_scoreL.text sizeWithFont:_scoreL.font constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByWordWrapping];
    _nameL.frame = CGRectMake(ScreenWidth/2-(size.width+sizeA.width)/2, _nameL.frame.origin.y, size.width, size.height);
    _genderIV.frame = CGRectMake(_nameL.frame.origin.x-_genderIV.frame.size.width-5, _genderIV.frame.origin.y, _genderIV.frame.size.width, _genderIV.frame.size.height);
    _scoreL.frame = CGRectMake(CGRectGetMaxX(_nameL.frame), _scoreL.frame.origin.y, sizeA.width, sizeA.height);
    if (!_themIV1.frame.size.width) {
        view.frame = CGRectMake(0, 0, ScreenWidth, 90 + 13);
    }else{
        view.frame = CGRectMake(0, 0, ScreenWidth, 90 + 13 + (ScreenWidth - 20)/3);
    }
}
- (void)headerButtonAction
{
    if (_headerAction) {
        _headerAction();
    }
}
@end
@interface CommonUserRankingCell : UITableViewCell

@property (nonatomic,retain)UILabel * rankingL;
@property (nonatomic,retain)EGOImageButton * headIV;
@property (nonatomic,retain)UIImageView * genderIV;
@property (nonatomic,retain)UILabel * nameL;
@property (nonatomic,retain)UILabel * scoreL;
@property (nonatomic,retain)EGOImageView * themIV1;
@property (nonatomic,retain)EGOImageView * themIV2;
@property (nonatomic,copy)void(^headerAction)();
@end
@implementation CommonUserRankingCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 65)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        
        self.rankingL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
        _rankingL.font = [UIFont systemFontOfSize:30];
        _rankingL.textColor = [UIColor colorWithRed:133/255.0 green:204/255.0 blue:1 alpha:1];
        [self.contentView addSubview:_rankingL];
        
        self.headIV = [[EGOImageButton alloc] initWithFrame:CGRectMake(55, 10, 45, 45)];
        _headIV.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
        [_headIV addTarget:self action:@selector(headerButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _headIV.layer.cornerRadius = 22.5;
        _headIV.layer.masksToBounds = YES;
        [self.contentView addSubview:_headIV];
        
        self.genderIV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 10, 16, 16)];
        [self.contentView addSubview:_genderIV];
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 200, 20)];
        _nameL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _nameL.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameL];
        
        self.scoreL = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 100, 20)];
        _scoreL.textColor = [UIColor colorWithWhite:120/255.0 alpha:1];
        _scoreL.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_scoreL];
        
        self.themIV1 = [[EGOImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 110, 7, 50, 50)];
        _themIV1.placeholderImage = [UIImage imageNamed:@"Placeholder"];
        [self.contentView addSubview:_themIV1];
        
        self.themIV2 = [[EGOImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 55, 7, 50, 50)];
        _themIV2.placeholderImage = [UIImage imageNamed:@"Placeholder"];
        [self.contentView addSubview:_themIV2];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [_rankingL.text sizeWithFont:_rankingL.font constrainedToSize:CGSizeMake(100, 100) lineBreakMode:NSLineBreakByWordWrapping];
    _rankingL.frame = CGRectMake(_rankingL.frame.origin.x, _rankingL.frame.origin.y, size.width, size.height);
    _headIV.frame = CGRectMake(CGRectGetMaxX(_rankingL.frame)+10, _headIV.frame.origin.y, _headIV.frame.size.width, _headIV.frame.size.height);
    if (_genderIV.image) {
        _genderIV.frame = CGRectMake(CGRectGetMaxX(_headIV.frame)+5, _genderIV.frame.origin.y, 16,16);
    }
    else
    {
        _genderIV.frame = CGRectMake(CGRectGetMaxX(_headIV.frame)+5, _genderIV.frame.origin.y, 0,16);
    }
    _genderIV.frame = CGRectMake(CGRectGetMaxX(_headIV.frame)+5, _genderIV.frame.origin.y, _genderIV.frame.size.width, _genderIV.frame.size.height);
    size = [_nameL.text sizeWithFont:_nameL.font constrainedToSize:CGSizeMake(ScreenWidth-CGRectGetMaxX(_genderIV.frame)-115, 20) lineBreakMode:NSLineBreakByWordWrapping];
    _nameL.frame = CGRectMake(CGRectGetMaxX(_genderIV.frame)+5, _nameL.frame.origin.y,size.width, size.height);
    size = [_scoreL.text sizeWithFont:_scoreL.font constrainedToSize:CGSizeMake(1000, 20) lineBreakMode:NSLineBreakByWordWrapping];
    _scoreL.frame = CGRectMake(CGRectGetMaxX(_headIV.frame)+5, _scoreL.frame.origin.y, size.width, size.height);
}
- (void)headerButtonAction
{
    if (_headerAction) {
        _headerAction();
    }
}
@end
@interface PetRankingViewController ()<UITableViewDelegate,UITableViewDataSource>
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

@implementation PetRankingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"萌宠排行";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    paihangType = 1;
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(backBtnDo)];
//    [self setRightButtonWithName:nil BackgroundImg:@"nav_button_rule" Target:@selector(rankingRule)];
    [self buildViewWithSkintype];
    
    self.buttonbgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    self.buttonbgV.backgroundColor = [UIColor whiteColor];
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
    [lineV setBackgroundColor:[UIColor colorWithWhite:230/255.0f alpha:1]];
    [self.buttonbgV addSubview:lineV];
    
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

    
    
    userView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight)];
    userView.scrollsToTop = YES;
    userView.delegate = self;
    userView.dataSource = self;
    userView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:userView];
    userView.tableHeaderView = self.buttonbgV;
    [userView addHeaderWithTarget:self action:@selector(getfirstPage)];
    [userView addFooterWithTarget:self action:@selector(getnextPage)];

    [userView headerBeginRefreshing];

}

-(void)getfirstPage
{
    if (paihangType==1) {
        [self getWeeklyFristUserList];
        
    }
    else
        [self getFristUserList];
}
-(void)getnextPage
{
    if (paihangType==1) {
        [self getWeeklyUserList];
    }
    else
        [self getUserList];
    
}

-(void)button1Clicked
{
    paihangType = 1;
    [userView headerBeginRefreshing];
    [self.button1 setBackgroundImage:[UIImage imageNamed:@"rank_leftbutton_selected"] forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:[UIImage imageNamed:@"rank_rightbutton_normal"] forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self getFristUserList];
}
-(void)button2Clicked
{
    paihangType = 2;
    [userView headerBeginRefreshing];
    [self.button2 setBackgroundImage:[UIImage imageNamed:@"rank_rightbutton_selected"] forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button1 setBackgroundImage:[UIImage imageNamed:@"rank_leftbutton_normal"] forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self getWeeklyFristUserList];
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
}
- (void)showUserView
{

}
- (void)getFristUserList
{
    page = 1;
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"rank" forKey:@"command"];
    [mDict setObject:@"petScoreTotalRankList" forKey:@"options"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        self.userList = [NSMutableArray arrayWithArray:[responseObject[@"value"] objectForKey:@"list"]];
        [userView reloadData];
        [userView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [userView headerEndRefreshing];
    }];
}
-(void)getUserList
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"rank" forKey:@"command"];
    [mDict setObject:@"petScoreTotalRankList" forKey:@"options"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        [_userList addObjectsFromArray:[responseObject[@"value"] objectForKey:@"list"]];
        [userView reloadData];
        [userView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [userView footerEndRefreshing];
    }];
}

- (void)getWeeklyFristUserList
{
    page = 1;
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"rank" forKey:@"command"];
    [mDict setObject:@"petScoreWeekRankList" forKey:@"options"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        self.userList = [NSMutableArray arrayWithArray:[responseObject[@"value"] objectForKey:@"list"]];
        [userView reloadData];
        [userView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [userView headerEndRefreshing];
    }];
}
-(void)getWeeklyUserList
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"rank" forKey:@"command"];
    [mDict setObject:@"petScoreWeekRankList" forKey:@"options"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        [_userList addObjectsFromArray:[responseObject[@"value"] objectForKey:@"list"]];
        [userView reloadData];
        [userView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [userView footerEndRefreshing];
    }];
}

#pragma mark- UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary * petDic = _userList[indexPath.row];
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = petDic[@"petId"];
    pv.petAvatarUrlStr = petDic[@"petHeadPortrait"];
    pv.petNickname = petDic[@"petNickName"];
    [self.navigationController pushViewController:pv animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<3) {
        NSDictionary * petDic = _userList[indexPath.row];
        if (((NSArray*)petDic[@"simplePetalkDTOs"]).count) {
            return 90 + 18 + (ScreenWidth - 20)/3;
        }
        return 90 + 18;
    }else
    {
        return 70;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * petDic = _userList[indexPath.row];
    __block PetRankingViewController * weakSelf = self;
    if (indexPath.row<3) {
        static NSString *petCellIdentifier = @"UserRankingCell";
        BigUserRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:petCellIdentifier];
        if (cell == nil) {
            cell = [[BigUserRankingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:petCellIdentifier];
        }
        switch (indexPath.row) {
            case 0:{
                cell.rankingIV.image = [UIImage imageNamed:@"usertop1"];
            }break;
            case 1:{
                cell.rankingIV.image = [UIImage imageNamed:@"usertop2"];
            }break;
            case 2:{
                cell.rankingIV.image = [UIImage imageNamed:@"usertop3"];
            }break;
            default:
                break;
        }
        cell.headIV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/90",petDic[@"petHeadPortrait"]]];
        cell.nameL.text = [NSString stringWithFormat:@"%@/",petDic[@"petNickName"]];
        cell.scoreL.text = [NSString stringWithFormat:@"%@积分",petDic[@"score"]];
        switch ([petDic[@"petGender"] integerValue]) {
            case 0:{
                cell.genderIV.image = [UIImage imageNamed:@"female"];
            }break;
            case 1:{
                cell.genderIV.image = [UIImage imageNamed:@"male"];
            }break;
            default:{
                cell.genderIV.image = nil;
            }break;
        }
        cell.themIV1.frame = CGRectZero;
        cell.themIV2.frame = CGRectZero;
        cell.themIV3.frame = CGRectZero;
        for (int i = 0; i<((NSArray*)petDic[@"simplePetalkDTOs"]).count; i++) {
            if (i>=3) {
                break;
            }
            NSDictionary * talkDic = ((NSArray*)petDic[@"simplePetalkDTOs"])[i];
            switch (i) {
                case 0:{
                    cell.themIV1.frame = CGRectMake(5, 90, (ScreenWidth - 20)/3, (ScreenWidth - 20)/3);
                    cell.themIV1.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",talkDic[@"photoUrl"]]];
                }break;
                case 1:{
                    cell.themIV2.frame = CGRectMake(10+(ScreenWidth - 20)/3, 90, (ScreenWidth - 20)/3, (ScreenWidth - 20)/3);
                    cell.themIV2.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",talkDic[@"photoUrl"]]];
                }break;
                case 2:{
                    cell.themIV3.frame = CGRectMake(15+(ScreenWidth - 20)*2/3, 90, (ScreenWidth - 20)/3, (ScreenWidth - 20)/3);
                    cell.themIV3.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",talkDic[@"photoUrl"]]];
                }break;
                default:
                    break;
            }
        }
        cell.headerAction = ^{

            
            
            ExperienceViewController * vc = [[ExperienceViewController alloc] init];
            vc.petId = petDic[@"petId"];
            vc.paihangType = paihangType;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else
    {
        static NSString *petCellIdentifier = @"CommonUserRankingCell";
        CommonUserRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:petCellIdentifier];
        if (cell == nil) {
            cell = [[CommonUserRankingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:petCellIdentifier];
        }
        cell.rankingL.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        cell.headIV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/90",petDic[@"petHeadPortrait"]]];
        cell.nameL.text = petDic[@"petNickName"];
        cell.scoreL.text = [NSString stringWithFormat:@"%@积分",petDic[@"score"]];
        switch ([petDic[@"petGender"] integerValue]) {
            case 0:{
                cell.genderIV.image = [UIImage imageNamed:@"female"];
            }break;
            case 1:{
                cell.genderIV.image = [UIImage imageNamed:@"male"];
            }break;
            default:{
                cell.genderIV.image = nil;
            }break;
        }
        cell.themIV1.frame = CGRectZero;
        cell.themIV2.frame = CGRectZero;
        for (int i = 0; i<((NSArray*)petDic[@"simplePetalkDTOs"]).count; i++) {
            if (i>=2) {
                break;
            }
            NSDictionary * talkDic = ((NSArray*)petDic[@"simplePetalkDTOs"])[i];
            switch (i) {
                case 0:{
                    cell.themIV1.frame = CGRectMake(ScreenWidth - 110, 7, 50, 50);
                    cell.themIV1.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",talkDic[@"photoUrl"]]];
                }break;
                case 1:{
                    cell.themIV2.frame = CGRectMake(ScreenWidth - 55, 7, 50, 50);
                    cell.themIV2.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",talkDic[@"photoUrl"]]];
                }break;
                default:
                    break;
            }
        }
        cell.headerAction = ^{
            PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
            pv.petId = petDic[@"petId"];
            pv.petAvatarUrlStr = petDic[@"petHeadPortrait"];
            pv.petNickname = petDic[@"petNickName"];
            [weakSelf.navigationController pushViewController:pv animated:YES];
        };
        return cell;
    }
    
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
