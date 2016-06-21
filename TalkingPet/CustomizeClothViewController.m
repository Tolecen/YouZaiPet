//
//  CustomizeClothViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/5/29.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "CustomizeClothViewController.h"

@interface CustomizeClothViewController ()

@end

@implementation CustomizeClothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bookNum = 1;
    self.mcardNum = 2;
    self.allPrice = 0.0f;
    self.useHowManyMCard = 0;
//    self.haveMCardPrice = YES;
    self.allAttriArray = [NSMutableArray array];
    self.selectIndexArray = [NSMutableArray array];
    self.petInfoDict = [NSMutableDictionary dictionary];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    self.title = @"定制";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    self.bgScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame)-40-navigationBarHeight)];
    self.bgScrollV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgScrollV];
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, 2000);
    
    self.firstPartV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 90)];
    self.firstPartV.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.firstPartV];
    
    self.clothImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 350/4.0f, 70)];
    self.clothImageV.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    [self.firstPartV addSubview:self.clothImageV];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(350/4.0f+20, 10, ScreenWidth-10-(350/4.0f+20), 20)];
    self.titleL.backgroundColor = [UIColor clearColor];
    self.titleL.font = [UIFont systemFontOfSize:16];
    self.titleL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    [self.firstPartV addSubview:self.titleL];
    
    
    self.secondTitleL = [[UILabel alloc] initWithFrame:CGRectMake(350/4.0f+20, 30, ScreenWidth-10-(350/4.0f+20), 50)];
    self.secondTitleL.backgroundColor = [UIColor clearColor];
    self.secondTitleL.font = [UIFont systemFontOfSize:14];
    self.secondTitleL.lineBreakMode = NSLineBreakByTruncatingTail;
    self.secondTitleL.numberOfLines = 0;
    self.secondTitleL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    [self.firstPartV addSubview:self.secondTitleL];
    
    self.secondPartV = [[UIView alloc] initWithFrame:CGRectMake(0, self.firstPartV.frame.size.height+self.firstPartV.frame.origin.y+10, ScreenWidth, 0)];
    self.secondPartV.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.secondPartV];
    
    
    self.thirdPartV = [[UIView alloc] initWithFrame:CGRectMake(0, self.secondPartV.frame.size.height+self.secondPartV.frame.origin.y+10, ScreenWidth, 100)];
    self.thirdPartV.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.thirdPartV];
    
    UILabel * tl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    tl.backgroundColor = [UIColor clearColor];
    tl.font = [UIFont boldSystemFontOfSize:14];
    tl.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    tl.text = @"爱宠信息";
    [self.thirdPartV addSubview:tl];
    
    
    self.editInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editInfoBtn setFrame:CGRectMake(ScreenWidth-65, 0, 60, 30)];
    [self.editInfoBtn setTitle:@"编辑>>" forState:UIControlStateNormal];
    [self.editInfoBtn setTitleColor:[UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1] forState:UIControlStateNormal];
    self.editInfoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //    howtoBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.thirdPartV addSubview:self.editInfoBtn];
    [self.editInfoBtn addTarget:self action:@selector(toAddPetInfoPage) forControlEvents:UIControlEventTouchUpInside];
    
    self.addPetInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addPetInfoBtn setBackgroundColor:[UIColor clearColor]];
    [self.addPetInfoBtn setFrame:CGRectMake((ScreenWidth-160)/2, 25, 160, 30)];
    [self.addPetInfoBtn setTitle:@"+ 添加爱宠信息" forState:UIControlStateNormal];
    [self.addPetInfoBtn setTitleColor:[UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1] forState:UIControlStateNormal];
    self.addPetInfoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.thirdPartV addSubview:self.addPetInfoBtn];
    [self.addPetInfoBtn addTarget:self action:@selector(toAddPetInfoPage) forControlEvents:UIControlEventTouchUpInside];
    
    self.infoV = [[UIView alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth, 120)];
    self.infoV.backgroundColor = [UIColor clearColor];
    [self.thirdPartV addSubview:self.infoV];
    
    self.breedL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 20)];
    self.breedL.backgroundColor = [UIColor clearColor];
    self.breedL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.breedL.font = [UIFont systemFontOfSize:14];
    [self.infoV addSubview:self.breedL];
    
    self.basicL = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, ScreenWidth-40, 20)];
    self.basicL.backgroundColor = [UIColor clearColor];
    self.basicL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.basicL.font = [UIFont systemFontOfSize:14];
    [self.infoV addSubview:self.basicL];
    
    self.weightL = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, ScreenWidth-40, 20)];
    self.weightL.backgroundColor = [UIColor clearColor];
    self.weightL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.weightL.font = [UIFont systemFontOfSize:14];
    [self.infoV addSubview:self.weightL];
    
    self.genderL = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, ScreenWidth-40, 20)];
    self.genderL.backgroundColor = [UIColor clearColor];
    self.genderL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.genderL.font = [UIFont systemFontOfSize:14];
    [self.infoV addSubview:self.genderL];
    
    self.fitfulL = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, ScreenWidth-40, 20)];
    self.fitfulL.backgroundColor = [UIColor clearColor];
    self.fitfulL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.fitfulL.font = [UIFont systemFontOfSize:14];
    [self.infoV addSubview:self.fitfulL];
    
    self.forthPartV = [[UIView alloc] initWithFrame:CGRectMake(0, self.thirdPartV.frame.size.height+self.thirdPartV.frame.origin.y+10, ScreenWidth, 180*((ScreenWidth-30)/2)/345+20)];
    self.forthPartV.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.forthPartV];
    
    if (self.haveMCardPrice) {
        self.mCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.mCardBtn setFrame:CGRectMake(10, 10, (ScreenWidth-30)/2, 180*((ScreenWidth-30)/2)/345)];
        [self.mCardBtn setBackgroundColor:[UIColor whiteColor]];
        [self.mCardBtn setImage:[UIImage imageNamed:@"mkayonghu-xuanzhong"] forState:UIControlStateNormal];
        [self.forthPartV addSubview:self.mCardBtn];
        [self.mCardBtn addTarget:self action:@selector(selectMcardBtn) forControlEvents:UIControlEventTouchUpInside];
        
        self.normalCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.normalCardBtn setFrame:CGRectMake((ScreenWidth-30)/2+20, 10, (ScreenWidth-30)/2, 180*((ScreenWidth-30)/2)/345)];
        [self.normalCardBtn setBackgroundColor:[UIColor whiteColor]];
        [self.normalCardBtn setImage:[UIImage imageNamed:@"putongyonghu-weixuanzhong"] forState:UIControlStateNormal];
        [self.forthPartV addSubview:self.normalCardBtn];
        [self.normalCardBtn addTarget:self action:@selector(selectNormalBtn) forControlEvents:UIControlEventTouchUpInside];
        
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
        [self.mPriceL setFont:[UIFont systemFontOfSize:22]];
        //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
        [self.mCardBtn addSubview:self.mPriceL];
        
        NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:self.mPriceStr];
        [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:18] range: NSMakeRange(0, self.mPriceStr.length)];
        [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.mPriceStr.length-1)];
        self.mPriceL.attributedText = attributedStr;
        
        
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
        [self.nPriceL setFont:[UIFont systemFontOfSize:22]];
        //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
        [self.normalCardBtn addSubview:self.nPriceL];
        
        NSMutableAttributedString * attributedStr2 = [[NSMutableAttributedString alloc] initWithString:self.nPriceStr];
        [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:18] range: NSMakeRange(0, self.nPriceStr.length)];
        [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.nPriceStr.length-1)];
        self.nPriceL.attributedText = attributedStr2;

    }
    else
    {
        UILabel * g = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
        g.backgroundColor = [UIColor clearColor];
        g.font = [UIFont boldSystemFontOfSize:14];
        g.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        g.text = @"专属价格：";
        [self.forthPartV addSubview:g];
        
        self.useMCard = NO;
        
        self.nPriceStr = @"￥234";
        self.nPrice = 234.0f;
        self.nPriceL = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 150, 20)];
        self.nPriceL.backgroundColor = [UIColor clearColor];
//        self.nPriceL.font = [UIFont systemFontOfSize:22];
        [self.nPriceL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
        [self.forthPartV addSubview:self.nPriceL];
        
        NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:self.nPriceStr];
        [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:18] range: NSMakeRange(0, self.nPriceStr.length)];
        [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.nPriceStr.length-1)];
        self.nPriceL.attributedText = attributedStr;

    }
    
    self.fifthPartV = [[UIView alloc] initWithFrame:CGRectMake(0, self.forthPartV.frame.size.height+self.forthPartV.frame.origin.y+10, ScreenWidth, 100)];
    self.fifthPartV.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.fifthPartV];


    UILabel * sl = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 100, 20)];
    sl.backgroundColor = [UIColor clearColor];
    sl.font = [UIFont boldSystemFontOfSize:14];
    sl.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    sl.text = @"选择数量：";
    [self.fifthPartV addSubview:sl];
    
    
    
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(90, 17, 60, 30)];
    [self.numL setBackgroundColor:[UIColor clearColor]];
    [self.numL setText:[NSString stringWithFormat:@"%d",self.bookNum]];
    self.numL.adjustsFontSizeToFitWidth = YES;
    [self.numL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
    [self.numL setTextAlignment:NSTextAlignmentCenter];
    [self.numL setFont:[UIFont systemFontOfSize:24]];
    //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.fifthPartV addSubview:self.numL];
    
    UIButton * minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusBtn setBackgroundColor:[UIColor clearColor]];
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor colorWithWhite:120/255.0f alpha:1] forState:UIControlStateNormal];
    [minusBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [minusBtn setFrame:CGRectMake(70, 17, 30, 30)];
    [self.fifthPartV addSubview:minusBtn];
    [minusBtn addTarget:self action:@selector(minusBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setBackgroundColor:[UIColor clearColor]];
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [plusBtn setTitleColor:[UIColor colorWithWhite:120/255.0f alpha:1] forState:UIControlStateNormal];
    [plusBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [plusBtn setFrame:CGRectMake(140, 17, 30, 30)];
    [self.fifthPartV addSubview:plusBtn];
    [plusBtn addTarget:self action:@selector(plusBtn) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.haveMCardPrice) {
        self.mCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-120, 10, 120, 20)];
        [self.mCardLabel setBackgroundColor:[UIColor clearColor]];
        [self.mCardLabel setText:[NSString stringWithFormat:@"M卡剩余:%d",self.mcardNum]];
        self.mCardLabel.adjustsFontSizeToFitWidth = YES;
        [self.mCardLabel setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
        [self.mCardLabel setTextAlignment:NSTextAlignmentRight];
        [self.mCardLabel setFont:[UIFont systemFontOfSize:14]];
        //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
        [self.fifthPartV addSubview:self.mCardLabel];
        
        self.yunfeiL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-120-10, 40, 120, 20)];
        [self.yunfeiL setBackgroundColor:[UIColor clearColor]];
        [self.yunfeiL setText:@"运费:￥10"];
        self.yunfeiL.adjustsFontSizeToFitWidth = YES;
        [self.yunfeiL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
        [self.yunfeiL setTextAlignment:NSTextAlignmentRight];
        [self.yunfeiL setFont:[UIFont systemFontOfSize:14]];
        //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
        [self.fifthPartV addSubview:self.yunfeiL];
    }
    else
    {
        self.yunfeiL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-120-10, 22, 120, 20)];
        [self.yunfeiL setBackgroundColor:[UIColor clearColor]];
        [self.yunfeiL setText:@"运费:￥10"];
        self.yunfeiL.adjustsFontSizeToFitWidth = YES;
        [self.yunfeiL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
        [self.yunfeiL setTextAlignment:NSTextAlignmentRight];
        [self.yunfeiL setFont:[UIFont systemFontOfSize:14]];
        //    [self.mPriceL setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
        [self.fifthPartV addSubview:self.yunfeiL];
    }
    

    
    UIButton * tolistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tolistBtn setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, ScreenWidth-150, 40)];
    [tolistBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tolistBtn];
//    [tolistBtn addTarget:self action:@selector(toOrderList) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1]];
    [buyBtn setTitle:@"立刻下单" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setFrame:CGRectMake(ScreenWidth-150, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, 150, 40)];
    [self.view addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(toSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    self.picon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 21, 18)];
    [self.picon setImage:[UIImage imageNamed:@"fuzhuangicon"]];
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
    self.allPriceStr = @"共0元";
    
    NSMutableAttributedString * attributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
    self.allPriceL.attributedText = attributedStr3;

    self.nPrice = [[self.infoDict objectForKey:@"price"] floatValue];
    self.originNPrice = self.nPrice;
//    self.attributeArray = [self getColorArray];
    [self getAllAttri];
    [self addAllAttri];
//    [self addAttributes];
    // Do any additional setup after loading the view.
}
-(void)getAllAttri
{
//    int j = 0;
//    NSMutableArray * d = [NSMutableArray array]
    [self.allAttriArray removeAllObjects];
    NSArray * t = [self.infoDict objectForKey:@"specs"];
    for (int i = 0; i<t.count; i++) {
        if ([[t[i] objectForKey:@"values"] count]>0) {
            [self.allAttriArray addObject:t[i]];
        }
    }
}
-(NSArray *)getColorArray
{
    int j = 0;
    NSArray * t = [self.infoDict objectForKey:@"specs"];
    for (int i = 0; i<t.count; i++) {
        if ([[[t objectAtIndex:i] objectForKey:@"id"] isEqualToString:@"color"]) {
            j = i;
            break;
        }
    }
    return [[t objectAtIndex:j] objectForKey:@"values"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self loadPetInfo];
    
    [self resetFrames];
    [self setContents];
}
-(void)setContents
{
    self.clothImageV.imageURL = [NSURL URLWithString:[self.infoDict objectForKey:@"cover"]];
    self.titleL.text = [self.infoDict objectForKey:@"name"];
    //        self.secondTitleStr = [dict objectForKey:@"name"];
    self.secondTitleStr = [self.infoDict objectForKey:@"title"];
    self.secondTitleL.text = self.secondTitleStr;
    
    
//    self.nPrice = [[self.infoDict objectForKey:@"price"] floatValue];
    self.nPriceStr = [NSString stringWithFormat:@"￥%.2f",self.nPrice];
    [self.nPriceL setText:self.nPriceStr];
    
    self.yunfei = [[self.infoDict objectForKey:@"shippingFee"] floatValue];
    if (self.yunfei==0) {
        [self.yunfeiL setText:@"免运费"];
    }
    else{
        [self.yunfeiL setText:[NSString stringWithFormat:@"运费:￥%@",[self.infoDict objectForKey:@"shippingFee"]]];
    }

}
-(void)minusBtn
{
    if (self.bookNum<=1) {
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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
-(void)resetFrames
{
//    [self.thirdPartV setFrame:CGRectMake(0, self.secondPartV.frame.size.height+self.secondPartV.frame.origin.y+10, ScreenWidth, 200)];
    [self.forthPartV setFrame:CGRectMake(0, self.thirdPartV.frame.size.height+self.thirdPartV.frame.origin.y+10, ScreenWidth,self.haveMCardPrice?(180*((ScreenWidth-30)/2)/345+20):50)];
    [self.fifthPartV setFrame:CGRectMake(0, self.forthPartV.frame.size.height+self.forthPartV.frame.origin.y+10, ScreenWidth, 65)];
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, self.fifthPartV.frame.size.height+self.fifthPartV.frame.origin.y+10);

}
-(void)loadPetInfo
{
    NSString * chestLength = [self.petInfoDict objectForKey:@"chestLength"];
    if (!chestLength) {
        self.addPetInfoBtn.hidden = NO;
        self.infoV.hidden = YES;
        self.editInfoBtn.hidden = YES;
        [self.thirdPartV setFrame:CGRectMake(0, self.secondPartV.frame.size.height+self.secondPartV.frame.origin.y+10, ScreenWidth, 70)];
    }
    else
    {
        self.addPetInfoBtn.hidden = YES;
        self.infoV.hidden = NO;
        self.editInfoBtn.hidden = NO;
        [self.thirdPartV setFrame:CGRectMake(0, self.secondPartV.frame.size.height+self.secondPartV.frame.origin.y+10, ScreenWidth, 170)];
        self.breedL.text =  [NSString stringWithFormat:@"爱宠品种：%@",[self.petInfoDict objectForKey:@"breed"]];
        self.basicL.text =  [NSString stringWithFormat:@"胸围：%@cm    颈围：%@cm   身长：%@cm",[self.petInfoDict objectForKey:@"chestLength"],[self.petInfoDict objectForKey:@"neckLength"],[self.petInfoDict objectForKey:@"bodyLength"]];
        self.weightL.text = [NSString stringWithFormat:@"爱宠体重：%@kg",[self.petInfoDict objectForKey:@"weight"]];
        self.genderL.text = [NSString stringWithFormat:@"爱宠性别：%@",[self.petInfoDict objectForKey:@"gender"]];
        self.fitfulL.text = [NSString stringWithFormat:@"喜欢板式：%@",[self.petInfoDict objectForKey:@"fitful"]];
        NSLog(@"dict:%@",self.petInfoDict);
    }
}
-(void)addAllAttri
{
    [self.selectIndexArray removeAllObjects];
    for (int i = 0; i<self.allAttriArray.count; i++) {
        [self addAttributes:i];
    }
    for (int i = 0; i<self.allAttriArray.count; i++) {
        self.nPrice = self.nPrice+[[[[self.allAttriArray[i] objectForKey:@"values"] objectAtIndex:[self.selectIndexArray[i] intValue]] objectForKey:@"price"] floatValue];
    }
    
    self.allPrice = self.nPrice*self.bookNum;
    [self setContents];
    [self setFinalPrice];
}

-(void)addAttributes:(int)index
{
    int ftag = 100*index;
    UIView * vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    vvv.tag = ftag;
    vvv.backgroundColor = [UIColor whiteColor];
    [self.secondPartV addSubview:vvv];
    
    UILabel * hj = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
    hj.backgroundColor = [UIColor clearColor];
    hj.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    hj.font = [UIFont systemFontOfSize:14];
    [vvv addSubview:hj];
    hj.text = [self.allAttriArray[index] objectForKey:@"name"];
    
    [self.selectIndexArray addObject:[NSNumber numberWithInt:0]];
    
    
    int lines = 1;
    NSArray * farray = [self.allAttriArray[index] objectForKey:@"values"];
    NSMutableArray * widthArray = [NSMutableArray array];
    for (int i = 0; i<farray.count; i++) {
        NSString * t = [farray[i] objectForKey:@"value"];
//        self.nPrice = self.nPrice+[[farray[i] objectForKey:@"price"] floatValue];
        CGSize z = [t sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 20)];
        [widthArray addObject:[NSNumber numberWithFloat:(z.width+20)]];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = ftag+i+1;
        btn.layer.cornerRadius = 3;
        
        btn.layer.borderWidth = 1;
        btn.layer.masksToBounds = YES;
        [btn setTitle:t forState:UIControlStateNormal];
        if (i==0) {
            btn.layer.borderColor = [[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1] CGColor];
            [btn setTitleColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1] forState:UIControlStateNormal];
        }
        else
        {
            btn.layer.borderColor = [[UIColor colorWithWhite:180/255.0f alpha:1] CGColor];
            [btn setTitleColor:[UIColor colorWithWhite:180/255.0f alpha:1] forState:UIControlStateNormal];
        }
        
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btn addTarget:self action:@selector(selectThisBtn:) forControlEvents:UIControlEventTouchUpInside];
        float c = [self getFinalWidth:widthArray];
        if (c>(ScreenWidth-10)) {
            [widthArray removeAllObjects];
            [widthArray addObject:[NSNumber numberWithFloat:(z.width+20)]];
            lines++;
        }
        btn.frame = CGRectMake([self getOriginWidth:widthArray], 25+10*lines+30*(lines-1), z.width+20, 30);
        [vvv addSubview:btn];
        
    }
    
    float vh = 10*lines+30*lines+10;
    
    
    
    //    float ah = 0;
    float vhx = 0;
    for (int l = 0; l<self.attriHArray.count; l++) {
        vhx = vhx + [self.attriHArray[l] floatValue]+10;
        //        ah = ah+[self.attriHArray[l] floatValue]+10;
    }
    
    [vvv setFrame:CGRectMake(self.secondPartV.frame.origin.x, vhx, ScreenWidth, vh+30)];
    [self.secondPartV setFrame:CGRectMake(0, self.secondPartV.frame.origin.y, ScreenWidth, vhx+vh+30+5)];
    [self.attriHArray addObject:[NSNumber numberWithFloat:vh+30]];
    self.selectIndex = 0;
    

}
-(void)setFinalPrice
{
    self.allPriceStr = [NSString stringWithFormat:@"共%.2f元",self.allPrice];
    
    NSMutableAttributedString * attributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
    self.allPriceL.attributedText = attributedStr3;
}
-(void)selectThisBtn:(UIButton *)sender
{
    self.nPrice = self.originNPrice;
    int ftag = (int)sender.tag;
    int d = ftag/100;
    NSArray * h = [self.allAttriArray[d] objectForKey:@"values"];;
    UIView * vv = [self.secondPartV viewWithTag:d*100];
    for (int i = 0; i<h.count; i++) {
        UIButton * btn = (UIButton *)[vv viewWithTag:(100*d+i+1)];
//        self.nPrice = self.nPrice+[[h[i] objectForKey:@"price"] floatValue];
        if (btn.tag==sender.tag) {
            btn.layer.borderColor = [[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1] CGColor];
            [btn setTitleColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1] forState:UIControlStateNormal];
            [self.selectIndexArray replaceObjectAtIndex:d withObject:[NSNumber numberWithInt:i]];
        }
        else
        {
            btn.layer.borderColor = [[UIColor colorWithWhite:180/255.0f alpha:1] CGColor];
            [btn setTitleColor:[UIColor colorWithWhite:180/255.0f alpha:1] forState:UIControlStateNormal];
        }
        
    }
    for (int i = 0; i<self.allAttriArray.count; i++) {
        self.nPrice = self.nPrice+[[[[self.allAttriArray[i] objectForKey:@"values"] objectAtIndex:[self.selectIndexArray[i] intValue]] objectForKey:@"price"] floatValue];
    }
    
    self.allPrice = self.nPrice*self.bookNum;
    [self setContents];
    [self setFinalPrice];
    //    self.selectIndex = sender.tag-100;
    //    NSLog(@"touched button index:%d",(int)sender.tag);
}
-(float)getFinalWidth:(NSMutableArray *)array
{
    float w = 0.0f;
    for (int i = 0; i<array.count; i++) {
        w = w+[array[i] floatValue];
    }
    return w+[array count]*10.0f;
}
-(float)getOriginWidth:(NSMutableArray *)array
{
    float w = 0.0f;
    for (int i = 0; i<array.count; i++) {
        w = w+[array[i] floatValue];
    }
    return w+[array count]*10.0f-[[array lastObject] floatValue];
}
-(void)toAddPetInfoPage
{
    ClothPetInfoViewController * cv = [[ClothPetInfoViewController alloc] init];
    cv.infoDict = self.petInfoDict;
    [self.navigationController pushViewController:cv animated:YES];
    
}
-(NSMutableArray *)getSpecs
{
    
    NSDictionary * bust = [NSDictionary dictionaryWithObjectsAndKeys:[self.petInfoDict objectForKey:@"chestLength"],@"value",@"bust",@"id", nil];
    NSDictionary * neck = [NSDictionary dictionaryWithObjectsAndKeys:@"neckCf",@"id",[self.petInfoDict objectForKey:@"neckLength"],@"value", nil];
    NSDictionary * bodyL = [NSDictionary dictionaryWithObjectsAndKeys:@"bodyLength",@"id",[self.petInfoDict objectForKey:@"bodyLength"],@"value", nil];
    NSDictionary * variety = [NSDictionary dictionaryWithObjectsAndKeys:@"variety",@"id",[self.petInfoDict objectForKey:@"breed"],@"value", nil];
    NSDictionary * bodyWeight = [NSDictionary dictionaryWithObjectsAndKeys:@"bodyWeight",@"id",[self.petInfoDict objectForKey:@"weight"],@"value", nil];
    NSDictionary * gender = [NSDictionary dictionaryWithObjectsAndKeys:@"gender",@"id",[self.petInfoDict objectForKey:@"gender"],@"value", nil];
    NSDictionary * clothingShape = [NSDictionary dictionaryWithObjectsAndKeys:@"clothingShape",@"id",[self.petInfoDict objectForKey:@"fitful"],@"value", nil];
//    NSDictionary * color = [NSDictionary dictionaryWithObjectsAndKeys:@"color",@"id",[self.attributeArray[self.selectIndex] objectForKey:@"id"],@"value", nil];
    NSMutableArray * fa = [NSMutableArray array];
    for (int i = 0; i<self.allAttriArray.count; i++) {
        NSDictionary * t = [NSDictionary dictionaryWithObjectsAndKeys:[self.allAttriArray[i] objectForKey:@"id"],@"id",[[[self.allAttriArray[i] objectForKey:@"values"] objectAtIndex:[self.selectIndexArray[i] intValue]] objectForKey:@"id"],@"value", nil];
        [fa addObject:t];
    }
    [fa addObject:bust];
    [fa addObject:neck];
    [fa addObject:bodyL];
    [fa addObject:variety];
    [fa addObject:bodyWeight];
    [fa addObject:gender];
    [fa addObject:clothingShape];
//    NSMutableArray * array = [NSMutableArray arrayWithObjects:color,bust,neck,bodyL,variety,bodyWeight,gender,clothingShape, nil];
    
    return fa;
}
-(void)submitOrder
{
    NSMutableArray * itemArray =[NSMutableArray array];
    NSMutableDictionary * infoD = [NSMutableDictionary dictionary];
    [infoD setObject:[self.infoDict objectForKey:@"id"] forKey:@"productId"];
    [infoD setObject:[self.infoDict objectForKey:@"updateTime"] forKey:@"productUpdateTime"];
    [infoD setObject:@"false" forKey:@"useCard"];
    [infoD setObject:[NSString stringWithFormat:@"%d",self.bookNum] forKey:@"count"];
    [infoD setObject:[self getSpecs] forKey:@"specs"];
    [itemArray addObject:infoD];
    [SVProgressHUD showWithStatus:@"提交订单中..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"order" forKey:@"command"];
    [usersDict setObject:@"create" forKey:@"options"];
    [usersDict setObject:itemArray forKey:@"orderItems"];
    if ([UserServe sharedUserServe].currentPet.petID) {
        [usersDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    }
    [NetServer requestWithEncryptParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self toConfirmPageWithOrderId:[responseObject objectForKey:@"value"]];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"订单提交有问题，稍后再试吧"];
    }];
}
-(void)toSubmit
{
    if (self.bookNum<1) {
        [SVProgressHUD showErrorWithStatus:@"至少选择数量为1哦"];
        return;
    }
    NSString * chestLength = [self.petInfoDict objectForKey:@"chestLength"];
    if (!chestLength) {
        [SVProgressHUD showErrorWithStatus:@"还没有为您的宠物填写定制信息呢"];
        return;
    }
    [self submitOrder];
}
-(void)toConfirmPageWithOrderId:(NSDictionary *)order;
{

    OrderConfirmViewController * ov = [[OrderConfirmViewController alloc] init];
    ov.imageUrl = [NSURL URLWithString:[self.infoDict objectForKey:@"cover"]];
    ov.goodsTitle = [self.infoDict objectForKey:@"name"];
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
    ov.yunfeiValue = [[order objectForKey:@"shippingFee"] floatValue];
    ov.orderId = [order objectForKey:@"id"];
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
