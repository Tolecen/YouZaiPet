//
//  MyShuoshuoTimeLineViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/2/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "MyShuoshuoTimeLineViewController.h"
#import "GTScrollNavigationBar.h"
#import "BlankPageView.h"
@interface MyShuoshuoTimeLineViewController ()
{
    BlankPageView * blankPage;
}
@end

@implementation MyShuoshuoTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    //    _contentTableView.backgroundColor = [UIColor clearColor];
    _contentTableView.backgroundColor = [UIColor whiteColor];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_contentTableView];
    
    self.tHelper = [[TimelineBrowserHelper alloc] initWithController:self tableview:self.contentTableView withHead:NO header:nil];
    self.contentTableView.delegate = self.tHelper;
    self.contentTableView.dataSource = self.tHelper;
    
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"petalk" forKey:@"command"];
    [hotDic setObject:@"userList" forKey:@"options"];
    [hotDic setObject:@"10" forKey:@"pageSize"];
//    [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    [hotDic setObject:@"O" forKey:@"type"];
    
    self.tHelper.reqDict = hotDic;
    [self.contentTableView headerBeginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBlankPage:) name:@"WXRBrowserHelperZeroData" object:_tHelper];
}
-(void)showBlankPage:(NSNotification*)not
{
    if (!not.userInfo) {
        if (!blankPage) {
            __weak UINavigationController * weakNav = self.navigationController;
            blankPage = [[BlankPageView alloc] initWithImage];
            [blankPage showWithView:self.view image:[UIImage imageNamed:@"myComment_without"] buttonImage:[UIImage imageNamed:@"myComment_toCom"] action:^{
                [weakNav popToRootViewControllerAnimated:YES];
            }];
        }
    }
    else if(blankPage){
        [blankPage removeFromSuperview];
        blankPage = nil;
    }
}
-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
