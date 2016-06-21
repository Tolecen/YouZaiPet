//
//  CustomizeGoodsViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/7/19.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "EGOImageView.h"
#import "AnimationHelper.h"
#import "OrderConfirmViewController.h"
#import "SVProgressHUD.h"
@interface CustomizeGoodsViewController : BaseViewController
@property (nonatomic,strong)NSMutableArray * allAttriArray;
@property (nonatomic,strong)NSMutableArray * attriHArray;
@property (nonatomic,strong)NSMutableArray * selectIndexArray;
@property (nonatomic,strong) UIScrollView * bgScrollV;
@property (nonatomic,strong) UIView * firstPartV;
@property (nonatomic,strong) UIView * secondPartV;
@property (nonatomic,strong) UIView * thirdPartV;
@property (nonatomic,strong) UIView * forthPartV;
@property (nonatomic,strong) UIView * fifthPartV;
@property (nonatomic,strong) EGOImageView * clothImageV;
@property (nonatomic,strong) UILabel * titleL;
@property (nonatomic,strong) UILabel * secondTitleL;
@property (nonatomic,strong) NSArray * attributeArray;
@property (nonatomic,strong) NSMutableDictionary * petInfoDict;
@property (nonatomic,strong) UIButton * addPetInfoBtn;
@property (nonatomic,strong) UIButton * editInfoBtn;
@property (nonatomic,strong) UIView * infoV;
@property (nonatomic,strong) UILabel * breedL;
@property (nonatomic,strong) UILabel * basicL;
@property (nonatomic,strong) UILabel * weightL;
@property (nonatomic,strong) UILabel * genderL;
@property (nonatomic,strong) UILabel * fitfulL;

@property (nonatomic,strong)UIButton * mCardBtn;
@property (nonatomic,strong)UIButton * normalCardBtn;
@property (nonatomic,strong)NSString * mPriceStr;
@property (nonatomic,strong)UILabel * mPriceL;

@property (nonatomic,strong)NSString * nPriceStr;
@property (nonatomic,strong)UILabel * nPriceL;

@property (nonatomic,assign)float allPrice;
@property (nonatomic,assign)float mPrice;
@property (nonatomic,assign)float nPrice;
@property (nonatomic,assign)float originNPrice;

@property (nonatomic,assign)int mcardNum;
@property (nonatomic,assign)int bookNum;
@property (nonatomic,assign)BOOL useMCard;
@property (nonatomic,assign)int useHowManyMCard;

//@property (nonatomic,assign)BOOL haveMCardPrice;
@property (nonatomic,assign)BOOL haveMCardPrice;

@property (nonatomic,strong)UILabel * numL;
@property (nonatomic,strong)UILabel * mCardLabel;
@property (nonatomic,strong)UILabel * yunfeiL;

@property (nonatomic,strong)UILabel * allnumL;
@property (nonatomic,strong)UILabel * allPriceL;
@property (nonatomic,strong)NSString * allPriceStr;

@property (nonatomic,strong)NSDictionary * infoDict;
@property (nonatomic,strong)NSString * secondTitleStr;
@property (nonatomic,assign)float yunfei;
@property (nonatomic,assign)int selectIndex;
@property (nonatomic,strong)UIImageView * picon;
@end
