//
//  PostCardFullScreenPreviewViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/5/22.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PostCardFullScreenPreviewViewController.h"
#import "RootViewController.h"
#import "UIView+Genie.h"
#import "PostCardPreviewViewController.h"
@interface PostCardFullScreenPreviewViewController ()

@end

@implementation PostCardFullScreenPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImageV = [[UIImageView alloc] initWithFrame:self.view.frame];
//    self.bgImageV.backgroundColor = [UIColor purpleColor];
    [self.bgImageV setImage:[UIImage imageNamed:@"muwenbg"]];
    [self.view addSubview:self.bgImageV];
    
    self.title = @"明信片预览";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    float originY = self.view.frame.size.height>500?self.view.frame.size.height*0.2129:self.view.frame.size.height*0.2;
    
    UIImageView * pbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, ScreenWidth, ScreenWidth*299/375)];
    [pbg setImage:[UIImage imageNamed:@"postcardgroup"]];
    pbg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pbg];
    
    float xcha = ScreenWidth*0.116;
    float ycha = (ScreenWidth*299/375)*0.149;
    
    self.pViewCenter = [[PostCardView alloc] initWithFrame:CGRectMake(ScreenWidth+xcha, ycha, ScreenWidth-(xcha*2), 0)];
    self.pViewLeft = [[PostCardView alloc] initWithFrame:CGRectMake(xcha, ycha, ScreenWidth-xcha*2, 0)];
    
    self.pViewCenter.hidden = YES;
    
    self.pViewBottom = [[PostCardView alloc] initWithFrame:CGRectMake(xcha, ycha+originY, ScreenWidth-xcha*2, 0)];
    [self.view addSubview:self.pViewBottom];
    
    NSLog(@"wwwwww%@",NSStringFromCGRect(self.pViewCenter.frame));
    self.pScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, ScreenWidth, self.pViewCenter.frame.size.height+ycha*2)];
    self.pScrollV.backgroundColor = [UIColor clearColor];
    [self.pScrollV setContentSize:CGSizeMake(ScreenWidth*3, self.pScrollV.frame.size.height)];
    self.pScrollV.contentOffset = CGPointMake(0, 0);
    self.pScrollV.showsHorizontalScrollIndicator = NO;
    [self.pScrollV addSubview:self.pViewCenter];
    [self.pScrollV addSubview:self.pViewLeft];
    self.pScrollV.pagingEnabled = YES;
    [self.view addSubview:self.pScrollV];
    self.pScrollV.delegate = self;
    
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-30-120, self.view.frame.size.height-(self.view.frame.size.height>500?180:150), 120, 20)];
    self.numL.backgroundColor = [UIColor clearColor];
    self.numL.textColor = [UIColor whiteColor];
    self.numL.font = [UIFont boldSystemFontOfSize:16];
    self.numL.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.numL];

    
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-(self.view.frame.size.height>500?140:110), ScreenWidth-60, 10)];
    [self.slider setThumbImage:[UIImage imageNamed:@"huakuaier"] forState:UIControlStateNormal];
//    [slider setMinimumTrackTintColor:[UIColor grayColor]];
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"jindutiao"] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"jindutiao"] forState:UIControlStateNormal];
//    [slider setMaximumTrackTintColor:[UIColor grayColor]];
    
    [self.view addSubview:self.slider];
    [self.slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
    
    self.dingzhiB = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dingzhiB setFrame:CGRectMake((ScreenWidth-120)/2, self.view.frame.size.height-(self.view.frame.size.height>500?90:70), 120, 39)];
    [self.dingzhiB setBackgroundColor:[UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1]];
    self.dingzhiB.layer.cornerRadius = 5;
    self.dingzhiB.layer.masksToBounds = YES;
//    [self.dingzhiB setBackgroundImage:[UIImage imageNamed:@"dingzhi_Btn"] forState:UIControlStateNormal];
    [self.dingzhiB setTitle:@"定制" forState:UIControlStateNormal];
    [self.dingzhiB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dingzhiB.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:self.dingzhiB];
    [self.dingzhiB addTarget:self action:@selector(toPostCardDetailPage) forControlEvents:UIControlEventTouchUpInside];
    

//    [self setPostCard];
    [self getMyshuoshuo];
 
    // Do any additional setup after loading the view.
}

-(void)getMyshuoshuo
{
    [SVProgressHUD showWithStatus:@"获取您的说说中..."];
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"petalk" forKey:@"command"];
    [hotDic setObject:@"list4Postcard" forKey:@"options"];
    [hotDic setObject:@"100" forKey:@"pageSize"];
    //    [hotDic setObject:[NSString stringWithFormat:@"%d",(int)self.pageIndex] forKey:@"pageIndex"];
    [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    [hotDic setObject:@"O" forKey:@"type"];
    [NetServer requestWithParameters:hotDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.pageIndex++;
        self.myShuoShuoArray = [self getModelArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
        self.selectedIndex = 0;
        self.totalShuoShuoNum = [[[responseObject objectForKey:@"value"] objectForKey:@"totalElements"] integerValue];
//        [self.tableView reloadData];
        //        [self selectWhichRow:0];
//        self.thumbTableView.iamloading = NO;
        self.totalShuoShuoNum = self.myShuoShuoArray.count;
        [SVProgressHUD dismiss];
        if (self.myShuoShuoArray.count<=0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有发布任何说说呢，不能打印明信片" delegate:self cancelButtonTitle:@"这就去发" otherButtonTitles:nil, nil];
            alert.tag = 22;
            [alert show];
            return;
        }
        
       
        self.selectedIndex = 0;
        self.slider.value = (float)(self.selectedIndex+1)/(float)self.totalShuoShuoNum;
        self.numL.text = [NSString stringWithFormat:@"%d/%d",(int)self.selectedIndex+1,(int)self.totalShuoShuoNum];
        [self setPostCard];
//        TalkingBrowse * talking = [self.myShuoShuoArray objectAtIndex:self.selectedIndex];
//        [self.pView displaySpritesWithTalking:talking];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取说说失败"];
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==22) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(NSMutableArray *)getModelArray:(NSArray *)array
{
    NSMutableArray * hArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        TalkingBrowse * talking = [[TalkingBrowse alloc] initWithHostInfo:[array objectAtIndex:i]];
        //        talking.cellIndex = i;
        //        talking.rowHeight = [TimeLineTalkingTableViewCell heightForRowWithTalking:talking CellType:0];
        self.lastId = talking.listId;
        [hArray addObject:talking];
    }
    return hArray;
}
-(void)setPostCard
{
    self.originCurrentRect = self.pViewBottom.frame;
    
    if (self.selectedIndex==0) {
        self.pScrollV.contentOffset = CGPointMake(0, 0);
        [self.pViewLeft displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
        //        self.currentPView = self.pViewLeft;
        if (self.myShuoShuoArray.count>=2) {
            [self.pViewBottom displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex+1]];
        }
    }
    else if (self.selectedIndex>=self.myShuoShuoArray.count-1) {
        self.pViewCenter.hidden = NO;
        [self.pViewBottom displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
        //            self.currentPView = self.pViewBottom;
        [self.pViewCenter displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex-1]];
        self.pScrollV.contentOffset = CGPointMake(ScreenWidth*2, 0);
    }
    else
    {
        self.pScrollV.contentOffset = CGPointMake(ScreenWidth, 0);
        self.pViewCenter.hidden = NO;
        [self.pViewCenter displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
        //        self.currentPView = self.pViewCenter;
        [self.pViewLeft displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex-1]];
        if (self.selectedIndex<self.myShuoShuoArray.count-1){
            [self.pViewBottom displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex+1]];
        }
    }
    if (self.myShuoShuoArray.count==1) {
        self.pScrollV.hidden = YES;
        [self.pViewBottom displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
    }
    
    self.originOffsetX = self.pScrollV.contentOffset.x;
}
-(void)updateValue:(id)sender
{
    float f = self.slider.value; //读取滑块的值
    f = self.totalShuoShuoNum*f;
    int d = round(f);
    if (d<1) {
        self.slider.value = 1/(float)self.totalShuoShuoNum;
        return;
    }
    if (self.selectedIndex!=d-1) {
        self.selectedIndex = d-1;
        self.numL.text = [NSString stringWithFormat:@"%d/%d",(int)self.selectedIndex+1,(int)self.totalShuoShuoNum];
        
        [self setPostCard];
        NSLog(@"fffff:%d",d);
    }
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"theX:%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x<self.originOffsetX&&self.originOffsetX>0) {
        self.selectedIndex--;
        if (self.selectedIndex==0) {
            scrollView.contentOffset = CGPointMake(0, 0);
            [self.pViewLeft displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
//            self.currentPView = self.pViewLeft;
            if (self.myShuoShuoArray.count>=2) {
                [self.pViewBottom displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex+1]];
            }
            self.pViewCenter.hidden = YES;
        }
        else
        {
            self.pScrollV.contentOffset = CGPointMake(ScreenWidth, 0);
            self.pViewCenter.hidden = NO;
            [self.pViewCenter displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
//            self.currentPView = self.pViewCenter;
            [self.pViewLeft displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex-1]];
            if (self.selectedIndex<self.myShuoShuoArray.count-1){
                [self.pViewBottom displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex+1]];
            }
        }
        self.originOffsetX = scrollView.contentOffset.x;
    }
    else if (scrollView.contentOffset.x>self.originOffsetX&&self.originOffsetX<ScreenWidth*2){

        self.selectedIndex++;
        if (self.selectedIndex==0) {
            scrollView.contentOffset = CGPointMake(0, 0);
            [self.pViewLeft displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
//            self.currentPView = self.pViewLeft;
            if (self.myShuoShuoArray.count>=2) {
                [self.pViewBottom displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex+1]];
            }
            self.pViewCenter.hidden = YES;
        }
        else
        {
            self.pScrollV.contentOffset = CGPointMake(ScreenWidth, 0);
            self.pViewCenter.hidden = NO;
            [self.pViewCenter displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
//            self.currentPView = self.pViewCenter;
            [self.pViewLeft displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex-1]];
            if (self.selectedIndex<self.myShuoShuoArray.count-1){
                [self.pViewBottom displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex+1]];
            }
        }
        if (self.selectedIndex>=self.myShuoShuoArray.count-1) {
            [self.pViewBottom displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
//            self.currentPView = self.pViewBottom;
            [self.pViewCenter displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex-1]];
            self.pScrollV.contentOffset = CGPointMake(ScreenWidth*2, 0);
        }
        self.originOffsetX = scrollView.contentOffset.x;
    }
    self.numL.text = [NSString stringWithFormat:@"%d/%d",(int)self.selectedIndex+1,(int)self.totalShuoShuoNum];
    [self.slider setValue:(float)(self.selectedIndex+1)/(float)self.totalShuoShuoNum animated:YES];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x<self.originOffsetX&&self.originOffsetX>0&&self.selectedIndex<self.myShuoShuoArray.count-1) {
        if (self.pViewCenter.hidden==NO) {
            self.pViewCenter.hidden = YES;
            [self.pViewBottom displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
//            self.currentPView = self.pViewBottom;
        }
    }
    else if ((scrollView.contentOffset.x>self.originOffsetX&&self.selectedIndex>0)||self.selectedIndex==self.myShuoShuoArray.count-1){
        self.pViewCenter.hidden = NO;
    }
}

-(void)toPostCardDetailPage
{
    PostCardPreviewViewController * postV = [[PostCardPreviewViewController alloc] init];
    [self.navigationController pushViewController:postV animated:YES];

}

-(void)addToList
{
    
    NSString * currentPetId = [UserServe sharedUserServe].userID;
    if (!currentPetId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"先登录哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }
    
    TalkingBrowse * tk = [self.myShuoShuoArray objectAtIndex:self.selectedIndex];
    NSMutableArray * array = [NSMutableArray array];
    if ([self.listDict objectForKey:tk.theID]) {
        array = [NSMutableArray arrayWithArray:[self.listDict objectForKey:tk.theID]];
        [array addObject:tk];
    }
    else
    {
        [array addObject:tk];
    }
    [self.listDict setObject:array forKey:tk.theID];
    
    self.dingzhiB.enabled = NO;
    CGRect endRect = CGRectMake(30, self.view.frame.size.height-60, 0, 0);
//    self.currentPView.hidden = NO;
    if (!self.currentPView) {
        self.currentPView = [[PostCardView alloc] initWithFrame:self.originCurrentRect];
    }
    
    [self.view addSubview:self.currentPView];
    [self.view bringSubviewToFront:self.dingzhiB];
//    self.currentPView.hidden = YES;
    [self.currentPView displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
    __block PostCardView * _pv = self.currentPView;
    [self.currentPView genieInTransitionWithDuration:0.5
                        destinationRect:endRect
                        destinationEdge:BCRectEdgeTop
                             completion:^{
                                 NSLog(@"I'm done!");
                                 self.dingzhiB.enabled = YES;
                                 if ([_pv superview]) {
                                     [_pv removeFromSuperview];
                                     _pv = nil;
                                 }
                             }];

}
-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(BOOL)shouldAutorotate
//{
//    return NO;
//    
//}
//
//
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscapeRight;
////    return self.orietation;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
