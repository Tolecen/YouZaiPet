//
//  PersonProfileViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-16.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "PersonProfileViewController.h"
#import "BrowseTalkingTableViewCell.h"
#import "BrowserForwardedTalkingTableViewCell.h"
#import "TalkingDetailPageViewController.h"
#import "BrowserTableHelper.h"
#import "UserListViewController.h"
#import "RootViewController.h"
#import "PetCategoryParser.h"
#import "TimelineBrowserHelper.h"

@interface PersonProfileViewController ()<UITableViewDataSource,UITableViewDelegate,TalkingTableViewCellDelegate,BrowserTableHelperDelegate,TimeLineBrowserTableHelperDelegate>
{
    UIImageView * bgV;
    
    NSInteger listType;//1原创,2转发
    UIButton * attentionB;
    UIButton * fansB;
    UIView * headerView;
    UIButton * currentB;
    UIImageView * zhishiIV;
    
    UIButton *publishB;
    UIButton *forwardB;
    
    UIImageView *publishIV;
    UIImageView *forwardIV;
    
    UILabel *publishL;
    UILabel *forwardL;
    
    UIImageView * upImgView;
    UIImageView * downImgView;
    
    UIImageView * genderIV;
    UIImageView * gradeIV;
    UILabel * breedAgeL;
    UILabel * gradeL;
    //    UILabel * ageL;
}
@property (nonatomic,retain)UILabel * nicknameL;
@property (nonatomic,retain)EGOImageButton * photoIV;
@property (nonatomic,retain)UITableView * tableView;
@property (nonatomic,strong) BrowserTableHelper * tableviewHelpeer;
@property (nonatomic,strong) TimelineBrowserHelper * tableviewTimeLineHelper;
@end

@implementation PersonProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"个人资料";
        self.hideNaviBg = YES;
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableviewHelpeer stopAudio];
    [self showNaviBg];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的";
//    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    // Do any additional setup after loading the view.
    
    
    
    
    listType = 1;
    self.tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = ({
        UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*673/750)];
        view.backgroundColor = [UIColor clearColor];
        
        bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*673/750)];
        [bgV setImage:[UIImage imageNamed:@"usercenter_topBg"]];
        [view addSubview:bgV];
        
        self.photoIV = [[EGOImageButton alloc] initWithFrame:CGRectMake(view.center.x-37, 3+navigationBarHeight, 74, 74)];
        _photoIV.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
        _photoIV.layer.masksToBounds=YES;
        _photoIV.layer.cornerRadius = 37;
        [view addSubview:_photoIV];
        
        self.darenV = [[UIImageView alloc] initWithFrame:CGRectMake(view.center.x-37+74-20, 3+74+navigationBarHeight, 20, 20)];
        [self.darenV setImage:[UIImage imageNamed:@"daren"]];
        [view addSubview:self.darenV];
        self.darenV.hidden =YES;
        
        
        self.nicknameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 80+navigationBarHeight, 300, 20)];
        _nicknameL.center = CGPointMake(_photoIV.center.x, _nicknameL.center.y);
        _nicknameL.backgroundColor = [UIColor clearColor];
        _nicknameL.font = [UIFont systemFontOfSize:15];
        _nicknameL.textAlignment = NSTextAlignmentCenter;
        _nicknameL.textColor = [UIColor whiteColor];
        [view addSubview:_nicknameL];
        
        genderIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_photoIV.frame)-20, CGRectGetMaxY(_photoIV.frame)-20, 20, 20)];
        [view addSubview:genderIV];
        
        breedAgeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 103+navigationBarHeight, ScreenWidth, 20)];
        breedAgeL.backgroundColor = [UIColor clearColor];
        breedAgeL.textColor = [UIColor whiteColor];
        breedAgeL.font = [UIFont systemFontOfSize:14];
        breedAgeL.textAlignment = NSTextAlignmentCenter;
        [view addSubview:breedAgeL];
        
        gradeIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [view addSubview:gradeIV];
        
        gradeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        gradeL.backgroundColor = [UIColor clearColor];
        gradeL.textColor = [UIColor whiteColor];
        gradeL.font = [UIFont systemFontOfSize:14];
        [view addSubview:gradeL];
        
        attentionB = [UIButton buttonWithType:UIButtonTypeCustom];
        [attentionB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        attentionB.titleLabel.font = [UIFont systemFontOfSize:16];
        [attentionB addTarget:self action:@selector(puthAttentionViewCntroller) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:attentionB];
        [attentionB setTitleShadowColor:[UIColor colorWithWhite:0.3 alpha:0.6] forState:UIControlStateNormal];
        attentionB.titleLabel.shadowOffset = CGSizeMake(1, 1);
        
        fansB = [UIButton buttonWithType:UIButtonTypeCustom];
        [fansB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        fansB.titleLabel.font = [UIFont systemFontOfSize:16];
        [fansB addTarget:self action:@selector(puthFansViewCntroller) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:fansB];
        [fansB setTitleShadowColor:[UIColor colorWithWhite:0.3 alpha:0.6] forState:UIControlStateNormal];
        fansB.titleLabel.shadowOffset = CGSizeMake(1, 1);
        
        UILabel * lineL = [[UILabel alloc] initWithFrame:CGRectMake(view.center.x-10, 133+navigationBarHeight, 20, 10)];
        [lineL setText:@"|"];
        [lineL setTextColor:[UIColor whiteColor]];
        [lineL setBackgroundColor:[UIColor clearColor]];
        [lineL setTextAlignment:NSTextAlignmentCenter];
        [lineL setFont:[UIFont systemFontOfSize:20]];
        lineL.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        lineL.shadowOffset = CGSizeMake(1, 1);
        [view addSubview:lineL];
        
        relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        relationBtn.frame = CGRectMake(view.center.x-10-65, 152+navigationBarHeight, 65, 25);
        relationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [relationBtn addTarget:self action:@selector(relationAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:relationBtn];
        
        UIButton * chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chatBtn.frame = CGRectMake(view.center.x+10, 152+navigationBarHeight, 65, 25);
        chatBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [chatBtn addTarget:self action:@selector(chatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [chatBtn setBackgroundImage:[UIImage imageNamed:@"usercenter_chat"] forState:UIControlStateNormal];
        [view addSubview:chatBtn];
        if ([UserServe sharedUserServe].account) {
            if ([[UserServe sharedUserServe].userID isEqualToString:self.petId]) {
                chatBtn.hidden = YES;
            }
        }
        UIView * bView = [[UIView alloc] initWithFrame:CGRectMake(0,  view.frame.size.height-30, view.frame.size.width, 30)];
        bView.backgroundColor = [UIColor colorWithWhite:228/255.0 alpha:0.36];
        [view addSubview:bView];
        publishB = [UIButton buttonWithType:UIButtonTypeCustom];
        publishB.backgroundColor = [UIColor clearColor];
        [publishB setFrame:CGRectMake(view.center.x-120, view.frame.size.height-30, 120, 30)];
        publishB.tag = 1;
        [view addSubview:publishB];
        currentB = publishB;
        publishL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        publishL.backgroundColor = [UIColor clearColor];
        publishL.textAlignment = NSTextAlignmentCenter;
        publishL.font = [UIFont boldSystemFontOfSize:15];
        publishL.textColor = [UIColor whiteColor];
        [publishB addSubview:publishL];
        [publishB addTarget:self action:@selector(selectorAction:) forControlEvents:UIControlEventTouchUpInside];
        publishB.showsTouchWhenHighlighted = YES;
        
        
        forwardB = [UIButton buttonWithType:UIButtonTypeCustom];
        forwardB.backgroundColor = [UIColor clearColor];
        [forwardB setFrame:CGRectMake(view.center.x, view.frame.size.height-30, 120, 30)];
        [view addSubview:forwardB];
        forwardB.tag = 2;
        forwardL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,120, 30)];
        forwardL.backgroundColor = [UIColor clearColor];
        forwardL.textAlignment = NSTextAlignmentCenter;
        forwardL.font = [UIFont boldSystemFontOfSize:15];
        forwardL.textColor = [UIColor whiteColor];
        [forwardB addSubview:forwardL];
        [forwardB addTarget:self action:@selector(selectorAction:) forControlEvents:UIControlEventTouchUpInside];
        forwardB.showsTouchWhenHighlighted = YES;
        
        zhishiIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-2, view.frame.size.width/2, 2)];
        zhishiIV.backgroundColor = [UIColor colorWithRed:133/255.0 green:203/255.0 blue:252/255.0 alpha:1];
        zhishiIV.center = CGPointMake(currentB.center.x, zhishiIV.center.y);
        [view addSubview:zhishiIV];
        
        view;
    });
    self.tableviewHelpeer = [[BrowserTableHelper alloc] initWithController:self Tableview:self.tableView SectionView:headerView];
    self.tableviewHelpeer.delegate = self;
    self.tableviewHelpeer.needShowZanAndComment = NO;
    
    
    
    self.tableviewTimeLineHelper = [[TimelineBrowserHelper alloc] initWithController:self tableview:self.tableView withHead:NO header:nil];
    self.tableviewTimeLineHelper.delegate = self;
    _tableView.delegate = self.tableviewTimeLineHelper;
    _tableView.dataSource = self.tableviewTimeLineHelper;
    
    [self getOriginShuoShuo];
    [self getUserInfoById];
    
    [self buildViewWithSkintype];
     
     
}
-(void)chatBtnAction:(UIButton *)sender
{
    if (![UserServe sharedUserServe].userID) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
    ChatDetailViewController * chatDV = [[ChatDetailViewController alloc] init];
    Pet * theP = [[Pet alloc] init];
    theP.petID = self.petId;
    theP.nickname = self.petNickname;
    theP.headImgURL = self.petAvatarUrlStr;
    chatDV.thePet = theP;
    chatDV.title =self.petNickname;
    [self.navigationController pushViewController:chatDV animated:YES];
}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];
    zhishiIV.image = [UIImage imageNamed:@"zhishi"];
    publishIV.image = [UIImage imageNamed:@"UCpublish"];
    forwardIV.image = [UIImage imageNamed:@"UCforward"];
}
- (void)relationAction:(UIButton *)button
{
    if (![UserServe sharedUserServe].userID) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
    button.enabled = NO;
    if ([self.relationShip isEqualToString:@"0"]) {
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"petfans" forKey:@"command"];
        [mDict setObject:@"focus" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].userID forKey:@"fansPetId"];
        [mDict setObject:self.petId forKey:@"petId"];
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[[responseObject objectForKey:@"value"] objectForKey:@"bothway"] isEqualToString:@"false"]) {
                self.relationShip = @"1";
                [relationBtn setBackgroundImage:[UIImage imageNamed:@"usercenter_relation1"] forState:UIControlStateNormal];
                //                [button setTitle:@"已关注" forState:UIControlStateNormal];
            }
            else{
                self.relationShip = @"2";
                //                [button setTitle:@"互相关注" forState:UIControlStateNormal];
                [relationBtn setBackgroundImage:[UIImage imageNamed:@"usercenter_relation2"] forState:UIControlStateNormal];
            }
            if ([responseObject objectForKey:@"message"]) {
                [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
            }
            //            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.enabled = YES;
            if (_delegate&& [_delegate respondsToSelector:@selector(attentionPetWithPetId:AndRelationship:)]) {
                
                [self.delegate attentionPetWithPetId:self.petId AndRelationship:self.relationShip];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            button.enabled = YES;
        }];
    }
    else
    {
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"petfans" forKey:@"command"];
        [mDict setObject:@"cancelFocus" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].userID forKey:@"fansPetId"];
        [mDict setObject:self.petId forKey:@"petId"];
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.relationShip = @"0";
            //            [button setBackgroundImage:[UIImage imageNamed:@"addAttention"] forState:UIControlStateNormal];
            [relationBtn setBackgroundImage:[UIImage imageNamed:@"usercenter_relation0"] forState:UIControlStateNormal];
            //            [button setTitle:@"+关注" forState:UIControlStateNormal];
            button.enabled = YES;
            if (_delegate&& [_delegate respondsToSelector:@selector(attentionPetWithPetId:AndRelationship:)]) {
                
                [self.delegate attentionPetWithPetId:self.petId AndRelationship:self.relationShip];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            button.enabled = YES;
        }];
    }
}
-(void)getUserInfoById
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"pet" forKey:@"command"];
    [mDict setObject:@"one" forKey:@"options"];
    [mDict setObject:self.petId forKey:@"petId"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"currPetId"];
    
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self.petId isEqualToString:@"44239"]) {
            relationBtn.enabled = NO;
        }
        [self.photoIV setImageURL:[NSURL URLWithString:[[responseObject objectForKey:@"value"] objectForKey:@"headPortrait"]]];
        self.darenV.hidden = [[[responseObject objectForKey:@"value"] objectForKey:@"star"] isEqualToString:@"1"]?NO:YES;
        self.nicknameL.text = [[responseObject objectForKey:@"value"] objectForKey:@"nickName"];
        self.title = @"";
        self.petNickname = [[responseObject objectForKey:@"value"] objectForKey:@"nickName"];
        CGSize k = [self.petNickname sizeWithFont:self.nicknameL.font constrainedToSize:CGSizeMake(ScreenWidth-40, self.nicknameL.frame.size.height)];
        [self.darenV setFrame:CGRectMake(ScreenWidth/2-k.width/2-25, self.nicknameL.frame.origin.y, 20, 20)];
        self.petAvatarUrlStr = [[responseObject objectForKey:@"value"] objectForKey:@"headPortrait"];
        switch ([[[responseObject objectForKey:@"value"] objectForKey:@"gender"] intValue]) {
            case 0:{
                genderIV.image = [UIImage imageNamed:@"female_border"];
            }break;
            case 1:{
                genderIV.image = [UIImage imageNamed:@"male_border"];
            }break;
            default:
                break;
        }
        PetCategoryParser * pet = [[PetCategoryParser alloc] init];
        int lv = [[[[responseObject objectForKey:@"value"] objectForKey:@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""] integerValue];
        if(lv>0)
        {
            breedAgeL.text = [NSString stringWithFormat:@"%@, %@, ",[pet breedWithIDcode:[[[responseObject objectForKey:@"value"] objectForKey:@"type"] integerValue]],[Common calAgeWithBirthDate:[[responseObject objectForKey:@"value"] objectForKey:@"birthday"]]];
            
            CGSize hZ = [breedAgeL.text sizeWithFont:breedAgeL.font constrainedToSize:CGSizeMake(ScreenWidth-100, breedAgeL.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
            //            gradeIV.frame = CGRectMake(breedAgeL.frame.origin.x+hZ.width, breedAgeL.frame.origin.y, 15, 15);
            gradeIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"LV%d.png",lv]];
            gradeIV.hidden = NO;
            gradeL.hidden = NO;
            //            gradeL.frame = CGRectMake(breedAgeL.frame.origin.x+hZ.width+15+10, breedAgeL.frame.origin.y, 60, 20);
            gradeL.text = [NSString stringWithFormat:@"LV.%d",lv];
            CGSize hZ2 = [gradeL.text sizeWithFont:gradeL.font constrainedToSize:CGSizeMake(ScreenWidth-100, 20) lineBreakMode:NSLineBreakByCharWrapping];
            
            int o = (self.view.frame.size.width - (hZ.width+18+5+hZ2.width))/2;
            breedAgeL.frame = CGRectMake(o, breedAgeL.frame.origin.y, hZ.width, breedAgeL.frame.size.height);
            gradeIV.frame = CGRectMake(o+hZ.width, breedAgeL.frame.origin.y+2, 18, 18);
            gradeL.frame = CGRectMake(o+hZ.width+18+5, breedAgeL.frame.origin.y, hZ2.width, 20);
            
        }
        else
        {
            breedAgeL.text = [[pet breedWithIDcode:[[[responseObject objectForKey:@"value"] objectForKey:@"type"] integerValue]] stringByAppendingString:[NSString stringWithFormat:@", %@",[Common calAgeWithBirthDate:[[responseObject objectForKey:@"value"] objectForKey:@"birthday"]]]];
            gradeIV.hidden = YES;
            gradeL.hidden = YES;
            breedAgeL.frame = CGRectMake(0, breedAgeL.frame.origin.y, ScreenWidth, breedAgeL.frame.size.height);
        }
        
        
        [attentionB setTitle:[NSString stringWithFormat:@"关注:%@",[[[responseObject objectForKey:@"value"] objectForKey:@"counter"] objectForKey:@"focus"]] forState:UIControlStateNormal];
        [fansB setTitle:[NSString stringWithFormat:@"粉丝:%@",[[[responseObject objectForKey:@"value"] objectForKey:@"counter"] objectForKey:@"fans"]] forState:UIControlStateNormal];
        CGSize attentionSize = [attentionB.titleLabel.text sizeWithFont:attentionB.titleLabel.font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        CGSize fansSize = [fansB.titleLabel.text sizeWithFont:fansB.titleLabel.font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        UIView * view = attentionB.superview;
        attentionB.frame = CGRectMake(view.center.x - attentionSize.width-30, 127+navigationBarHeight, attentionSize.width+20, 20);
        fansB.frame = CGRectMake(view.center.x + 10, 127+navigationBarHeight, fansSize.width+20, 20);
        
        publishL.text = [NSString stringWithFormat:@"说说(%@)",[[[responseObject objectForKey:@"value"] objectForKey:@"counter"] objectForKey:@"issue"]] ;
        forwardL.text = [NSString stringWithFormat:@"转发(%@)",[[[responseObject objectForKey:@"value"] objectForKey:@"counter"] objectForKey:@"relay"]];
        
        self.relationShip = [[responseObject objectForKey:@"value"] objectForKey:@"rs"];
        
        if ([self.relationShip isEqualToString:@"0"]) {
            [relationBtn setBackgroundImage:[UIImage imageNamed:@"usercenter_relation0"] forState:UIControlStateNormal];
        }
        else if ([self.relationShip isEqualToString:@"1"]){
            [relationBtn setBackgroundImage:[UIImage imageNamed:@"usercenter_relation1"] forState:UIControlStateNormal];
        }
        else if ([self.relationShip isEqualToString:@"2"]){
            [relationBtn setBackgroundImage:[UIImage imageNamed:@"usercenter_relation2"] forState:UIControlStateNormal];
        }
        else
        {
            relationBtn.hidden = YES;
        }
        
        
        [self.tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getAllCommentsAndForward error:%@",error);
        [self.tableView headerEndRefreshing];
    }];
}
-(void)refreshTableDo
{
    [self getUserInfoById];
    if (listType==1) {
        [self getOriginShuoShuo];
    }
    else if (listType==2){
        [self getForwardedShuoShuo];
    }
}
- (void)puthAttentionViewCntroller
{
    UserListViewController * attentionV = [[UserListViewController alloc] init];
    attentionV.listType = UserListTypeAttention;
    attentionV.petID = self.petId;
    [self.navigationController pushViewController:attentionV animated:YES];
}
- (void)puthFansViewCntroller
{
    UserListViewController * fansV = [[UserListViewController alloc] init];
    fansV.listType = UserListTypeFans;
    fansV.petID = self.petId;
    [self.navigationController pushViewController:fansV animated:YES];
}
-(void)getForwardedShuoShuo
{
    self.tableviewTimeLineHelper.iamActive = NO;
    self.tableviewHelpeer.iamActive = YES;
    self.tableView.delegate = self.tableviewHelpeer;
    self.tableView.dataSource = self.tableviewHelpeer;
    [self.tableView reloadData];

    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"userList" forKey:@"options"];
    [mDict setObject:self.petId forKey:@"petId"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:@"R" forKey:@"type"];
    if ([UserServe sharedUserServe].userID) {
        [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    }
    [self.tableviewHelpeer loadFirstDataPageWithDict:mDict];
}
-(void)getOriginShuoShuo
{
    [self.tableviewHelpeer stopAudio];
    self.tableviewTimeLineHelper.iamActive = YES;
    self.tableviewHelpeer.iamActive = NO;
    self.tableView.delegate = self.tableviewTimeLineHelper;
    self.tableView.dataSource = self.tableviewTimeLineHelper;
    [self.tableView reloadData];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"userList" forKey:@"options"];
    [mDict setObject:self.petId forKey:@"petId"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:@"O" forKey:@"type"];
    if ([UserServe sharedUserServe].userID) {
        [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    }
    [self.tableviewTimeLineHelper loadFirstDataPageWithDict:mDict];
}

-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)scrollit
//{
//    CGFloat scale = 1;
//    if (_tableView.contentOffset.y<0) {
//        scale = (bgV.frame.size.height/2-_tableView.contentOffset.y)/bgV.frame.size.height*2;
//    }
//    bgV.transform = CGAffineTransformMakeScale(scale, scale);
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (listType == 1) {
        static NSString *cellIdentifier = @"talkingCell";
        BrowseTalkingTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[BrowseTalkingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.publisherAvatarV.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
        cell.publisherAvatarV.imageURL = [NSURL URLWithString:@"http://www.qqcan.com/uploads/allimg/c120811/1344A300Z50-3T615.jpg"];
        return cell;
    }else
    {
        static NSString *cellIdentifier = @"forwardedCell";
        BrowserForwardedTalkingTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[BrowserForwardedTalkingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.publisherAvatarV.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
        cell.publisherAvatarV.imageURL = [NSURL URLWithString:@"http://99touxiang.com/public/upload/gexing/5/16-063616_452.jpg"];
        
        cell.forwardedAvatarV.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
        cell.forwardedAvatarV.imageURL = [NSURL URLWithString:@"http://img1.3lian.com/gif/more/11/201212/987fc26a2e0ad90607c999d6e2bec40b.jpg"];
        [cell refreshCell];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (listType == 1) {
        return 510;
    }else
    {
        return 580;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    [self.navigationController pushViewController:talkingDV animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (void)selectorAction:(UIButton *)button
{
    if (![currentB isEqual:button]) {
        [button setTitleColor:[UIColor colorWithRed:0/255.0 green:153/255.0 blue:204/255.0 alpha:1] forState:UIControlStateNormal];
        [currentB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        currentB = button;
        [UIView animateWithDuration:0.3 animations:^{
            zhishiIV.center = CGPointMake(currentB.center.x, zhishiIV.center.y);
        }];
        listType = button.tag;
        //        [_tableView reloadData];
        //        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    if (button.tag==1) {
        [self getOriginShuoShuo];
    }
    else if (button.tag==2){
        [self getForwardedShuoShuo];
    }
    
}
- (void)forwardWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    talkingDV.commentStyle = commentStyleForward;
    [self.navigationController pushViewController:talkingDV animated:YES];
}
- (void)commentWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    talkingDV.commentStyle = commentStyleComment;
    [self.navigationController pushViewController:talkingDV animated:YES];
}
- (void)zanWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    
}
- (void)shareWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    
}
- (void)attentionPetWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    
}
- (void)petProfileWhoPublishTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    [self.navigationController pushViewController:pv animated:YES];
}
- (void)petProfileWhoForwardTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    [self.navigationController pushViewController:pv animated:YES];
}
- (void)locationWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    
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
