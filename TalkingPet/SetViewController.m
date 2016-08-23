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

@property(nonatomic,copy)NSArray *dataArrA;
@property(nonatomic,copy)NSArray *dataArrB;

@end

@implementation SetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
        
        self.dataArrA=@[@[@"关于友仔",@"草稿箱",],@[@"播放设置",@"图片设置",@"意见反馈",@"清理缓存"],@[@"退出登录"]];
        
        self.dataArrB=@[@[@"关于友仔"],@[@"播放设置",@"图片设置",@"意见反馈",@"清理缓存"],@[@"登录"]];
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
    
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(backAction)];
    
    self.settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight) style:UITableViewStyleGrouped];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    _settingTableView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    _settingTableView.backgroundColor = [UIColor clearColor];
    _settingTableView.rowHeight = 45;
    _settingTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    _settingTableView.showsVerticalScrollIndicator = NO;
    _settingTableView.separatorInset=UIEdgeInsetsMake(0,0.1, 0, 0.1);
    _settingTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLineEtched;
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
            [_settingTableView reloadData];
        });
    });
    
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    if (ifHasLogin) {
        return  [self.dataArrA count];
    }
    else
    {
        return  [self.dataArrB count];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (ifHasLogin) {
        return  [self.dataArrA[section] count];
    }
    else
    {
        return  [self.dataArrB[section] count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ifHasLogin) {
        if (indexPath.section == 1 && indexPath.row == 3) {
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
                
                UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 1)];
                label2.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
                [cell addSubview:label2];
            }
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.separatorInset = UIEdgeInsetsMake(0,0.1, 0, 0.1);
            cell.textLabel.text = self.dataArrA[indexPath.section][indexPath.row];
            cell.textLabel.textColor=[UIColor colorWithR:150 g:150 b:150 alpha:1];
            label.text = [NSString stringWithFormat:@"%.2fM",cacheSize];
            return cell;
        }
        else if (indexPath.section==2)
        {
            static NSString *cellIdentifier = @"settingCell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, ScreenWidth-60, cell.frame.size.height)];
                [cell addSubview:label1];
                label1.text=self.dataArrA[indexPath.section][indexPath.row];
                label1.textAlignment=NSTextAlignmentCenter;
                label1.tag=200;
                label1.backgroundColor=[UIColor colorWithRed:0.99 green:0.35 blue:0.26 alpha:1.00];
                label1.textColor=[UIColor colorWithRed:0.98 green:0.95 blue:0.95 alpha:1.00];
                label1.layer.masksToBounds=YES;
                label1.layer.cornerRadius=5;
                
            }
            
            UILabel *label1= [cell viewWithTag:200];
            label1.textColor=[UIColor colorWithRed:0.98 green:0.95 blue:0.95 alpha:1.00];
            label1.text=self.dataArrA[indexPath.section][indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
        else
        {
            static NSString *cellIdentifier = @"settingCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 1)];
                label2.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
                [cell addSubview:label2];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.dataArrA[indexPath.section][indexPath.row];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor=[UIColor colorWithR:150 g:150 b:150 alpha:1];
            
            return cell;
        }
    }
    else{
        
        if (indexPath.section == 1 && indexPath.row == 3) {
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
                
                UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 1)];
                label2.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
                [cell addSubview:label2];
            }
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.dataArrB[indexPath.section][indexPath.row];
            label.text = [NSString stringWithFormat:@"%.2fM",cacheSize];
            cell.textLabel.textColor=[UIColor colorWithR:150 g:150 b:150 alpha:1];
            
            return cell;
        }
        else if (indexPath.section==2)
        {
            static NSString *cellIdentifier = @"settingCell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, ScreenWidth-60, cell.frame.size.height)];
                
                label1.tag=200;
                label1.text=self.dataArrB[indexPath.section][indexPath.row];
                label1.backgroundColor=[UIColor colorWithRed:0.99 green:0.35 blue:0.26 alpha:1.00];
                label1.textAlignment=NSTextAlignmentCenter;
                label1.layer.masksToBounds=YES;
                label1.layer.cornerRadius=5;
                [cell addSubview:label1];
                
            }
            UILabel *label1= [cell viewWithTag:200];
            label1.text=self.dataArrB[indexPath.section][indexPath.row];
            label1.textColor=[UIColor colorWithRed:0.98 green:0.95 blue:0.95 alpha:1.00];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
        else
        {
            static NSString *cellIdentifier = @"settingCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 1)];
                label2.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
                [cell addSubview:label2];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.dataArrB[indexPath.section][indexPath.row];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor=[UIColor colorWithR:150 g:150 b:150 alpha:1];
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0) {
        //关于友仔
        CheckUpdateViewController * updataVC = [[CheckUpdateViewController alloc] init];
        [self.navigationController pushViewController:updataVC animated:YES];
    }
    else if(indexPath.section==0&&indexPath.row==1)
    {
        //草稿箱
        [self draftsButtonAction];
        
    }
    if(indexPath.section==1)
    {
        if (indexPath.row==0) {
            //播放设置
            PlaySettingViewController * vc = [[PlaySettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else if (indexPath.row==1)
        {
            //图片设置
            PicSaveSettingViewController * picSet = [[PicSaveSettingViewController alloc] init];
            picSet.title = @"图片保存设置";
            [self.navigationController pushViewController:picSet animated:YES];
        }
        else if (indexPath.row==2)
        {
            //意见反馈
            OpinionViewController * opinionVC = [[OpinionViewController alloc] init];
            [self.navigationController pushViewController:opinionVC animated:YES];
        }
        else if (indexPath.row==3)
        {
            //清理缓存
            [self cleanUpCache];
        }
    }
    if(ifHasLogin)
    {
        if (indexPath.section==1) {
            //清理缓存
//            [self cleanUpCache];
        }
        else if (indexPath.section==2) {
            //退出登录
            [self doLogOut];
        }
    }else
    {
        if (indexPath.section==2) {
            //登录
            [self showLoginView];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
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
    NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/you-zi/id1137536950?l=zh&ls=1&mt=8"];
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
