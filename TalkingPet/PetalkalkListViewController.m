//
//  PetalkalkListViewController.m
//  TalkingPet
//
//  Created by wangxr on 14/12/1.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "PetalkalkListViewController.h"
#import "BrowserTableHelper.h"
#import "RootViewController.h"
#import "BlankPageView.h"

@interface PetalkalkListViewController ()
{
    BlankPageView * blankPage;
}
@property (nonatomic, strong)UITableView * contentTableView;

@property (nonatomic,strong) BrowserTableHelper * tableViewHelper;
@end
@implementation PetalkalkListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.listTyep = PetalkListTyepAllPetalk;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    _contentTableView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_contentTableView];
    
    self.tableViewHelper = [[BrowserTableHelper alloc] initWithController:self Tableview:_contentTableView SectionView:nil];
    
    _contentTableView.delegate = _tableViewHelper;
    _contentTableView.dataSource = _tableViewHelper;
    if (self.listTyep==PetalkListTyepAllPetalk) {
        _tableViewHelper.cellNeedShowPublishTime = NO;
    }
    else
        _tableViewHelper.cellNeedShowPublishTime = NO;
    
    
    NSMutableDictionary * hotDic = [NetServer commonDict];
    if (self.listTyep == PetalkListTyepChannel) {
        [self requestChannelInfo];
        [hotDic setObject:@"petalk" forKey:@"command"];
        [hotDic setObject:@"0" forKey:@"pageIndex"];
        [hotDic setObject:@"10" forKey:@"pageSize"];
        [hotDic setObject:@"channel" forKey:@"options"];
        [hotDic setObject:self.otherCode forKey:@"code"];
        if ([UserServe sharedUserServe].userID) {
            [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
        }
    }if (self.listTyep == PetalkListTyepPetBreed) {
        [hotDic setObject:@"petalk" forKey:@"command"];
        [hotDic setObject:@"0" forKey:@"pageIndex"];
        [hotDic setObject:@"10" forKey:@"pageSize"];
        [hotDic setObject:@"petBreed" forKey:@"options"];
        [hotDic setObject:self.otherCode forKey:@"code"];
        if ([UserServe sharedUserServe].userID) {
            [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        }
    }if (self.listTyep == PetalkListTyepAllPetalk) {
        [hotDic setObject:@"petalk" forKey:@"command"];
        [hotDic setObject:@"10" forKey:@"pageSize"];
        [hotDic setObject:@"all" forKey:@"options"];
        if ([UserServe sharedUserServe].userID) {
            [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        }
    }if (self.listTyep == PetalkListTyepMyPublish) {
        [hotDic setObject:@"petalk" forKey:@"command"];
        [hotDic setObject:@"userList" forKey:@"options"];
        [hotDic setObject:@"10" forKey:@"pageSize"];
        [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
        [hotDic setObject:@"O" forKey:@"type"];
    }if (self.listTyep == PetalkListTyepMyForWord) {
        [hotDic setObject:@"petalk" forKey:@"command"];
        [hotDic setObject:@"userList" forKey:@"options"];
        [hotDic setObject:@"10" forKey:@"pageSize"];
        [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
        [hotDic setObject:@"R" forKey:@"type"];
        self.tableViewHelper.needShowZanAndComment = NO;
        
    }if (self.listTyep == PetalkListTyepMyZan) {
        [hotDic setObject:@"petalk" forKey:@"command"];
        [hotDic setObject:@"userList" forKey:@"options"];
        [hotDic setObject:@"10" forKey:@"pageSize"];
//        [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
        [hotDic setObject:@"F" forKey:@"type"];
        self.tableViewHelper.needShowZanAndComment = NO;
    }
    if (_listTyep == PetalkListTyepMyForWord || _listTyep == PetalkListTyepMyZan) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBlankPage:) name:@"WXRBrowserHelperZeroData" object:_tableViewHelper];
    }
    self.tableViewHelper.reqDict = hotDic;
    [self.contentTableView headerBeginRefreshing];
    
    // Do any additional setup after loading the view.
}
-(void)showBlankPage:(NSNotification*)not
{
    if (!not.userInfo) {
        if (!blankPage) {
            __weak UINavigationController * weakNav = self.navigationController;
            blankPage = [[BlankPageView alloc] initWithImage];
            if (_listTyep == PetalkListTyepMyForWord) {
                [blankPage showWithView:self.view image:[UIImage imageNamed:@"forWord_without"] buttonImage:[UIImage imageNamed:@"forWord_toFo"] action:^{
                    [weakNav popToRootViewControllerAnimated:YES];
                }];
            }else if (_listTyep == PetalkListTyepMyZan)
            {
                [blankPage showWithView:self.view image:[UIImage imageNamed:@"zanPetalk_without"] buttonImage:[UIImage imageNamed:@"zanPetalk_toZan"] action:^{
                    [weakNav popToRootViewControllerAnimated:YES];
                }];
            }
        }
    }
    else if(blankPage){
        [blankPage removeFromSuperview];
        blankPage = nil;
    }
}
-(void)requestChannelInfo
{
    NSMutableDictionary* dict = [NetServer commonDict];
    [dict setObject:@"channel" forKey:@"command"];
    [dict setObject:@"one" forKey:@"options"];
    [dict setObject:self.otherCode forKey:@"code"];
    [NetServer requestWithParameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"get a tag info success:%@",responseObject);
        NSDictionary * value = [responseObject objectForKey:@"value"];
//        Tag * theT = [[Tag alloc] init];
//        theT.tagName = [value objectForKey:@"name"];
//        theT.tagID = [value objectForKey:@"id"];
        if ([value objectForKey:@"detailUrl"]) {
            self.detailUrl = [value objectForKey:@"detailUrl"];
        }
        if ([value objectForKey:@"bgUrl"]) {
            self.backGroundURL = [value objectForKey:@"bgUrl"];
        }
        self.title = [value objectForKey:@"name"];
        if (![self.backGroundURL isEqualToString:@" "]&&self.backGroundURL.length>2) {
            //            UIView * bgvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 125)];
            //            [bgvv setBackgroundColor:[UIColor clearColor]];
            self.bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
            [self.bgV setBackgroundColor:[UIColor clearColor]];
            
                        
            self.dButton = [[EGOImageButton alloc] initWithPlaceholderImage:nil delegate:self];
            [self.dButton setFrame:CGRectMake(0, 0, ScreenWidth, 120)];
            self.dButton.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
            [self.bgV addSubview:self.dButton];
            [self.dButton setImageURL:[NSURL URLWithString:self.backGroundURL]];
            [self.dButton addTarget:self action:@selector(clickedContentImageV:) forControlEvents:UIControlEventTouchUpInside];
            
            _contentTableView.tableHeaderView = self.bgV;
        }
        else
        {


        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)clickedContentImageV:(EGOImageButton *)sender
{
    if (self.detailUrl) {
        if (![self.detailUrl isEqualToString:@" "]&&self.detailUrl.length>2) {
            WebContentViewController * vb = [[WebContentViewController alloc] init];
            vb.urlStr =[self.detailUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            vb.title = self.title;
            [self.navigationController pushViewController:vb animated:YES];
        }
    }
}
- (void)imageButtonLoadedImage:(EGOImageButton *)imageButton
{
    CGSize size = imageButton.currentImage.size;
    imageButton.frame = CGRectMake(0, 0, ScreenWidth, size.height*ScreenWidth/size.width);
    UIView * bgvv = imageButton.superview;
    bgvv.frame = CGRectMake(0, 0, ScreenWidth, size.height*ScreenWidth/size.width);
    
    _contentTableView.tableHeaderView = bgvv;
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
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.tableViewHelper stopAudio];
}
-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
        
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
