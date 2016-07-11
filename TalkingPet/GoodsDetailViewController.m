//
//  GoodsDetailViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/1/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "SVProgressHUD.h"
#import "ExchangeRecordViewController.h"
#import "ShareSheet.h"
#import "PagedFlowView.h"
#import "EGOImageView.h"
#import "Common.h"
#import "WebContentViewController.h"

@interface GoodsDetailViewController ()<UIAlertViewDelegate,PagedFlowViewDelegate
,PagedFlowViewDataSource,UIWebViewDelegate>
{
    UIAlertView * exchangeAlertView;
    BOOL shared;
    UIButton * exchangeB;
    UIScrollView * scrollV;
    UIWebView * webView;
}
@property (nonatomic,retain)PagedFlowView * pageV;
@end

@implementation GoodsDetailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        shared = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    [self buildViewWithSkintype];
    
    scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight-40)];
    scrollV.contentSize = CGSizeMake(ScreenWidth, self.view.frame.size.height-navigationBarHeight-25+410);
    scrollV.scrollsToTop = YES;
    scrollV.backgroundColor = [UIColor colorWithWhite:236/255.0 alpha:1];
    [self.view addSubview: scrollV];
    UIView * whiteV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth+80)];
    whiteV.backgroundColor = [UIColor whiteColor];
    [scrollV addSubview:whiteV];
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth+80, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithWhite:150/255.0 alpha:1];
    [scrollV addSubview:line];
    
    self.pageV = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _pageV.delegate = self;
    _pageV.dataSource = self;
    _pageV.backgroundColor = [UIColor whiteColor];
    [scrollV addSubview:_pageV] ;
    UIPageControl * page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, ScreenWidth-20, ScreenWidth, 20)];
    page.currentPageIndicatorTintColor = [UIColor colorWithRed:135/255.0 green:130/255.0 blue:250/255.0 alpha:1];
    page.pageIndicatorTintColor = [UIColor colorWithWhite:200/255.0 alpha:1];
    _pageV.pageControl = page;
    [scrollV addSubview:page];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = _goodsDic[@"description"];
    label.numberOfLines = 0;
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(ScreenWidth-10, 50) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(5, ScreenWidth+10, size.width,size.height);
    label.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    [scrollV addSubview:label];
    
    UIImageView * peaIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, ScreenWidth+20+size.height, 15, 15)];
    peaIV.image = [UIImage imageNamed:@"peaicon"];
    [scrollV addSubview:peaIV];
    
    UILabel * priceL = [[UILabel alloc] initWithFrame:CGRectMake(25, ScreenWidth+20+size.height, 100, 15)];
    priceL.font = [UIFont systemFontOfSize:15];
    priceL.text = _goodsDic[@"price"];
    priceL.textColor = [UIColor colorWithRed:247/255.0 green:98/255.0 blue:192/255.0 alpha:1];
    [scrollV addSubview:priceL];

    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ScreenWidth+90, ScreenWidth, self.view.frame.size.height-navigationBarHeight-47)];
    [webView loadHTMLString:_goodsDic[@"detail"] baseURL:nil];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = NO;
    webView.delegate = self;
    webView.scrollView.scrollsToTop = NO;
    webView.dataDetectorTypes = UIDataDetectorTypeLink;
    [scrollV addSubview:webView];
    
    
    UIImageView * downIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-navigationBarHeight-40, ScreenWidth, 40)];
    downIV.userInteractionEnabled = YES;
    downIV.image = [UIImage imageNamed:@"market_downBar"];
    [self.view addSubview:downIV];
    
    exchangeB = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeB setBackgroundImage:[UIImage imageNamed:@"exchangB"] forState:UIControlStateNormal];
    [downIV addSubview:exchangeB];
    exchangeB.titleLabel.font = [UIFont systemFontOfSize:14];
    exchangeB.frame = CGRectMake(ScreenWidth-90, 5, 80, 30);
    switch (_type) {
        case GoodsDetailTyepExchange:{
            if ([_goodsDic[@"state"] intValue] == 11)//有货
            {
                [exchangeB setTitle:@"我要兑换" forState:UIControlStateNormal];
                [exchangeB addTarget:self action:@selector(exchangeAction) forControlEvents:UIControlEventTouchUpInside];
            }else if ([_goodsDic[@"state"] intValue] == 10)
            {
                exchangeB.enabled = NO;
                [exchangeB setTitle:@"即将开售" forState:UIControlStateNormal];
            }else if ([_goodsDic[@"state"] intValue] == 12){
                exchangeB.enabled = NO;
                [exchangeB setTitle:@"无货" forState:UIControlStateNormal];
            }
            
        }break;
        case GoodsDetailTyepTrial:{
            peaIV.image = [UIImage imageNamed:@"peaicon_unuse"];
            priceL.textColor = [UIColor colorWithWhite:150/255.0 alpha:1];
            
            CGSize s = [priceL.text sizeWithFont:priceL.font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            UIView * pass = [[UIView alloc] initWithFrame:CGRectMake(2, peaIV.frame.origin.y+7, s.width+25, 1)];
            pass.backgroundColor = [UIColor colorWithWhite:150/255.0 alpha:1];
            [scrollV addSubview:pass];
            
            UILabel*inventoryL = [[UILabel alloc] initWithFrame:CGRectMake(10, peaIV.frame.origin.y+25, 90, 15)];
            [inventoryL setFont:[UIFont systemFontOfSize:12]];
            [inventoryL setBackgroundColor:[UIColor clearColor]];
            inventoryL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
            inventoryL.text = [NSString stringWithFormat:@"试用数:%@",_goodsDic[@"inventory"]];
            [scrollV addSubview:inventoryL];
            UILabel*participationL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-90, inventoryL.frame.origin.y, 90, 15)];
            [participationL setFont:[UIFont systemFontOfSize:12]];
            [participationL setBackgroundColor:[UIColor clearColor]];
            participationL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
            participationL.text = [NSString stringWithFormat:@"参与数:%@",_goodsDic[@"apply"]];
            [scrollV addSubview:participationL];
            
            whiteV.frame = CGRectMake(0, 0, ScreenWidth, inventoryL.frame.origin.y+20);
            line.frame = CGRectMake(0, inventoryL.frame.origin.y+19, ScreenWidth, 1);
            webView.frame = CGRectMake(0, whiteV.frame.size.height+10, webView.frame.size.width, webView.frame.size.height);
            
            UILabel*endTimeL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-150, inventoryL.frame.origin.y, 150, 15)];
            [endTimeL setFont:[UIFont systemFontOfSize:12]];
            [endTimeL setBackgroundColor:[UIColor clearColor]];
            endTimeL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
            [scrollV addSubview:endTimeL];
            [self setRightButtonWithName:@"分享" BackgroundImg:nil Target:@selector(shareTrialGoods)];
            if ([_goodsDic[@"state"] intValue] == 20)//即将开始
            {
                endTimeL.text = @"即将开始";
                exchangeB.enabled = NO;
                [exchangeB setTitle:@"即将开始" forState:UIControlStateNormal];
            }else if ([_goodsDic[@"state"] intValue] == 21)//进行中
            {
                endTimeL.text = [NSString stringWithFormat:@"距离结束:%@",[Common dateStringBetweenNewToTimestamp:_goodsDic[@"endTime"]]];
                if([_goodsDic[@"orderState"] isEqualToString:@""])//未参加
                {
                    [exchangeB setTitle:@"我要试用" forState:UIControlStateNormal];
                    [exchangeB addTarget:self action:@selector(exchangeAction) forControlEvents:UIControlEventTouchUpInside];
                }
            }else if([_goodsDic[@"state"] intValue] == 22) {
                endTimeL.text = @"活动结束";
                exchangeB.enabled = NO;
                if([_goodsDic[@"orderState"] isEqualToString:@""])//未参加
                {
                    [exchangeB setTitle:@"活动结束" forState:UIControlStateNormal];
                }
            }
            if([_goodsDic[@"orderState"] intValue]==41)//已参加
            {
                exchangeB.enabled = NO;
                [exchangeB setTitle:@"申请中" forState:UIControlStateNormal];
            }else if([_goodsDic[@"orderState"] intValue]==42)//已通过
            {
                exchangeB.enabled = NO;
                [exchangeB setTitle:@"申请通过" forState:UIControlStateNormal];
            }else if([_goodsDic[@"orderState"] intValue]==43)//已拒绝
            {
                exchangeB.enabled = NO;
                [exchangeB setTitle:@"申请拒绝" forState:UIControlStateNormal];
            }else if([_goodsDic[@"orderState"] intValue]==44)//已通过
            {
                exchangeB.enabled = NO;
                [exchangeB setTitle:@"申请通过" forState:UIControlStateNormal];
            }
            
        }break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backBtnDo
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareTrialGoods
{
    __block GoodsDetailViewController * blockSelf = self;
    ShareSheet * shareSheet = [[ShareSheet alloc]initWithIconArray:@[@"weiChatFriend",@"friendCircle",@"sina",@"qq"] titleArray:@[@"微信好友",@"朋友圈",@"微博",@"QQ"] action:^(NSInteger index) {
        switch (index) {
            case 0:{
                [ShareServe shareToWeixiFriendWithTitle:[NSString stringWithFormat:@"【免费试用】%@可以免费领取啦，有钱就任性，有领就敢送。",_goodsDic[@"name"]] Content:@"宠物说社区，最有趣的宠物社交平台。更有免费试用大奖等你来领！" imageUrl:[_goodsDic[@"photos"] firstObject] webUrl:[NSString stringWithFormat:GOODSBASEURL,_goodsDic[@"code"]] Succeed:^{
                    shared = YES;
                    if([_goodsDic[@"state"] intValue] == 21) {
                        if([_goodsDic[@"orderState"] isEqualToString:@""])//未参加
                        {
                            [blockSelf exchangeAction];
                        }
                    }
                }];
            }break;
            case 1:{
                [ShareServe shareToFriendCircleWithTitle:[NSString stringWithFormat:@"【免费试用】%@可以免费领取啦，有钱就任性，有领就敢送。",_goodsDic[@"name"]] Content:@"宠物说社区，最有趣的宠物社交平台。更有免费试用大奖等你来领！" imageUrl:[_goodsDic[@"photos"] firstObject] webUrl:[NSString stringWithFormat:GOODSBASEURL,_goodsDic[@"code"]] Succeed:^{
                    shared = YES;
                    if([_goodsDic[@"state"] intValue] == 21) {
                        if([_goodsDic[@"orderState"] isEqualToString:@""])//未参加
                        {
                            [blockSelf exchangeAction];
                        }
                    }
                }];
            }break;
            case 2:{
                [ShareServe shareToSineWithContent:[NSString stringWithFormat:@"【免费试用】%@可以免费领取啦，有钱就任性，有领就敢送。宠物说社区，最有趣的宠物社交平台。更有免费试用大奖等你来领！%@",_goodsDic[@"name"],[NSString stringWithFormat:GOODSBASEURL,_goodsDic[@"code"]]] imageUrl:[_goodsDic[@"photos"] firstObject] Succeed:^{
                    shared = YES;
                    if([_goodsDic[@"state"] intValue] == 21) {
                        if([_goodsDic[@"orderState"] isEqualToString:@""])//未参加
                        {
                            [blockSelf exchangeAction];
                        }
                    }
                }];
            }break;
            case 3:{
                [ShareServe shareToQQWithTitle:[NSString stringWithFormat:@"【免费试用】%@可以免费领取啦，有钱就任性，有领就敢送。",_goodsDic[@"name"]] Content:@"宠物说社区，最有趣的宠物社交平台。更有免费试用大奖等你来领！" imageUrl:[_goodsDic[@"photos"] firstObject] webUrl:[NSString stringWithFormat:GOODSBASEURL,_goodsDic[@"code"]] Succeed:^{
                    shared = YES;
                    if([_goodsDic[@"state"] intValue] == 21) {
                        if([_goodsDic[@"orderState"] isEqualToString:@""])//未参加
                        {
                            [blockSelf exchangeAction];
                        }
                    }
                }];
            }break;
            default:
                break;
        }
        
    }];
    [shareSheet show];
//    ShareSheet * sheet = [[ShareSheet alloc] initWithTrialName:_goodsDic[@"name"] Code:_goodsDic[@"code"] imageURL:[_goodsDic[@"photos"] firstObject]];
//    [sheet showWithShareSucceed:^{
//        
//    }];
}
- (void)exchangeAction
{
    switch (_type) {
        case GoodsDetailTyepExchange:{
            if ([_goodsDic[@"price"] intValue]>[[UserServe sharedUserServe].account.coin intValue]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"哎呀，你的宠豆太少了，攒攒再来兑换吧" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
                [alert show];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确定花费%@宠豆兑换该商品吗?",_goodsDic[@"price"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }break;
        case GoodsDetailTyepTrial:{
            if (shared) {
                [SVProgressHUD showWithStatus:@"申请中,请稍后"];
                NSMutableDictionary* mDict = [NetServer commonDict];
                [mDict setObject:@"goods" forKey:@"command"];
                [mDict setObject:@"orderCreate" forKey:@"options"];
                [mDict setObject:_goodsDic[@"code"] forKey:@"code"];
                [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
                [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [SVProgressHUD showSuccessWithStatus:@"申请成功"];
                    [exchangeB setTitle:@"申请中" forState:UIControlStateNormal];
                    exchangeB.enabled = NO;
                    if (_trialSuccess) {
                        _trialSuccess();
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD dismiss];
                }];
            }else{
                [self ifSureToSHare];
            }
            
        }break;
        default:
            break;
    }
}
-(void)ifSureToSHare
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享给好友就能申请试用资格哦，分享给好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享", nil];
    alert.tag = 111;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==111){
        if (buttonIndex==1) {
            [self performSelector:@selector(shareTrialGoods) withObject:nil afterDelay:0.5];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:exchangeAlertView]) {
        exchangeAlertView = nil;
        if (buttonIndex == 1) {
            //去兑换记录
            ExchangeRecordViewController * exchangeVC = [[ExchangeRecordViewController alloc] init];
            [self.navigationController pushViewController:exchangeVC animated:YES];
        }
    }
    else if (alertView.tag==111){
        if (buttonIndex==1) {
//            [self performSelector:@selector(shareTrialGoods) withObject:nil afterDelay:0.5];
        }
    }
    else
    {
        if (buttonIndex == 1) {
            [SVProgressHUD showWithStatus:@"兑换中,请稍后"];
            NSMutableDictionary* mDict = [NetServer commonDict];
            [mDict setObject:@"goods" forKey:@"command"];
            [mDict setObject:@"orderCreate" forKey:@"options"];
            [mDict setObject:_goodsDic[@"code"] forKey:@"code"];
            [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
            [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                exchangeAlertView = [[UIAlertView alloc] initWithTitle:@"商品兑换成功!" message:@"快去兑换记录中领取该商品吧" delegate:self cancelButtonTitle:@"继续兑换" otherButtonTitles:@"领取商品" ,nil];
                [exchangeAlertView show];
                [SVProgressHUD dismiss];
                int currentCoin = [[UserServe sharedUserServe].account.coin intValue] -[_goodsDic[@"price"] intValue];
                [UserServe sharedUserServe].account.coin = [NSString stringWithFormat:@"%d",currentCoin];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRExchangeSuccess" object:self userInfo:nil];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [SVProgressHUD dismiss];
            }];
        }
    }
}
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(ScreenWidth, ScreenWidth);
}
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    return ((NSArray*)_goodsDic[@"photos"]).count;
}
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    EGOImageView * imageV = (EGOImageView*)[flowView dequeueReusableCell];
    if (!imageV) {
        imageV = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"Placeholder"]];
    }
    imageV.imageURL = [NSURL URLWithString:((NSArray*)_goodsDic[@"photos"])[index]];
    return imageV;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * url = [NSString stringWithFormat:@"%@",request.URL];
    if ([url hasPrefix:@"http"]) {
        TOWebViewController * vb = [[TOWebViewController alloc] init];
        vb.url = [NSURL URLWithString:url];
        [self.navigationController pushViewController:vb animated:YES];
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)myWebView
{
    webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, myWebView.frame.size.width, myWebView.scrollView.contentSize.height+10);
    scrollV.contentSize = CGSizeMake(ScreenWidth, webView.scrollView.contentSize.height+webView.frame.origin.y);
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
