//
//  CheckUpdateViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-8-27.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "CheckUpdateViewController.h"
#import "WXRTextViewController.h"

@interface CheckUpdateViewController ()<UIAlertViewDelegate>
{
    UIButton * updateB;
}
@end

@implementation CheckUpdateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于我们";
        self.titleArray = [NSArray arrayWithObjects:@"友仔小助手",@"支持我们，给好评", nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    UIImageView * bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, self.view.frame.size.height-5-navigationBarHeight)];
    bgIV.image = [UIImage imageNamed:@"squareBG"];
    bgIV.userInteractionEnabled = YES;
    [self.view addSubview:bgIV];
    
    UIImageView * iconV = [[UIImageView alloc] initWithFrame:CGRectMake(bgIV.center.x-75+5, 40, 70, 70)];
    [iconV setImage:[UIImage imageNamed:@"iconabout"]];
    [bgIV addSubview:iconV];
    iconV.layer.cornerRadius = 10;
    iconV.layer.masksToBounds = YES;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(bgIV.center.x+5+5, 60, 70, 50)];
    label.numberOfLines = 0;
    label.text =[NSString stringWithFormat:@"友仔\nV%@",CurrentVersion];
    [bgIV addSubview:label];
    
//    UILabel * addressL = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, bgIV.frame.size.width, 20)];
//    addressL.text = @"www.chongwushuo.com";
//    addressL.textAlignment = NSTextAlignmentCenter;
//    addressL.textColor = [UIColor grayColor];
//    [bgIV addSubview:addressL];
    
    self.settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 130, ScreenWidth, 200) style:UITableViewStyleGrouped];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
//    _settingTableView.backgroundView = uu;
    _settingTableView.backgroundColor = [UIColor whiteColor];
    _settingTableView.rowHeight = 45;
    _settingTableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
    _settingTableView.showsVerticalScrollIndicator = NO;
    _settingTableView.scrollEnabled = NO;
    [self.view addSubview:_settingTableView];
    
//    updateB = [UIButton buttonWithType:UIButtonTypeCustom];
//    [updateB setTitle:@"检查版本更新" forState:UIControlStateNormal];
//    [updateB setBackgroundImage:[UIImage imageNamed:@"lastVersion"] forState:UIControlStateNormal];
//    [updateB addTarget:self action:@selector(checkNewVersion) forControlEvents:UIControlEventTouchUpInside];
//    updateB.frame = CGRectMake(bgIV.center.x-68, 300, 135, 35);
//    [bgIV addSubview:updateB];
    
    UILabel * statementL= [[UILabel alloc] initWithFrame:CGRectMake(0, bgIV.frame.size.height-50, bgIV.frame.size.width, 40)];
    statementL.text = @"上海钰宠宠物用品有限公司\t版权所有\n© buybestpet.com, All Rights Reserved";
    statementL.font = [UIFont systemFontOfSize:12];
    statementL.numberOfLines = 0;
    statementL.textAlignment = NSTextAlignmentCenter;
    statementL.textColor = [UIColor grayColor];
    [bgIV addSubview:statementL];
    
    UIButton * userB = [UIButton buttonWithType:UIButtonTypeCustom];
    userB.frame = CGRectMake(ScreenWidth/2-120-5, bgIV.frame.size.height-150, 120, 30);
    [userB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    userB.titleLabel.font = [UIFont systemFontOfSize:16];
    [userB setTitle:@"用户协议" forState:UIControlStateNormal];
    [userB addTarget:self action:@selector(userProtocol) forControlEvents:UIControlEventTouchUpInside];
    [bgIV addSubview:userB];
    userB.layer.cornerRadius = 5;
    userB.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    userB.layer.borderWidth = 1;
    userB.layer.shadowColor = [[UIColor grayColor] CGColor];
    
    
    UIButton * openB = [UIButton buttonWithType:UIButtonTypeCustom];
    openB.frame = CGRectMake(ScreenWidth/2+5, bgIV.frame.size.height-150, 120, 30);
    [openB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    openB.titleLabel.font = [UIFont systemFontOfSize:16];
    [openB setTitle:@"开源组件许可" forState:UIControlStateNormal];
    [openB addTarget:self action:@selector(openSourcePermissionPage) forControlEvents:UIControlEventTouchUpInside];
    [bgIV addSubview:openB];
    openB.layer.cornerRadius = 5;
    openB.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    openB.layer.borderWidth = 1;
    
//    UILabel * addressL = [[UILabel alloc] initWithFrame:CGRectMake(0, bgIV.frame.size.height-100, bgIV.frame.size.width, 20)];
//    addressL.font = [UIFont systemFontOfSize:12];
//    addressL.text = @"www.chongwushuo.com";
//    addressL.textAlignment = NSTextAlignmentCenter;
//    addressL.textColor = [UIColor grayColor];
//    [bgIV addSubview:addressL];
    
    if ([SystemServer sharedSystemServer].appstoreIsInReview) {
        [self creatiADView];
    }
    
    [self buildViewWithSkintype];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row==0) {
//        WelcomeViewController * welcomeVC = [[WelcomeViewController alloc] init];
//        welcomeVC.needCloseBn = YES;
//        [self addChildViewController:welcomeVC];
//        [welcomeVC.view setFrame:self.view.bounds];
//        [self.view addSubview:welcomeVC.view];
//    }
    if (indexPath.row==0){
        WebContentViewController * vb = [[WebContentViewController alloc] init];
        vb.urlStr =[@"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=200867907&idx=1&sn=7119893f3ed7c8615b074347a56c9519#rd" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        vb.title = @"友仔小帮手";
        [self.navigationController pushViewController:vb animated:YES];
    }
    else if (indexPath.row==1){
        NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id914242691"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
    }
    else if (indexPath.row==3){
        [self checkNewVersion];
    }
}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];
    [updateB setBackgroundImage:[UIImage imageNamed:@"lastVersion"] forState:UIControlStateNormal];
}
-(void)creatiADView
{
    float h = [UIScreen mainScreen].bounds.size.height;
    imgV = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgV setFrame:CGRectMake(5, self.view.frame.size.height-50-navigationBarHeight-5, self.view.frame.size.width-10, 50.0)];
    [imgV setImage:[UIImage imageNamed:@"adbanner"] forState:UIControlStateNormal];
    [self.view addSubview:imgV];
    [imgV addTarget:self action:@selector(adclicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * deleteB  = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteB.tag = 2013;
    deleteB.frame = CGRectMake(ScreenWidth-35, self.view.frame.size.height-50-navigationBarHeight+5, 30, 30);
    [deleteB setBackgroundImage:[UIImage imageNamed:@"deletenewop"] forState:UIControlStateNormal];
    [deleteB addTarget:self action:@selector(removeadvertisement:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteB];
    //    //以画面直立的方式设定Banner于画面底部
    //    bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    //    bannerView.backgroundColor = [UIColor redColor];
    //    [bannerView setFrame:CGRectMake(0.0, self.view.frame.size.height-44-[self originY]-50-50, self.view.frame.size.width, 50.0)];
    NSLog(@"THEFRAMEHEIGHT:%f",h);
    //    //此Banner所能支援的类型
    ////    bannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    //
    //    //目前的Banner 类型
    //    bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    //
    //    //设定代理
    //    bannerView.delegate = self;
    //
    //    //无法按下触发广告
    //    bannerView.userInteractionEnabled = YES;
    //
    //    [self.view addSubview:bannerView];
}
-(void)adclicked
{
    NSString * appLink = @"https://itunes.apple.com/us/app/chong-wu-quan-ai-chong-wu/id686838840?ls=1&mt=8";
    NSURL *url = [NSURL URLWithString:appLink];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}
-(void)removeadvertisement:(UIButton *)sender
{
    [sender removeFromSuperview];
    [imgV removeFromSuperview];
}
- (void)backBtnDo
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)userProtocol
{
    WXRTextViewController * controller = [[WXRTextViewController alloc] init];
    controller.title = @"用户协议";
    NSString *path =[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"UserProtocol"ofType:@"txt"]];
    NSData* data = [[NSData alloc]initWithContentsOfFile:path];
    controller.content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)openSourcePermissionPage
{
    WebContentViewController * vb = [[WebContentViewController alloc] init];
    vb.urlStr =[@"http://www.chongwushuo.com/ios_opensource.html" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //        vb.url = [NSURL URLWithString:[@"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=200867907&idx=1&sn=7119893f3ed7c8615b074347a56c9519#rd" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    vb.title = @"开源组件许可";
    [self.navigationController pushViewController:vb animated:YES];
}
- (void)checkNewVersion
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"system" forKey:@"command"];
    [mDict setObject:@"version" forKey:@"options"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = responseObject[@"value"];
        
        NSArray *localVersion = [CurrentVersion componentsSeparatedByString:@"."];
        NSArray *serverVersion = [dic[@"vname"] componentsSeparatedByString:@"."];
        
        int hVFirst = [[NSString stringWithFormat:@"%@",[localVersion objectAtIndex:0]] intValue];
        int hVSecond = [[NSString stringWithFormat:@"%@",[localVersion objectAtIndex:1]] intValue];
        int hVThird = [[NSString stringWithFormat:@"%@",[localVersion objectAtIndex:2]] intValue];
        int lVFirst = [[NSString stringWithFormat:@"%@",[serverVersion objectAtIndex:0]] intValue];
        int lVSecond = [[NSString stringWithFormat:@"%@",[serverVersion objectAtIndex:1]] intValue];
        int lVThird = [[NSString stringWithFormat:@"%@",[serverVersion objectAtIndex:2]] intValue];
        
        if (hVFirst<lVFirst) {
            if ([dic[@"compulsively"] isEqualToString:@"true"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本，您的版本已经不符合最低版本要求，请您前往App Store下载，否则会影响您的正常使用哦" delegate:self cancelButtonTitle:@"好的，现在去" otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
                //                NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id914242691"];
                //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本,请前往App Store下载!" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:@"现在去", nil];
                alert.tag = 2;
                [alert show];
            }
        }
        else if (hVFirst==lVFirst&&hVSecond<lVSecond){
            if ([dic[@"compulsively"] isEqualToString:@"true"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本，您的版本已经不符合最低版本要求，请您前往App Store下载，否则会影响您的正常使用哦" delegate:self cancelButtonTitle:@"好的，现在去" otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
                //                NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id914242691"];
                //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本,请前往App Store下载!" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:@"现在去", nil];
                alert.tag = 2;
                [alert show];
            }
            
        }
        else if(hVFirst==lVFirst&&hVSecond==lVSecond&&hVThird<lVThird){
            if ([dic[@"compulsively"] isEqualToString:@"true"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本，您的版本已经不符合最低版本要求，请您前往App Store下载，否则会影响您的正常使用哦" delegate:self cancelButtonTitle:@"好的，现在去" otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
                //                NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id914242691"];
                //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本,请前往App Store下载!" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:@"现在去", nil];
                alert.tag = 2;
                [alert show];
            }
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您使用的就是最新版本的友仔啦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            alert.tag = 1;
            [alert show];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    [self backBtnDo];
    if (buttonIndex == 1) {
        NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id914242691"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
    }
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
