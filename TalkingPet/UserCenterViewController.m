//
//  UserCenterViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-14.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "UserCenterViewController.h"
#import "Common.h"
#import "PetCategoryParser.h"
#import "EGOImageButton.h"
#import "EGOImageView.h"
#import "UserListViewController.h"
#import "NewUserViewController.h"
#import "PetalkalkListViewController.h"
#import "MyGradeViewController.h"
#import "MyCionViewController.h"
#import "RootViewController.h"
#import "PublishServer.h"
#import "MyOrderViewConyroller.h"
#import "UserCenterGouWuFuncTableViewCell.h"
#import "AddressManageViewController.h"
#import "SetViewController.h"
#import "SectionMSgViewController.h"
#import "YZShoppingCarVC.h"

@interface UserCenterCell : UITableViewCell
@property (nonatomic,retain)UIImageView * imageV;
@property (nonatomic,retain)UILabel * textL;
@property (nonatomic,retain)UILabel * numberL;
@end
@implementation UserCenterCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
 
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12.5, 25, 25)];
        [self.contentView addSubview:_imageV];
        
        self.textL = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 80, 20)];
        self.textL.font = [UIFont systemFontOfSize:14];
        self.textL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:_textL];
        
        self.numberL = [[UILabel alloc] initWithFrame:CGRectMake(120, 12, 80, 15)];
        self.numberL.font = [UIFont systemFontOfSize:14];
        self.numberL.textColor = [UIColor colorWithWhite:150/255.0 alpha:1];
        [self.contentView addSubview:_numberL];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate,NewUserViewControllerDelegate>
{
    UIImageView * bgV ;
    
    UIButton * signInB;
    EGOImageButton * photoIB;
    UIButton * moreB;
    UIImageView * genderIV;
    UILabel * nicknameL;
    UILabel * breedAgeL;
    UIButton * attentionB;
    UIButton *fansB;
    
    
    UILabel * shuoshuoNumL;
    UIButton * shuoshuoBtn;
    UILabel * forwardNumL;
    UIButton * forwardBtn;
    UILabel * commentNumL;
    UIButton * commentBtn;
    UILabel * caiNumL;
    UIButton * caiBtn;
}
@property(nonatomic,retain)UITableView * tableView;
@property(nonatomic,retain)NSArray * stringArr;
@property(nonatomic,retain)NSArray * imgArr;
@property (nonatomic,retain) UIImageView * darenV;
@property (nonatomic,strong)UIButton * loginBtn;
@property (nonatomic,strong)UIBarButtonItem * msgBtnItem;

@property (nonatomic,retain)NewUserViewController * editCurrentPetVC;
@property (nonatomic,retain)NewUserViewController * addNewPetVC;
@end

@implementation UserCenterViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"个人中心";
        self.stringArr = @[@"我的等级",@"我的仔币"];
        self.imgArr = @[@"wodedengji@2x",@"wodezaibi@2x"];
        self.hideNaviBg = YES;
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNaviBg];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![UserServe sharedUserServe].userName) {
        _tableView.hidden = YES;
        _loginBtn.hidden = NO;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else{
        _tableView.hidden = NO;
        _loginBtn.hidden = YES;
        self.navigationItem.rightBarButtonItem = _msgBtnItem;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithR:240 g:240 b:240 alpha:1];
    // Do any additional setup after loading the view.
//    [self setBackButtonWithTarget:@selector(backAction)];
//    [self setRightButtonWithName:nil BackgroundImg:@"morebtn" Target:@selector(moreBtnClicked)];
    
    UIImage *image1 = [UIImage imageNamed:@"shezhi@2x"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *lItem = [[UIBarButtonItem alloc] initWithImage:image1 style:UIBarButtonItemStyleDone target:self action:@selector(showSetViewController)];
    self.navigationItem.leftBarButtonItem = lItem;
    
    UIImage *image = [UIImage imageNamed:@"xiaoxi@2x"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _msgBtnItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(toMessageVC:)];
    self.navigationItem.rightBarButtonItem = _msgBtnItem;
    
    bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, -100, self.view.frame.size.width, 400)];
    [bgV setImage:[UIImage imageNamed:@"usercenter_topBg"]];
    [self.view addSubview:bgV];
    
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake((ScreenWidth-100)/2, CGRectGetMaxY(bgV.frame)+30, 100, 30);
    _loginBtn.backgroundColor = [UIColor whiteColor];
    _loginBtn.layer.cornerRadius = 15;
    _loginBtn.layer.borderWidth = 1;
    _loginBtn.layer.borderColor = [CommonGreenColor CGColor];
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
    [_loginBtn setTitle:@"立刻登录" forState:UIControlStateNormal];
    [self.view addSubview:_loginBtn];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_loginBtn addTarget:self action:@selector(toLogInPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
//    _tableView.hidden = YES;
    _tableView.backgroundView = nil;
    _tableView.clipsToBounds = YES;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
//    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.rowHeight = 50;
    [_tableView addHeaderWithTarget:self action:@selector(getCurrentPetInfo)];
    _tableView.tableHeaderView = ({
        UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        view.backgroundColor = [UIColor clearColor];
        
        UIView * whiteV = [[UIView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 180)];
        whiteV.backgroundColor = [UIColor whiteColor];
        [view addSubview:whiteV];
        
//        signInB = [UIButton buttonWithType:UIButtonTypeCustom];
//        signInB.frame = CGRectMake(ScreenWidth-10-48, 10+navigationBarHeight, 46, 20);
//        signInB.titleLabel.font = [UIFont systemFontOfSize:13];
//        [signInB addTarget:self action:@selector(currentPetSignIn) forControlEvents:UIControlEventTouchUpInside];
//        [self buildSignInButtonWithCurrentPetSignatured];
//        [view addSubview:signInB];
        
        photoIB = [[EGOImageButton alloc] initWithFrame:CGRectMake(view.center.x-37, 120-37, 74, 74)];
        photoIB.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
        photoIB.layer.masksToBounds=YES;
        photoIB.layer.cornerRadius = 37;
        photoIB.layer.borderColor = [CommonGreenColor CGColor];
        photoIB.layer.borderWidth = 1;
        [view addSubview:photoIB];
        [photoIB addTarget:self action:@selector(pushToEditCurrentPetVC) forControlEvents:UIControlEventTouchUpInside];
        
//        self.darenV = [[UIImageView alloc] initWithFrame:CGRectMake(view.center.x-37+74-20, 23+74-20+navigationBarHeight, 20, 20)];
//        [self.darenV setImage:[UIImage imageNamed:@"daren"]];
//        [view addSubview:self.darenV];
//        self.darenV.hidden = YES;
        
        nicknameL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(photoIB.frame)+8, 300, 20)];
        nicknameL.center = CGPointMake(photoIB.center.x, nicknameL.center.y);
        nicknameL.backgroundColor = [UIColor clearColor];
        nicknameL.font = [UIFont boldSystemFontOfSize:16];
        nicknameL.textAlignment = NSTextAlignmentCenter;
        nicknameL.textColor = CommonGreenColor;
        [view addSubview:nicknameL];
        
//        genderIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIB.frame)-20, CGRectGetMaxY(photoIB.frame)-20, 20, 20)];
//        [view addSubview:genderIV];
        
        breedAgeL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nicknameL.frame)+5, ScreenWidth, 20)];
        breedAgeL.backgroundColor = [UIColor clearColor];
        breedAgeL.textColor = CommonGreenColor;
        breedAgeL.font = [UIFont systemFontOfSize:14];
        breedAgeL.textAlignment = NSTextAlignmentCenter;
        [view addSubview:breedAgeL];
        
        attentionB = [UIButton buttonWithType:UIButtonTypeCustom];
        [attentionB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        attentionB.titleLabel.font = [UIFont systemFontOfSize:16];
        [attentionB addTarget:self action:@selector(puthAttentionViewCntroller) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:attentionB];
//        [attentionB setTitleShadowColor:[UIColor colorWithWhite:0.3 alpha:0.6] forState:UIControlStateNormal];
//        attentionB.titleLabel.shadowOffset = CGSizeMake(1, 1);
        
        fansB = [UIButton buttonWithType:UIButtonTypeCustom];
        [fansB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        fansB.titleLabel.font = [UIFont systemFontOfSize:16];
        [fansB addTarget:self action:@selector(puthFansViewCntroller) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:fansB];
//        [fansB setTitleShadowColor:[UIColor colorWithWhite:0.3 alpha:0.6] forState:UIControlStateNormal];
//        fansB.titleLabel.shadowOffset = CGSizeMake(1, 1);
        
        UILabel * lineL = [[UILabel alloc] initWithFrame:CGRectMake(view.center.x-10, CGRectGetMaxY(breedAgeL.frame)+16, 20, 10)];
        [lineL setText:@"|"];
        [lineL setTextColor:[UIColor whiteColor]];
        [lineL setBackgroundColor:[UIColor clearColor]];
        [lineL setTextAlignment:NSTextAlignmentCenter];
        [lineL setFont:[UIFont systemFontOfSize:20]];
        lineL.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        lineL.shadowOffset = CGSizeMake(1, 1);
        [view addSubview:lineL];
        
        UIView * bView = [[UIView alloc] initWithFrame:CGRectMake(10,  CGRectGetMaxY(breedAgeL.frame)+40, view.frame.size.width-20, 1)];
        bView.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
        [view addSubview:bView];
        
        shuoshuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shuoshuoBtn.backgroundColor = [UIColor clearColor];
        [shuoshuoBtn setFrame:CGRectMake(0, view.frame.size.height-45, ScreenWidth/3, 40)];
        [view addSubview:shuoshuoBtn];
        shuoshuoNumL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, 20)];
        shuoshuoNumL.backgroundColor = [UIColor clearColor];
        shuoshuoNumL.textAlignment = NSTextAlignmentCenter;
        shuoshuoNumL.font = [UIFont boldSystemFontOfSize:15];
        shuoshuoNumL.textColor = [UIColor grayColor];
        [shuoshuoBtn addSubview:shuoshuoNumL];
        UILabel * shuoshuoL = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, ScreenWidth/3, 20)];
        [shuoshuoL setBackgroundColor:[UIColor clearColor]];
        shuoshuoL.textAlignment = NSTextAlignmentCenter;
        [shuoshuoL setText:@"发布"];
        shuoshuoL.font = [UIFont systemFontOfSize:13];
        shuoshuoL.textColor = [UIColor lightGrayColor];
        [shuoshuoBtn addSubview:shuoshuoL];
        [shuoshuoBtn addTarget:self action:@selector(toshuoshuoListPage) forControlEvents:UIControlEventTouchUpInside];
        shuoshuoBtn.showsTouchWhenHighlighted = YES;
        
        
//        forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        forwardBtn.backgroundColor = [UIColor clearColor];
//        [forwardBtn setFrame:CGRectMake(ScreenWidth/3, view.frame.size.height-55, ScreenWidth/3, 40)];
//        [view addSubview:forwardBtn];
//        forwardNumL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, 20)];
//        forwardNumL.backgroundColor = [UIColor clearColor];
//        forwardNumL.textAlignment = NSTextAlignmentCenter;
//        forwardNumL.font = [UIFont boldSystemFontOfSize:15];
//        forwardNumL.textColor = [UIColor grayColor];
//        [forwardBtn addSubview:forwardNumL];
//        UILabel * forwardL = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, ScreenWidth/3, 20)];
//        [forwardL setBackgroundColor:[UIColor clearColor]];
//        forwardL.textAlignment = NSTextAlignmentCenter;
//        [forwardL setText:@"转发"];
//        forwardL.font = [UIFont systemFontOfSize:13];
//        forwardL.textColor = [UIColor lightGrayColor];
//        [forwardBtn addSubview:forwardL];
//        [forwardBtn addTarget:self action:@selector(tomyForwardPage) forControlEvents:UIControlEventTouchUpInside];
//        forwardBtn.showsTouchWhenHighlighted = YES;
        
        commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.backgroundColor = [UIColor clearColor];
        [commentBtn setFrame:CGRectMake(ScreenWidth/3, view.frame.size.height-45, ScreenWidth/3, 40)];
        [view addSubview:commentBtn];
        commentNumL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, 20)];
        commentNumL.backgroundColor = [UIColor clearColor];
        commentNumL.textAlignment = NSTextAlignmentCenter;
        commentNumL.font = [UIFont boldSystemFontOfSize:15];
        commentNumL.textColor = [UIColor grayColor];
        [commentBtn addSubview:commentNumL];
        UILabel * comentL = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, ScreenWidth/3, 20)];
        [comentL setBackgroundColor:[UIColor clearColor]];
        comentL.textAlignment = NSTextAlignmentCenter;
        [comentL setText:@"评论"];
        comentL.font = [UIFont systemFontOfSize:13];
        comentL.textColor = [UIColor lightGrayColor];
        [commentBtn addSubview:comentL];
        [commentBtn addTarget:self action:@selector(tomyCommentPage) forControlEvents:UIControlEventTouchUpInside];
        commentBtn.showsTouchWhenHighlighted = YES;
        
        
        caiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        caiBtn.backgroundColor = [UIColor clearColor];
        [caiBtn setFrame:CGRectMake((ScreenWidth/3)*2, view.frame.size.height-45, ScreenWidth/3, 40)];
        [view addSubview:caiBtn];
        caiNumL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, 20)];
        caiNumL.backgroundColor = [UIColor clearColor];
        caiNumL.textAlignment = NSTextAlignmentCenter;
        caiNumL.font = [UIFont boldSystemFontOfSize:15];
        caiNumL.textColor = [UIColor grayColor];
        [caiBtn addSubview:caiNumL];
        UILabel * caiL = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, ScreenWidth/3, 20)];
        [caiL setBackgroundColor:[UIColor clearColor]];
        caiL.textAlignment = NSTextAlignmentCenter;
        [caiL setText:@"喜欢"];
        caiL.font = [UIFont systemFontOfSize:13];
        caiL.textColor = [UIColor lightGrayColor];
        [caiBtn addSubview:caiL];
        [caiBtn addTarget:self action:@selector(tomyFavorPage) forControlEvents:UIControlEventTouchUpInside];
        caiBtn.showsTouchWhenHighlighted = YES;
        
        view;
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildSignInButtonWithCurrentPetSignatured) name:@"WXRUsersignInOrNo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewContent) name:@"WXRLoginSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeSuccess:) name:@"WXRExchangeSuccess" object:nil];
    
    [self loadViewContent];
    [self buildViewWithSkintype];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)exchangeSuccess:(NSNotification*)notification
{
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)loadViewContent
{
    nicknameL.text = [UserServe sharedUserServe].account.nickname;
    photoIB.imageURL = [NSURL URLWithString:[UserServe sharedUserServe].account.headImgURL];
//    if ([UserServe sharedUserServe].petArr.count>0) {
//        [moreB setBackgroundImage:[UIImage imageNamed:@"usercenter_changePet"] forState:UIControlStateNormal];
//    }else
//    {
//        [moreB setBackgroundImage:[UIImage imageNamed:@"usercenter_addPet"] forState:UIControlStateNormal];
//    }
    [attentionB setTitle:[NSString stringWithFormat:@"关注:%@",[UserServe sharedUserServe].account.attentionNo] forState:UIControlStateNormal];
    [fansB setTitle:[NSString stringWithFormat:@"粉丝:%@",[UserServe sharedUserServe].account.fansNo] forState:UIControlStateNormal];
    CGSize attentionSize = [attentionB.titleLabel.text sizeWithFont:attentionB.titleLabel.font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize fansSize = [fansB.titleLabel.text sizeWithFont:fansB.titleLabel.font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    UIView * view = attentionB.superview;
    attentionB.frame = CGRectMake(view.center.x - attentionSize.width-30, CGRectGetMaxY(breedAgeL.frame)+10, attentionSize.width+20, 20);
    fansB.frame = CGRectMake(view.center.x + 10, CGRectGetMaxY(breedAgeL.frame)+10, fansSize.width+20, 20);
//    switch ([[UserServe sharedUserServe].account.gender integerValue]) {
//        case 0:{
//            genderIV.image = [UIImage imageNamed:@"female_border"];
//        }break;
//        case 1:{
//            genderIV.image = [UIImage imageNamed:@"male_border"];
//        }break;
//        default:{
//            genderIV.image = nil;
//        }break;
//    }
////    self.darenV.hidden = [UserServe sharedUserServe].account.ifDaren?NO:YES;
//    CGSize k = [nicknameL.text sizeWithFont:nicknameL.font constrainedToSize:CGSizeMake(ScreenWidth-40, nicknameL.frame.size.height)];
//    [self.darenV setFrame:CGRectMake(ScreenWidth/2-k.width/2-25, nicknameL.frame.origin.y, 20, 20)];
//    PetCategoryParser * pet = [[PetCategoryParser alloc] init];
//    breedAgeL.text = [[[pet breedWithIDcode:[[UserServe sharedUserServe].account.breed integerValue]] stringByAppendingString:[NSString stringWithFormat:@"  %@",[Common calAgeWithBirthDate:[NSString stringWithFormat:@"%f",[[UserServe sharedUserServe].account.birthday timeIntervalSince1970]*1000]]]] stringByAppendingString:[NSString stringWithFormat:@"   LV.%d",[[UserServe sharedUserServe].account.grade intValue]]];
    breedAgeL.text = [NSString stringWithFormat:@" LV.%d",[[UserServe sharedUserServe].account.grade intValue]];
    
    [_tableView reloadData];
    
    shuoshuoNumL.text = [UserServe sharedUserServe].account.issue;
    forwardNumL.text = [UserServe sharedUserServe].account.relay;
    commentNumL.text = [UserServe sharedUserServe].account.comment;
    caiNumL.text = [UserServe sharedUserServe].account.favour;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"UserCenterScorePrompt"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"UserCenterScorePrompt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        PromptView * p = [[PromptView alloc] initWithPoint:CGPointMake(70, self.tableView.tableHeaderView.frame.size.height+120+10) image:[UIImage imageNamed:@"score_prompt"] arrowDirection:1];
        [self.view addSubview:p];
        [p show];
    }
}
- (void)actionPetSynchronous
{
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"pet" forKey:@"command"];
    [regDict setObject:@"active" forKey:@"options"];
    [regDict setObject:[UserServe sharedUserServe].userID forKey:@"id"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark -
- (void)puthAttentionViewCntroller
{
    UserListViewController * attentionV = [[UserListViewController alloc] init];
    attentionV.listType = UserListTypeAttention;
    attentionV.petID = [UserServe sharedUserServe].userID;
    [self.navigationController pushViewController:attentionV animated:YES];
}
- (void)puthFansViewCntroller
{
    UserListViewController * fansV = [[UserListViewController alloc] init];
    fansV.listType = UserListTypeFans;
    fansV.petID = [UserServe sharedUserServe].userID;
    [self.navigationController pushViewController:fansV animated:YES];
}
- (void)buildSignInButtonWithCurrentPetSignatured
{
//    if ([UserServe sharedUserServe].accountSignatured) {
////        [signInB setTitle:@"已签到" forState:UIControlStateNormal];
//        [signInB setBackgroundImage:[UIImage imageNamed:@"usercenter_signedBtn"] forState:UIControlStateNormal];
//    }else
//    {
//        [signInB setBackgroundImage:[UIImage imageNamed:@"usercenter_signBtn"] forState:UIControlStateNormal];
//    }
    
}
- (void)currentPetSignIn
{
    [PublishServer signInWithNavigationController:self.navigationController completion:^{
//        [self buildSignInButtonWithCurrentPetSignatured];
//        [[RootViewController sharedRootViewController].mainVC mainViewNeedSignIn];
    }];;
}
- (void)pushToEditCurrentPetVC
{
    self.editCurrentPetVC = [[NewUserViewController alloc] init];
    _editCurrentPetVC.delegate = self;
    _editCurrentPetVC.fromUserCenter = YES;
    [self.navigationController pushViewController:_editCurrentPetVC animated:YES];
}
- (void)getCurrentPetInfo
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"account" forKey:@"command"];
    [mDict setObject:@"userInfo" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
//    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = [responseObject objectForKey:@"value"];
        [UserServe sharedUserServe].account.fansNo = (dict[@"counter"])[@"fans"];
        [UserServe sharedUserServe].account.attentionNo = (dict[@"counter"])[@"focus"];
        [UserServe sharedUserServe].account.issue = (dict[@"counter"])[@"issue"];
        [UserServe sharedUserServe].account.relay = (dict[@"counter"])[@"relay"];
        [UserServe sharedUserServe].account.comment = (dict[@"counter"])[@"comment"];
        [UserServe sharedUserServe].account.favour = (dict[@"counter"])[@"favour"];
        [UserServe sharedUserServe].account.grade = [dict[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];
        [UserServe sharedUserServe].account.score = dict[@"score"];
        [UserServe sharedUserServe].account.coin = dict[@"coin"];
        [self loadViewContent];
//        [DatabaseServe activatePet:[UserServe sharedUserServe].account WithUsername:[UserServe sharedUserServe].userName];
        
        Account * acc = [[Account alloc]initWithDictionary:dict error:nil];
        [DatabaseServe activateUeserWithAccount:acc];
//        userServe.account = [DatabaseServe getActionAccount];
        
        [self.tableView headerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView headerEndRefreshing];
    }];
}
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scale = 1;
    if (scrollView.contentOffset.y<0) {
        scale = (bgV.frame.size.height/2-scrollView.contentOffset.y)/bgV.frame.size.height*2;
    }
    bgV.transform = CGAffineTransformMakeScale(scale, scale);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:_stringArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *CommentCellIdentifier1 = @"mallCell";
        UserCenterGouWuFuncTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier1 ];
        if (cell == nil) {
            cell = [[UserCenterGouWuFuncTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentCellIdentifier1];
        }
        cell.buttonClicked = ^(int index){
            [self toSomePage:index];
        };
        return cell;

    }
    else{
        static NSString *CommentCellIdentifier = @"Cell";
        UserCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier ];
        if (cell == nil) {
            cell = [[UserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentCellIdentifier];
        }
        cell.textL.text = _stringArr[indexPath.row];
        cell.imageV.image = [UIImage imageNamed:_imgArr[indexPath.row]];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==0?140.f:50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:{
                MyGradeViewController * myGradeVC = [[MyGradeViewController alloc] init];
                myGradeVC.title = @"我的等级";
                [self.navigationController pushViewController:myGradeVC animated:YES];
            }break;
            case 1:{
                MyCionViewController * myGradeVC = [[MyCionViewController alloc] init];
                [self.navigationController pushViewController:myGradeVC animated:YES];
            }break;
//            case 2:{
//                MyGradeViewController * myGradeVC = [[MyGradeViewController alloc] init];
//                myGradeVC.title = @"我的积分";
//                [self.navigationController pushViewController:myGradeVC animated:YES];
//            }break;
//            case 3:{
//                MyOrderViewConyroller * myOrderVC = [[MyOrderViewConyroller alloc] init];
//                [self.navigationController pushViewController:myOrderVC animated:YES];
//            }break;
//            case 4:{
//                QuanViewController * quanVC = [[QuanViewController alloc] init];
//                quanVC.pageType = 0;
//                [self.navigationController pushViewController:quanVC animated:YES];
//            }break;
            default:
                break;
        }
    }
//    if (indexPath.section==1) {
//        switch (indexPath.row) {
//            case 0:{
//                PetalkalkListViewController * tagTlistV = [[PetalkalkListViewController alloc] init];
//                tagTlistV.title = _stringArr[indexPath.row+2];
//                tagTlistV.listTyep = PetalkListTyepMyPublish;
//                [self.navigationController pushViewController:tagTlistV animated:YES];
//            }break;
//            case 1:{
//                PetalkalkListViewController * tagTlistV = [[PetalkalkListViewController alloc] init];
//                tagTlistV.title = _stringArr[indexPath.row+2];
//                tagTlistV.listTyep = PetalkListTyepMyForWord;
//                [self.navigationController pushViewController:tagTlistV animated:YES];
//            }break;
//            case 2:{
//                MyCommentViewController * myCV = [[MyCommentViewController alloc] init];
//                [self.navigationController pushViewController:myCV animated:YES];
//                
//            }break;
//            case 3:{
//                PetalkalkListViewController * tagTlistV = [[PetalkalkListViewController alloc] init];
//                tagTlistV.title = _stringArr[indexPath.row+2];
//                tagTlistV.listTyep = PetalkListTyepMyZan;
//                [self.navigationController pushViewController:tagTlistV animated:YES];
//            }break;
//            
//            default:
//                break;
//        }
//    }
}
-(void)toSomePage:(int)index
{
    switch (index) {
        case 0:{
            [self toShoppingCarVC];
        }break;
        case 1:{
            AddressManageViewController * sv = [[AddressManageViewController alloc] init];
            sv.finishTitle = @"保存";
            [self.navigationController pushViewController:sv animated:YES];
        }break;
        case 2:{
            MyOrderViewConyroller * myOrderVC = [[MyOrderViewConyroller alloc] init];
            [self.navigationController pushViewController:myOrderVC animated:YES];
        }break;
        default:
            break;
    }

}
-(void)toshuoshuoListPage
{
    MyShuoshuoTimeLineViewController * tagTlistV = [[MyShuoshuoTimeLineViewController alloc] init];
    tagTlistV.title = @"我的发布";
//    tagTlistV.listTyep = PetalkListTyepMyPublish;
    [self.navigationController pushViewController:tagTlistV animated:YES];
}
-(void)tomyForwardPage
{
    PetalkalkListViewController * tagTlistV = [[PetalkalkListViewController alloc] init];
    tagTlistV.title = @"我的转发";
    tagTlistV.listTyep = PetalkListTyepMyForWord;
    [self.navigationController pushViewController:tagTlistV animated:YES];
}
-(void)tomyCommentPage
{
    MyCommentViewController * myCV = [[MyCommentViewController alloc] init];
    [self.navigationController pushViewController:myCV animated:YES];

}
-(void)tomyFavorPage
{
    PetalkalkListViewController * tagTlistV = [[PetalkalkListViewController alloc] init];
    tagTlistV.title = @"我喜欢的";
    tagTlistV.listTyep = PetalkListTyepMyZan;
    [self.navigationController pushViewController:tagTlistV animated:YES];
}

#pragma mark -
- (NSString *)titleWithNewUserViewController:(NewUserViewController*)controller
{
    if (controller == _addNewPetVC) {
        return @"添加宠物";
    }
    return @"编辑资料";
}
- (UIButton *)finishButtonWithWithNewUserViewController:(NewUserViewController*)controller
{
    UIButton * registerB = [UIButton buttonWithType:UIButtonTypeCustom];
    registerB.frame = CGRectMake(0.0, 0.0, 65, 32);
    if (controller == _addNewPetVC) {
        [registerB setTitle:@"添加" forState:UIControlStateNormal];
        [registerB addTarget:self action:@selector(addNewPet) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        [registerB setTitle:@"保存" forState:UIControlStateNormal];
        [registerB addTarget:self action:@selector(saveCurrentPet) forControlEvents:UIControlEventTouchUpInside];
    }
    return registerB;
}
- (Account*)petWithWithNewUserViewController:(NewUserViewController*)controller
{
    if (controller == _editCurrentPetVC) {
        return [UserServe sharedUserServe].account;
    }
    return nil;
}
- (void)addNewPet
{
    if ([_addNewPetVC.nameTF.text CutSpacing].length<2||[_addNewPetVC.nameTF.text CutSpacing].length>15) {
        [SVProgressHUD showErrorWithStatus:@"昵称要填哦，2-15个字"];
        return;
    }
    if (_addNewPetVC.genderTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"性别要选呀"];
        return;
    }
    if (_addNewPetVC.birthTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"生日要选呀"];
        return;
    }
    if (_addNewPetVC.breedTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"你的种族得让人家知道呀"];
        return;
    }
    if (_addNewPetVC.regionTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"填一下你在哪吧"];
        return;
    }
    if (_addNewPetVC.headIMG) {
        [SVProgressHUD showWithStatus:@"设置头像..."];
        [NetServer uploadImage:_addNewPetVC.headIMG Type:@"avatar" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        } Success:^(id responseObject, NSString *fileURL) {
            _addNewPetVC.avatarUrl = fileURL;
            [SVProgressHUD dismiss];
            [self saveEditNewPet];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [_addNewPetVC showAlertWithMessage:@"头像上传失败，请稍后重试"];
        }];
    }
    else{
        [self saveEditNewPet];
    }
}
- (void)saveCurrentPet
{
    if ([_editCurrentPetVC.nameTF.text CutSpacing].length<2||[_editCurrentPetVC.nameTF.text CutSpacing].length>15) {
        [SVProgressHUD showErrorWithStatus:@"昵称要填哦，2-15个字"];
        return;
    }
    if (_editCurrentPetVC.headIMG) {
        [SVProgressHUD showWithStatus:@"设置头像..."];
        [NetServer uploadImage:_editCurrentPetVC.headIMG Type:@"avatar" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        } Success:^(id responseObject, NSString *fileURL) {
            _editCurrentPetVC.avatarUrl = fileURL;
            [SVProgressHUD dismiss];
            [self saveEditCurrentPet];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [_editCurrentPetVC showAlertWithMessage:@"头像上传失败，请稍后重试"];
        }];
    }
    else{
        [self saveEditCurrentPet];
    }
}
- (void)saveEditCurrentPet
{
    [SVProgressHUD showWithStatus:@"设置个人资料..."];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"pet" forKey:@"command"];
    [regDict setObject:@"update" forKey:@"options"];
    [regDict setObject:[UserServe sharedUserServe].userID forKey:@"id"];
    [regDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    [regDict setObject:[_editCurrentPetVC.nameTF.text CutSpacing] forKey:@"nickname"];
    [regDict setObject:_editCurrentPetVC.avatarUrl forKey:@"headPortrait"];
    [regDict setObject:_editCurrentPetVC.genderCode forKey:@"gender"];
//    [regDict setObject:_editCurrentPetVC.breedCode forKey:@"type"];
//    [regDict setObject:[NSString stringWithFormat:@"%.0f",_editCurrentPetVC.selectedBirthday*1000] forKey:@"birthday"];
//    [regDict setObject:_editCurrentPetVC.regionTL.text forKey:@"address"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UserServe sharedUserServe].account = ({
            Account * pet = [UserServe sharedUserServe].account;
            pet.nickname = [_editCurrentPetVC.nameTF.text CutSpacing];
            pet.headImgURL = _editCurrentPetVC.avatarUrl;
            pet.gender = _editCurrentPetVC.genderCode;
//            pet.breed = _editCurrentPetVC.breedCode;
//            pet.region = _editCurrentPetVC.regionTL.text;
//            pet.birthday = [NSDate dateWithTimeIntervalSince1970:_editCurrentPetVC.selectedBirthday];
            pet;
        });
        [DatabaseServe activatePet:[UserServe sharedUserServe].account WithUsername:[UserServe sharedUserServe].userName];
        
        [SVProgressHUD dismiss];
        [self loadViewContent];
        [_editCurrentPetVC back];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register failed info:%@",error);
        [SVProgressHUD dismiss];
        [_editCurrentPetVC showAlertWithMessage:error.domain];
    }];
}
- (void)saveEditNewPet
{
    [SVProgressHUD showWithStatus:@"设置个人资料..."];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"pet" forKey:@"command"];
    [regDict setObject:@"create" forKey:@"options"];
    [regDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    [regDict setObject:[_addNewPetVC.nameTF.text CutSpacing] forKey:@"nickName"];
    [regDict setObject:_addNewPetVC.avatarUrl forKey:@"headPortrait"];
    [regDict setObject:_addNewPetVC.genderCode forKey:@"gender"];
    [regDict setObject:_addNewPetVC.breedCode forKey:@"type"];
    [regDict setObject:[NSString stringWithFormat:@"%.0f",_addNewPetVC.selectedBirthday*1000] forKey:@"birthday"];
    [regDict setObject:_addNewPetVC.regionTL.text forKey:@"address"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * petDic = responseObject[@"value"];
        Pet * pet = [[Pet alloc] init];
        pet.petID = petDic[@"id"];
        pet.nickname = petDic[@"nickName"];
        pet.headImgURL = petDic[@"headPortrait"];
        pet.gender = petDic[@"gender"];
        pet.breed = petDic[@"type"];
        pet.region = petDic[@"address"];
        pet.birthday = [NSDate dateWithTimeIntervalSince1970:[petDic[@"birthday"] doubleValue]/1000];
        pet.fansNo = @"0";
        pet.attentionNo = @"0";
        pet.issue = @"0";
        pet.relay = @"0";
        pet.comment = @"0";
        pet.favour = @"0";
        pet.grade = [petDic[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];;
        pet.score = petDic[@"score"];
        pet.coin = petDic[@"coin"];
        pet.ifDaren = [petDic[@"star"] isEqualToString:@"1"]?YES:NO;
//        [UserServe sharedUserServe].petArr = [NSMutableArray arrayWithArray:[UserServe sharedUserServe].petArr];
//        [[UserServe sharedUserServe].petArr addObject:pet];
        [DatabaseServe savePet:pet WithUsername:[UserServe sharedUserServe].userName];
        [SVProgressHUD dismiss];
        [self loadViewContent];
        [_addNewPetVC back];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register failed info:%@",error);
        [SVProgressHUD dismiss];
        [_addNewPetVC showAlertWithMessage:error.domain];
    }];
}

- (void)showSetViewController
{
    SetViewController * setVC = [[SetViewController alloc] init];

    [self.navigationController pushViewController:setVC animated:YES];

}
-(void)toMessageVC:(UIButton *)sender
{
    SectionMSgViewController * secmsg = [[SectionMSgViewController alloc] init];
    [self.navigationController pushViewController:secmsg animated:YES];
}
-(void)toShoppingCarVC
{
    YZShoppingCarVC *shoppingCarVC = [[YZShoppingCarVC alloc] init];
    shoppingCarVC.selectedIndex = 0;
    [self.navigationController pushViewController:shoppingCarVC animated:YES];
}
-(void)moreBtnClicked
{
    ChangePetViewController * chv = [[ChangePetViewController alloc] init];
    chv.title = @"切换宠物";
    [self.navigationController pushViewController:chv animated:YES];
    
}
-(void)toLogInPage
{
    [[RootViewController sharedRootViewController] showLoginViewController];
}
#pragma mark -
@end