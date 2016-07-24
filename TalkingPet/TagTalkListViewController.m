//
//  TagTalkListViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14-8-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "TagTalkListViewController.h"
#import "BrowserTableHelper.h"
#import "RootViewController.h"
#import "PublishServer.h"

@interface TagTalkListViewController ()<UIActionSheetDelegate>
{
    UIButton * currentButton;
    UIColor * currentColor;
}
@property (nonatomic, strong)UITableView * contentTableView;
@property (nonatomic, strong)UIView * sectionBtnView;
@property (nonatomic, strong)UIButton * commentNumBtn;
@property (nonatomic, strong)UIButton * favorNumBtn;

@property (nonatomic,strong) BrowserTableHelper * tableViewHelper;
@end

@implementation TagTalkListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.shouldRequestTagInfo = NO;
        self.shouldDismiss = NO;
        self.canShowPublishBtn = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildViewWithSkintype];
    self.displayModel = 0;
    [self setBackButtonWithTarget:@selector(backBtnDo:)];

    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    _contentTableView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_contentTableView];
    
//    [self setRightButtonWithName:@"发布" BackgroundImg:nil Target:@selector(publishNewPetaking)];
    self.sectionBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [self.sectionBtnView setBackgroundColor:[UIColor colorWithWhite:235/255.0f alpha:1]];
    self.commentNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    currentButton = _commentNumBtn;
    [self.commentNumBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
    [self.commentNumBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.commentNumBtn setFrame:CGRectMake(0, 0, ScreenWidth/2, 30)];
//    [self.commentNumBtn setBackgroundImage:[UIImage imageNamed:@"seleted_lift"] forState:UIControlStateNormal];
    [self.commentNumBtn setBackgroundColor:[UIColor colorWithWhite:235/255.0f alpha:1]];
    [self.commentNumBtn setTitle:@"精华" forState:UIControlStateNormal];
    [self.sectionBtnView addSubview:self.commentNumBtn];
    [self.commentNumBtn addTarget:self action:@selector(hotBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.commentNumBtn.adjustsImageWhenHighlighted = NO;
    

    self.favorNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favorNumBtn setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
    [self.favorNumBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.favorNumBtn setFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 30)];
//    [self.favorNumBtn setBackgroundImage:[UIImage imageNamed:@"unseleted_right"] forState:UIControlStateNormal];
    [self.favorNumBtn setBackgroundColor:[UIColor colorWithWhite:235/255.0f alpha:1]];
    [self.favorNumBtn setTitle:@"最新" forState:UIControlStateNormal];
    [self.sectionBtnView addSubview:self.favorNumBtn];
    [self.favorNumBtn addTarget:self action:@selector(newBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.favorNumBtn.adjustsImageWhenHighlighted = NO;
    
    self.selectedLine = [[UIView alloc] initWithFrame:CGRectMake(currentButton.center.x-50, 28, 100, 2)];
    [self.selectedLine setBackgroundColor:CommonGreenColor];
    [self.sectionBtnView addSubview:self.selectedLine];

    
    self.tableViewHelper = [[BrowserTableHelper alloc] initWithController:self Tableview:_contentTableView SectionView:nil];
    _contentTableView.delegate = self.tableViewHelper;
    _contentTableView.dataSource = self.tableViewHelper;
    self.tableViewHelper.tableViewType = TableViewTypeTagList;
 
    if (!self.shouldRequestTagInfo) {
        if (![self.tag.backGroundURL isEqualToString:@" "]&&self.tag.backGroundURL.length>2) {
            self.bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
            [self.bgV setBackgroundColor:[UIColor clearColor]];
            
//            [self.sectionBtnView setFrame:CGRectMake(0, self.bgV.frame.size.height-30, ScreenWidth, 30)];
//            [self.bgV addSubview:self.sectionBtnView];
            self.dButton = [[EGOImageButton alloc] initWithPlaceholderImage:nil delegate:self];
            [self.dButton setFrame:CGRectMake(0, 0, ScreenWidth, 120)];
            self.dButton.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
            [self.bgV addSubview:self.dButton];
            [self.dButton setImageURL:[NSURL URLWithString:self.tag.backGroundURL]];
            [self.dButton addTarget:self action:@selector(clickedContentImageV:) forControlEvents:UIControlEventTouchUpInside];
             _contentTableView.tableHeaderView = self.bgV;
            
        }
        else
        {
            self.bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
            [self.bgV setBackgroundColor:[UIColor clearColor]];
            
//            [self.sectionBtnView setFrame:CGRectMake(0, self.bgV.frame.size.height-30, 320, 30)];
//            [self.bgV addSubview:self.sectionBtnView];
            _contentTableView.tableHeaderView = self.bgV;
        }
    }
    else
    {
        [self requestTagInfo];
    }
   
    // Do any additional setup after loading the view.
}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];
    currentColor = [UIColor colorWithRed:60/255.0 green:198/255.0 blue:255/255.0 alpha:1];
}
-(void)requestTagInfo
{
    NSMutableDictionary* dict = [NetServer commonDict];
    [dict setObject:@"tag" forKey:@"command"];
    [dict setObject:@"one" forKey:@"options"];
    [dict setObject:self.tag.tagID forKey:@"tagId"];
    [NetServer requestWithParameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"get a tag info success:%@",responseObject);
        NSDictionary * value = [responseObject objectForKey:@"value"];
        Tag * theT = [[Tag alloc] init];
        theT.tagName = [value objectForKey:@"name"];
        theT.tagID = [value objectForKey:@"id"];
        if ([value objectForKey:@"detailUrl"]) {
            theT.tagDetailUrl = [value objectForKey:@"detailUrl"];
        }
        if ([value objectForKey:@"bgUrl"]) {
            theT.backGroundURL = [value objectForKey:@"bgUrl"];
        }
        if ([[value objectForKey:@"deleted"] isEqualToString:@"false"]&&self.canShowPublishBtn) {
                [self setRightButtonWithName:@"发布" BackgroundImg:nil Target:@selector(publishNewPetaking)];
        }
        self.tag = theT;
        self.title = self.tag.tagName;
        if (![self.tag.backGroundURL isEqualToString:@" "]&&self.tag.backGroundURL.length>2) {
//            UIView * bgvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 125)];
//            [bgvv setBackgroundColor:[UIColor clearColor]];
            self.bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120+30)];
            [self.bgV setBackgroundColor:[UIColor clearColor]];
            
            if ([[value objectForKey:@"ctrl"] isEqualToString:@"11"]) {
                self.displayModel = 2;
                [self.sectionBtnView setFrame:CGRectMake(0, self.bgV.frame.size.height-30, ScreenWidth, 30)];
                [self.bgV addSubview:self.sectionBtnView];
                [self getHotPetalkList];
            }
            else if ([[value objectForKey:@"ctrl"] isEqualToString:@"01"]){
                self.displayModel = 0;
                [self getPetalkList];
            }
            else
            {
                self.displayModel = 1;
                [self getHotPetalkList];
            }
            
            self.dButton = [[EGOImageButton alloc] initWithPlaceholderImage:nil delegate:self];
            [self.dButton setFrame:CGRectMake(0, 0, ScreenWidth, 120)];
            self.dButton.backgroundColor = [UIColor lightGrayColor];
            [self.bgV addSubview:self.dButton];
            [self.dButton setImageURL:[NSURL URLWithString:self.tag.backGroundURL]];
            [self.dButton addTarget:self action:@selector(clickedContentImageV:) forControlEvents:UIControlEventTouchUpInside];
            
            _contentTableView.tableHeaderView = self.bgV;
        }
        else
        {
            
            if ([[value objectForKey:@"ctrl"] isEqualToString:@"11"]) {
                self.bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
                [self.bgV setBackgroundColor:[UIColor clearColor]];

                self.displayModel = 2;
                [self.sectionBtnView setFrame:CGRectMake(0, self.bgV.frame.size.height-30, ScreenWidth, 30)];
                [self.bgV addSubview:self.sectionBtnView];
                [self getHotPetalkList];
                _contentTableView.tableHeaderView = self.bgV;
            }
            else if ([[value objectForKey:@"ctrl"] isEqualToString:@"01"]){
                self.displayModel = 0;
                [self getPetalkList];
            }
            else
            {
                self.displayModel = 1;
                [self getHotPetalkList];
            }

            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)clickedContentImageV:(EGOImageButton *)sender
{
    if (self.tag.tagDetailUrl) {
        if (![self.tag.tagDetailUrl isEqualToString:@" "]&&self.tag.tagDetailUrl.length>2) {
            WebContentViewController * vb = [[WebContentViewController alloc] init];
            vb.urlStr =[self.tag.tagDetailUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            vb.title = self.tag.tagName;
            [self.navigationController pushViewController:vb animated:YES];
        }
    }
}
-(void)hotBtnClicked:(UIButton *)sender
{
    if ([currentButton isEqual:_favorNumBtn]) {
        [UIView animateWithDuration:0.2 animations:^{
                [self.selectedLine setFrame:CGRectMake(self.commentNumBtn.center.x-50, 28, 100, 2)];
        }];

        [self.commentNumBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
        [self.favorNumBtn setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
        [self getHotPetalkList];
        currentButton = _commentNumBtn;
        }
}
-(void)newBtnClicked:(UIButton *)sender
{
    if ([currentButton isEqual:_commentNumBtn]) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.selectedLine setFrame:CGRectMake(self.favorNumBtn.center.x-50, 28, 100, 2)];
        }];
        
        [self.favorNumBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
        [self.commentNumBtn setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
        [self getPetalkList];
        currentButton = _favorNumBtn;
        }
}
- (void)getHotPetalkList
{
    _tableViewHelper.cellNeedShowPublishTime = NO;
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"petalk" forKey:@"command"];
    [hotDic setObject:@"1" forKey:@"pageIndex"];
    [hotDic setObject:@"10" forKey:@"pageSize"];
    [hotDic setObject:@"tagList" forKey:@"options"];
    [hotDic setObject:self.tag.tagID forKey:@"tagId"];
    if ([UserServe sharedUserServe].userID) {
        [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    }
    [_tableViewHelper loadFirstDataPageWithDict:hotDic];
}
- (void)getPetalkList
{
    _tableViewHelper.cellNeedShowPublishTime = NO;
    NSMutableDictionary * listDic = [NetServer commonDict];
    [listDic setObject:@"petalk" forKey:@"command"];
    [listDic setObject:@"10" forKey:@"pageSize"];
    [listDic setObject:@"tagListTimeline" forKey:@"options"];
    [listDic setObject:self.tag.tagID forKey:@"tagId"];
    if ([UserServe sharedUserServe].userID) {
        [listDic setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    }
    [_tableViewHelper loadFirstDataPageWithDict:listDic];
}
- (void)imageButtonLoadedImage:(EGOImageButton *)imageButton
{
    CGSize size = imageButton.currentImage.size;
    imageButton.frame = CGRectMake(0, 0, ScreenWidth, size.height*ScreenWidth/size.width);
    UIView * bgvv = imageButton.superview;
    if (self.displayModel==2) {
        bgvv.frame = CGRectMake(0, 0, ScreenWidth, size.height*ScreenWidth/size.width+30);
        [self.sectionBtnView setFrame:CGRectMake(0, bgvv.frame.size.height-30, ScreenWidth, 30)];
    }
    else
        bgvv.frame = CGRectMake(0, 0, ScreenWidth, size.height*ScreenWidth/size.width);

    _contentTableView.tableHeaderView = bgvv;
}
-(void)publishNewPetaking
{
    if (![UserServe sharedUserServe].userName) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图片文字",@"图片语音",@"经验交流", nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [PublishServer publishStoryWithTag:self.tag completion:nil];
    }else if (buttonIndex == 1)
    {
        [PublishServer publishPetalkWithTag:self.tag completion:nil];
    }
    else if (buttonIndex == 2)
    {
        [PublishServer publishPictureWithTag:self.tag completion:nil];
    }
}
-(void)dealloc
{
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 35;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}
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
    if (self.shouldDismiss) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
