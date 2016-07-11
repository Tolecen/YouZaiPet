//
//  SquareListViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/1/29.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "SquareListViewController.h"
#import "MJRefresh.h"
#import "EGOImageView.h"
#import "TagTalkListViewController.h"
#import "PetalkalkListViewController.h"
#import "WebContentViewController.h"
#import "TalkingDetailPageViewController.h"
#import "PrizeListViewController.h"
#import "RootViewController.h"
@interface SquareCell : UITableViewCell
@property (nonatomic,retain)EGOImageView * imageV;
@end
@implementation SquareCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageV = [[EGOImageView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-10, (ScreenWidth-10)*0.3)];
        [self.contentView addSubview:_imageV];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
@end;

@interface SquareListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView * tableview;
@property (nonatomic,retain) NSMutableArray * dataArr;
@end
@implementation SquareListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    [self buildViewWithSkintype];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableview];
    _tableview.rowHeight = (ScreenWidth-10)*0.3+5;
    
    [_tableview addHeaderWithTarget:self action:@selector(getdataList)];
    [_tableview headerBeginRefreshing];
}
-(void)backBtnDo
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getdataList
{
    NSMutableDictionary* updateDict = [NetServer commonDict];
    [updateDict setObject:@"layout" forKey:@"command"];
    [updateDict setObject:@"datum" forKey:@"options"];
    [updateDict setObject:_squaerCode forKey:@"code"];
    [NetServer requestWithParameters:updateDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataArr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"value"]) {
            SquareIteam * iteam = [[SquareIteam alloc] init];
            iteam.handleType = dic[@"handleType"];
            iteam.iconUrl = dic[@"iconUrl"];
            iteam.title = dic[@"title"];
            iteam.key = dic[@"key"];
            [_dataArr addObject:iteam];
        }
        [_tableview headerEndRefreshing];
        [_tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableview headerEndRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *goodsCellIdentifier = @"SquareCell";
    SquareCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellIdentifier];
    if (cell == nil) {
        cell = [[SquareCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:goodsCellIdentifier];
    }
    SquareIteam * iteam = [_dataArr objectAtIndex:indexPath.row];
    cell.imageV.imageURL = [NSURL URLWithString:iteam.iconUrl];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SquareIteam*iteam = _dataArr[indexPath.row];
    [[self class] actionTheSquareIteam:iteam withNavigationController:self.navigationController];
}
+(void)actionTheSquareIteam:(SquareIteam*)iteam withNavigationController:(UINavigationController *)navigationController
{

    switch ([iteam.handleType integerValue]) {
        case 2:{
            TagTalkListViewController * tagTlistV = [[TagTalkListViewController alloc] init];
            tagTlistV.title = iteam.title;
            Tag * tag = [[Tag alloc] init];
            tag.tagID = iteam.key;
            tag.tagName = iteam.title;
            tagTlistV.tag = tag;
            tagTlistV.shouldRequestTagInfo = YES;
            [navigationController pushViewController:tagTlistV animated:YES];
        }break;
        case 3:{
            PetalkalkListViewController * tagTlistV = [[PetalkalkListViewController alloc] init];
            tagTlistV.otherCode = iteam.key;
            tagTlistV.title = iteam.title;
            tagTlistV.listTyep = PetalkListTyepChannel;
            [navigationController pushViewController:tagTlistV animated:YES];
        }break;
        case 4:{
            PetalkalkListViewController * tagTlistV = [[PetalkalkListViewController alloc] init];
            tagTlistV.otherCode = iteam.key;
            tagTlistV.title = iteam.title;
            tagTlistV.listTyep = PetalkListTyepPetBreed;
            [navigationController pushViewController:tagTlistV animated:YES];
        }break;
        case 5:{
            PetalkalkListViewController * tagTlistV = [[PetalkalkListViewController alloc] init];
            tagTlistV.title = iteam.title;
            tagTlistV.listTyep = PetalkListTyepAllPetalk;
            [navigationController pushViewController:tagTlistV animated:YES];
        }break;
        case 6:{
            SquareListViewController * squaerListVC = [[SquareListViewController alloc] init];
            squaerListVC.title = iteam.title;
            squaerListVC.squaerCode = iteam.key;
            [navigationController pushViewController:squaerListVC animated:YES];
        }break;
        case 7:{
            WebContentViewController * vb = [[WebContentViewController alloc] init];
            vb.urlStr =iteam.key;
            [navigationController pushViewController:vb animated:YES];
        }break;
        case 8:{
            TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
            TalkingBrowse * tb = [[TalkingBrowse alloc] init];
            tb.theID = iteam.key;
            talkingDV.talking = tb;
            [navigationController pushViewController:talkingDV animated:YES];
        }break;
//        case 9:{
//            //排行
//        }break;
        case 10:{
            if (![UserServe sharedUserServe].account) {
                [[RootViewController sharedRootViewController] showLoginViewController];
                return;
            }
            PrizeListViewController * prizeVC = [[PrizeListViewController alloc] init];
            prizeVC.squareKey = iteam.key;
            [navigationController pushViewController:prizeVC animated:YES];
        }break;
        case 11:{
            InteractionBarViewController * interBar = [[InteractionBarViewController alloc] init];
            interBar.hideNaviBg = YES;
            interBar.state = 1;
            [navigationController pushViewController:interBar animated:YES];
        }break;
        case 15:{
            if (![UserServe sharedUserServe].account) {
                [[RootViewController sharedRootViewController] showLoginViewController];
                return;
            }
            GetQuanViewController * interBar = [[GetQuanViewController alloc] init];
            interBar.activityId = iteam.key;
            [navigationController pushViewController:interBar animated:YES];
        }break;
        default:
        {
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:nil message:@"攻城狮正在努力开发，敬请期待" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles:nil];
            [alertV show];
        }break;
    }
}

@end
