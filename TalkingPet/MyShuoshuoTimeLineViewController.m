//
//  MyShuoshuoTimeLineViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/2/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "MyShuoshuoTimeLineViewController.h"
#import "GTScrollNavigationBar.h"
//#import "BlankPageView.h"
@interface MyShuoshuoTimeLineViewController ()
{
    UIView * blankPage;
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
            blankPage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
            blankPage.backgroundColor=[UIColor whiteColor];
            [self.view addSubview:blankPage];
            
            UIImageView *imgV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dongtai@2x"]];
            
            imgV.frame=CGRectMake((ScreenWidth-85.2)/2, 172, 85.2, 69);
            [blankPage addSubview:imgV];
            
            UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 261, ScreenWidth, 20)];
            lab.text=@"您还没有发布动态";
            lab.textColor=[UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:0.50];
            lab.textAlignment=NSTextAlignmentCenter;
            [blankPage addSubview:lab];
            
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame=CGRectMake((ScreenWidth-99)/2, 306, 99, 38);
            [btn setTitle:@"立即发布" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.39 green:0.80 blue:0.69 alpha:1.00] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gofabuClick) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.masksToBounds=YES;
            btn.layer.cornerRadius=5;
            btn.layer.borderWidth=1;
            btn.layer.borderColor=[UIColor colorWithRed:0.39 green:0.80 blue:0.69 alpha:1.00].CGColor;
            btn.backgroundColor=[UIColor whiteColor];
            [blankPage addSubview:btn];
        }
    }
    else if(blankPage){
        [blankPage removeFromSuperview];
        blankPage = nil;
    }
}
//发布跳转方法
-(void)gofabuClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
