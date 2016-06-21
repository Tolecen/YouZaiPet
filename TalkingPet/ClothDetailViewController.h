//
//  ClothDetailViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/5/29.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "PagedFlowView.h"
#import "EGOImageButton.h"
#import "CustomizeClothViewController.h"
#import "CustomizeGoodsViewController.h"
#import "GoodsDetailTableViewHelper.h"
#import "ConsultIconView.h"
typedef enum ClothPageType{
    ClothPageTypeCloth,
    ClothPageTypeLiBao
}ClothPageType;
@interface ClothDetailViewController : BaseViewController<PagedFlowViewDataSource,PagedFlowViewDelegate,GoodsDetailTableViewHelperDelegate>
@property (nonatomic,strong)UIScrollView * bgScrollV;
@property (nonatomic,retain)PagedFlowView * sameView;
@property (nonatomic,strong)UIView * titlebg;
@property (nonatomic,strong)UILabel * titleL;
@property (nonatomic,strong)UILabel * secondTitleL;
@property (nonatomic,strong)NSString * secondTitleStr;
@property (nonatomic,strong)UIView * bottomBg;
@property (nonatomic,strong)UIButton * dingzhiBtn;
@property (nonatomic,strong)UIView * mcardPriceBg;
@property (nonatomic,strong)UIView * normalPriceBg;

@property (nonatomic,strong)NSString * mPriceStr;
@property (nonatomic,strong)UILabel * mPriceL;
@property (nonatomic,strong)NSString * mUnivalentStr;
@property (nonatomic,strong)UILabel * mUnivalentL;

@property (nonatomic,strong)NSString * nPriceStr;
@property (nonatomic,assign)float nPrice;
@property (nonatomic,strong)UILabel * nPriceL;
@property (nonatomic,strong)NSString * nUnivalentStr;
@property (nonatomic,strong)UILabel * nUnivalentL;

@property (nonatomic,strong)UILabel * mtl2;
@property (nonatomic,strong)UILabel * mtl;

@property (nonatomic,strong)UILabel * yunfeiL;
@property (nonatomic,assign)float yunfei;

//@property (nonatomic,assign)float allPrice;
//@property (nonatomic,assign)float mPrice;
//@property (nonatomic,assign)float nPrice;
//
//@property (nonatomic,assign)int mcardNum;
//@property (nonatomic,assign)int bookNum;
//@property (nonatomic,assign)BOOL useMCard;
//@property (nonatomic,assign)int useHowManyMCard;

@property (nonatomic,assign)BOOL haveMCardPrice;
@property (nonatomic,assign)ClothPageType clothPageType;

@property (nonatomic,strong)NSString * productId;

@property (nonatomic,strong)NSArray * picsArray;
@property (nonatomic,strong)NSArray * desPicsArray;
@property (nonatomic,strong)UIView * detailV;
@property (nonatomic,strong)GoodsDetailTableViewHelper * goodsDetailHelper;
@property (nonatomic,strong)NSDictionary * infoDict;

@property (nonatomic,assign)int pageType;
@end
