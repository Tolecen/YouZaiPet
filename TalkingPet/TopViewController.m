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

@interface TopViewController ()<UINavigationControllerDelegate>
{
    UIButton * photoB;
    UIImageView * tabBar;
//    BOOL needNotiNormalChat;
}
@property (nonatomic,retain)UINavigationController * petalkNav;
@property (nonatomic,retain)UINavigationController * marketNav;
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
    
    CustomizeViewController * marketVC = [[CustomizeViewController alloc]init];
    self.marketNav = [[UINavigationController alloc] initWithRootViewController:marketVC];
    _marketNav.delegate = self;
    [self addChildViewController:_marketNav];
    [_marketNav.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49)];
    
    tabBar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuBar"]];
    tabBar.userInteractionEnabled = YES;
    tabBar.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
    [self.view addSubview:tabBar];
    
    photoB = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoB addTarget:self action:@selector(showPhotograph) forControlEvents:UIControlEventTouchUpInside];
    photoB.frame = CGRectMake(0, 0, 46, 46);
    photoB.center = CGPointMake(CGRectGetMidX(tabBar.bounds), 25);
    [photoB setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    photoB.showsTouchWhenHighlighted = YES;
    [tabBar addSubview:photoB];
    
    
    UIButton * petalkB = [UIButton buttonWithType:UIButtonTypeCustom];
    petalkB.tag = 1;
    [petalkB addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    petalkB.frame = CGRectMake(0, 0, 40, 40);
    petalkB.center = CGPointMake(CGRectGetMaxX(tabBar.bounds)/5, 25);
    [petalkB setBackgroundImage:[UIImage imageNamed:@"petalk-sel"] forState:UIControlStateNormal];
    [tabBar addSubview:petalkB];
    
    UIButton * marketB = [UIButton buttonWithType:UIButtonTypeCustom];
    marketB.tag = 2;
    [marketB addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    marketB.frame = CGRectMake(0, 0, 40, 40);
    marketB.center = CGPointMake(CGRectGetMaxX(tabBar.bounds)*4/5, 25);
    [marketB setBackgroundImage:[UIImage imageNamed:@"market-nom"] forState:UIControlStateNormal];
    [tabBar addSubview:marketB];
    
//    self.menuBarNotiImg = [[UIImageView alloc] initWithFrame:CGRectMake(32, 5, 10, 10)];
//    [self.menuBarNotiImg setImage:[UIImage imageNamed:@"dotunread"]];
//    [_menuBar addSubview:self.menuBarNotiImg];
//    
//    if ([DatabaseServe needNotiNormalChatInOtherPage]) {
//        [self addNormalChatNoti];
//    }
//    else
//    {
//        NSString * unreadCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].currentPet.petID]];
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
            [self transitionFromViewController:_marketNav toViewController:_petalkNav duration:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [_marketNav willMoveToParentViewController:nil];
                    [_marketNav.view removeFromSuperview];
                    [btn setBackgroundImage:[UIImage imageNamed:@"petalk-sel"] forState:UIControlStateNormal];
                    UIButton * button = (UIButton*)[btn.superview viewWithTag:2];
                    [button setBackgroundImage:[UIImage imageNamed:@"market-nom"] forState:UIControlStateNormal];
                     _currentC = _petalkNav;
                }
            }];
        }break;
        case 2:{
            if ([_currentC isEqual:_marketNav]) {
                return;
            }
            [self transitionFromViewController:_petalkNav toViewController:_marketNav duration:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [_petalkNav willMoveToParentViewController:nil];
                    [_petalkNav.view removeFromSuperview];
                    [btn setBackgroundImage:[UIImage imageNamed:@"market-sel"] forState:UIControlStateNormal];
                    UIButton * button = (UIButton*)[btn.superview viewWithTag:1];
                    [button setBackgroundImage:[UIImage imageNamed:@"petalk-nom"] forState:UIControlStateNormal];
                     _currentC = _marketNav;
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
    if (![UserServe sharedUserServe].currentPet) {
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
//    NSString * unreadCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].currentPet.petID]];
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
