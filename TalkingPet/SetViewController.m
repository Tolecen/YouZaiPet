//
//  SetViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-14.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "SetViewController.h"
#import "RootViewController.h"
#import "ChangePasswordViewController.h"
#import "CheckUpdateViewController.h"
#import "OpinionViewController.h"
#import "EGOCache.h"
#import "TFileManager.h"
#import <StoreKit/StoreKit.h>
#import "SystemServer.h"
#import "ChangeSkinViewController.h"
#import "SVProgressHUD.h"

@interface SetViewController ()<SKStoreProductViewControllerDelegate>
{
    float cacheSize;
}
@end

@implementation SetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
        self.sectionFirstArray = [NSArray arrayWithObjects:@"关于宠物说", nil];
        self.sectionFirstArray_2 = [NSArray arrayWithObjects:@"草稿箱", nil];

//        self.sectionFirstArraytwo = [NSArray arrayWithObjects:@"播放设置",@"个性化皮肤", nil];
        self.sectionSecondArray = [NSArray arrayWithObjects:@"播放设置", nil];
        self.sectionSecondArrayA = [NSArray arrayWithObjects:@"播放设置",@"图片设置",@"私信设置", nil];
        self.sectionSecondArrayB = [NSArray arrayWithObjects:@"播放设置", nil];
        self.sectionThirdArray = [NSArray arrayWithObjects:@"意见反馈",@"清理缓存", nil];
        self.sectionForthArrayA = [NSArray arrayWithObjects:@"修改密码",@"退出登录", nil];
        self.sectionForthArrayB = [NSArray arrayWithObjects:@"登录", nil];
        self.allArrayA = [NSArray arrayWithObjects:self.sectionFirstArray,self.sectionFirstArray_2,self.sectionSecondArray,self.sectionThirdArray,self.sectionForthArrayA, nil];
        self.allArrayB = [NSArray arrayWithObjects:self.sectionFirstArray,self.sectionFirstArray_2,self.sectionSecondArray,self.sectionThirdArray,self.sectionForthArrayB, nil];
        
        loggingOut = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshLogStatus];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView * uu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, self.view.frame.size.height-navigationBarHeight-5)];
    [uu setBackgroundColor:[UIColor whiteColor]];
    [uu setAlpha:0.8];
    
    [self setBackButtonWithTarget:@selector(backAction)];

    self.settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight) style:UITableViewStyleGrouped];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    _settingTableView.backgroundView = uu;
    _settingTableView.backgroundColor = [UIColor clearColor];
    _settingTableView.rowHeight = 45;
    _settingTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    _settingTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_settingTableView];
    [self buildViewWithSkintype];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_queue_t queue = dispatch_queue_create("com.pet.getLatLoncache", NULL);
    dispatch_async(queue, ^{
        cacheSize = [TFileManager allCacheSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_settingTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:ifHasLogin?3:2]] withRowAnimation:UITableViewRowAnimationNone];
        });
    });
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.allArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.allArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ifHasLogin) {
        if (indexPath.section == 3 && indexPath.row == 1) {
            static NSString *identifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
            UILabel * label = (UILabel *)[cell viewWithTag:100];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-70-30, 13, 70, 20)];
                label.tag = 100;
                label.textColor = [UIColor grayColor];
                [cell addSubview:label];
                label.textAlignment = NSTextAlignmentRight;
            }
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [[self.allArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            label.text = [NSString stringWithFormat:@"%.2fM",cacheSize];
            return cell;
        }
        else
        {
            static NSString *cellIdentifier = @"settingCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            //        cell.backgroundColor = [UIColor whiteColor];
            //        cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [[self.allArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            return cell;
        }
    }
    else{
        if (indexPath.section == 2 && indexPath.row == 1) {
            static NSString *identifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
            UILabel * label = (UILabel *)[cell viewWithTag:100];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-70-30, 13, 70, 20)];
                label.tag = 100;
                label.textColor = [UIColor grayColor];
                [cell addSubview:label];
                label.textAlignment = NSTextAlignmentRight;
            }
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [[self.allArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            label.text = [NSString stringWithFormat:@"%.2fM",cacheSize];
            return cell;
        }else
        {
            static NSString *cellIdentifier = @"settingCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
    //        cell.backgroundColor = [UIColor whiteColor];
    //        cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [[self.allArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0) {
//        WelcomeViewController * welcomeVC = [[WelcomeViewController alloc] init];
//        welcomeVC.needCloseBn = YES;
//        [self addChildViewController:welcomeVC];
//        [welcomeVC.view setFrame:self.view.bounds];
//        [self.view addSubview:welcomeVC.view];
        
        CheckUpdateViewController * updataVC = [[CheckUpdateViewController alloc] init];
        [self.navigationController pushViewController:updataVC animated:YES];
    }
    
    if (ifHasLogin) {
        if(indexPath.section==1){
            [self draftsButtonAction];
        }
        else if (indexPath.section==2){
            if (indexPath.row==0) {
                PlaySettingViewController * vc = [[PlaySettingViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if (indexPath.row==1){
                PicSaveSettingViewController * picSet = [[PicSaveSettingViewController alloc] init];
                picSet.title = @"图片保存设置";
                [self.navigationController pushViewController:picSet animated:YES];
            }
            else if (indexPath.row==2){
                ChatSettingViewController * cv = [[ChatSettingViewController alloc] init];
                cv.title = @"私信设置";
                [self.navigationController pushViewController:cv animated:YES];
            }
        }
        else if (indexPath.section==3){
            if (indexPath.row==0) {
                OpinionViewController * opinionVC = [[OpinionViewController alloc] init];
                [self.navigationController pushViewController:opinionVC animated:YES];
            }
            else if (indexPath.row==1){
                [self cleanUpCache];
            }
        }
        else if (indexPath.section==4){
            if (self.sectionForthArray.count==1&&indexPath.section==4) {
                //        NSString * uName = [UserServe sharedUserServe].userName;
                if (ifHasLogin) {
                    [self doLogOut];
                }
                else
                    [self showLoginView];
            }
            else if (self.sectionForthArray.count==2&&indexPath.section==4) {
                if (indexPath.row==1) {
                    [self doLogOut];
                }
                if (indexPath.row==0) {
                    ChangePasswordViewController * changeVC = [[ChangePasswordViewController alloc] init];
                    [self.navigationController pushViewController:changeVC animated:YES];
                }
            }
        }
    }
    else
    {
        if(indexPath.section==1){
            if (indexPath.row==0) {
                PlaySettingViewController * vc = [[PlaySettingViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if (indexPath.section==2){
            if (indexPath.row==0) {
                OpinionViewController * opinionVC = [[OpinionViewController alloc] init];
                [self.navigationController pushViewController:opinionVC animated:YES];
            }
            else if (indexPath.row==1){
                [self cleanUpCache];
            }
        }
        else if (indexPath.section==3){
            [self showLoginView];
        }
    }
    
    
    /*
    if (indexPath.section==0&&indexPath.row==1) {
        WebContentViewController * vb = [[WebContentViewController alloc] init];
        vb.urlStr =[@"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=200867907&idx=1&sn=7119893f3ed7c8615b074347a56c9519#rd" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        vb.url = [NSURL URLWithString:[@"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=200867907&idx=1&sn=7119893f3ed7c8615b074347a56c9519#rd" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        vb.title = @"宠物说小帮手";
        [self.navigationController pushViewController:vb animated:YES];
    }
    if (indexPath.section==1&&indexPath.row==0) {
        PlaySettingViewController * vc = [[PlaySettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section==1&&indexPath.row==1) {
        if (ifHasLogin) {
            ChatSettingViewController * cv = [[ChatSettingViewController alloc] init];
            cv.title = @"私信设置";
            [self.navigationController pushViewController:cv animated:YES];
        }
        else{
            ChangeSkinViewController * vc = [[ChangeSkinViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section==1&&indexPath.row==2) {
        ChangeSkinViewController * vc = [[ChangeSkinViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section==2&&indexPath.row==0) {
        CheckUpdateViewController * updataVC = [[CheckUpdateViewController alloc] init];
        [self.navigationController pushViewController:updataVC animated:YES];
    }
    if (indexPath.section==2&&indexPath.row==1) {
        OpinionViewController * opinionVC = [[OpinionViewController alloc] init];
        [self.navigationController pushViewController:opinionVC animated:YES];
    }
    if (indexPath.section==2&&indexPath.row==2) {
        [self evaluate];
    }
    if (indexPath.section==2&&indexPath.row==3) {
        [self cleanUpCache];
    }
    if (self.sectionForthArray.count==1&&indexPath.section==3) {
//        NSString * uName = [UserServe sharedUserServe].userName;
        if (ifHasLogin) {
            [self doLogOut];
        }
        else
            [self showLoginView];
    }
    else if (self.sectionForthArray.count==2&&indexPath.section==3) {
        if (indexPath.row==1) {
            [self doLogOut];
        }
        if (indexPath.row==0) {
            ChangePasswordViewController * changeVC = [[ChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:changeVC animated:YES];
        }
    }
     */
}
-(void)refreshLogStatus
{
    NSString * uName = [UserServe sharedUserServe].userName;
    if (uName) {
        ifHasLogin = YES;
        if ([uName hasPrefix:@"wx"]||[uName hasPrefix:@"qq"]||[uName hasPrefix:@"sina"]) {
            self.sectionForthArrayA = [NSArray arrayWithObjects:@"退出登录", nil];
        }
        else
        {
            self.sectionForthArrayA = [NSArray arrayWithObjects:@"修改密码",@"退出登录", nil];
        }
        self.sectionForthArray = self.sectionForthArrayA;
        self.sectionSecondArray = self.sectionSecondArrayA;
        self.allArrayA = [NSArray arrayWithObjects:self.sectionFirstArray,self.sectionFirstArray_2,self.sectionSecondArray,self.sectionThirdArray,self.sectionForthArrayA, nil];
        self.allArray = self.allArrayA;
    }
    else
    {
        ifHasLogin = NO;
        self.sectionForthArray = self.sectionForthArrayB;
        self.sectionSecondArray = self.sectionSecondArrayB;
        self.allArrayB = [NSArray arrayWithObjects:self.sectionFirstArray,self.sectionSecondArray,self.sectionThirdArray,self.sectionForthArrayB, nil];
        self.allArray = self.allArrayB;
    }
    if (self.settingTableView) {
        [self.settingTableView reloadData];
    }
}
-(void)doLogOut
{
    if (loggingOut) {
        return;
    }
    UIActionSheet * act = [[UIActionSheet alloc] initWithTitle:@"确定退出账号?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出账号" otherButtonTitles: nil];
    [act showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self realLogOut];
    }
}
-(void)realLogOut
{
    if (loggingOut||![UserServe sharedUserServe].userID) {
        return;
    }
    [SVProgressHUD showWithStatus:@"退出中..."];
    loggingOut = YES;
    NSMutableDictionary* dict = [NetServer commonDict];
    [dict setObject:@"logout" forKey:@"command"];
    [dict setObject:@"logout" forKey:@"options"];
    [dict setObject:[SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil] forKey:@"sessionToken"];
    [dict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    [NetServer requestWithParameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"sucess logout :%@",responseObject);
        [SVProgressHUD dismiss];
        loggingOut = NO;
        NSString * uName = [UserServe sharedUserServe].userName;
        if (uName) {
            if ([uName hasPrefix:@"sina"]) {
                [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
            }
        }
        [SFHFKeychainUtils deleteItemForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
        [SFHFKeychainUtils deleteItemForUsername:[NSString stringWithFormat:@"%@%@SKey",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
        [DatabaseServe unActivateUeser];
        [UserServe sharedUserServe].userName = nil;
        [UserServe sharedUserServe].userID = nil;
//        [UserServe sharedUserServe].petArr = nil;
        [UserServe sharedUserServe].account = nil;
//        [SFHFKeychainUtils deleteItemForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRLoginSucceed" object:self userInfo:nil];
        [self refreshLogStatus];
//        [[SystemServer sharedSystemServer].chatClient logout];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好，退出失败哦"];
        loggingOut = NO;
    }];

}
-(void)draftsButtonAction
{
    
    DraftsViewController * draftsVC = [[DraftsViewController alloc] init];
    [self.navigationController pushViewController:draftsVC animated:YES];
    
}
- (void)showLoginView
{
    [[RootViewController sharedRootViewController] showLoginViewController];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cleanUpCache
{
    [SVProgressHUD showWithStatus:@"清理中,请稍后"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EGOCache globalCache] clearCache];
        [TFileManager deleteSoundCache];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"清理成功"];
            cacheSize = 0;
//            [_settingTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            [self.settingTableView reloadData];
        });
    });
}
- (void)evaluate
{
    NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id914242691"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
//初始化控制器
//    [SVProgressHUD showWithStatus:@"加载页面"];
//    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
//    storeProductViewContorller.delegate = self;
//    [storeProductViewContorller loadProductWithParameters:
//     @{SKStoreProductParameterITunesItemIdentifier : @"914242691"} completionBlock:^(BOOL result, NSError *error) {
//        [SVProgressHUD dismiss];
//         if(error){
//             [SVProgressHUD showErrorWithStatus:@"加载失败"];
//         }else{
//             [self presentViewController:storeProductViewContorller animated:YES completion:nil
//              ];
//         }
//     }];
}

//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
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
