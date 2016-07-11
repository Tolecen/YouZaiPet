//
//  PostCardPreviewViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/5/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PostCardPreviewViewController.h"
#import "MJRefresh.h"
#import "RootViewController.h"
#import "SVProgressHUD.h"
#import "UIView+Genie.h"
@interface PostCardPreviewViewController ()

@end

@implementation PostCardPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    self.title = @"定制明信片";
    
    self.selectedIndex = 0;
    self.pageIndex = 0;
    self.univalent = @"5";
    self.allPrice = @"0";
    self.postCardNum = 0;
    self.listDict = [NSMutableDictionary dictionary];
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
//    [self setRightButtonWithName:nil BackgroundImg:@"nav_button_rule" Target:@selector(toIntroV)];
    
    self.myShuoShuoArray = [NSMutableArray array];
    
    self.bgScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame)-40-navigationBarHeight)];
    self.bgScrollV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgScrollV];
    
    self.topBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 190)];
    self.topBgV.backgroundColor = [UIColor clearColor];
    [self.bgScrollV addSubview:self.topBgV];
    
    
    
//    UIImage * timg = [UIImage imageNamed:@"postcard_template1"];
//    self.imageVBg = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenWidth, ScreenWidth*timg.size.height/timg.size.width)];
//    self.imageVBg.backgroundColor = [UIColor clearColor];
//    [self.bgScrollV addSubview:self.imageVBg];
//    
//    self.spritesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*timg.size.height/timg.size.width)];
//    self.spritesView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
//    [self.imageVBg addSubview:self.spritesView];
//    
//    self.templateImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*timg.size.height/timg.size.width)];
//    [self.templateImageV setImage:timg];
//    [self.imageVBg addSubview:self.templateImageV];
    
    UIImageView * i = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, ScreenWidth-20+4, (ScreenWidth-20+4)*0.717)];
    [i setImage:[UIImage imageNamed:@"postcard_bg"]];
    [self.bgScrollV addSubview:i];
    
    
    self.pView = [[PostCardView alloc] initWithFrame:CGRectMake(10, 15, ScreenWidth-20, 0)];
    [self.bgScrollV addSubview:self.pView];
    
    self.originCurrentRect = [self.view convertRect:self.pView.frame fromView:self.bgScrollV];
    
    UITapGestureRecognizer * tapv = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toFullScreenPreview)];
    self.pView.userInteractionEnabled = YES;
    [self.pView addGestureRecognizer:tapv];
    
    [self.topBgV setFrame:CGRectMake(0, 0, ScreenWidth, self.pView.frame.size.height+150)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.pView.frame.size.height+30, ScreenWidth, 60)];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.scrollsToTop = YES;
//    self.tableView.contentOffset = CGPointMake(0, -37);
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    //    _notiTableView.rowHeight = 90;
//    //    _notiTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
//    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
    
//    AllAroundPullView *rightPullView = [[AllAroundPullView alloc] initWithScrollView:self.tableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
//        NSLog(@"--");
////        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
//    }];
//    [self.tableView addSubview:rightPullView];
    
    self.thumbTableView = [[PTEHorizontalTableView alloc] initWithFrame:CGRectMake(0, self.pView.frame.size.height+30, ScreenWidth, 60)];
    self.thumbTableView.tableView = self.tableView;
    self.thumbTableView.delegate = self;
    [self.bgScrollV addSubview:self.thumbTableView];
    
//    self.tableView.contentInset = UIEdgeInsetsMake(32, 0, 32, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
//    self.scrollLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.scrollLeftBtn setFrame:CGRectMake(0, self.templateImageV.frame.size.height+30, 32, 60)];
//    [self.scrollLeftBtn setImage:[UIImage imageNamed:@"scroll_left"] forState:UIControlStateNormal];
//    [self.bgScrollV addSubview:self.scrollLeftBtn];
    
//    self.scrollRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.scrollRightBtn setFrame:CGRectMake(ScreenWidth-32, self.templateImageV.frame.size.height+30, 32, 60)];
//    [self.scrollRightBtn setImage:[UIImage imageNamed:@"scroll_right"] forState:UIControlStateNormal];
//    [self.bgScrollV addSubview:self.scrollRightBtn];
    
    dingzhiB = [UIButton buttonWithType:UIButtonTypeCustom];
    [dingzhiB setFrame:CGRectMake((ScreenWidth-140)/2, self.thumbTableView.frame.size.height+self.pView.frame.size.height+30+15, 120, 39)];
    [dingzhiB setBackgroundImage:[UIImage imageNamed:@"dingzhi_Btn"] forState:UIControlStateNormal];
    [dingzhiB setTitle:@"添加" forState:UIControlStateNormal];
    [dingzhiB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dingzhiB.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.bgScrollV addSubview:dingzhiB];
    [dingzhiB addTarget:self action:@selector(addToList) forControlEvents:UIControlEventTouchUpInside];
    dingzhiB.enabled = NO;
    
    self.titleBgV = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBgV.frame.size.height+10, ScreenWidth, 60)];
    [self.titleBgV setBackgroundColor:[UIColor whiteColor]];
    [self.bgScrollV addSubview:self.titleBgV];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 20)];
    [self.titleL setBackgroundColor:[UIColor clearColor]];
    [self.titleL setText:@"宠物说私宠定制明信片，能开口说话的明信片"];
    [self.titleL setFont:[UIFont systemFontOfSize:15]];
    [self.titleL setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
    [self.titleBgV addSubview:self.titleL];
    
    
    self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, ScreenWidth-20, 20)];
    [self.priceL setBackgroundColor:[UIColor clearColor]];
//    [self.priceL setText:@"￥5元/张"];
    [self.priceL setFont:[UIFont systemFontOfSize:18]];
    [self.priceL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
    [self.titleBgV addSubview:self.priceL];
    self.priceStr = [NSString stringWithFormat:@"￥%@元/张",self.univalent];
    
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:self.priceStr];
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:18] range: NSMakeRange(0, self.priceStr.length)];
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.priceStr.length-4)];
    self.priceL.attributedText = attributedStr;
    
    self.yunfeiL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-120-10, 35, 120, 20)];
    [self.yunfeiL setBackgroundColor:[UIColor clearColor]];
    [self.yunfeiL setText:@"运费:￥10"];
    self.yunfeiL.adjustsFontSizeToFitWidth = YES;
    [self.yunfeiL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.yunfeiL setTextAlignment:NSTextAlignmentRight];
    [self.yunfeiL setFont:[UIFont systemFontOfSize:14]];
    //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.titleBgV addSubview:self.yunfeiL];
    
    
    self.contentBgV = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleBgV.frame.size.height+self.titleBgV.frame.origin.y+10, ScreenWidth, 113)];
    [self.contentBgV setBackgroundColor:[UIColor whiteColor]];
    [self.bgScrollV addSubview:self.contentBgV];
    
    ConsultIconView * cv = [[ConsultIconView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 113)];
    cv.vc = self;
    [self.contentBgV addSubview:cv];
    
//    self.contentTitileL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 20)];
//    [self.contentTitileL setBackgroundColor:[UIColor clearColor]];
//    [self.contentTitileL setText:@"宠物说私宠定制明信片简介"];
//    [self.contentTitileL setFont:[UIFont systemFontOfSize:15]];
//    [self.contentTitileL setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
//    [self.contentBgV addSubview:self.contentTitileL];
//    
//    self.contentStr = @"可敬的克拉斯加都第三方活祭生父讲课费hiulKSLKDD考虑到卡上来对付拉伸的卡卡的拉萨看到了开发快递费近段时间佛挡杀佛降多少开户费简单算法交电话费就看电视费决定是否交话费交话费交电话费决定是否阿萨德拉斯昆德拉SD卡拉开点啦是肯定是肯定\n就回家哈师大就爱看还是点击啊实打实的卷卡式带就撒谎大师级的哈会计师大剧盛典好近啊好的哈师大接受度未婚夫广告费设计等哈说的哈数据的哈克说大红色的克拉斯卡手机的撒娇的卡上就搭理我i奥德克啦升级的卡是基督教奥斯卡的卡就打卡机山大\n接啊肯德基卡机大声地拉见识到了卡手机大神解答老卡机大立科技啊稍等";
//    self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, ScreenWidth-20, 20)];
//    [self.contentL setBackgroundColor:[UIColor clearColor]];
//    [self.contentL setText:self.contentStr];
//    [self.contentL setFont:[UIFont systemFontOfSize:14]];
//    self.contentL.numberOfLines = 0;
//    self.contentL.lineBreakMode = NSLineBreakByCharWrapping;
//    [self.contentL setTextColor:[UIColor colorWithWhite:130/255.0f alpha:1]];
//    [self.contentBgV addSubview:self.contentL];
//    
//    CGSize s = [self.contentStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
//    [self.contentL setFrame:CGRectMake(10, 30, s.width, s.height)];
//    [self.contentBgV setFrame:CGRectMake(0, self.contentBgV.frame.origin.y, ScreenWidth, s.height+30+15)];
    
//    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, self.contentBgV.frame.size.height+self.contentBgV.frame.origin.y);
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, 1000);
    
    self.tolistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tolistBtn setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, ScreenWidth-150, 40)];
    [self.tolistBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tolistBtn];
    [self.tolistBtn addTarget:self action:@selector(toOrderList) forControlEvents:UIControlEventTouchUpInside];
    self.tolistBtn.enabled = NO;
    
    buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1]];
    [buyBtn setTitle:@"立刻下单" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setFrame:CGRectMake(ScreenWidth-150, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, 150, 40)];
    [self.view addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.enabled = NO;
    
    self.picon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 26, 20)];
    [self.picon setImage:[UIImage imageNamed:@"postcard_icon"]];
    [self.tolistBtn addSubview:self.picon];
    
    UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(45, 13, 20, 20)];
    l.backgroundColor = [UIColor clearColor];
    l.text = @"×";
    l.font = [UIFont systemFontOfSize:14];
    l.textColor = [UIColor colorWithWhite:130/255.0f alpha:1];
    [self.tolistBtn addSubview:l];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(55, 13, 40, 20)];
    self.numL.backgroundColor = [UIColor clearColor];
    self.numL.text = @"0";
    self.numL.font = [UIFont systemFontOfSize:14];
    self.numL.adjustsFontSizeToFitWidth = YES;
    self.numL.textColor = [UIColor colorWithWhite:130/255.0f alpha:1];
    [self.tolistBtn addSubview:self.numL];
    
    self.allPriceL = [[UILabel alloc] initWithFrame:CGRectMake(85, 10, ScreenWidth-150-85-10, 20)];
    [self.allPriceL setBackgroundColor:[UIColor clearColor]];
    self.allPriceL.textAlignment = NSTextAlignmentRight;
    //    [self.priceL setText:@"￥5元/张"];
    [self.allPriceL setFont:[UIFont systemFontOfSize:16]];
    self.allPriceL.adjustsFontSizeToFitWidth= YES;
    [self.allPriceL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
    [self.tolistBtn addSubview:self.allPriceL];
    self.allPriceStr =[NSString stringWithFormat:@"共%@元",self.allPrice];
    
    NSMutableAttributedString * attributedStr2 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr2 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
    [attributedStr2 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
    self.allPriceL.attributedText = attributedStr2;
    
//    self.pcJsonDict = [self readPostion];
//
//    [self creatAllSprites];
    
    
    [self getMyShuoShuo];
    
    // Do any additional setup after loading the view.
}
-(void)creatAllSprites
{
    self.headerV = [[EGOImageView alloc] initWithFrame:CGRectZero];
    self.contentImageV = [[EGOImageView alloc] initWithFrame:CGRectZero];
    self.erweimaV = [[EGOImageView alloc] initWithFrame:CGRectZero];
    self.pcContentL = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pcContentL.numberOfLines = 0;
    self.pcContentL.lineBreakMode = NSLineBreakByCharWrapping;
    self.pcContentL.backgroundColor = [UIColor clearColor];
    self.pcContentL.font = [UIFont fontWithName:@"DFPWaWaW5" size:12];
    self.pcContentL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.nicknameL = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nicknameL.backgroundColor = [UIColor clearColor];
    self.nicknameL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.nicknameL.font = [UIFont fontWithName:@"DFPWaWaW5" size:16];
    self.timeL = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeL.backgroundColor = [UIColor whiteColor];
    self.timeL.textColor = [UIColor colorWithRed:220/255.0f green:20/255.0f blue:60/255.0f alpha:1];
    self.timeL.textAlignment = NSTextAlignmentCenter;
    self.timeL.adjustsFontSizeToFitWidth=YES;
    self.timeL2 = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeL2.backgroundColor = [UIColor whiteColor];
    self.timeL2.textColor = [UIColor colorWithRed:220/255.0f green:20/255.0f blue:60/255.0f alpha:1];
    self.timeL2.textAlignment = NSTextAlignmentCenter;
    self.timeL2.adjustsFontSizeToFitWidth =YES;
    
    float spriteW = self.spritesView.frame.size.width;
    float spriteH = self.spritesView.frame.size.height;
    float w = [[self.pcJsonDict objectForKey:@"width"] floatValue];
    float h = [[self.pcJsonDict objectForKey:@"height"] floatValue];
    
    
    NSArray * spArray = [self.pcJsonDict objectForKey:@"sprites"];
    for (int i = 0; i<spArray.count; i++) {
        NSDictionary * t = spArray[i];
        float startX = [self getRatioWithNum:[[t objectForKey:@"startX"] floatValue] All:w];
        float startY = [self getRatioWithNum:[[t objectForKey:@"startY"] floatValue] All:h];
        float width = [self getRatioWithNum:[[t objectForKey:@"spriteWidth"] floatValue] All:w];
        float height = [self getRatioWithNum:[[t objectForKey:@"spriteHeight"] floatValue] All:h];
        NSInteger type = [[t objectForKey:@"type"] integerValue];
//        TalkingBrowse * talking = [self.myShuoShuoArray objectAtIndex:self.selectedIndex];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"MM/dd*yyyy"];
//        NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[talking.publishTime doubleValue]]];
        if (type==1) {
            [self.headerV setFrame:CGRectMake(spriteW*startX, spriteH*startY, spriteW*width, spriteH*height)];
//            self.headerV.imageURL = [NSURL URLWithString:[UserServe sharedUserServe].account.headImgURL];
            [self.spritesView addSubview:self.headerV];
        }
        else if (type==2){
            [self.contentImageV setFrame:CGRectMake(spriteW*startX, spriteH*startY, spriteW*width, spriteH*height)];
            
//            self.contentImageV.imageURL = [NSURL URLWithString:talking.imgUrl];
            [self.spritesView addSubview:self.contentImageV];
        }
        else if (type==3){
            [self.pcContentL setFrame:CGRectMake(spriteW*startX, spriteH*startY, spriteW*width, spriteH*height)];
            //            self.pcContentL.backgroundColor = [UIColor redColor];
//            [self.pcContentL setText:[@"    " stringByAppendingString:talking.descriptionContent]];
            [self.templateImageV addSubview:self.pcContentL];
        }
        else if (type==4){
            [self.timeL setFrame:CGRectMake(spriteW*startX, spriteH*startY, spriteW*width, spriteH*height)];
            //            self.timeL.backgroundColor = [UIColor redColor];
//            self.timeL.text = [messageDateStr componentsSeparatedByString:@"*"][0];
            [self.templateImageV addSubview:self.timeL];
            
        }
        else if (type==5){
            
            [self.timeL2 setFrame:CGRectMake(spriteW*startX, spriteH*startY, spriteW*width, spriteH*height)];
            //            self.timeL2.backgroundColor = [UIColor redColor];
//            self.timeL2.text = [messageDateStr componentsSeparatedByString:@"*"][1];
            [self.templateImageV addSubview:self.timeL2];
            
        }
        else if (type==6)
        {
            [self.nicknameL setFrame:CGRectMake(spriteW*startX, spriteH*startY, spriteW*width, spriteH*height)];
//            [self.nicknameL setText:[UserServe sharedUserServe].account.nickname];
            [self.templateImageV addSubview:self.nicknameL];
        }
        
    }

    
}
-(NSDictionary *)readPostion
{
    NSString *resText = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"postcardjson" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary * dict = [resText JSONValue];
    NSLog(@"postcard_json_data:%@",dict);
    return dict;
}
-(void)displaySprites
{

    NSArray * spArray = [self.pcJsonDict objectForKey:@"sprites"];
    for (int i = 0; i<spArray.count; i++) {
        NSDictionary * t = spArray[i];

        NSInteger type = [[t objectForKey:@"type"] integerValue];
        TalkingBrowse * talking = [self.myShuoShuoArray objectAtIndex:self.selectedIndex];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd*yyyy"];
        NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[talking.publishTime doubleValue]]];
        if (type==1) {
            self.headerV.imageURL = [NSURL URLWithString:[UserServe sharedUserServe].account.headImgURL];
        }
        else if (type==2){
            self.contentImageV.imageURL = [NSURL URLWithString:talking.imgUrl];
        }
        else if (type==3){
            [self.pcContentL setText:[@"    " stringByAppendingString:talking.descriptionContent]];
        }
        else if (type==4){
            self.timeL.text = [messageDateStr componentsSeparatedByString:@"*"][0];
            
        }
        else if (type==5){
            self.timeL2.text = [messageDateStr componentsSeparatedByString:@"*"][1];
            
        }
        else if (type==6)
        {
            [self.nicknameL setText:[UserServe sharedUserServe].account.nickname];
        }
        
    }


}
-(void)shouldToLoadNextPage
{
    NSLog(@"next i am coming");
    if (!self.thumbTableView.iamloading&&(self.myShuoShuoArray.count/20.0f)==self.pageIndex&&self.pageIndex!=0) {
        [self getNextPage];
    }
    
}
-(float)getRatioWithNum:(float)num All:(float)all
{
    return num/all;
}
-(void)getMyShuoShuo
{
    self.thumbTableView.iamloading = YES;
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"petalk" forKey:@"command"];
    [hotDic setObject:@"list4Postcard" forKey:@"options"];
    [hotDic setObject:@"20" forKey:@"pageSize"];
//    [hotDic setObject:[NSString stringWithFormat:@"%d",(int)self.pageIndex] forKey:@"pageIndex"];
    [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    [hotDic setObject:@"O" forKey:@"type"];
    [NetServer requestWithParameters:hotDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.pageIndex++;
        self.myShuoShuoArray = [self getModelArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
        self.selectedIndex = 0;
        self.totalShuoShuoNum = [[[responseObject objectForKey:@"value"] objectForKey:@"totalElements"] integerValue];
        [self.tableView reloadData];
//        [self selectWhichRow:0];
        self.thumbTableView.iamloading = NO;
        
        if (self.myShuoShuoArray.count<=0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有发布任何说说呢，不能打印明信片" delegate:self cancelButtonTitle:@"这就去发" otherButtonTitles:nil, nil];
            alert.tag = 22;
            [alert show];
            return;
        }
        TalkingBrowse * talking = [self.myShuoShuoArray objectAtIndex:self.selectedIndex];
        [self.pView displaySpritesWithTalking:talking];
        [self getProductDetail];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取商品失败，请重新尝试"];
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==22) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)getNextPage
{
    self.thumbTableView.iamloading = YES;
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"petalk" forKey:@"command"];
    [hotDic setObject:@"list4Postcard" forKey:@"options"];
    [hotDic setObject:@"20" forKey:@"pageSize"];
    [hotDic setObject:self.lastId forKey:@"id"];
    [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    [hotDic setObject:@"O" forKey:@"type"];
    [NetServer requestWithParameters:hotDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.pageIndex++;
        [self.myShuoShuoArray addObjectsFromArray:[self getModelArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]]];
        
        [self.tableView reloadData];
        //        [self selectWhichRow:0];
//        [self displaySprites];
        self.thumbTableView.iamloading = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(void)getProductDetail
{
    [SVProgressHUD showWithStatus:@"获取商品信息..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"product" forKey:@"command"];
    [usersDict setObject:@"detailSpecsByCategory" forKey:@"options"];
    [usersDict setObject:@"1" forKey:@"categoryId"];
    if ([UserServe sharedUserServe].userID) {
        [usersDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    }
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = [responseObject objectForKey:@"value"];
        [self.titleL setText:dict[@"name"]];
        self.backInfoDict = dict;
        self.univalent = [dict objectForKey:@"price"];
        self.priceStr = [NSString stringWithFormat:@"￥%@元/张",self.univalent];
        NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:self.priceStr];
        [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:18] range: NSMakeRange(0, self.priceStr.length)];
        [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.priceStr.length-4)];
        self.priceL.attributedText = attributedStr;
        
        self.yunfei = [[dict objectForKey:@"shippingFee"] floatValue];
        if (self.yunfei==0) {
            [self.yunfeiL setText:@"免运费"];
        }
        else{
            [self.yunfeiL setText:[NSString stringWithFormat:@"运费:￥%@",[dict objectForKey:@"shippingFee"]]];
        }
        
        if (!self.detailV) {
            self.detailV = [[UIView alloc] initWithFrame:CGRectMake(0, 113, ScreenWidth, 50)];
            [self.contentBgV addSubview:self.detailV];
            self.goodsDetailHelper = [[GoodsDetailTableViewHelper alloc] initWithTableview:self.detailV PicArray:[dict objectForKey:@"descPics"]];
            //        self.goodsDetailHelper.bgScrollV = self.bgScrollV;
            self.goodsDetailHelper.delegate = self;
            [self.goodsDetailHelper loadContent];
            
            //        [self.detailTableV reloadData];
            NSLog(@"alloc detailv");
        }
        
        [SVProgressHUD dismiss];
        
        dingzhiB.enabled = YES;
        buyBtn.enabled = YES;
        self.tolistBtn.enabled = YES;
        
        if (![Common ifHaveGuided:@"postcard1"]) {
            [self addtishi];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"商品获取失败"];
    }];
    
}

-(void)addtishi
{
    TishiNewView * tishiN = [[TishiNewView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [tishiN show];
    tishiN.dismissHandle = ^{
        //        [self addtishi2];
    };
    
    CGRect u = [[UIApplication sharedApplication].keyWindow convertRect:dingzhiB.frame fromView:self.bgScrollV];
    
    
    UIImageView * h = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-203)/2, u.origin.y+40-153, 203, 153)];
    [h setImage:[UIImage imageNamed:@"postcard_p"]];
    [tishiN addSubview:h];
    
    [Common setGuided:@"postcard1"];
}

-(NSMutableArray *)getSpecsForKey:(NSString *)key
{
    NSDictionary * template = [NSDictionary dictionaryWithObjectsAndKeys:@"postcardTmplId",@"id",[[[[[self.backInfoDict objectForKey:@"specs"] firstObject] objectForKey:@"values"] firstObject] objectForKey:@"id"],@"value", nil];
    NSDictionary * petalkId = [NSDictionary dictionaryWithObjectsAndKeys:@"petalkId",@"id",key,@"value", nil];
    NSMutableArray * array = [NSMutableArray arrayWithObjects:template,petalkId, nil];
    
    return array;
}

-(void)submitOrder
{
    if ([self.numL.text integerValue]<8) {
        [SVProgressHUD showErrorWithStatus:@"明信片最少选择8张才能下单哦~"];
        return;
    }
    
    NSMutableArray * itemArray =[NSMutableArray array];
    NSArray * keysArray = [self.listDict allKeys];
    for (int i = 0; i<keysArray.count; i++) {
        NSMutableDictionary * infoD = [NSMutableDictionary dictionary];
        [infoD setObject:[self.backInfoDict objectForKey:@"id"] forKey:@"productId"];
        [infoD setObject:[self.backInfoDict objectForKey:@"updateTime"] forKey:@"productUpdateTime"];
        [infoD setObject:@"false" forKey:@"useCard"];
        [infoD setObject:[NSString stringWithFormat:@"%d",(int)[[self.listDict objectForKey:keysArray[i]] count]] forKey:@"count"];
        [infoD setObject:[self getSpecsForKey:keysArray[i]] forKey:@"specs"];
        [itemArray addObject:infoD];
    }
   
    [SVProgressHUD showWithStatus:@"提交订单中..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"order" forKey:@"command"];
    [usersDict setObject:@"create" forKey:@"options"];
    [usersDict setObject:itemArray forKey:@"orderItems"];
    if ([UserServe sharedUserServe].userID) {
        [usersDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    }
    [NetServer requestWithEncryptParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self toConfirmPageWithOrderId:[responseObject objectForKey:@"value"]];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"订单提交有问题，稍后再试吧"];
    }];
}
-(void)toConfirmPageWithOrderId:(NSDictionary *)order
{
    
    OrderConfirmViewController * ov = [[OrderConfirmViewController alloc] init];
    if (self.listDict) {
        NSArray * h = [self.listDict objectForKey:[self.listDict allKeys][0]];
        TalkingBrowse * tk = h[0];
        ov.imageUrl = [NSURL URLWithString:tk.thumbImgUrl];
    }
    
    ov.goodsTitle = self.titleL.text;
    ov.univalent = [NSString stringWithFormat:@"%.2f",([[order objectForKey:@"amount"] floatValue]-[[order objectForKey:@"shippingFee"] floatValue])/[[order objectForKey:@"productCount"] floatValue]];
    if ([ov.univalent floatValue]!=[self.univalent floatValue]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不好意思，商品价格发生了变化，请确认好价格再决定是否支付" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    ov.goodsNum = [order objectForKey:@"productCount"];
    ov.allPriceStr = [NSString stringWithFormat:@"%.2f",[[order objectForKey:@"amount"] floatValue]-[[order objectForKey:@"shippingFee"] floatValue]];
    float shippingfee = [[order objectForKey:@"shippingFee"] floatValue];
    if (shippingfee==0) {
        [self.yunfeiL setText:@"免运费"];
    }
    else{
        [self.yunfeiL setText:[NSString stringWithFormat:@"运费:￥%@",[order objectForKey:@"shippingFee"]]];
    }
    ov.yunfei = self.yunfeiL.text;
    ov.orderId = [order objectForKey:@"id"];
    ov.yunfeiValue = [[order objectForKey:@"shippingFee"] floatValue];
    [self.navigationController pushViewController:ov animated:YES];
}
-(void)resetContentSize
{
    [self.contentBgV setFrame:CGRectMake(0, self.titleBgV.frame.size.height+self.titleBgV.frame.origin.y+10, ScreenWidth, 10+self.detailV.frame.size.height+113)];
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, self.contentBgV.frame.origin.y+self.contentBgV.frame.size.height+10);
}
//-(void)selectWhichRow:(NSInteger)row
//{
//    for (int i = 0; i<self.myShuoShuoArray.count; i++) {
//        PostCardThumbTableViewCell * cell = (PostCardThumbTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
//        if (i==row) {
//            cell.maskView.hidden = NO;
//        }
//        else
//            cell.maskView.hidden = YES;
//        
//    }
//}
-(void)toFullScreenPreview
{
//    [SVProgressHUD showErrorWithStatus:@"Developing"];
//     self.imageVBg.transform = CGAffineTransformMakeRotation(90 *M_PI / 180.0);
//    return;
//    PostCardFullScreenPreviewViewController * pv = [[PostCardFullScreenPreviewViewController alloc] init];
//    pv.hideNaviBg = YES;
//    pv.myShuoShuoArray = self.myShuoShuoArray;
//    pv.selectedIndex = self.selectedIndex;
//    pv.pageIndex= self.pageIndex;
//    pv.lastId = self.lastId;
//    pv.listDict = self.listDict;
//    pv.totalShuoShuoNum = self.totalShuoShuoNum;
//    [self.navigationController pushViewController:pv animated:YES];
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
    
    NSArray * as = [self.listDict allKeys];
    int cardNum = 0;
    for (int i = 0; i<as.count; i++) {
        NSArray * fg = [self.listDict objectForKey:as[i]];
        cardNum = cardNum+(int)fg.count;
    }
    self.postCardNum = cardNum;
    [self calAllprice];
    
    CGRect endRect = CGRectMake(20, self.tolistBtn.frame.origin.y+10, 20, 10);
    if (!self.currentPView) {
        self.currentPView = [[PostCardView alloc] initWithFrame:self.originCurrentRect];
    }
    
    [self.view addSubview:self.currentPView];
//    [self.view bringSubviewToFront:self.dingzhiB];
    //    self.currentPView.hidden = YES;
    [self.currentPView displaySpritesWithTalking:self.myShuoShuoArray[self.selectedIndex]];
    __block PostCardView * _pv = self.currentPView;
    [self.currentPView genieInTransitionWithDuration:0.5
                                     destinationRect:endRect
                                     destinationEdge:BCRectEdgeTop
                                          completion:^{
                                              NSLog(@"I'm done!");
                                              
                                              if ([_pv superview]) {
                                                  [_pv removeFromSuperview];
                                                  _pv = nil;
                                              }
                                              [AnimationHelper shakeTheView:self.picon];
                                          }];
    
}

-(void)recalNumAndPrice
{
    NSArray * as = [self.listDict allKeys];
    int cardNum = 0;
    for (int i = 0; i<as.count; i++) {
        NSArray * fg = [self.listDict objectForKey:as[i]];
        cardNum = cardNum+(int)fg.count;
    }
    self.postCardNum = cardNum;
    [self calAllprice];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self recalNumAndPrice];
    [self showNaviBg];
}

-(void)calAllprice
{
//    self.postCardNum = cardNum;
    self.numL.text = [NSString stringWithFormat:@"%d",(int)self.postCardNum];
    
    self.allPrice = [NSString stringWithFormat:@"%.2f",self.postCardNum*[self.univalent floatValue]];
    
    self.allPriceStr =[NSString stringWithFormat:@"共%@元",self.allPrice];
    
    NSMutableAttributedString * attributedStr2 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr2 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
    [attributedStr2 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
    self.allPriceL.attributedText = attributedStr2;
}

-(void)toOrderList
{
    if ([self.numL.text integerValue]<1) {
        [SVProgressHUD showErrorWithStatus:@"至少选择一张明信片哦"];
        return;
    }
    OrderListViewController * ov = [[OrderListViewController alloc] init];
    ov.orderListDict = self.listDict;
    ov.goodsTitle = self.titleL.text;
    ov.goodsInfoDict = self.backInfoDict;
    ov.univalent = self.univalent;
    ov.allPriceStr = self.allPriceStr;
    ov.allNum = self.postCardNum;
    ov.delegate = self;
    [self.navigationController pushViewController:ov animated:YES];
}
-(void)resetPCNum:(NSInteger)num
{
    self.postCardNum = num;
    [self calAllprice];
}
-(void)toIntroV
{
    WebContentViewController * webVC = [[WebContentViewController alloc] init];
    webVC.urlStr = @"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=205284014&idx=1&sn=7fa978b2abe59d83ccb25425a0709371#rd";
    [self.navigationController pushViewController:webVC animated:YES];
}
-(void)tableViewFooterRereshing:(UITableView *)tableview
{
    
}
- (NSInteger)tableView:(PTEHorizontalTableView *)horizontalTableView
 numberOfRowsInSection:(NSInteger)section
{
//    return objects.count;
    return self.myShuoShuoArray.count;
}

- (UITableViewCell *)tableView:(PTEHorizontalTableView *)horizontalTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"thumbPostCardCell";
    PostCardThumbTableViewCell *cell = [horizontalTableView.tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[PostCardThumbTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    TalkingBrowse * talkibg = [self.myShuoShuoArray objectAtIndex:indexPath.row];
    cell.currentIndex = indexPath.row;
    cell.selectedIndex = self.selectedIndex;
    cell.thumbImageV.imageURL = [NSURL URLWithString:talkibg.thumbImgUrl];
//    UILabel * label = cell.contentView.subviews[0];
//    label.text = objects[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(PTEHorizontalTableView *)horizontalTableView widthForCellAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//- (UIView*)tableView:(PTEHorizontalTableView*)horizontalTableView viewForHeaderInSection:(NSInteger)section{
//    UIView *m = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50,90)];
//    [m setBackgroundColor:[UIColor darkGrayColor]];
//    return m;
//}
//
//- (UIView*)tableView:(PTEHorizontalTableView*)horizontalTableView viewForFooterInSection:(NSInteger)section{
//    UIView *m = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50,90)];
//    [m setBackgroundColor:[UIColor redColor]];
//    return m;
//}

- (void)tableView:(PTEHorizontalTableView *)horizontalTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected row -> %ld",(long)indexPath.row);
    
    self.selectedIndex = indexPath.row;
    [horizontalTableView.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
//    [self selectWhichRow:indexPath.row];
//    [self displaySprites];
    TalkingBrowse * talking = [self.myShuoShuoArray objectAtIndex:self.selectedIndex];
    [self.pView displaySpritesWithTalking:talking];
}

-(void)toConfirmPage
{

    OrderConfirmViewController * ov = [[OrderConfirmViewController alloc] init];
    [self.navigationController pushViewController:ov animated:YES];
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
