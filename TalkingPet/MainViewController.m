  //
//  MainViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "MainViewController.h"
#import "RootViewController.h"
#import "SquareViewController.h"
#import "AttentionViewController.h"
#import "HotViewController.h"
#import "EGOImageView.h"
#import "PublishServer.h"
#import "SquareNewViewController.h"
#import "SearchViewController.h"
@interface MainViewController ()<UIScrollViewDelegate>
{
    UIButton * hotB;
    UIButton * squareB;
    UIButton * careB;
    UIImageView * scrollBG;
    
    EGOImageView * petHeadView;
    UIButton * logBtn;
}
@property (nonatomic,retain) UIScrollView * backScrollV;
@property (nonatomic, strong)HotViewController * hotVC;
@property (nonatomic, strong)SquareNewViewController * squareVC;
@property (nonatomic, strong)AttentionViewController * attentionVC;
//@property (nonatomic, strong)UIView * searchView;
//@property (nonatomic, strong)UIView * searchBarBGV;
//@property (nonatomic, strong)UITextField * searchTF;
//@property (nonatomic, strong)UIButton * cancelSearchBtn;
//@property (nonatomic, strong)UIButton * clearTFBtn;
@end

@implementation MainViewController

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
    self.view.frame = self.parentViewController.view.bounds;
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"sousuo@2x"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightMoreItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(toSearchPage)];
    self.navigationItem.rightBarButtonItem = rightMoreItem;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:({
//        UIButton*userB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [userB setImage:[UIImage imageNamed:@"sousuo-ico2"] forState:UIControlStateNormal];
//        userB.frame = CGRectMake(0.0, 0.0, 38, 38);
////        petHeadView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
////        petHeadView.center = CGPointMake(CGRectGetMidX(userB.bounds), CGRectGetMidY(userB.bounds));
////        petHeadView.layer.cornerRadius = 13.5;
////        petHeadView.layer.masksToBounds = YES;
////        [userB addSubview:petHeadView];
////        petHeadView.imageURL = [NSURL URLWithString:[UserServe sharedUserServe].account.headImgURL];
//        if ([[UIDevice currentDevice].systemVersion integerValue]>=7) {
//            userB.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, -12);
////            petHeadView.frame = CGRectOffset(petHeadView.frame, 12, 0);
//        }
//        [userB addTarget:self action:@selector(showUserSide) forControlEvents:UIControlEventTouchUpInside];
//        userB;
//    })];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:({
//        UIButton * messageB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [messageB setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
//        messageB.frame = CGRectMake(0.0, 0.0, 38, 38);
//        if ([[UIDevice currentDevice].systemVersion integerValue]>=7) {
//            messageB.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
//        }
//        [messageB addTarget:self action:@selector(showMessageSide) forControlEvents:UIControlEventTouchUpInside];
//        messageB;
//    })];
    UIView * segmentIV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 194, 44)];
//    UIImageView * imageV = [[UIImageView alloc]initWithFrame:segmentIV.bounds];
//    imageV.image = [UIImage imageNamed:@"segmentBG"];
//    [segmentIV addSubview:imageV];
    segmentIV.clipsToBounds = YES;
    self.navigationItem.titleView = segmentIV;
    scrollBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 36, 63, 8)];
    scrollBG.image = [UIImage imageNamed:@"shouye-zhishiqi@2x"];
    [segmentIV addSubview:scrollBG];
    hotB = [UIButton buttonWithType:UIButtonTypeCustom];
    hotB.frame = CGRectMake(0, 4, 63, 28);
    hotB.titleLabel.font = [UIFont systemFontOfSize:16];
    [hotB setTitle:@"热门" forState:UIControlStateNormal];
    [hotB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hotB addTarget:self action:@selector(scrollBackScrollView:) forControlEvents:UIControlEventTouchUpInside];
    [segmentIV addSubview:hotB];
    squareB = [UIButton buttonWithType:UIButtonTypeCustom];
    squareB.frame = CGRectMake(65.5, 4, 63, 28);
    squareB.titleLabel.font = [UIFont systemFontOfSize:15];
    [squareB setTitleColor:[UIColor colorWithR:245 g:245 b:245 alpha:1] forState:UIControlStateNormal];
    [squareB setTitle:@"广场" forState:UIControlStateNormal];
    [squareB addTarget:self action:@selector(scrollBackScrollView:) forControlEvents:UIControlEventTouchUpInside];
    [segmentIV addSubview:squareB];
    careB = [UIButton buttonWithType:UIButtonTypeCustom];
    careB.frame = CGRectMake(131, 4, 63, 28);
    careB.titleLabel.font = [UIFont systemFontOfSize:15];
    [careB setTitleColor:[UIColor colorWithR:245 g:245 b:245 alpha:1] forState:UIControlStateNormal];
    [careB setTitle:@"关注" forState:UIControlStateNormal];
    [careB addTarget:self action:@selector(scrollBackScrollView:) forControlEvents:UIControlEventTouchUpInside];
    [segmentIV addSubview:careB];
    
    self.backScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight)];
    [self.view addSubview:_backScrollV];
    _backScrollV.delegate = self;
    _backScrollV.showsHorizontalScrollIndicator = NO;
    _backScrollV.showsVerticalScrollIndicator = NO;
    _backScrollV.backgroundColor = [UIColor whiteColor];
    _backScrollV.contentSize = CGSizeMake(_backScrollV.frame.size.width*3, _backScrollV.frame.size.height);
    _backScrollV.pagingEnabled = YES;
    _backScrollV.bounces = NO;
    _backScrollV.scrollsToTop = NO;
    
    self.hotVC = [[HotViewController alloc] init];
    [_hotVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight)];
//    _hotVC.hotView.frame = _hotVC.view.bounds;
    [self addChildViewController:_hotVC];
    [_backScrollV addSubview:_hotVC.view];
    [_hotVC didMoveToParentViewController:self];
    _hotVC.contentTableView.scrollsToTop = YES;
    
    self.squareVC = [[SquareNewViewController alloc] init];
    [_squareVC.view setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight)];
    _squareVC.scrollView.frame = _squareVC.view.bounds;
    [self addChildViewController:_squareVC];
    [_backScrollV addSubview:_squareVC.view];
    [_squareVC didMoveToParentViewController:self];
    _squareVC.scrollView.scrollsToTop = NO;
    
    self.attentionVC = [[AttentionViewController alloc] init];
    [_attentionVC.view setFrame:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight)];
    _attentionVC.tableView.frame = _attentionVC.view.bounds;
    [self addChildViewController:_attentionVC];
    [_backScrollV addSubview:_attentionVC.view];
    [_attentionVC didMoveToParentViewController:self];
    _attentionVC.tableView.scrollsToTop = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewContent) name:@"WXRLoginSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPublishSection) name:@"WXRPublishServerBeginPublish" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionViewReload) name:@"WXRPublishServerPublishSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainViewNeedSignIn) name:@"WXRUsersignInOrNo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSthWhenPoped) name:@"popedToRoot" object:nil];
//    NSString * firstIn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
//    if (!firstIn) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTishi) name:@"MainPrompt" object:nil];
//    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
    
}
-(void)addTishi
{
    if ([Common ifHaveGuided:@"main1"]) {
        return;
    }
    TishiNewView * tishiN = [[TishiNewView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [tishiN show];
    tishiN.dismissHandle = ^{
        [self addtishi2];
    };
    
    UIImageView * j = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 82, 120)];
    [j setImage:[UIImage imageNamed:@"main_leftp"]];
    [tishiN addSubview:j];
    
    UIImageView * k = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-77, -5, 77, 120)];
    [k setImage:[UIImage imageNamed:@"main_rightp"]];
    [tishiN addSubview:k];
    
    UIImageView * h = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-209)/2, 100, 209, 62)];
    [h setImage:[UIImage imageNamed:@"main_text1"]];
    [tishiN addSubview:h];
    
}
-(void)addtishi2
{
    TishiNewView * tishiN = [[TishiNewView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [tishiN show];
    tishiN.dismissHandle = ^{
        [self addtishi3];
    };
    
    UIImageView * h = [[UIImageView alloc] initWithFrame:CGRectMake(((ScreenWidth*4/5)+30)-256, ScreenHeight-115, 256, 115)];
    [h setImage:[UIImage imageNamed:@"main_dingzhip"]];
    [tishiN addSubview:h];
    
    
}

-(void)addtishi3
{
    TishiNewView * tishiN = [[TishiNewView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [tishiN show];
    tishiN.dismissHandle = ^{
        //        [self addtishi2];
    };
    
    UIImageView * h = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-35, ScreenHeight-146, 210, 146)];
    [h setImage:[UIImage imageNamed:@"new_story"]];
    [tishiN addSubview:h];
    
//    [Common setGuided:@"main1"];
}
- (void)mainViewNeedSignIn
{
//    UIButton * signB = (UIButton*)[self.view viewWithTag:10086];
//    if (![UserServe sharedUserServe].accountSignatured) {
//        if (!signB) {
//            signB = [UIButton buttonWithType:UIButtonTypeCustom];
//            signB.tag = 10086;
//            signB.frame = CGRectMake(ScreenWidth-86, self.view.frame.size.height-100, 76, 89);
//            [signB setBackgroundImage:[UIImage imageNamed:@"mainViewSignIn"] forState:UIControlStateNormal];
//            [signB addTarget:self action:@selector(mainViewSignIn:) forControlEvents:UIControlEventTouchUpInside];
//            [self.view addSubview:signB];
//        }
//    }else
//    {
//        [signB removeFromSuperview];
//    }
}
-(void)mainViewSignIn:(UIButton*)btn
{
    UINavigationController *navigationController = [RootViewController sharedRootViewController].topVC.currentC;
    if (![UserServe sharedUserServe].userName) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
    [PublishServer signInWithNavigationController:navigationController completion:^{
    }];
}
- (void)loadViewContent
{
    petHeadView.image = nil;
    petHeadView.imageURL = [NSURL URLWithString:[UserServe sharedUserServe].account.headImgURL];
    [_hotVC beginRefreshing];
    [_squareVC beginRefreshing];
    [_attentionVC beginRefreshing];
}
-(void)reloadPublishSection
{
    [self.backScrollV setContentOffset:CGPointMake(self.view.frame.size.width*2, 0) animated:NO];
    [hotB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [squareB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [careB setTitleColor:CommonGreenColor forState:UIControlStateNormal];
    _hotVC.contentTableView.scrollsToTop = NO;
    _squareVC.scrollView.scrollsToTop = NO;
    _attentionVC.tableView.scrollsToTop = YES;
    [_attentionVC.tableView reloadData];
}
-(void)attentionViewReload
{
    [_attentionVC.tableView reloadData];
    [_attentionVC beginRefreshing];
}
- (void)doSthWhenPoped
{
    [_backScrollV setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)showMessageSide
{
    [[RootViewController sharedRootViewController].sideMenu presentLeftMenuViewController];
}
- (void)showUserSide
{
    [[RootViewController sharedRootViewController].sideMenu presentRightMenuViewController];
}
-(void)scrollBackScrollView:(UIButton*)btn
{
    if ([btn isEqual:hotB]) {
        [_backScrollV setContentOffset:CGPointMake(0, 0) animated:YES];
    }else
    if ([btn isEqual:squareB]) {
        [_backScrollV setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        [_hotVC.tableViewHelper stopAudio];
    }else
    if ([btn isEqual:careB]) {
        [_hotVC.tableViewHelper stopAudio];
        [_backScrollV setContentOffset:CGPointMake(self.view.frame.size.width*2, 0) animated:YES];
    }
}
#pragma mark -
#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _backScrollV) {
        scrollBG.frame = CGRectMake(scrollView.contentOffset.x*194/scrollView.contentSize.width, 36, 63, 8);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _backScrollV) {
        if (scrollBG.center.x < 22 + hotB.frame.size.width) {
            [hotB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [squareB setTitleColor:[UIColor colorWithR:245 g:245 b:245 alpha:1] forState:UIControlStateNormal];
            [careB setTitleColor:[UIColor colorWithR:245 g:245 b:245 alpha:1] forState:UIControlStateNormal];
            _hotVC.contentTableView.scrollsToTop = YES;
            _squareVC.scrollView.scrollsToTop = NO;
            _attentionVC.tableView.scrollsToTop = NO;
            hotB.titleLabel.font = [UIFont systemFontOfSize:16];
            squareB.titleLabel.font = [UIFont systemFontOfSize:15];
            careB.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        if (scrollBG.center.x > 2 + hotB.frame.size.width && scrollBG.center.x < 2 + 2*hotB.frame.size.width) {
            [hotB setTitleColor:[UIColor colorWithR:245 g:245 b:245 alpha:1] forState:UIControlStateNormal];
            [squareB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [careB setTitleColor:[UIColor colorWithR:245 g:245 b:245 alpha:1] forState:UIControlStateNormal];
            _hotVC.contentTableView.scrollsToTop = NO;
            _squareVC.scrollView.scrollsToTop = YES;
            _attentionVC.tableView.scrollsToTop = NO;
            [_hotVC.tableViewHelper stopAudio];
            
            hotB.titleLabel.font = [UIFont systemFontOfSize:15];
            squareB.titleLabel.font = [UIFont systemFontOfSize:16];
            careB.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        if (scrollBG.center.x > 2 + 2*hotB.frame.size.width) {
            [hotB setTitleColor:[UIColor colorWithR:245 g:245 b:245 alpha:1] forState:UIControlStateNormal];
            [squareB setTitleColor:[UIColor colorWithR:245 g:245 b:245 alpha:1] forState:UIControlStateNormal];
            [careB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _hotVC.contentTableView.scrollsToTop = NO;
            _squareVC.scrollView.scrollsToTop = NO;
            _attentionVC.tableView.scrollsToTop = YES;
            [_hotVC.tableViewHelper stopAudio];
            
            hotB.titleLabel.font = [UIFont systemFontOfSize:15];
            squareB.titleLabel.font = [UIFont systemFontOfSize:15];
            careB.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
}

-(void)toSearchPage
{
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    UINavigationController *navigationController = [RootViewController sharedRootViewController].topVC.currentC;
    [navigationController pushViewController:searchVC animated:NO];
    [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
