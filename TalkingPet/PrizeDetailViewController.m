//
//  PrizeDetailViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/10.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PrizeDetailViewController.h"

@interface PrizeDetailViewController ()

@end

@implementation PrizeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstGet = YES;
//    self.title = @"详情";
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.currentCategory = 0;
    self.tagId = @"";
    [self setAnotherBackButtonWithTarget:@selector(backBtnDo:)];
//    [self removeNaviBg];
    
    self.headerArray = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"http://www.baidu.com",@"url",@"http://d.hiphotos.baidu.com/image/pic/item/f11f3a292df5e0feba84cf005e6034a85edf7216.jpg",@"bgurl", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"http://www.163.com",@"url",@"http://f.hiphotos.baidu.com/image/pic/item/838ba61ea8d3fd1fbc60249b334e251f95ca5f22.jpg",@"bgurl", nil], nil];
    
    self.bgScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-40)];
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetHeight(self.view.frame));
//    self.bgScrollV.backgroundColor = [UIColor redColor];
    self.bgScrollV.scrollsToTop = NO;
//    self.bgScrollV.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.bgScrollV.bounces = YES;
    [self.view addSubview:self.bgScrollV];
    
    self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.actionBtn setFrame:CGRectMake(0, self.view.frame.size.height-40, ScreenWidth, 40)];
    [self.actionBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"actionBtnBg"]]];
    [self.actionBtn setTitle:@"参加" forState:UIControlStateNormal];
    [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionBtn addTarget:self action:@selector(actionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.actionBtn];
    self.actionBtn.enabled = NO;
    
    self.todoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.todoBtn setFrame:CGRectMake(0, self.view.frame.size.height-40, ScreenWidth/2, 40)];
    [self.todoBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"otherActionBtn"]]];
    [self.todoBtn setTitle:@"去完成" forState:UIControlStateNormal];
    [self.todoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.todoBtn addTarget:self action:@selector(todoClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.todoBtn];
    self.todoBtn.hidden = YES;
    UIView * l = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-1, 0, 1, 40)];
    [l setBackgroundColor:[UIColor colorWithWhite:132/255.0f alpha:1]];
    [self.todoBtn addSubview:l];
    
    self.tomissionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tomissionBtn setFrame:CGRectMake(ScreenWidth/2, self.view.frame.size.height-40, ScreenWidth/2, 40)];
    [self.tomissionBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"otherActionBtn"]]];
    [self.tomissionBtn setTitle:@"去我的任务" forState:UIControlStateNormal];
    [self.tomissionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tomissionBtn addTarget:self action:@selector(toMissionClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tomissionBtn];
    self.tomissionBtn.hidden = YES;
    
    self.sameView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (ScreenWidth)*(2/3.0f))];
    _sameView.delegate = self;
    _sameView.dataSource = self;
    //    _sameView.hidden = YES;
    [self.bgScrollV addSubview:_sameView];
    
    UIPageControl * page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (ScreenWidth)*(2/3.0f)-20, ScreenWidth, 20)];
    page.currentPageIndicatorTintColor = [UIColor colorWithRed:135/255.0 green:130/255.0 blue:250/255.0 alpha:1];
    page.pageIndicatorTintColor = [UIColor colorWithWhite:200/255.0 alpha:1];
    _sameView.pageControl = page;
    [_sameView addSubview:page];
    
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(10, self.sameView.frame.origin.y+self.sameView.frame.size.height+5, ScreenWidth-20, 20)];
    [self.numL setBackgroundColor:[UIColor clearColor]];
    self.numL.font = [UIFont systemFontOfSize:15];
    self.numL.text = @"参加人数：100";
    self.numL.textColor = [UIColor colorWithRed:120/255.0f green:120/255.0f blue:120/255.0f alpha:1];
    [self.bgScrollV addSubview:self.numL];
    
    self.canShowUNum = (ScreenWidth-40)/40;
    //            int d = (num-(int)num)>0.
    for (int i = 0; i<self.canShowUNum; i++) {
        EGOImageButton * zanAvatar = [[EGOImageButton alloc] initWithFrame:CGRectMake(15+10*i+30*i, self.numL.frame.origin.y+self.numL.frame.size.height+10, 30, 30)];
        zanAvatar.tag = 200+i;
        //            [zanAvatar setBackgroundColor:[UIColor colorWithWhite:230/255.0f alpha:1]];
        zanAvatar.placeholderImage = [UIImage imageNamed:@"browser_avatarPlaceholder"];
        [self.bgScrollV addSubview:zanAvatar];
        zanAvatar.layer.cornerRadius = 15;
        zanAvatar.layer.masksToBounds = YES;
        [zanAvatar addTarget:self action:@selector(avatarShouldPush:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(10, self.numL.frame.origin.y+self.numL.frame.size.height+10+30+5, ScreenWidth, 20)];
    self.timeL.backgroundColor = [UIColor clearColor];
    self.timeL.font = [UIFont systemFontOfSize:15];
    self.timeL.text = @"活动时间：2015年0月0日-2015年0月0日";
    self.timeL.adjustsFontSizeToFitWidth = YES;
    self.timeL.textColor = [UIColor colorWithRed:120/255.0f green:120/255.0f blue:120/255.0f alpha:1];
    [self.bgScrollV addSubview:self.timeL];
    
    self.canyuL = [[UILabel alloc] initWithFrame:CGRectMake(10, self.timeL.frame.origin.y+self.timeL.frame.size.height+15, ScreenWidth, 20)];
    self.canyuL.backgroundColor = [UIColor clearColor];
    self.canyuL.font = [UIFont boldSystemFontOfSize:16];
    self.canyuL.textColor = [UIColor colorWithRed:120/255.0f green:120/255.0f blue:120/255.0f alpha:1];
    self.canyuL.text = @"参与方式:";
    [self.bgScrollV addSubview:self.canyuL];
    
    self.desL = [[UILabel alloc] initWithFrame:CGRectMake(10, self.canyuL.frame.origin.y+self.canyuL.frame.size.height+10, ScreenWidth-20, 20)];
    self.desL.backgroundColor = [UIColor clearColor];
    self.desL.font = [UIFont systemFontOfSize:15];
    self.desL.text = @"活动详情";
    self.desL.adjustsFontSizeToFitWidth = YES;
    self.desL.numberOfLines = 0;
    self.desL.lineBreakMode = NSLineBreakByCharWrapping;
    self.desL.textColor = [UIColor colorWithRed:120/255.0f green:120/255.0f blue:120/255.0f alpha:1];
    [self.bgScrollV addSubview:self.desL];
    
    CGSize gcs = [self.desL.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    self.desL.frame = CGRectMake(10, self.canyuL.frame.origin.y+self.canyuL.frame.size.height+10, ScreenWidth-20, gcs.height);
    
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, gcs.height+self.desL.frame.origin.y+10);
    
    [self getActiveContent];
    [self getDetail];

    // Do any additional setup after loading the view.
}
-(void)getDetail
{
    if (self.firstGet) {
        [SVProgressHUD showWithStatus:@"获取详情中..."];
    }
    
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"awardActivity" forKey:@"command"];
    [usersDict setObject:@"one" forKey:@"options"];
    if ([UserServe sharedUserServe].currentPet.petID) {
        [usersDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    }
    [usersDict setObject:self.awardId forKey:@"id"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.firstGet = NO;
        self.actionBtn.enabled = YES;
        [SVProgressHUD dismiss];
        NSDictionary * content = [responseObject objectForKey:@"value"];
        self.headerArray = [content objectForKey:@"awardPics"];
        [self.sameView reloadData];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY年MM月dd日"];
        NSDate *timesp1 = [NSDate dateWithTimeIntervalSince1970:[[content objectForKey:@"beginTime"]  doubleValue]/1000];
        NSString *timespStr1 = [formatter stringFromDate:timesp1];
        NSDate *timesp2 = [NSDate dateWithTimeIntervalSince1970:[[content objectForKey:@"endTime"]  doubleValue]/1000];
        NSString *timespStr2 = [formatter stringFromDate:timesp2];
        self.status = [[content objectForKey:@"state"] intValue];
        if ([self.delegate respondsToSelector:@selector(resetStatusforIndex:withStatus:)]) {
            [self.delegate resetStatusforIndex:self.cellIndex withStatus:self.status];
        }
        self.currentCategory = [[content objectForKey:@"catagory"] intValue];
        self.tagId = [content objectForKey:@"tagId"];
        if (self.status==2) {
            [self.actionBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"actionBtnBg"]]];
            [self.actionBtn setTitle:@"参加" forState:UIControlStateNormal];
        }
        else if(self.status==5)
        {
            [self.actionBtn setBackgroundColor:[UIColor lightGrayColor]];
            [self.actionBtn setTitle:@"已结束" forState:UIControlStateNormal];
            self.actionBtn.enabled = NO;
        }
        else if (self.status==1){
            [self.actionBtn setBackgroundColor:[UIColor lightGrayColor]];
            [self.actionBtn setTitle:@"未开始" forState:UIControlStateNormal];
            self.actionBtn.enabled = NO;
        }
        else if (self.status==3&&self.currentCategory!=2){
            self.actionBtn.hidden = YES;
            self.todoBtn.hidden = NO;
            [self.todoBtn setTitle:@"已参与" forState:UIControlStateNormal];
            self.tomissionBtn.hidden = NO;
        }
        else if (self.status==6&&self.currentCategory!=2){
            self.actionBtn.hidden = YES;
            self.todoBtn.hidden = NO;
            [self.todoBtn setTitle:@"去完成" forState:UIControlStateNormal];
            self.tomissionBtn.hidden = NO;
        }
        else
        {
            self.actionBtn.hidden = YES;
            self.todoBtn.hidden = NO;
            [self.todoBtn setTitle:@"去首页" forState:UIControlStateNormal];
            self.tomissionBtn.hidden = NO;
//            [self.actionBtn setBackgroundColor:[UIColor lightGrayColor]];
//            [self.actionBtn setTitle:@"前往我的任务" forState:UIControlStateNormal];
        }
        
        self.timeL.text = [NSString stringWithFormat:@"活动时间：%@-%@",timespStr1,timespStr2];
        self.numL.text = [NSString stringWithFormat:@"参加人数：%@",[content objectForKey:@"joinerCount"]];
        self.desL.text = [[content objectForKey:@"description"] stringByAppendingString:@"\n\n\n本活动及其奖品与苹果公司无关"];
        CGSize gcs = [self.desL.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        self.desL.frame = CGRectMake(10, self.canyuL.frame.origin.y+self.canyuL.frame.size.height+10, ScreenWidth-20, gcs.height);
        
        self.joinerArray = [content objectForKey:@"joiners"];
        for (int i = 0; i<self.canShowUNum; i++) {
            EGOImageButton * zanAvatarV = (EGOImageButton *)[self.bgScrollV viewWithTag:200+i];
            //        UIImageView * daV = (UIImageView *)[self.contentView viewWithTag:900+i];
            if (self.canShowUNum>self.joinerArray.count) {
                if (i<self.joinerArray.count) {
                    zanAvatarV.hidden = NO;
                    zanAvatarV.imageURL = [NSURL URLWithString:[[self.joinerArray objectAtIndex:i] objectForKey:@"avatarUrl"]];
                }
                else{
                    zanAvatarV.hidden = YES;
                    //                daV.hidden = YES;
                }
            }
            else
            {
                zanAvatarV.hidden = NO;
                zanAvatarV.imageURL = [NSURL URLWithString:[[self.joinerArray objectAtIndex:i] objectForKey:@"avatarUrl"]];
            }
        }
        self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, gcs.height+self.desL.frame.origin.y+10);
//        self.awardArary = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"value"]];
//        [self.listTableV reloadData];
//        [self endRefreshing:self.listTableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self endRefreshing:self.listTableV];
        [SVProgressHUD showErrorWithStatus:@"详情获取失败"];
    }];
    
}
-(void)actionBtnClicked
{
    if (self.status==2) {
        [self joinIt];
    }
    else {
        if (self.fromTaskPage) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        MyTaskViewController * mv = [[MyTaskViewController alloc] init];
        [self.navigationController pushViewController:mv animated:YES];
    }
    
}
-(void)todoClicked
{
    [self showNaviBg];
    if (self.currentCategory==1||self.currentCategory==3) {
        TagTalkListViewController * tagTlistV = [[TagTalkListViewController alloc] init];
        Tag * theTag = [[Tag alloc] init];
        theTag.tagID = self.tagId;
        tagTlistV.tag = theTag;
        tagTlistV.shouldRequestTagInfo = YES;
        [self.navigationController pushViewController:tagTlistV animated:YES];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popedToRoot" object:self userInfo:nil];
    }

}
-(void)toMissionClicked
{
    MyTaskViewController * mv = [[MyTaskViewController alloc] init];
    [self.navigationController pushViewController:mv animated:YES];
}
-(void)joinIt
{
    [SVProgressHUD showWithStatus:@"参加中..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"awardActivity" forKey:@"command"];
    [usersDict setObject:@"join" forKey:@"options"];
    if ([UserServe sharedUserServe].currentPet.petID) {
        [usersDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    }
    [usersDict setObject:self.awardId forKey:@"activityId"];
    [usersDict setObject:[UserServe sharedUserServe].currentPet.headImgURL forKey:@"headPortrait"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [self getDetail];
        if (self.currentCategory==1||self.currentCategory==3) {
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"活动参加成功，现在就要去相应的标签下参加活动么" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"现在就去", nil];
//            alert.tag = 1;
//            [alert show];
        }
        else
        {
//            MyTaskViewController * mv = [[MyTaskViewController alloc] init];
//            [self.navigationController pushViewController:mv animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"参加失败"];
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        TagTalkListViewController * tagTlistV = [[TagTalkListViewController alloc] init];
        Tag * theTag = [[Tag alloc] init];
        theTag.tagID = self.tagId;
        tagTlistV.tag = theTag;
        tagTlistV.shouldRequestTagInfo = YES;
        [self.navigationController pushViewController:tagTlistV animated:YES];
    }
}
-(void)avatarShouldPush:(UIButton *)sender
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = [[self.joinerArray objectAtIndex:sender.tag-200] objectForKey:@"id"];
    [self.navigationController pushViewController:pv animated:YES];
}
-(void)getActiveContent
{
    for (int i = 0; i<self.canShowUNum; i++) {
        EGOImageButton * zanAvatarV = (EGOImageButton *)[self.bgScrollV viewWithTag:200+i];

        zanAvatarV.hidden = NO;
        zanAvatarV.imageURL = [NSURL URLWithString:@""];
    }

}
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(ScreenWidth, (ScreenWidth)*(2/3.0f));
}
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    if (self.headerArray.count) {
        if (self.headerArray.count<=1) {
            self.sameView.pageControl.hidden = YES;
        }
        else
            self.sameView.pageControl.hidden = NO;
        return self.headerArray.count;
    }
    self.sameView.pageControl.hidden = YES;
    return 1;
}
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    if (!self.headerArray.count) {
        return [[UIView alloc]init];
    }
    EGOImageView * imageV = (EGOImageView*)[flowView dequeueReusableCell];
    if (!imageV) {
        imageV = [[EGOImageView alloc] init];
        imageV.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        imageV.frame = CGRectMake(0, 0, ScreenWidth, (ScreenWidth)*(2/3.0f));
    }
    //    imageV.tag = 200+index;
    //    [imageV addTarget:self action:@selector(tagButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    imageV.imageURL = [NSURL URLWithString:[self.headerArray[index] objectForKey:@"url"]];
    return imageV;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getDetail];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNaviBg];
}
-(void)backBtnDo:(UIButton *)sender
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
