//
//  TopViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "TopViewController.h"
#import "RootViewController.h"
#import "PublishServer.h"

#import "MainViewController.h"
#import "CustomizeViewController.h"
#import "ShangchengMainViewController.h"
#import "UserCenterViewController.h"

@interface TopViewController ()<UINavigationControllerDelegate>
{
    UIButton * photoB;
    UIImageView * tabBar;
//    BOOL needNotiNormalChat;
}
@property (nonatomic,retain)UINavigationController * petalkNav;
@property (nonatomic,retain)UINavigationController * marketNav;
@property (nonatomic,retain)UINavigationController * personNav;
@end

@implementation TopViewController
-(void)showTabBar
{
    tabBar.hidden = NO;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count>1&&!tabBar.hidden) {
        [navigationController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [RootViewController sharedRootViewController].sideMenu.panGestureEnabled = NO;
        tabBar.hidden = YES;
    }

    
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count<=1) {
        [navigationController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49)];
        [RootViewController sharedRootViewController].sideMenu.panGestureEnabled = YES;
        tabBar.hidden = NO;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MainViewController * mainVC = [[MainViewController alloc] init];
    self.petalkNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    _petalkNav.delegate = self;
    [self addChildViewController:_petalkNav];
    [_petalkNav.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49)];
    [self.view addSubview:_petalkNav.view];
    [_petalkNav didMoveToParentViewController:self];
    _currentC = _petalkNav;
    
    ShangchengMainViewController * marketVC = [[ShangchengMainViewController alloc]init];
    self.marketNav = [[UINavigationController alloc] initWithRootViewController:marketVC];
    _marketNav.delegate = self;
    [self addChildViewController:_marketNav];
    [_marketNav.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49)];
    
    UserCenterViewController * personVC = [[UserCenterViewController alloc]init];
    self.personNav = [[UINavigationController alloc] initWithRootViewController:personVC];
    _personNav.delegate = self;
    [self addChildViewController:_personNav];
    [_personNav.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49)];
    
    tabBar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuBar"]];
    tabBar.userInteractionEnabled = YES;
    tabBar.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
    [self.view addSubview:tabBar];
    
    float sep = ((ScreenWidth-40*4)-60)/3.0f;
    

    
    
    UIButton * petalkB = [UIButton buttonWithType:UIButtonTypeCustom];
    petalkB.tag = 1;
    [petalkB addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    petalkB.frame = CGRectMake(30, 0, 40, 40);
//    petalkB.center = CGPointMake(CGRectGetMaxX(tabBar.bounds)/5, 25);
    [petalkB setBackgroundImage:[UIImage imageNamed:@"petalk-sel"] forState:UIControlStateNormal];
    [tabBar addSubview:petalkB];
    
    UILabel * petalkBL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(petalkB.frame), CGRectGetMaxY(petalkB.frame)-10, 40, 20)];
    petalkBL.font = [UIFont systemFontOfSize:10];
    petalkBL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    petalkBL.textAlignment = NSTextAlignmentCenter;
    petalkBL.text = @"首页";
    petalkBL.tag = 100;
    petalkBL.textColor = CommonGreenColor;
    [tabBar addSubview:petalkBL];
    
    photoB = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoB addTarget:self action:@selector(showPhotograph) forControlEvents:UIControlEventTouchUpInside];
    photoB.frame = CGRectMake(CGRectGetMaxX(petalkB.frame)+sep, 0, 40, 40);
//    photoB.center = CGPointMake(CGRectGetMidX(tabBar.bounds), 25);
    [photoB setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    photoB.showsTouchWhenHighlighted = YES;
    [tabBar addSubview:photoB];
    
    UILabel * photoBL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(photoB.frame), CGRectGetMaxY(photoB.frame)-10, 40, 20)];
    photoBL.font = [UIFont systemFontOfSize:10];
    photoBL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    photoBL.textAlignment = NSTextAlignmentCenter;
    photoBL.text = @"发布";
    photoBL.textColor = [UIColor colorWithWhite:150/255.f alpha:1];
    [tabBar addSubview:photoBL];
    
    UIButton * marketB = [UIButton buttonWithType:UIButtonTypeCustom];
    marketB.tag = 2;
    [marketB addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    marketB.frame = CGRectMake(CGRectGetMaxX(photoB.frame)+sep, 0, 40, 40);
//    marketB.center = CGPointMake(CGRectGetMaxX(tabBar.bounds)*4/5, 25);
    [marketB setBackgroundImage:[UIImage imageNamed:@"market-nom"] forState:UIControlStateNormal];
    [tabBar addSubview:marketB];
    
    UILabel * marketBL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(marketB.frame), CGRectGetMaxY(marketB.frame)-10, 40, 20)];
    marketBL.font = [UIFont systemFontOfSize:10];
    marketBL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    marketBL.textAlignment = NSTextAlignmentCenter;
    marketBL.text = @"商城";
    marketBL.tag = 200;
    marketBL.textColor = [UIColor colorWithWhite:150/255.f alpha:1];
    [tabBar addSubview:marketBL];
    
    UIButton * myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myBtn.tag = 3;
    [myBtn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    myBtn.frame = CGRectMake(CGRectGetMaxX(marketB.frame)+sep, 0, 40, 40);
    //    marketB.center = CGPointMake(CGRectGetMaxX(tabBar.bounds)*4/5, 25);
    [myBtn setBackgroundImage:[UIImage imageNamed:@"myp-nom"] forState:UIControlStateNormal];
    [tabBar addSubview:myBtn];
    
    UILabel * myBtnL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(myBtn.frame), CGRectGetMaxY(myBtn.frame)-10, 40, 20)];
    myBtnL.font = [UIFont systemFontOfSize:10];
    myBtnL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    myBtnL.textAlignment = NSTextAlignmentCenter;
    myBtnL.text = @"我的";
    myBtnL.tag = 300;
    myBtnL.textColor = [UIColor colorWithWhite:150/255.f alpha:1];
    [tabBar addSubview:myBtnL];
    
//    self.menuBarNotiImg = [[UIImageView alloc] initWithFrame:CGRectMake(32, 5, 10, 10)];
//    [self.menuBarNotiImg setImage:[UIImage imageNamed:@"dotunread"]];
//    [_menuBar addSubview:self.menuBarNotiImg];
//    
//    if ([DatabaseServe needNotiNormalChatInOtherPage]) {
//        [self addNormalChatNoti];
//    }
//    else
//    {
//        NSString * unreadCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].userID]];
//        if ([unreadCount intValue]<=0) {
//            [self removeNormalChatNoti];
//        }
//        
//    }
}
- (void)tabAction:(UIButton*)btn
{
    switch (btn.tag) {
        case 1:{
            if ([_currentC isEqual:_petalkNav]) {
                return;
            }
            [self transitionFromViewController:_currentC toViewController:_petalkNav duration:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [_currentC willMoveToParentViewController:nil];
                    [_currentC.view removeFromSuperview];
                    [btn setBackgroundImage:[UIImage imageNamed:@"petalk-sel"] forState:UIControlStateNormal];
                    UIButton * button = (UIButton*)[btn.superview viewWithTag:2];
                    [button setBackgroundImage:[UIImage imageNamed:@"market-nom"] forState:UIControlStateNormal];
                    UIButton * button2 = (UIButton*)[btn.superview viewWithTag:3];
                    [button2 setBackgroundImage:[UIImage imageNamed:@"myp-nom"] forState:UIControlStateNormal];
                    UILabel * l1 = (UILabel*)[btn.superview viewWithTag:200];
                    l1.textColor = [UIColor colorWithWhite:150/255.f alpha:1];
                    UILabel * l2 = (UILabel*)[btn.superview viewWithTag:300];
                    l2.textColor = [UIColor colorWithWhite:150/255.f alpha:1];
                     _currentC = _petalkNav;
                }
            }];
        }break;
        case 2:{
            if ([_currentC isEqual:_marketNav]) {
                return;
            }
            [self transitionFromViewController:_currentC toViewController:_marketNav duration:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [_currentC willMoveToParentViewController:nil];
                    [_currentC.view removeFromSuperview];
                    [btn setBackgroundImage:[UIImage imageNamed:@"market-sel"] forState:UIControlStateNormal];
                    UIButton * button = (UIButton*)[btn.superview viewWithTag:1];
                    [button setBackgroundImage:[UIImage imageNamed:@"petalk-nom"] forState:UIControlStateNormal];
                    UIButton * button2 = (UIButton*)[btn.superview viewWithTag:3];
                    [button2 setBackgroundImage:[UIImage imageNamed:@"myp-nom"] forState:UIControlStateNormal];
                    UILabel * l1 = (UILabel*)[btn.superview viewWithTag:100];
                    l1.textColor = [UIColor colorWithWhite:150/255.f alpha:1];
                    UILabel * l2 = (UILabel*)[btn.superview viewWithTag:300];
                    l2.textColor = [UIColor colorWithWhite:150/255.f alpha:1];
                     _currentC = _marketNav;
                }
            }];
        }break;
        case 3:{
            if ([_currentC isEqual:_personNav]) {
                return;
            }
            [self transitionFromViewController:_currentC toViewController:_personNav duration:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [_currentC willMoveToParentViewController:nil];
                    [_currentC.view removeFromSuperview];
                    [btn setBackgroundImage:[UIImage imageNamed:@"myp-sel"] forState:UIControlStateNormal];
                    UIButton * button = (UIButton*)[btn.superview viewWithTag:1];
                    [button setBackgroundImage:[UIImage imageNamed:@"petalk-nom"] forState:UIControlStateNormal];
                    UIButton * button2 = (UIButton*)[btn.superview viewWithTag:2];
                    [button2 setBackgroundImage:[UIImage imageNamed:@"market-nom"] forState:UIControlStateNormal];
                    UILabel * l1 = (UILabel*)[btn.superview viewWithTag:100];
                    l1.textColor = [UIColor colorWithWhite:150/255.f alpha:1];
                    UILabel * l2 = (UILabel*)[btn.superview viewWithTag:200];
                    l2.textColor = [UIColor colorWithWhite:150/255.f alpha:1];
                    _currentC = _personNav;
                }
            }];
        }break;
        default:
            break;
    }
}
- (void)showPhotograph
{
    if (![UserServe sharedUserServe].userName) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
    PublishView * view = [[PublishView alloc] init];
    __weak PublishView * weakView = view;
    [view showWithAction:^(NSInteger index) {
        switch (index) {
            case 0:{
                [PublishServer publishPetalkWithTag:nil completion:^{
                    [weakView removeFromSuperview];
                }];
            }break;
            case 1:{
                [PublishServer publishPictureWithTag:nil completion:^{
                    [weakView removeFromSuperview];
                }];
            }break;
            case 2:{
                [PublishServer publishStoryWithTag:nil completion:^{
                    [weakView removeFromSuperview];
                }];
            }break;
            default:
                break;
        }
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UIApplication sharedApplication].statusBarHidden == YES) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
        else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
        }
    }
//    [self msgNotiReceived];
}
- (void)dealloc {
//    [self configureNotification:NO];
}


#pragma mark - SCNavigationController delegate

- (void)showMenuView
{
    [[RootViewController sharedRootViewController].sideMenu presentRightMenuViewController];
}
- (void)showMsgView
{
    if (![UserServe sharedUserServe].account) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
//    [self removeNormalChatNoti];
    [[RootViewController sharedRootViewController].sideMenu presentLeftMenuViewController];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)addNormalChatNoti
//{
//    needNotiNormalChat = YES;
//    self.menuBarNotiImg.hidden = NO;
//}
//-(void)removeNormalChatNoti
//{
//    needNotiNormalChat = NO;
//    self.menuBarNotiImg.hidden = YES;
//    [DatabaseServe setNeedNotiNormalChatWithStatus:0];
//}
//-(void)msgNotiReceived
//{
//    NSString * unreadCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].userID]];
//    if ([unreadCount intValue]>0||needNotiNormalChat) {
//        self.menuBarNotiImg.hidden = NO;
//        
//    }
//    else
//        self.menuBarNotiImg.hidden = YES;
//    
//}
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
