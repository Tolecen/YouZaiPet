//
//  RootViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "RootViewController.h"
#import "MenuViewController.h"
#import "LoginViewController.h"
#import "WXRTextViewController.h"
#import "HotUserViewComtroller.h"
#import "PetalkalkListViewController.h"
#import "WelcomeViewController.h"
#import "SectionMSgViewController.h"
#import "GTScrollNavigationBar.h"
@interface RootViewController ()
{
    MenuViewController * menuVC;
    SectionMSgViewController * msgVC;
}

@end

@implementation RootViewController
static RootViewController* rootViewController;
+ (RootViewController*)sharedRootViewController
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        rootViewController=[[self alloc] initWithNibName:nil bundle:nil];
        
    });
    return rootViewController;
}

- (BOOL)shouldAutorotate
{
    return self.currentViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.currentViewController.supportedInterfaceOrientations;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topVC = [[TopViewController alloc]init];
    
    menuVC = [[MenuViewController alloc]init];
    msgVC = [[SectionMSgViewController alloc]init];
    
    self.sideMenu = [[RESideMenu alloc] initWithContentViewController:_topVC leftMenuViewController:nil rightMenuViewController:nil];
    _sideMenu.backgroundImage = [UIImage imageNamed:@"background"];
    [self addChildViewController:_sideMenu];
    [_sideMenu.view setFrame:self.view.bounds];
    [self.view addSubview:_sideMenu.view];
    [_sideMenu didMoveToParentViewController:self];
    
    NSString * firstIn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
    if (!firstIn) {
//        WelcomeViewController * welcomeVC = [[WelcomeViewController alloc] init];
//        [self addChildViewController:welcomeVC];
//        [welcomeVC.view setFrame:[[UIScreen mainScreen] bounds]];
//        [self.view addSubview:welcomeVC.view];
//        [welcomeVC didMoveToParentViewController:self];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
        NSString *openImgDirectory = [documentsw stringByAppendingPathComponent:@"OpenImages"];
        BOOL isDirss2 = FALSE;
        BOOL isDirExistss2 = [[NSFileManager defaultManager] fileExistsAtPath:openImgDirectory isDirectory:&isDirss2];
        
        if (!(isDirExistss2 && isDirss2))
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:openImgDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        else
        {
            NSArray * pathArr = [[NSFileManager defaultManager] subpathsAtPath:openImgDirectory];
            if (pathArr.count>0) {
                OpenImageViewController * welcomeVC = [[OpenImageViewController alloc] init];
                [self addChildViewController:welcomeVC];
                [welcomeVC.view setFrame:[[UIScreen mainScreen] bounds]];
                [self.view addSubview:welcomeVC.view];
            }
        }

    }
}

-(void)showTaglistViewControllerWithTag:(NSString *)theTag
{
    TagTalkListViewController * tagTlistV = [[TagTalkListViewController alloc] init];
//    tagTlistV.title = ((Tag*)self.tagList[button.tag-100]).tagName;
//    tagTlistV.tag = theTag;
    tagTlistV.tag = [[Tag alloc] init];
    tagTlistV.tag.tagID = @"12";
    UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:tagTlistV];
    [self presentViewController:navigation animated:NO completion:^{
        
    }];
}

-(void)processWithDict:(NSDictionary *)infoDict
{
    NSString * theType = [infoDict objectForKey:@"type"];
    UINavigationController *navigationController = self.topVC.currentC;
    if (theType) {
        if ([theType isEqualToString:@"1"]||[theType isEqualToString:@"2"]||[theType isEqualToString:@"3"]) {
//            UINavigationController *navigationController = (UINavigationController *)[RootViewController sharedRootViewController].frostedViewController.contentViewController;
//            if (![navigationController.viewControllers[0] isEqual:[RootViewController sharedRootViewController].msgVC]&&navigationController.viewControllers.count==1&&!self.presentedViewController) {
//                navigationController.viewControllers = @[[RootViewController sharedRootViewController].msgVC];
//                [menuVC.tableView reloadData];
//            }
        }
        else if ([theType isEqualToString:@"4"]){
            //说说，打开一条说说
            TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
            TalkingBrowse * tb = [[TalkingBrowse alloc] init];
            tb.theID = [infoDict objectForKey:@"id"];
            talkingDV.talking = tb;
            //        talkingDV.shouldDismiss = YES;
            //        UINavigationController * nv = [[UINavigationController alloc] initWithRootViewController:talkingDV];
            //        nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //        [self presentViewController:nv animated:YES completion:^{
            //
            //        }];
            [navigationController pushViewController:talkingDV animated:NO];
        }
        else if ([theType isEqualToString:@"5"]){
            //打开标签详情页
            TagTalkListViewController * tagTlistV = [[TagTalkListViewController alloc] init];
            tagTlistV.title = @"活动";
            Tag * tag = [[Tag alloc] init];
            tag.tagID = [infoDict objectForKey:@"id"];
            tagTlistV.tag = tag;
            tagTlistV.shouldRequestTagInfo = YES;
            [navigationController pushViewController:tagTlistV animated:NO];
        }
        else if ([theType isEqualToString:@"6"]){
            //系统通知，弹出详情页，请求纯文字
            [self requestSystemNotiWithId:[infoDict objectForKey:@"id"] Type:theType];
        }
        else if ([theType isEqualToString:@"7"]){
            //公告,弹框直接显示内容
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"公告" message:[[infoDict objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//            [alert show];
            [self requestSystemNotiWithId:[infoDict objectForKey:@"id"] Type:theType];
        }
        else if ([theType isEqualToString:@"8"]){
            PetalkalkListViewController * tagTlistV = [[PetalkalkListViewController alloc] init];
            tagTlistV.title = @"频道";
//            Tag * tag = [[Tag alloc] init];
//            tag.tagID = [infoDict objectForKey:@"id"];
//            tagTlistV.tag = tag;
//            tagTlistV.shouldRequestTagInfo = YES;
            tagTlistV.otherCode = [infoDict objectForKey:@"id"];
//            tagTlistV.title = iteam.title;
            tagTlistV.listTyep = PetalkListTyepChannel;
            [navigationController pushViewController:tagTlistV animated:NO];
        }
        

    }
    

   
}
-(void)requestSystemNotiWithId:(NSString *)theId Type:(NSString *)theType
{
    NSMutableDictionary* dict = [NetServer commonDict];
    [dict setObject:@"announcement" forKey:@"command"];
    [dict setObject:@"one" forKey:@"options"];
    [dict setObject:theId forKey:@"id"];
    [NetServer requestWithParameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"get a announcement success:%@",responseObject);
//        contentString = [responseObject objectForKey:@"value"];
        if ([theType isEqualToString:@"6"]) {
            WXRTextViewController * controller = [[WXRTextViewController alloc] init];
            controller.title = [[responseObject objectForKey:@"value"] objectForKey:@"title"];
            
            controller.content = [[responseObject objectForKey:@"value"] objectForKey:@"content"];
            UINavigationController *navigationController = self.topVC.currentC;
            [navigationController pushViewController:controller animated:NO];
        }
        else if([theType isEqualToString:@"7"])
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"公告" message:[[responseObject objectForKey:@"value"] objectForKey:@"content"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];


 
}

-(void)playDone
{
//    [self.mainVC.hotTableViewHelper cellPlayAni:self.mainVC.hotTableViewHelper.tableV];
}
-(void)removeVideo
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showLoginViewController
{
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navigation animated:YES completion:^{

    }];
    
}
- (void) showHotUserViewController
{
    HotUserViewComtroller * hotVC = [[HotUserViewComtroller alloc] init];
    UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:hotVC];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}
-(void)showPetaikAlertWithTitle:(NSString*)title message:(NSString*)message
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
    imgV.center = CGPointMake(CGRectGetMidX([backView bounds]), CGRectGetMidY([backView bounds]));
    [backView addSubview:imgV];
    UILabel * titleL = [[UILabel alloc]initWithFrame:CGRectMake(5, 110, 170, 20)];
    titleL.text = title;
    titleL.backgroundColor = [UIColor clearColor];
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.adjustsFontSizeToFitWidth = YES;
    titleL.minimumScaleFactor = 0.1;
    titleL.textColor = [UIColor colorWithRed:135/255.0 green:130/255.0 blue:250/255.0 alpha:1];
    [imgV addSubview:titleL];
    UILabel * msgL = [[UILabel alloc]initWithFrame:CGRectMake(5, 130, 170, 40)];
    msgL.text = message;
    msgL.backgroundColor = [UIColor clearColor];
    msgL.font = [UIFont systemFontOfSize:22];
    msgL.textAlignment = NSTextAlignmentCenter;
    msgL.adjustsFontSizeToFitWidth = YES;
    msgL.minimumScaleFactor = 0.1;
    msgL.textColor = [UIColor colorWithRed:135/255.0 green:130/255.0 blue:250/255.0 alpha:1];
    [imgV addSubview:msgL];
    imgV.image = [UIImage imageNamed:@"alertImg"];
    [self.view addSubview:backView];
    [backView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.5];
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
