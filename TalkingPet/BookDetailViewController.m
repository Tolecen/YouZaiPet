//
//  BookDetailViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/5/25.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BookDetailViewController.h"

@interface BookDetailViewController ()

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bookNum = 1;
    self.mcardNum = 2;
    self.allPrice = 0.0f;
    self.useHowManyMCard = 0;
    self.haveMCardPrice = YES;
    

    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    self.title = @"定制成长日记";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
//    [self setRightButtonWithName:nil BackgroundImg:@"nav_button_rule" Target:@selector(toIntroV)];
    
    
    self.bgScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame)-40-navigationBarHeight)];
    self.bgScrollV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgScrollV];
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, 2000);
    
    
    self.sameView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4*ScreenWidth/5)];
    _sameView.delegate = self;
    _sameView.dataSource = self;
//    self.sameView.layer.cornerRadius = 5;
//    self.sameView.layer.masksToBounds = YES;
    //    _sameView.hidden = YES;
    [self.bgScrollV addSubview:_sameView];
    
    UIPageControl * page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 4*ScreenWidth/5-20, ScreenWidth, 20)];
    page.currentPageIndicatorTintColor = [UIColor colorWithRed:135/255.0 green:130/255.0 blue:250/255.0 alpha:1];
    page.pageIndicatorTintColor = [UIColor colorWithWhite:200/255.0 alpha:1];
    _sameView.pageControl = page;
    [_sameView addSubview:page];
    
    self.titlebg = [[UIView alloc] initWithFrame:CGRectMake(0, _sameView.frame.origin.y+_sameView.frame.size.height+10, ScreenWidth, 50)];
    self.titlebg.backgroundColor = [UIColor whiteColor];
    
    [self.bgScrollV addSubview:self.titlebg];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 20)];
    [self.titleL setBackgroundColor:[UIColor clearColor]];
    [self.titleL setFont:[UIFont systemFontOfSize:15]];
    [self.titleL setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
    [self.titlebg addSubview:self.titleL];
    [self.titleL setText:@"成长日记"];
    
    self.secondTitleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, ScreenWidth-20, 20)];
    [self.secondTitleL setBackgroundColor:[UIColor clearColor]];
    [self.secondTitleL setFont:[UIFont systemFontOfSize:13]];
    self.secondTitleL.numberOfLines = 0;
    self.secondTitleL.lineBreakMode = NSLineBreakByCharWrapping;
    [self.secondTitleL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.titlebg addSubview:self.secondTitleL];
    [self.secondTitleL setText:@"嫁鸡随鸡啊；是考虑到卡死了都你说的你解散的"];
    
    self.priceBg = [[UIView alloc] initWithFrame:CGRectMake(0, self.titlebg.frame.origin.y+self.titlebg.frame.size.height+10, ScreenWidth, 40*((ScreenWidth-30)/2)/69+20)];
    self.priceBg.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.priceBg];
    
    self.bottomBg = [[UIView alloc] initWithFrame:CGRectMake(0, self.priceBg.frame.origin.y+self.priceBg.frame.size.height, ScreenWidth, 60)];
    self.bottomBg.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.bottomBg];
    
    self.mCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mCardBtn setFrame:CGRectMake(10, 10, (ScreenWidth-30)/2, 40*((ScreenWidth-30)/2)/69)];
    [self.mCardBtn setBackgroundColor:[UIColor whiteColor]];
    [self.mCardBtn setImage:[UIImage imageNamed:@"mkayonghu-xuanzhong"] forState:UIControlStateNormal];
    [self.priceBg addSubview:self.mCardBtn];
    [self.mCardBtn addTarget:self action:@selector(selectMcardBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.normalCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalCardBtn setFrame:CGRectMake((ScreenWidth-30)/2+20, 10, (ScreenWidth-30)/2, 40*((ScreenWidth-30)/2)/69)];
    [self.normalCardBtn setBackgroundColor:[UIColor whiteColor]];
    [self.normalCardBtn setImage:[UIImage imageNamed:@"putongyonghu-weixuanzhong"] forState:UIControlStateNormal];
    [self.priceBg addSubview:self.normalCardBtn];
    [self.normalCardBtn addTarget:self action:@selector(selectNormalBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.nnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    self.nnView.backgroundColor = [UIColor clearColor];
    [self.priceBg addSubview:self.nnView];
    
    UILabel * b = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
    b.text = @"定制价格:";
    b.backgroundColor = [UIColor clearColor];
    b.font = [UIFont boldSystemFontOfSize:14];
    b.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    [self.nnView addSubview:b];
    
//    self.nPriceStr = @"￥128";
//    self.nPrice = 128.0f;
    
    self.nnPriceL = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 120, 20)];
    [self.nnPriceL setBackgroundColor:[UIColor clearColor]];
//    [self.nnPriceL setText:self.nPriceStr];
    [self.nnPriceL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
//    [self.nnPriceL setTextAlignment:NSTextAlignmentCenter];
    [self.nnPriceL setFont:[UIFont systemFontOfSize:24]];
    //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.nnView addSubview:self.nnPriceL];
//    self.nnPriceL.text = self.nPriceStr;
    
    self.nnUnivalentL = [[UILabel alloc] initWithFrame:CGRectMake(80,15, 0, 20)];
    [self.nnUnivalentL setBackgroundColor:[UIColor clearColor]];
    [self.nnUnivalentL setText:self.nPriceStr];
    self.nnUnivalentL.adjustsFontSizeToFitWidth = YES;
    [self.nnUnivalentL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
//    [self.nnUnivalentL setTextAlignment:NSTextAlignmentCenter];
    [self.nnUnivalentL setFont:[UIFont systemFontOfSize:14]];
    //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.nnView addSubview:self.nnUnivalentL];

    
    UILabel * mtl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, (ScreenWidth-30)/2, 20)];
    [mtl setBackgroundColor:[UIColor clearColor]];
    [mtl setText:@"M卡价格"];
    [mtl setTextAlignment:NSTextAlignmentCenter];
    [mtl setFont:[UIFont boldSystemFontOfSize:12]];
    [mtl setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
    [self.mCardBtn addSubview:mtl];
    
    self.mPriceStr = @"￥68";
    self.mPrice = 68.0f;
    self.mPriceL = [[UILabel alloc] initWithFrame:CGRectMake(0, (40*((ScreenWidth-30)/2)/69)/2-10, (ScreenWidth-30)/2, 20)];
    [self.mPriceL setBackgroundColor:[UIColor clearColor]];
    [self.mPriceL setText:self.mPriceStr];
    [self.mPriceL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
    [self.mPriceL setTextAlignment:NSTextAlignmentCenter];
    [self.mPriceL setFont:[UIFont systemFontOfSize:24]];
//    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.mCardBtn addSubview:self.mPriceL];
    self.mPriceL.text = self.mPriceStr;
    
//    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:self.mPriceStr];
//    [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:18] range: NSMakeRange(0, self.mPriceStr.length)];
//    [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.mPriceStr.length-1)];
//    self.mPriceL.attributedText = attributedStr;
    
    self.mUnivalentStr = @"(￥0.68/页，共100页)";
    self.mUnivalentL = [[UILabel alloc] initWithFrame:CGRectMake(20, (40*((ScreenWidth-30)/2)/69)-25, (ScreenWidth-30)/2-40, 20)];
    [self.mUnivalentL setBackgroundColor:[UIColor clearColor]];
    [self.mUnivalentL setText:self.mUnivalentStr];
    [self.mUnivalentL setTextAlignment:NSTextAlignmentCenter];
    self.mUnivalentL.adjustsFontSizeToFitWidth = YES;
    [self.mUnivalentL setFont:[UIFont systemFontOfSize:12]];
    [self.mUnivalentL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.mCardBtn addSubview:self.mUnivalentL];
    
    
    UILabel * mtl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, (ScreenWidth-30)/2, 20)];
    [mtl2 setBackgroundColor:[UIColor clearColor]];
    [mtl2 setText:@"普通价格"];
    [mtl2 setTextAlignment:NSTextAlignmentCenter];
    [mtl2 setFont:[UIFont boldSystemFontOfSize:12]];
    [mtl2 setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
    [self.normalCardBtn addSubview:mtl2];
    
    self.nPriceStr = @"￥128";
    self.nPrice = 128.0f;
    self.nPriceL = [[UILabel alloc] initWithFrame:CGRectMake(0, (40*((ScreenWidth-30)/2)/69)/2-10, (ScreenWidth-30)/2, 20)];
    [self.nPriceL setBackgroundColor:[UIColor clearColor]];
    [self.nPriceL setText:self.nPriceStr];
    [self.nPriceL setTextColor:[UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1]];
    [self.nPriceL setTextAlignment:NSTextAlignmentCenter];
    [self.nPriceL setFont:[UIFont systemFontOfSize:24]];
    //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.normalCardBtn addSubview:self.nPriceL];
    self.nPriceL.text = self.nPriceStr;
    
//    NSMutableAttributedString * attributedStr2 = [[NSMutableAttributedString alloc] initWithString:self.nPriceStr];
//    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:18] range: NSMakeRange(0, self.nPriceStr.length)];
//    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.nPriceStr.length-1)];
//    self.nPriceL.attributedText = attributedStr2;
    
    self.nUnivalentStr = @"(￥1.28/页，共100页)";
    self.nUnivalentL = [[UILabel alloc] initWithFrame:CGRectMake(20, (40*((ScreenWidth-30)/2)/69)-25, (ScreenWidth-30)/2-40, 20)];
    [self.nUnivalentL setBackgroundColor:[UIColor clearColor]];
    [self.nUnivalentL setText:self.nUnivalentStr];
    [self.nUnivalentL setTextAlignment:NSTextAlignmentCenter];
    self.nUnivalentL.adjustsFontSizeToFitWidth = YES;
    [self.nUnivalentL setFont:[UIFont systemFontOfSize:12]];
    [self.nUnivalentL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.normalCardBtn addSubview:self.nUnivalentL];
    
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 1)];
    lineV.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
    [self.bottomBg addSubview:lineV];
    
    UILabel * sl = [[UILabel alloc] initWithFrame:CGRectMake(10, lineV.frame.size.height+lineV.frame.origin.y+20, 100, 20)];
    sl.backgroundColor = [UIColor clearColor];
    sl.font = [UIFont boldSystemFontOfSize:14];
    sl.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    sl.text = @"选择数量：";
    [self.bottomBg addSubview:sl];
    
    

    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(90, lineV.frame.size.height+lineV.frame.origin.y+15, 60, 30)];
    [self.numL setBackgroundColor:[UIColor clearColor]];
    [self.numL setText:[NSString stringWithFormat:@"%d",self.bookNum]];
    self.numL.adjustsFontSizeToFitWidth = YES;
    [self.numL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
    [self.numL setTextAlignment:NSTextAlignmentCenter];
    [self.numL setFont:[UIFont systemFontOfSize:24]];
    //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.bottomBg addSubview:self.numL];
    
    minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusBtn setBackgroundColor:[UIColor clearColor]];
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor colorWithWhite:120/255.0f alpha:1] forState:UIControlStateNormal];
    [minusBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [minusBtn setFrame:CGRectMake(70, lineV.frame.size.height+lineV.frame.origin.y+15, 30, 30)];
    [self.bottomBg addSubview:minusBtn];
    [minusBtn addTarget:self action:@selector(minusBtn) forControlEvents:UIControlEventTouchUpInside];
    minusBtn.enabled = NO;
    
    plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setBackgroundColor:[UIColor clearColor]];
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [plusBtn setTitleColor:[UIColor colorWithWhite:120/255.0f alpha:1] forState:UIControlStateNormal];
    [plusBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [plusBtn setFrame:CGRectMake(140, lineV.frame.size.height+lineV.frame.origin.y+15, 30, 30)];
    [self.bottomBg addSubview:plusBtn];
    [plusBtn addTarget:self action:@selector(plusBtn) forControlEvents:UIControlEventTouchUpInside];
    plusBtn.enabled = NO;
    
//    self.mCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-120, lineV.frame.size.height+lineV.frame.origin.y+5, 120, 20)];
//    [self.mCardLabel setBackgroundColor:[UIColor clearColor]];
//    [self.mCardLabel setText:[NSString stringWithFormat:@"M卡剩余:%d",self.mcardNum]];
//    self.mCardLabel.adjustsFontSizeToFitWidth = YES;
//    [self.mCardLabel setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
//    [self.mCardLabel setTextAlignment:NSTextAlignmentRight];
//    [self.mCardLabel setFont:[UIFont systemFontOfSize:14]];
//    //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
//    [self.bottomBg addSubview:self.mCardLabel];
    
    self.yunfeiL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-120-10, lineV.frame.size.height+lineV.frame.origin.y+20, 120, 20)];
    [self.yunfeiL setBackgroundColor:[UIColor clearColor]];
    [self.yunfeiL setText:@"运费:￥10"];
    self.yunfeiL.adjustsFontSizeToFitWidth = YES;
    [self.yunfeiL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.yunfeiL setTextAlignment:NSTextAlignmentRight];
    [self.yunfeiL setFont:[UIFont systemFontOfSize:14]];
    //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.bottomBg addSubview:self.yunfeiL];
    
    UIView * lineV2 = [[UIView alloc] initWithFrame:CGRectMake(10, 59, ScreenWidth-20, 1)];
    lineV2.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
    [self.bottomBg addSubview:lineV2];

    ConsultIconView * cv = [[ConsultIconView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 113)];
    cv.vc = self;
    [self.bottomBg addSubview:cv];
    
    UIButton * tolistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tolistBtn setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, ScreenWidth-150, 40)];
    [tolistBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tolistBtn];
//    [tolistBtn addTarget:self action:@selector(toOrderList) forControlEvents:UIControlEventTouchUpInside];
    
    buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1]];
    [buyBtn setTitle:@"立刻下单" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setFrame:CGRectMake(ScreenWidth-150, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, 150, 40)];
    [self.view addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.enabled = NO;
    
    self.picon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 18, 17)];
    [self.picon setImage:[UIImage imageNamed:@"chengzhangriji_icon"]];
    [tolistBtn addSubview:self.picon];
    
    UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(40, 13, 20, 20)];
    l.backgroundColor = [UIColor clearColor];
    l.text = @"×";
    l.font = [UIFont systemFontOfSize:14];
    l.textColor = [UIColor colorWithWhite:130/255.0f alpha:1];
    [tolistBtn addSubview:l];
    
    self.allnumL = [[UILabel alloc] initWithFrame:CGRectMake(50, 13, 40, 20)];
    self.allnumL.backgroundColor = [UIColor clearColor];
    self.allnumL.text = [NSString stringWithFormat:@"%d",self.bookNum];
    self.allnumL.font = [UIFont systemFontOfSize:14];
    self.allnumL.adjustsFontSizeToFitWidth = YES;
    self.allnumL.textColor = [UIColor colorWithWhite:130/255.0f alpha:1];
    [tolistBtn addSubview:self.allnumL];
    
    self.allPriceL = [[UILabel alloc] initWithFrame:CGRectMake(85, 10, ScreenWidth-150-85-10, 20)];
    [self.allPriceL setBackgroundColor:[UIColor clearColor]];
    self.allPriceL.textAlignment = NSTextAlignmentRight;
    //    [self.priceL setText:@"￥5元/张"];
    [self.allPriceL setFont:[UIFont systemFontOfSize:16]];
    self.allPriceL.adjustsFontSizeToFitWidth= YES;
    [self.allPriceL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
    [tolistBtn addSubview:self.allPriceL];
    self.allPriceStr = [NSString stringWithFormat:@"共%.2f元",self.allPrice];
    
    NSMutableAttributedString * attributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
    self.allPriceL.attributedText = attributedStr3;

    [self getProductDetail];
    // Do any additional setup after loading the view.
}

-(void)getProductDetail
{
    [SVProgressHUD showWithStatus:@"获取商品信息..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"product" forKey:@"command"];
    [usersDict setObject:@"detailSpecsByCategory" forKey:@"options"];
    [usersDict setObject:@"2" forKey:@"categoryId"];
    if ([UserServe sharedUserServe].userID) {
        [usersDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    }
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = [responseObject objectForKey:@"value"];
        self.backInfoDict = dict;
        self.haveMCardPrice = NO;
        self.productId = [dict objectForKey:@"id"];
        self.titleL.text = [dict objectForKey:@"name"];
        self.secondTitleStr = [dict objectForKey:@"title"];
//        self.nUnivalentStr = [NSString stringWithFormat:@"(￥%@/页，共%d页)",[dict objectForKey:@"price"],(int)self.totalPages];
        self.nUnivalentStr = @"";
        
//        self.nPrice = [[dict objectForKey:@"price"] floatValue]*self.totalPages;
        self.nPrice = [[dict objectForKey:@"price"] floatValue];
        self.nPriceStr = [NSString stringWithFormat:@"￥%.2f",self.nPrice];
        
//        self.yunfeiL.text = [NSString stringWithFormat:@"运费：￥%@",[dict objectForKey:@"shippingFee"]];
        self.yunfei = [[dict objectForKey:@"shippingFee"] floatValue];
        if (self.yunfei==0) {
            [self.yunfeiL setText:@"免运费"];
        }
        else{
            [self.yunfeiL setText:[NSString stringWithFormat:@"运费:￥%@",[dict objectForKey:@"shippingFee"]]];
        }
        
        self.allPrice = self.nPrice*self.bookNum;
        self.allPriceStr = [NSString stringWithFormat:@"共%.2f元",self.allPrice];
        
        NSMutableAttributedString * attributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
        [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
        [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
        [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
        [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
        self.allPriceL.attributedText = attributedStr3;
        
        self.desPicsArray = [dict objectForKey:@"descPics"];
        
        [self loadTheContent];
        
        self.picsArray = [dict objectForKey:@"pics"];
        
        [self.sameView reloadData];
        [SVProgressHUD dismiss];
        
        minusBtn.enabled = YES;
        plusBtn.enabled = YES;
        buyBtn.enabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"商品获取失败"];
    }];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)loadTheContent
{
    CGSize o = [self.secondTitleStr sizeWithFont:self.secondTitleL.font constrainedToSize:CGSizeMake(self.secondTitleL.frame.size.width, 200) lineBreakMode:NSLineBreakByCharWrapping];
    self.secondTitleL.frame = CGRectMake(self.secondTitleL.frame.origin.x, self.secondTitleL.frame.origin.y, self.secondTitleL.frame.size.width, o.height);
    self.secondTitleL.text = self.secondTitleStr;
    [self.titlebg setFrame:CGRectMake(0, _sameView.frame.origin.y+_sameView.frame.size.height+10, ScreenWidth, 25+o.height+5)];
    if (self.haveMCardPrice) {
        self.mCardBtn.hidden = NO;
        self.normalCardBtn.hidden = NO;
        self.nnView.hidden = YES;
        
        
        [self.priceBg setFrame:CGRectMake(0, self.titlebg.frame.origin.y+self.titlebg.frame.size.height+10, ScreenWidth, 40*((ScreenWidth-30)/2)/69+20)];
        [self.bottomBg setFrame:CGRectMake(0, self.priceBg.frame.origin.y+self.priceBg.frame.size.height, ScreenWidth, 1000)];
        
        if (self.mcardNum>0) {
            [self.mCardBtn setImage:[UIImage imageNamed:@"mkayonghu-xuanzhong"] forState:UIControlStateNormal];
            [self.normalCardBtn setImage:[UIImage imageNamed:@"putongyonghu-weixuanzhong"] forState:UIControlStateNormal];
            self.useMCard = YES;
        }
        else
        {
            [self.mCardBtn setImage:[UIImage imageNamed:@"mkayonghu-weixuanzhong"] forState:UIControlStateNormal];
            [self.normalCardBtn setImage:[UIImage imageNamed:@"putongyonghu-xuanzhong"] forState:UIControlStateNormal];
            self.useMCard = NO;
        }

    }
    else
    {
        self.mCardBtn.hidden = YES;
        self.normalCardBtn.hidden = YES;
        self.nnView.hidden = NO;
        self.useMCard = NO;
        
        [self.priceBg setFrame:CGRectMake(0, self.titlebg.frame.origin.y+self.titlebg.frame.size.height+10, ScreenWidth, 50)];
        [self.bottomBg setFrame:CGRectMake(0, self.priceBg.frame.origin.y+self.priceBg.frame.size.height, ScreenWidth, 1000)];
        
        
        self.nnPriceL.text = self.nPriceStr;
        
        CGSize i = [self.nnPriceL.text sizeWithFont:[UIFont systemFontOfSize:24] constrainedToSize:CGSizeMake(120, 20)];
        
        
        [self.nnUnivalentL setFrame:CGRectMake(self.nnPriceL.frame.origin.x+i.width+10, 15, ScreenWidth-80-i.width, 20)];
        self.nnUnivalentL.text = self.nUnivalentStr;
        
        
    }

    if (!self.detailTableV) {
        self.detailTableV = [[UIView alloc] initWithFrame:CGRectMake(0, 60+113, ScreenWidth, 50)];
        [self.bottomBg addSubview:self.detailTableV];
        self.goodsDetailHelper = [[GoodsDetailTableViewHelper alloc] initWithTableview:self.detailTableV PicArray:self.desPicsArray];
//        self.goodsDetailHelper.bgScrollV = self.bgScrollV;
        self.goodsDetailHelper.delegate = self;
        [self.goodsDetailHelper loadContent];

//        [self.detailTableV reloadData];
        NSLog(@"alloc detailv");
    }
}
-(void)resetContentSize
{
    [self.bottomBg setFrame:CGRectMake(0, self.priceBg.frame.origin.y+self.priceBg.frame.size.height, ScreenWidth, 60+113+self.detailTableV.frame.size.height)];
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, self.bottomBg.frame.origin.y+self.bottomBg.frame.size.height+10);
}
-(void)minusBtn
{
    if (self.bookNum<=0) {
        return;
    }
    
    if (self.bookNum>self.useHowManyMCard) {
        self.allPrice = self.allPrice-self.nPrice;
    }
    else{
        self.allPrice = self.allPrice-self.mPrice;
        self.mcardNum++;
        self.useHowManyMCard--;
        [self.mCardLabel setText:[NSString stringWithFormat:@"M卡剩余:%d",self.mcardNum]];
        
    }
    [self.numL setText:[NSString stringWithFormat:@"%d",self.bookNum>0?--self.bookNum:0]];

    
    self.allnumL.text = self.numL.text;
    
    self.allPriceStr = [NSString stringWithFormat:@"共%.2f元",self.allPrice];
    
    NSMutableAttributedString * attributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
    self.allPriceL.attributedText = attributedStr3;
    [AnimationHelper shakeTheView:self.picon];
}
-(void)plusBtn
{
    if (self.useMCard) {
        if (self.mcardNum>0) {
            [self.numL setText:[NSString stringWithFormat:@"%d",++self.bookNum]];
            self.allPrice = self.allPrice+self.mPrice;
            self.mcardNum--;
            self.useHowManyMCard++;
            [self.mCardLabel setText:[NSString stringWithFormat:@"M卡剩余:%d",self.mcardNum]];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的可用M卡已不足，请使用正常售价继续添加商品" delegate:self cancelButtonTitle:@"好的，知道了" otherButtonTitles:nil, nil];
            [alert show];
            [self selectNormalBtn];
        }
    }
    else
    {
        [self.numL setText:[NSString stringWithFormat:@"%d",++self.bookNum]];
        self.allPrice = self.allPrice+self.nPrice;

    }
    
    self.allnumL.text = self.numL.text;
    
    self.allPriceStr = [NSString stringWithFormat:@"共%.2f元",self.allPrice];
    
    NSMutableAttributedString * attributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
    self.allPriceL.attributedText = attributedStr3;
    [AnimationHelper shakeTheView:self.picon];

    
}
-(void)selectMcardBtn
{
    if (self.mcardNum<=0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的可用M卡已不足，请使用正常售价继续添加商品" delegate:self cancelButtonTitle:@"好的，知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self.mCardBtn setImage:[UIImage imageNamed:@"mkayonghu-xuanzhong"] forState:UIControlStateNormal];
    [self.normalCardBtn setImage:[UIImage imageNamed:@"putongyonghu-weixuanzhong"] forState:UIControlStateNormal];
    self.useMCard = YES;
}
-(void)selectNormalBtn
{
    [self.mCardBtn setImage:[UIImage imageNamed:@"mkayonghu-weixuanzhong"] forState:UIControlStateNormal];
    [self.normalCardBtn setImage:[UIImage imageNamed:@"putongyonghu-xuanzhong"] forState:UIControlStateNormal];
    self.useMCard = NO;
}

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(ScreenWidth, 4*ScreenWidth/5);
}
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
//    if (self.headerArray.count) {
//        if (self.headerArray.count<=1) {
//            self.sameView.pageControl.hidden = YES;
//        }
//        else
//            self.sameView.pageControl.hidden = NO;
//        return self.headerArray.count;
//    }
//    self.sameView.pageControl.hidden = YES;
    return self.picsArray?self.picsArray.count:1;
}
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{

    EGOImageView * imageV = (EGOImageView*)[flowView dequeueReusableCell];
    if (!imageV) {
        imageV = [[EGOImageView alloc] init];
        imageV.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        imageV.frame = CGRectMake(0, 0, ScreenWidth-20, (ScreenWidth-20)*(1/4.0f));
    }
    imageV.tag = 200+index;
//    [imageV addTarget:self action:@selector(tagButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    if (self.picsArray) {
        imageV.imageURL = [NSURL URLWithString:[self.picsArray[index] objectForKey:@"pic"]];
    }
    
    return imageV;
}
-(void)tagButtonTouched:(EGOImageButton *)sender
{
    
}
-(NSMutableArray *)getSpecs
{
    NSDictionary * template = [NSDictionary dictionaryWithObjectsAndKeys:@"diaryTmplId",@"id",[[[[[self.backInfoDict objectForKey:@"specs"] firstObject] objectForKey:@"values"] firstObject] objectForKey:@"id"],@"value", nil];
    NSMutableArray * array = [NSMutableArray arrayWithObjects:template, nil];
    
    return array;
}
-(void)submitOrder
{
    if (self.totalNum<100) {
        UIAlertView * u = [[UIAlertView alloc] initWithTitle:@"提示" message:@"说说不足100条，无法制作哦，继续加油发说说吧~" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [u show];
        return;
    }
    if (self.bookNum<1) {
        [SVProgressHUD showErrorWithStatus:@"成长日记数量请最少选择1本哦"];
        return;
    }
    NSMutableArray * itemArray =[NSMutableArray array];
    NSMutableDictionary * infoD = [NSMutableDictionary dictionary];
    [infoD setObject:[self.backInfoDict objectForKey:@"id"] forKey:@"productId"];
    [infoD setObject:[self.backInfoDict objectForKey:@"updateTime"] forKey:@"productUpdateTime"];
    [infoD setObject:@"false" forKey:@"useCard"];
    [infoD setObject:[NSString stringWithFormat:@"%d",self.bookNum] forKey:@"count"];
    [infoD setObject:[self getSpecs] forKey:@"specs"];
    [itemArray addObject:infoD];
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
        [SVProgressHUD showErrorWithStatus:@"订单提交有问题，请尝试下拉刷新此页重新提交"];
    }];
}
-(void)toConfirmPageWithOrderId:(NSDictionary *)order
{

    OrderConfirmViewController * ov = [[OrderConfirmViewController alloc] init];
    if (self.picsArray&&self.picsArray.count>0) {
        ov.imageUrl = [NSURL URLWithString:[self.picsArray[0] objectForKey:@"pic"]];
    }
    
    ov.goodsTitle = self.titleL.text;
    ov.univalent = [NSString stringWithFormat:@"%.2f",([[order objectForKey:@"amount"] floatValue]-[[order objectForKey:@"shippingFee"] floatValue])/[[order objectForKey:@"productCount"] floatValue]];
    if ([ov.univalent floatValue]!=self.nPrice) {
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
-(void)toIntroV
{
    WebContentViewController * webVC = [[WebContentViewController alloc] init];
    webVC.urlStr = @"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=205284014&idx=1&sn=7fa978b2abe59d83ccb25425a0709371#rd";
    [self.navigationController pushViewController:webVC animated:YES];
}
-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
