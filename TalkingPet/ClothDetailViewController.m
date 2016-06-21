//
//  ClothDetailViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/5/29.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ClothDetailViewController.h"

@interface ClothDetailViewController ()

@end

@implementation ClothDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.haveMCardPrice = NO;
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    self.bgScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame)-40-navigationBarHeight)];
    self.bgScrollV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgScrollV];
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, 2000);
    
    
    self.sameView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4*ScreenWidth/5)];
    _sameView.delegate = self;
    _sameView.dataSource = self;
    self.sameView.layer.cornerRadius = 5;
    self.sameView.layer.masksToBounds = YES;
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
    
    self.secondTitleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, ScreenWidth-20, 20)];
    [self.secondTitleL setBackgroundColor:[UIColor clearColor]];
    [self.secondTitleL setFont:[UIFont systemFontOfSize:13]];
    self.secondTitleL.numberOfLines = 0;
    self.secondTitleL.lineBreakMode = NSLineBreakByCharWrapping;
    [self.secondTitleL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.titlebg addSubview:self.secondTitleL];
    
    self.bottomBg = [[UIView alloc] initWithFrame:CGRectMake(0, self.titlebg.frame.origin.y+self.titlebg.frame.size.height+10, ScreenWidth, 1000)];
    self.bottomBg.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.bottomBg];
    
//    self.mcardPriceBg = [[UIView alloc] initWithFrame:CGRectMake(10, 10, (ScreenWidth-30)/2, 55)];
//    self.mcardPriceBg.backgroundColor = [UIColor clearColor];
////    [self.mCardBtn setFrame:];
//    [self.mcardPriceBg setBackgroundColor:[UIColor whiteColor]];
////    [self.mcardPriceBg setImage:[UIImage imageNamed:@"mkayonghu-xuanzhong"] forState:UIControlStateNormal];
//    [self.bottomBg addSubview:self.mcardPriceBg];
////    [self.mcardPriceBg addTarget:self action:@selector(selectMcardBtn) forControlEvents:UIControlEventTouchUpInside];
    
//    self.normalPriceBg = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-30)/2+20, 10, (ScreenWidth-30)/2, 55)];
////    [self.normalCardBtn setFrame:];
//    [self.normalPriceBg setBackgroundColor:[UIColor clearColor]];
////    [self.normalCardBtn setImage:[UIImage imageNamed:@"putongyonghu-weixuanzhong"] forState:UIControlStateNormal];
//    [self.bottomBg addSubview:self.normalPriceBg];
////    [self.normalCardBtn addTarget:self action:@selector(selectNormalBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.mtl  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    [self.mtl setBackgroundColor:[UIColor clearColor]];
//    [mtl setTextAlignment:NSTextAlignmentCenter];
    [self.mtl setFont:[UIFont systemFontOfSize:14]];
    [self.mtl setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
    [self.bottomBg addSubview:self.mtl];
    
    self.mPriceL = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, (ScreenWidth-30)/2-80, 20)];
    [self.mPriceL setBackgroundColor:[UIColor clearColor]];
    [self.mPriceL setText:self.mPriceStr];
    [self.mPriceL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
//    [self.mPriceL setTextAlignment:NSTextAlignmentCenter];
    [self.mPriceL setFont:[UIFont systemFontOfSize:22]];
    //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.bottomBg addSubview:self.mPriceL];
    
//    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:self.mPriceStr];
//    [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:18] range: NSMakeRange(0, self.mPriceStr.length)];
//    [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.mPriceStr.length-1)];
//    self.mPriceL.attributedText = attributedStr;
    

    
    
    self.mtl2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,100, 20)];
    [self.mtl2  setBackgroundColor:[UIColor clearColor]];
//    [mtl2 setTextAlignment:NSTextAlignmentCenter];
    self.mtl2.text = @"优惠价：";
    [self.mtl2  setFont:[UIFont boldSystemFontOfSize:14]];
    [self.mtl2  setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
    [self.bottomBg addSubview:self.mtl2 ];
    
    self.nPrice = 128;
    self.nPriceL = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, ScreenWidth-80-20, 20)];
    [self.nPriceL setBackgroundColor:[UIColor clearColor]];
    [self.nPriceL setText:self.nPriceStr];
    self.nPriceL.adjustsFontSizeToFitWidth = YES;
    [self.nPriceL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
//    [self.nPriceL setTextAlignment:NSTextAlignmentCenter];
    [self.nPriceL setFont:[UIFont systemFontOfSize:22]];
    //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.bottomBg addSubview:self.nPriceL];
    
//    NSMutableAttributedString * attributedStr2 = [[NSMutableAttributedString alloc] initWithString:self.nPriceStr];
//    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:18] range: NSMakeRange(0, self.nPriceStr.length)];
//    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.nPriceStr.length-1)];
//    self.nPriceL.attributedText = attributedStr2;
    

//    UIView * lineVs = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, self.mcardPriceBg.frame.origin.y+5, 1, self.mcardPriceBg.frame.size.height)];
//    lineVs.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
//    [self.bottomBg addSubview:lineVs];
    
    self.yunfeiL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-120-10, 35, 120, 20)];
    [self.yunfeiL setBackgroundColor:[UIColor clearColor]];
    self.yunfeiL.adjustsFontSizeToFitWidth = YES;
    [self.yunfeiL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.yunfeiL setTextAlignment:NSTextAlignmentRight];
    [self.yunfeiL setFont:[UIFont systemFontOfSize:14]];
    //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.bottomBg addSubview:self.yunfeiL];

    
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 60, ScreenWidth-20, 1)];
    lineV.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
    [self.bottomBg addSubview:lineV];
    
    ConsultIconView * cv = [[ConsultIconView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 113)];
    cv.vc = self;
    [self.bottomBg addSubview:cv];

    
    
    self.dingzhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dingzhiBtn setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, ScreenWidth, 40)];
    self.dingzhiBtn.backgroundColor = [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1];
    [self.dingzhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dingzhiBtn setTitle:@"定制" forState:UIControlStateNormal];
    [self.view addSubview:self.dingzhiBtn];
    [self.dingzhiBtn addTarget:self action:@selector(toCustomizePage) forControlEvents:UIControlEventTouchUpInside];
    self.dingzhiBtn.enabled = NO;
    
    [self getClothDetail];
    // Do any additional setup after loading the view.
}
-(void)getClothDetail
{
    [SVProgressHUD showWithStatus:@"获取商品信息..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"product" forKey:@"command"];
    [usersDict setObject:@"detailSpecs" forKey:@"options"];
    [usersDict setObject:self.productId forKey:@"id"];
    if ([UserServe sharedUserServe].currentPet.petID) {
        [usersDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    }
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = [responseObject objectForKey:@"value"];
        self.infoDict = dict;
        self.haveMCardPrice = NO;
        self.desPicsArray = [dict objectForKey:@"descPics"];
        
        self.picsArray = [dict objectForKey:@"pics"];
        
        [self.sameView reloadData];
        
        self.titleL.text = [dict objectForKey:@"name"];
        //        self.secondTitleStr = [dict objectForKey:@"name"];
        self.secondTitleStr = [dict objectForKey:@"title"];
        self.secondTitleL.text = self.secondTitleStr;
        
        
        self.nPrice = [[dict objectForKey:@"price"] floatValue];
        self.nPriceStr = [NSString stringWithFormat:@"￥%.2f",self.nPrice];
        [self.nPriceL setText:self.nPriceStr];
        
        self.yunfei = [[dict objectForKey:@"shippingFee"] floatValue];
        if (self.yunfei==0) {
            [self.yunfeiL setText:@"免运费"];
        }
        else{
            [self.yunfeiL setText:[NSString stringWithFormat:@"运费:￥%@",[dict objectForKey:@"shippingFee"]]];
        }
        
        [self setContentFrame];
        
        if (!self.detailV) {
            self.detailV = [[UIView alloc] initWithFrame:CGRectMake(0, 60+113, ScreenWidth, 50)];
            [self.bottomBg addSubview:self.detailV];
            self.goodsDetailHelper = [[GoodsDetailTableViewHelper alloc] initWithTableview:self.detailV PicArray:self.desPicsArray];
            //        self.goodsDetailHelper.bgScrollV = self.bgScrollV;
            self.goodsDetailHelper.delegate = self;
            [self.goodsDetailHelper loadContent];
            
            //        [self.detailTableV reloadData];
            NSLog(@"alloc detailv");
        }

            [SVProgressHUD dismiss];
        self.dingzhiBtn.enabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"商品获取失败"];
    }];
    
}
//-(void)
-(void)resetContentSize
{
    [self.bottomBg setFrame:CGRectMake(0, self.bottomBg.frame.origin.y, ScreenWidth, self.detailV.frame.size.height+60+113)];
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, self.bottomBg.frame.origin.y+self.bottomBg.frame.size.height+10);
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setContentFrame];
}
-(void)setContentFrame
{
//    CGSize i = [self.nPriceStr sizeWithFont:[UIFont systemFontOfSize:22] constrainedToSize:CGSizeMake(120, 20)];
//    [self.nPriceL setFrame:CGRectMake(ScreenWidth-10-i.width, 10, i.width, 20)];
//    CGSize j = [self.mtl2.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(120, 20)];
//    [self.mtl2 setFrame:CGRectMake(ScreenWidth-10-i.width-j.width-5, 10, j.width, 20)];
    
    if (self.haveMCardPrice) {
        self.mPriceL.hidden = NO;
        self.mtl.hidden = NO;
        CGSize i2 = [self.mPriceStr sizeWithFont:[UIFont systemFontOfSize:22] constrainedToSize:CGSizeMake(120, 20)];
        [self.mPriceL setFrame:CGRectMake(self.mtl2.frame.origin.x-40-i2.width, 10, i2.width, 20)];
        CGSize j2 = [self.mtl.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(120, 20)];
        [self.mtl setFrame:CGRectMake(self.mPriceL.frame.origin.x-j2.width-5, 10, j2.width, 20)];
    }
    else
    {
        self.mPriceL.hidden = YES;
        self.mtl.hidden = YES;
    }
    
    CGSize k = [self.secondTitleStr sizeWithFont:self.secondTitleL.font constrainedToSize:CGSizeMake(self.secondTitleL.frame.size.width, 200) lineBreakMode:NSLineBreakByCharWrapping];
    [self.secondTitleL setFrame:CGRectMake(10, 25, self.secondTitleL.frame.size.width, k.height)];
    [self.titlebg setFrame:CGRectMake(0, _sameView.frame.origin.y+_sameView.frame.size.height+10, ScreenWidth, 25+k.height+5)];
    [self.bottomBg setFrame:CGRectMake(0, self.titlebg.frame.origin.y+self.titlebg.frame.size.height+10, ScreenWidth, self.bottomBg.frame.size.height)];
    
}
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(ScreenWidth, 4*ScreenWidth/5);
}
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{

    return self.picsArray?self.picsArray.count:1;;
}
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    
    EGOImageButton * imageV = (EGOImageButton*)[flowView dequeueReusableCell];
    if (!imageV) {
        imageV = [[EGOImageButton alloc] init];
        imageV.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        imageV.frame = CGRectMake(0, 0, ScreenWidth-20, (ScreenWidth-20)*(1/4.0f));
    }
    imageV.tag = 200+index;
    if (self.picsArray) {
        imageV.imageURL = [NSURL URLWithString:[self.picsArray[index] objectForKey:@"pic"]];
    }
    return imageV;
}
-(void)toCustomizePage
{
    if (!self.infoDict) {
        [SVProgressHUD showErrorWithStatus:@"商品信息还没有获取到，请稍等"];
        return;
    }
    if (self.pageType==0) {
        CustomizeClothViewController * cv = [[CustomizeClothViewController alloc] init];
        cv.haveMCardPrice = self.haveMCardPrice;
        cv.infoDict = self.infoDict;
        [self.navigationController pushViewController:cv animated:YES];
    }
    else
    {
        CustomizeGoodsViewController * cv = [[CustomizeGoodsViewController alloc] init];
        cv.haveMCardPrice = self.haveMCardPrice;
        cv.infoDict = self.infoDict;
        [self.navigationController pushViewController:cv animated:YES];

    }
    
    
}
-(void)tagButtonTouched:(EGOImageButton *)sender
{
    
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
