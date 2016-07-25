//
//  GiftPackageViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14/12/9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "GiftPackageViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "MJDetailViewController.h"
#import "TouchPropagatedScrollView.h"
#import "QHCommonUtil.h"
#define MENU_HEIGHT 36
#define MENU_BUTTON_WIDTH  100
#define MIN_MENU_FONT  13.f
#define MAX_MENU_FONT  18.f
//#import "MJSecondDetailViewController.h"
@interface GiftPackageViewController ()<MJPopupDelegate>
@property (nonatomic,strong) UIView * topNaviV;
@property (nonatomic,strong) TouchPropagatedScrollView * navScrollV;
@end

@implementation GiftPackageViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"会员礼包";
        self.dataArray = [NSMutableArray array];
        self.titleArray = [NSMutableArray array];
        self.codeArray = [NSMutableArray arrayWithObjects:@"DJ", nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    currentIndex = 1;
    buttonIndex = 0;
//    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    [self setRightButtonWithName:@"我的" BackgroundImg:nil Target:@selector(myPackage)];
     [self buildViewWithSkintype];

 
    
    self.sectionBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [self.sectionBtnView setBackgroundColor:[UIColor clearColor]];
    self.commentNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    currentButton = _commentNumBtn;
    [self.commentNumBtn setTitleColor:currentColor forState:UIControlStateNormal];
    [self.commentNumBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.commentNumBtn setFrame:CGRectMake(5, 0, 155, 30)];
    [self.commentNumBtn setBackgroundImage:[UIImage imageNamed:@"seleted_lift"] forState:UIControlStateNormal];
    [self.commentNumBtn setTitle:@"所有礼包" forState:UIControlStateNormal];
    [self.sectionBtnView addSubview:self.commentNumBtn];
    [self.commentNumBtn addTarget:self action:@selector(allBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.commentNumBtn.adjustsImageWhenHighlighted = NO;
    
    self.favorNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favorNumBtn setTitleColor:[UIColor colorWithWhite:100/255.0 alpha:1] forState:UIControlStateNormal];
    [self.favorNumBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.favorNumBtn setFrame:CGRectMake(160, 0, 155, 30)];
    [self.favorNumBtn setBackgroundImage:[UIImage imageNamed:@"unseleted_right"] forState:UIControlStateNormal];
    [self.favorNumBtn setTitle:@"我的礼包" forState:UIControlStateNormal];
    [self.sectionBtnView addSubview:self.favorNumBtn];
    [self.favorNumBtn addTarget:self action:@selector(myBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.favorNumBtn.adjustsImageWhenHighlighted = NO;

    
    self.packageTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, ScreenWidth, self.view.frame.size.height-navigationBarHeight-35)];
    _packageTableview.delegate = self;
    _packageTableview.dataSource = self;
    _packageTableview.backgroundView = nil;
    _packageTableview.scrollsToTop = YES;
    _packageTableview.backgroundColor = [UIColor clearColor];
    _packageTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _notiTableView.rowHeight = 90;
    //    _notiTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    _packageTableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_packageTableview];
    
//    _packageTableview.tableHeaderView = self.topMenu;
    
    [self.packageTableview addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
    //        [self.tableV headerBeginRefreshing];
    [self.packageTableview addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];

    
//    [self getPackageByType:0];
    [self getTabList];
    
    self.nocontentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 20)];
    [self.nocontentLabel setText:@"亲，还没有适合您的礼包哦"];
    [self.nocontentLabel setBackgroundColor:[UIColor clearColor]];
    [self.nocontentLabel setTextAlignment:NSTextAlignmentCenter];
    [self.nocontentLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.nocontentLabel];
    self.nocontentLabel.hidden = YES;
//    [self.packageTableview headerBeginRefreshing];
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup)];
//    tapRecognizer.numberOfTapsRequired = 1;
//    tapRecognizer.delegate = self;
//    [self.view addGestureRecognizer:tapRecognizer];
//    self.useBlurForPopup = YES;
    // Do any additional setup after loading the view.
}
-(void)myPackage
{
    MyBagListViewController * mv = [[MyBagListViewController alloc] init];
    [self.navigationController pushViewController:mv animated:YES];
}
- (void)createTwo
{
//    float btnW = 30;
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(_topNaviV.frame.size.width - btnW, 0, btnW, MENU_HEIGHT)];
//    [btn setBackgroundColor:[UIColor redColor]];
//    [btn setTitle:@"+" forState:UIControlStateNormal];
//    [_topNaviV addSubview:btn];
//    [btn addTarget:self action:@selector(showSelectView:) forControlEvents:UIControlEventTouchUpInside];
    
    _topNaviV = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, MENU_HEIGHT)];
    _topNaviV.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    [self.view addSubview:_topNaviV];
//
    NSArray *arT = self.titleArray;
    _navScrollV = [[TouchPropagatedScrollView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width - 10, MENU_HEIGHT)];
    [_navScrollV setShowsHorizontalScrollIndicator:NO];
    for (int i = 0; i < [arT count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(([arT count]<3?((ScreenWidth-20)/2):MENU_BUTTON_WIDTH) * i, 0, [arT count]<3?((ScreenWidth-20)/2):MENU_BUTTON_WIDTH, MENU_HEIGHT)];
        [btn setTitle:[arT objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i + 1;
        if(i==0)
        {
            [self changeColorForButton:btn red:1];
            btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
        }else
        {
            btn.titleLabel.font = [UIFont systemFontOfSize:MIN_MENU_FONT];
            [self changeColorForButton:btn red:0];
        }
        [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_navScrollV addSubview:btn];
    }
    [_navScrollV setContentSize:CGSizeMake(MENU_BUTTON_WIDTH * [arT count], MENU_HEIGHT)];
    [_topNaviV addSubview:_navScrollV];
}
-(void)getPackageWithId:(NSString *)theId
{
//    for (int i = 0; i<self.dataArray.count; i++) {
//        PackageInfo * pInfo = self.dataArray[i];
//        if ([pInfo.packageId isEqualToString:theId]) {
//            pInfo.haveGot = YES;
//            [self.dataArray replaceObjectAtIndex:i withObject:pInfo];
//        }
//        
//    }
//    [self.packageTableview reloadData];
    currentIndex = 1;
    [self getPackageByType:(int)buttonIndex];

}
-(void)alsoResetStatusHaveGotToIndex:(NSInteger)index
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        currentIndex = 1;
        [self getPackageByType:(int)buttonIndex];
//    });
    
}
-(void)getTabList
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"tab" forKey:@"command"];
    [mDict setObject:@"giftBag" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"no" forKey:@"petId"];
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"200"]) {
            [self.titleArray removeAllObjects];
            [self.codeArray removeAllObjects];
            NSArray * tA = [responseObject objectForKey:@"value"];
            for (int i = 0; i<tA.count; i++) {
                [self.titleArray addObject:[[tA objectAtIndex:i] objectForKey:@"memo"]];
                [self.codeArray addObject:[[tA objectAtIndex:i] objectForKey:@"code"]];
            }
            if (self.titleArray.count==1) {
                 [self.packageTableview setFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height)];
            }
            else if (self.titleArray.count>1){
                [self createTwo];
            }
            [self getPackageByType:(int)buttonIndex];
        }
 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    

}
-(void)getPackageByType:(int)theType
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"giftBag" forKey:@"command"];
    [mDict setObject:@"all" forKey:@"options"];
    [mDict setObject:self.codeArray[theType] forKey:@"code"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"no" forKey:@"petId"];
    [mDict setObject:@"20" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",(int)currentIndex] forKey:@"pageIndex"];
    //    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    NSLog(@"Get ShuoShuo:%@",mDict);
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"200"]) {
            if (currentIndex==1) {
                self.dataArray = [self getModelArray:[responseObject objectForKey:@"value"]];
//               self.dataArray = [self getModelArray:self.dataArray];
            }
            else{
                [self.dataArray addObjectsFromArray:[self getModelArray:[responseObject objectForKey:@"value"]]];
//                [self endRefreshing:self.packageTableview];
            }
            
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
- (void)actionbtn:(UIButton *)btn
{
//    [_scrollV scrollRectToVisible:CGRectMake(_scrollV.frame.size.width * (btn.tag - 1), _scrollV.frame.origin.y, _scrollV.frame.size.width, _scrollV.frame.size.height) animated:YES];
    currentIndex = 1;
    float xx = ScreenWidth * (btn.tag - 1) * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
    [_navScrollV scrollRectToVisible:CGRectMake(xx, 0, _navScrollV.frame.size.width, _navScrollV.frame.size.height) animated:YES];
    [self changeView:(int)btn.tag];
    buttonIndex = btn.tag-1;
    [self getPackageByType:(int)(btn.tag-1)];
    
}
- (void)changeColorForButton:(UIButton *)btn red:(float)nRedPercent
{
//    float value = [QHCommonUtil lerp:nRedPercent min:0 max:212];
    if (nRedPercent==1) {
        [btn setTitleColor:currentColor forState:UIControlStateNormal];
    }
    else
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}
- (void)changeView:(int)x
{

    

    for (UIButton * btn in _navScrollV.subviews) {
        if (![btn isKindOfClass:[UIButton class]]) {
            return;
        }

        if (btn.tag!=x) {

                btn.titleLabel.font = [UIFont systemFontOfSize:MIN_MENU_FONT];
                [self changeColorForButton:btn red:0];
            
        }
        else
        {

            btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
            [self changeColorForButton:btn red:1];
        }
    }

    

    

 
}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];
    currentColor = [UIColor colorWithRed:60/255.0 green:198/255.0 blue:255/255.0 alpha:1];
}
-(void)allBtnClicked:(UIButton *)sender
{
    if ([currentButton isEqual:_favorNumBtn]) {
        [self.commentNumBtn setBackgroundImage:[UIImage imageNamed:@"seleted_lift"] forState:UIControlStateNormal];
        [self.favorNumBtn setBackgroundImage:[UIImage imageNamed:@"unseleted_right"] forState:UIControlStateNormal];
        
        [self.commentNumBtn setTitleColor:currentColor forState:UIControlStateNormal];
        [self.favorNumBtn setTitleColor:[UIColor colorWithWhite:100/255.0 alpha:1] forState:UIControlStateNormal];
//        [self getHotPetalkList];
        currentButton = _commentNumBtn;
    }
}
-(void)myBtnClicked:(UIButton *)sender
{
    if ([currentButton isEqual:_commentNumBtn]) {
        [self.favorNumBtn setBackgroundImage:[UIImage imageNamed:@"seleted_right"] forState:UIControlStateNormal];
        [self.commentNumBtn setBackgroundImage:[UIImage imageNamed:@"unseleted_lift"] forState:UIControlStateNormal];
        
        [self.favorNumBtn setTitleColor:currentColor forState:UIControlStateNormal];
        [self.commentNumBtn setTitleColor:[UIColor colorWithWhite:100/255.0 alpha:1] forState:UIControlStateNormal];
//        [self getPetalkList];
        currentButton = _favorNumBtn;
    }
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
        cell.delegate = self;
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.packageInfo = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PackageInfoTableViewCell *cell = (PackageInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        [self presentPopup:pInfo Index:indexPath.row];
    }
    else if (pInfo.haveExpirdate){
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不好意思，礼包已经过期了" delegate:self cancelButtonTitle:@"好吧，知道了" otherButtonTitles: nil];
//        [alert show];
        
        [SVProgressHUD showErrorWithStatus:@"不好意思，礼包已经过期了"];
    }
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不好意思，您还没有权限预览这个礼包哦" delegate:self cancelButtonTitle:@"好吧，知道了" otherButtonTitles: nil];
//        [alert show];
        [SVProgressHUD showErrorWithStatus:@"不好意思，您还没有权限预览这个礼包哦"];

    }
}

- (void)tableViewHeaderRereshing:(UITableView *)tableView
{
    currentIndex=1;
    [self getPackageByType:(int)buttonIndex];
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
    currentIndex++;
    [self getPackageByType:(int)buttonIndex];
}
-(void)endRefreshing:(UITableView *)tableView
{
    //    self.isRefreshing = NO;
    [self.packageTableview footerEndRefreshing];
    [self.packageTableview headerEndRefreshing];
    [self.packageTableview reloadData];
    
}

-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Popup Functions

- (void)presentPopup:(PackageInfo *)package Index:(NSInteger)index {
    MJDetailViewController *detailViewController = [[MJDetailViewController alloc] init];
    detailViewController.delegate = self;
    detailViewController.cellIndex = index;
    detailViewController.packageInfo = package;
    [self presentPopupViewController:detailViewController animationType:4];
}

-(void)cancelButtonClicked:(MJDetailViewController *)detailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
}

#pragma mark - gesture recognizer delegate functions

// so that tapping popup view doesnt dismiss it

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
