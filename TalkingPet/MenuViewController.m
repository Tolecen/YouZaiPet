//
//  MenuViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "MenuViewController.h"
#import "RootViewController.h"
#import "DraftsViewController.h"
#import "EGOImageView.h"
#import "UserCenterViewController.h"
#import "SelectedHotViewVontroller.h"
#import "GiftPackageViewController.h"
#import "MarketViewController.h"
#import "SetViewController.h"
#import "SearchViewController.h"

@protocol CurrentPetCellDelegate
- (void)draftsButtonAction;
@end
@interface CurrentPetCell : UITableViewCell
{

}
@property (nonatomic,assign) id <CurrentPetCellDelegate> delegate;
@property (nonatomic,retain)EGOImageView * photoView;
@property (nonatomic,retain)UILabel * nicknameL;
@property (nonatomic,strong) UIImageView * darenV;
@end
@implementation CurrentPetCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.photoView  = [[EGOImageView alloc] initWithFrame:CGRectZero];
        _photoView.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
        _photoView.layer.cornerRadius = 50;
        _photoView.layer.masksToBounds=YES;

        [self.contentView addSubview:_photoView];
        
        self.darenV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.darenV setImage:[UIImage imageNamed:@"daren"]];
        [self.contentView addSubview:self.darenV];
        
        self.nicknameL = [[UILabel alloc]initWithFrame:CGRectZero];
        _nicknameL.textAlignment = NSTextAlignmentCenter;
        _nicknameL.font = [UIFont boldSystemFontOfSize:15];
        _nicknameL.textColor = [UIColor whiteColor];
        _nicknameL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nicknameL];
        self.backgroundColor = [UIColor clearColor];
//        UIButton * draftsB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [draftsB setTitle:@"草稿箱" forState:UIControlStateNormal];
//        [draftsB setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        draftsB.frame = CGRectMake(0, _photoView.center.y, 150, 20);
//        [draftsB addTarget:self action:@selector(goToDrafts) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:draftsB];
    }
    return self;
}
-(void)layoutSubviews
{
    [self.photoView setFrame:CGRectMake((self.frame.size.width/2-50), 10, 100, 100)];
    [self.nicknameL setFrame:CGRectMake((self.frame.size.width/2-50), 120, 100, 20)];
    [self.darenV setFrame:CGRectMake((self.frame.size.width/2-22)/2.0f-30+60-17, 10+60-17, 17, 17)];
    _darenV.frame = CGRectMake((self.frame.size.width/2+26), 86, 17, 17);
    if ([UserServe sharedUserServe].currentPet) {
        self.darenV.hidden = ![UserServe sharedUserServe].currentPet.ifDaren;
    }
    else
        self.darenV.hidden = YES;
}
- (void)goToDrafts
{
    if (_delegate) {
        [_delegate draftsButtonAction];
    }
}
@end
@interface OtherCell : UITableViewCell
@property (nonatomic,retain)UIImageView * notiImageV;
@property (nonatomic,retain)UIImageView * xinFImageV;
@property (nonatomic,retain)UIImageView * iconView;
@property (nonatomic,retain)UILabel * titleL;
@end
@implementation OtherCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconView  = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth>320?10:5, 10, 25, 25)];
        _iconView.center = CGPointMake(_iconView.center.x, self.contentView.center.y);
        [self.contentView addSubview:_iconView];
        
        self.notiImageV = [[UIImageView alloc] initWithFrame:CGRectMake(50, 8, 10, 10)];
        [self.notiImageV setImage:[UIImage imageNamed:@"dotunread"]];
        [self.contentView addSubview:self.notiImageV];
        
        self.xinFImageV = [[UIImageView alloc] initWithFrame:CGRectMake(48, 8, 24, 10)];
        [self.xinFImageV setImage:[UIImage imageNamed:@"functionnew"]];
        [self.contentView addSubview:self.xinFImageV];
        
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth>320?50:45, 0, 150, 20)];
        _titleL.center = CGPointMake(_titleL.center.x, _iconView.center.y);
        _titleL.textColor = [UIColor whiteColor];
        _titleL.font = [UIFont boldSystemFontOfSize:15];
        _titleL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleL];
        self.backgroundColor = [UIColor clearColor];
        for (UIView * view in self.subviews) {
            view.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}
@end
@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource,CurrentPetCellDelegate>

@property (nonatomic,retain) NSArray * titleArr;
@property (nonatomic,retain) NSArray * iconArr;
@property (nonatomic,assign) BOOL needNotiChatMsg;
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.needNotiChatMsg = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildViewWithSkintype) name:@"WXRchangeSkin" object:nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+22, 0,self.view.frame.size.width/2-22, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    self.titleArr = @[@"宠豆商城",@"会员礼包",@"互动吧",@"我的任务"];
    self.iconArr = @[@"market",@"bag",@"interactionBar",@"mytask_icon"];
    
    UIButton * setB = [UIButton buttonWithType:UIButtonTypeCustom];
    [setB setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    setB.frame = CGRectMake(self.view.frame.size.width/2+22, self.view.frame.size.height-60, 27.5, 47.5);
    [setB addTarget:self action:@selector(showSetViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setB];
    UIButton * searchB = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchB setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    searchB.frame = CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-60, 27.5, 47.5);
    [searchB addTarget:self action:@selector(showSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchB];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:@"WXRLoginSucceed" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reloadView
{
    [_tableView reloadData];
}
-(void)draftsButtonAction
{
    if (![UserServe sharedUserServe].userName) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
    UINavigationController *navigationController = [RootViewController sharedRootViewController].topVC.currentC;
    
    DraftsViewController * draftsVC = [[DraftsViewController alloc] init];
    [navigationController pushViewController:draftsVC animated:YES];
    
    [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *petCellIdentifier = @"petCell";
        CurrentPetCell *cell = [tableView dequeueReusableCellWithIdentifier:petCellIdentifier ];
        if (cell == nil) {
            cell = [[CurrentPetCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:petCellIdentifier];
        }
        cell.delegate = self;
        if ([UserServe sharedUserServe].currentPet) {
            cell.photoView.imageURL =[NSURL URLWithString:[UserServe sharedUserServe].currentPet.headImgURL];
            cell.nicknameL.text = [UserServe sharedUserServe].currentPet.nickname;
        }else
        {
            cell.photoView.imageURL =nil;
            cell.nicknameL.text = @"未登录";
        }
        
        return cell;
    }
    else
    {
        static NSString *otherCellIdentifier = @"cell";
        OtherCell *cell = [tableView dequeueReusableCellWithIdentifier:otherCellIdentifier ];
        if (cell == nil) {
            cell = [[OtherCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:otherCellIdentifier];
        }
        cell.titleL.text = _titleArr[indexPath.row];
        cell.iconView.image = [UIImage imageNamed:_iconArr[indexPath.row]];
        cell.notiImageV.hidden = YES;
        cell.xinFImageV.hidden = YES;
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navigationController = [RootViewController sharedRootViewController].topVC.currentC;
    if (indexPath.section == 0) {
        if (![UserServe sharedUserServe].userName) {
            [[RootViewController sharedRootViewController] showLoginViewController];
            [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
            return;
        }
        UserCenterViewController * userCenterVC = [[UserCenterViewController alloc] init];
        [navigationController pushViewController:userCenterVC animated:YES];
    }else{
        if (indexPath.section == 1 && indexPath.row == 0) {
            if (![UserServe sharedUserServe].userName) {
                [[RootViewController sharedRootViewController] showLoginViewController];
                [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
                return;
            }
            MarketViewController * mv = [[MarketViewController alloc] init];
            [navigationController pushViewController:mv animated:YES];
        }else if (indexPath.section == 1 && indexPath.row == 1){
            if (![UserServe sharedUserServe].userName) {
                [[RootViewController sharedRootViewController] showLoginViewController];
                [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
                return;
            }
            GiftPackageViewController * giftVC = [[GiftPackageViewController alloc] init];
            [navigationController pushViewController:giftVC animated:YES];
        }
        else if (indexPath.section == 1 && indexPath.row == 2){
            InteractionListViewController * giftVC = [[InteractionListViewController alloc] init];
            giftVC.title = @"互动吧";
            [navigationController pushViewController:giftVC animated:YES];
        }
        else if (indexPath.section == 1 && indexPath.row == 3){
            if (![UserServe sharedUserServe].userName) {
                [[RootViewController sharedRootViewController] showLoginViewController];
                [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
                return;
            }
            MyTaskViewController * giftVC = [[MyTaskViewController alloc] init];
            [navigationController pushViewController:giftVC animated:YES];
        }
        else if (indexPath.section == 1 && indexPath.row == 4){
            
        }
    }
    [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
}
- (void)showSetViewController
{
    SetViewController * setVC = [[SetViewController alloc] init];
    UINavigationController *navigationController = [RootViewController sharedRootViewController].topVC.currentC;
    [navigationController pushViewController:setVC animated:YES];
    [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
}
- (void)showSearchViewController
{
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    UINavigationController *navigationController = [RootViewController sharedRootViewController].topVC.currentC;
    [navigationController pushViewController:searchVC animated:NO];
    [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
