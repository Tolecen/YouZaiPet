//
//  SectionMSgViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14/10/23.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "SectionMSgViewController.h"
#import "RootViewController.h"
@interface SectionMSgViewController ()

@end

@implementation SectionMSgViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"消息";
        needNotiNormalChat = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(back)];
//    self.headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2-22, 130)];
//    [self.headerV setBackgroundColor:[UIColor clearColor]];
    
    
//    UIImageView * photoView  = [[UIImageView alloc] initWithFrame:CGRectMake((self.headerV.frame.size.width-90.5)/2, 0, 90.5, 124.5)];
//    [photoView setImage:[UIImage imageNamed:@"msgMenu_header"]];
//    [self.headerV addSubview:photoView];
//    
    self.msgTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight) style:UITableViewStylePlain];
    _msgTableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.msgTableV.delegate = self;
    self.msgTableV.dataSource = self;
    self.msgTableV.scrollsToTop = YES;
//    self.msgTableV.tableHeaderView = self.headerV;
    self.msgTableV.backgroundColor = [UIColor whiteColor];
    self.msgTableV.backgroundView = nil;
    self.msgTableV.rowHeight = 50;
    self.msgTableV.sectionFooterHeight = 5;
    self.msgTableV.sectionHeaderHeight = 0;
    self.msgTableV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.msgTableV];
    
//    navigationControllerd = (UINavigationController *)[RootViewController sharedRootViewController].sideMenu.contentViewController;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SectionmsgNotiReceived) name:@"SectionmsgNotiReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalChatMsgReceived:) name:@"NormalChatMsgReceived" object:nil];
    
    [self requestAll];
    // Do any additional setup after loading the view.
}
-(void)normalChatMsgReceived:(NSNotification *)noti
{
//    if (needNotiNormalChat) {
        normalChat_count++;
        [self.msgTableV reloadData];
//    }

}
-(void)SectionmsgNotiReceived
{
    [self requestAll];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    needNotiNormalChat = YES;
    [self.msgTableV reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self requestAll];
//    dispatch_queue_t queue = dispatch_queue_create("com.pet.getCheckUnreadNumOfNormalChat", NULL);
//    dispatch_async(queue, ^{
        normalChat_count = [DatabaseServe getAllUnreadNormalChatCount];
//        NSLog(@"normalCountChatGeted:%d",normalChat_count);
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.msgTableV reloadData];
//
//        });
//        
//    });

//    [self performSelector:@selector(requestAll) withObject:nil afterDelay:0.2];
}
-(void)requestAll
{
//    [self requestCommentAndForwardNum];
//    [self requestCaiNum];
//    [self requestGuanzhuNum];
//    [self requestSystemNotiNum];
    
    [self requestAllNum];
}
-(void)requestAllNum
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"message" forKey:@"command"];
    [mDict setObject:@"UMCG" forKey:@"options"];
//    [mDict setObject:@"C_R" forKey:@"type"];
    NSString * petId = [UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"";
    [mDict setObject:petId forKey:@"userId"];
    if ([petId isEqualToString:@""]) {
        return;
    }
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"ALL num back:%@",responseObject);
        NSString * c_R_countStr = [[responseObject objectForKey:@"value"] objectForKey:@"C_R"];
        NSString * f_countStr = [[responseObject objectForKey:@"value"] objectForKey:@"F"];
        NSString * fans_countStr = [[responseObject objectForKey:@"value"] objectForKey:@"fans"];
        
        
        c_r_count = [c_R_countStr intValue];
        NSString * haveCountC_R = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"haveCountC_R%@",[UserServe sharedUserServe].userID]];
        if (haveCountC_R) {
            int cha = [c_R_countStr intValue]-[haveCountC_R intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cha] forKey:[NSString stringWithFormat:@"needMetionCountC_R%@",[UserServe sharedUserServe].userID]];
            //            if (cha>0) {
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
            //                //                success(operation,responseObject);
            //            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"needMetionCountC_R%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] setObject:c_R_countStr forKey:[NSString stringWithFormat:@"haveCountC_R%@",[UserServe sharedUserServe].userID]];
        }
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        if (([navigationControllerd.viewControllers  isEqual: @[self]])) {
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].userID]];
//            
////            [[NSUserDefaults standardUserDefaults] synchronize];
//            
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
//        }

        
        
        
        f_count = [f_countStr intValue];
        NSString * haveCountF = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"haveCountF%@",[UserServe sharedUserServe].userID]];
        if (haveCountF) {
            int cha = [f_countStr intValue]-[haveCountF intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cha] forKey:[NSString stringWithFormat:@"needMetionCountF%@",[UserServe sharedUserServe].userID]];
            //            if (cha>0) {
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
            //                //                success(operation,responseObject);
            //            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"needMetionCountF%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] setObject:f_countStr forKey:[NSString stringWithFormat:@"haveCountF%@",[UserServe sharedUserServe].userID]];
        }
        
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        if (([navigationControllerd.viewControllers  isEqual: @[self]])) {
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].userID]];
//            
////            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
//        }
        
        
        fans_count = [fans_countStr intValue];
        NSString * haveCountFans = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"haveCountFans%@",[UserServe sharedUserServe].userID]];
        if (haveCountFans) {
            int cha = [fans_countStr intValue]-[haveCountFans intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cha] forKey:[NSString stringWithFormat:@"needMetionCountFans%@",[UserServe sharedUserServe].userID]];
            //            if (cha>0) {
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
            //                //                success(operation,responseObject);
            //            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"needMetionCountFans%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] setObject:fans_countStr forKey:[NSString stringWithFormat:@"haveCountFans%@",[UserServe sharedUserServe].userID]];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        if (([navigationControllerd.viewControllers  isEqual: @[self]])) {
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].userID]];
//            
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
//        }


        [self.msgTableV reloadData];
        [self requestSystemNotiNum];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestSystemNotiNum];
    }];
    

}
/*
-(void)requestCommentAndForwardNum
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"message" forKey:@"command"];
    [mDict setObject:@"UMC" forKey:@"options"];
    [mDict setObject:@"C_R" forKey:@"type"];
    NSString * petId = [UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"";
    [mDict setObject:petId forKey:@"petId"];
    if ([petId isEqualToString:@""]) {
        return;
    }
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"C_R num back:%@",responseObject);
        NSString * allCount = [responseObject objectForKey:@"value"];
        c_r_count = [allCount intValue];
        NSString * haveCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"haveCountC_R%@",[UserServe sharedUserServe].userID]];
        if (haveCount) {
            int cha = [allCount intValue]-[haveCount intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cha] forKey:[NSString stringWithFormat:@"needMetionCountC_R%@",[UserServe sharedUserServe].userID]];
//            if (cha>0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
//                //                success(operation,responseObject);
//            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"needMetionCountC_R%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] setObject:allCount forKey:[NSString stringWithFormat:@"haveCountC_R%@",[UserServe sharedUserServe].userID]];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (([navigationControllerd.viewControllers  isEqual: @[self]])) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].userID]];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
        }

        
        [self.msgTableV reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
-(void)requestCaiNum
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"message" forKey:@"command"];
    [mDict setObject:@"UMC" forKey:@"options"];
    [mDict setObject:@"F" forKey:@"type"];
    NSString * petId = [UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"";
    [mDict setObject:petId forKey:@"petId"];
    if ([petId isEqualToString:@""]) {
        return;
    }
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * allCount = [responseObject objectForKey:@"value"];
        f_count = [allCount intValue];
        NSString * haveCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"haveCountF%@",[UserServe sharedUserServe].userID]];
        if (haveCount) {
            int cha = [allCount intValue]-[haveCount intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cha] forKey:[NSString stringWithFormat:@"needMetionCountF%@",[UserServe sharedUserServe].userID]];
            //            if (cha>0) {
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
            //                //                success(operation,responseObject);
            //            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"needMetionCountF%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] setObject:allCount forKey:[NSString stringWithFormat:@"haveCountF%@",[UserServe sharedUserServe].userID]];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (([navigationControllerd.viewControllers  isEqual: @[self]])) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].userID]];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
        }
        
        [self.msgTableV reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)requestGuanzhuNum
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"message" forKey:@"command"];
    [mDict setObject:@"UMC" forKey:@"options"];
    [mDict setObject:@"fans" forKey:@"type"];
    NSString * petId = [UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"";
    [mDict setObject:petId forKey:@"petId"];
    if ([petId isEqualToString:@""]) {
        return;
    }
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * allCount = [responseObject objectForKey:@"value"];
        fans_count = [allCount intValue];
        NSString * haveCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"haveCountFans%@",[UserServe sharedUserServe].userID]];
        if (haveCount) {
            int cha = [allCount intValue]-[haveCount intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cha] forKey:[NSString stringWithFormat:@"needMetionCountFans%@",[UserServe sharedUserServe].userID]];
            //            if (cha>0) {
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
            //                //                success(operation,responseObject);
            //            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"needMetionCountFans%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] setObject:allCount forKey:[NSString stringWithFormat:@"haveCountFans%@",[UserServe sharedUserServe].userID]];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (([navigationControllerd.viewControllers  isEqual: @[self]])) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].userID]];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
        }
        [self.msgTableV reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
*/
-(void)requestSystemNotiNum
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"announcement" forKey:@"command"];
    [mDict setObject:@"count" forKey:@"options"];
//    [mDict setObject:@"sys" forKey:@"type"];
//    NSString * petId = [UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"";
//    [mDict setObject:petId forKey:@"petId"];
//    if ([petId isEqualToString:@""]) {
//        return;
//    }
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * allCount = [responseObject objectForKey:@"value"];
        sys_count = [allCount intValue];
        NSString * haveCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"haveCountSys%@",[UserServe sharedUserServe].userID]];
        if (haveCount) {
            int cha = [allCount intValue]-[haveCount intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cha] forKey:[NSString stringWithFormat:@"needMetionCountSys%@",[UserServe sharedUserServe].userID]];
            //            if (cha>0) {
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
            //                //                success(operation,responseObject);
            //            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"needMetionCountSys%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] setObject:allCount forKey:[NSString stringWithFormat:@"haveCountSys%@",[UserServe sharedUserServe].userID]];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        if (([navigationControllerd.viewControllers  isEqual: @[self]])) {
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].userID]];
//            
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
//        }
        
        [self.msgTableV reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.msgTableV reloadData];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else if (section==1){
        return 2;
    }
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"sectionCell";
    ITTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[ITTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        for (UIView * view in cell.subviews) {
            view.backgroundColor = [UIColor clearColor];
        }
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==1) {
        if (indexPath.row==1) {
            cell.desLabel.text = @"评论和转发";
            NSString * haveCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCountC_R%@",[UserServe sharedUserServe].userID]];
            if (haveCount) {
                [cell setUnreadNum:haveCount];
            }
            else
            {
                [cell setUnreadNum:@"0"];
            }
            [cell.imageV setImage:[UIImage imageNamed:@"msgC"]];
        }
        else
        {
            cell.desLabel.text = @"喜欢";
            NSString * haveCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCountF%@",[UserServe sharedUserServe].userID]];
            if (haveCount) {
                [cell setUnreadNum:haveCount];
            }
            else
            {
                [cell setUnreadNum:@"0"];
            }
            [cell.imageV setImage:[UIImage imageNamed:@"msgF"]];
        }
    }
    else if (indexPath.section==0){
        cell.desLabel.text = @"新粉丝";
        NSString * haveCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCountFans%@",[UserServe sharedUserServe].userID]];
        if (haveCount) {
            [cell setUnreadNum:haveCount];
        }
        else
        {
            [cell setUnreadNum:@"0"];
        }
        [cell.imageV setImage:[UIImage imageNamed:@"msgA"]];
    }
//    else if(indexPath.section==2)
//    {
//        cell.desLabel.text = @"私信";
////        NSString * haveCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCountChat%@",[UserServe sharedUserServe].userID]];
//        NSLog(@"normalCountChat:%d",normalChat_count);
//        if (normalChat_count>0) {
//            [cell setUnreadNum:[NSString stringWithFormat:@"%d",normalChat_count]];
//        }
//        else
//        {
//            [cell setUnreadNum:@"0"];
//        }
//        [cell.imageV setImage:[UIImage imageNamed:@"msgChat"]];
//    }
    else
    {
        cell.desLabel.text = @"通知";
        NSString * haveCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCountSys%@",[UserServe sharedUserServe].userID]];
        if (haveCount) {
            [cell setUnreadNum:haveCount];
        }
        else
        {
            [cell setUnreadNum:@"0"];
        }
        [cell.imageV setImage:[UIImage imageNamed:@"msgP"]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = [RootViewController sharedRootViewController].topVC.currentC;
    MessageViewController * msgV = [[MessageViewController alloc] init];
    if (indexPath.section==1) {
        if (![UserServe sharedUserServe].userName) {
            [[RootViewController sharedRootViewController] showLoginViewController];
            [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
            return;
        }
        if (indexPath.row==1) {
            msgV.title = @"评论和转发";
            msgV.msgType = MsgTypeC_R;
            NSString * unreadCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCountC_R%@",[UserServe sharedUserServe].userID]];
            if ([unreadCount intValue]>0) {
//                [RootViewController sharedRootViewController].msgVC.needRefreshMsg = YES;
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCountC_R%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",c_r_count] forKey:[NSString stringWithFormat:@"haveCountC_R%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            msgV.title = @"喜欢";
            msgV.msgType = MsgTypeF;
            NSString * unreadCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCountF%@",[UserServe sharedUserServe].userID]];
            if ([unreadCount intValue]>0) {
                //                [RootViewController sharedRootViewController].msgVC.needRefreshMsg = YES;
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCountF%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",f_count] forKey:[NSString stringWithFormat:@"haveCountF%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else if (indexPath.section==0){
        if (![UserServe sharedUserServe].userName) {
            [[RootViewController sharedRootViewController] showLoginViewController];
            [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
            return;
        }
        msgV.title = @"粉丝";
        msgV.msgType = MsgTypeFans;
        NSString * unreadCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCountFans%@",[UserServe sharedUserServe].userID]];
        if ([unreadCount intValue]>0) {
            //                [RootViewController sharedRootViewController].msgVC.needRefreshMsg = YES;
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCountFans%@",[UserServe sharedUserServe].userID]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",fans_count] forKey:[NSString stringWithFormat:@"haveCountFans%@",[UserServe sharedUserServe].userID]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    else if (indexPath.section==2){
//        if (![UserServe sharedUserServe].userName) {
//            [[RootViewController sharedRootViewController] showLoginViewController];
//            [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
//            return;
//        }
//        ChatViewController * chatV = [[ChatViewController alloc] init];
//        chatV.title = @"私信";
////        normalChat_count = 0;
////        needNotiNormalChat = NO;
////        [self.msgTableV reloadData];
//        [navigationController pushViewController:chatV animated:YES];
//        [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
//        return;
//    }
    else{
        msgV.title = @"通知";
        
        msgV.msgType = MsgTypeSys;
        NSString * unreadCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCountSys%@",[UserServe sharedUserServe].userID]];
        if ([unreadCount intValue]>0) {
            //                [RootViewController sharedRootViewController].msgVC.needRefreshMsg = YES;
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCountSys%@",[UserServe sharedUserServe].userID]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",sys_count] forKey:[NSString stringWithFormat:@"haveCountSys%@",[UserServe sharedUserServe].userID]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString * unreadCount = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].userID]];
    if ([unreadCount intValue]>0) {
        //                [RootViewController sharedRootViewController].msgVC.needRefreshMsg = YES;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"needMetionCount%@",[UserServe sharedUserServe].userID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgNotiReceived" object:self userInfo:nil];
    [navigationController pushViewController:msgV animated:YES];
    [[RootViewController sharedRootViewController].sideMenu hideMenuViewController];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
