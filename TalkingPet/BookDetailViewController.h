//
//  BookDetailViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/5/25.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "WebContentViewController.h"
#import "PagedFlowView.h"
#import "EGOImageButton.h"
#import "OrderConfirmViewController.h"
#import "SVProgressHUD.h"
#import "GoodsDetailTableViewHelper.h"
#import "AnimationHelper.h"
#import "ConsultIconView.h"
@interface BookDetailViewController : BaseViewController<PagedFlowViewDataSource,PagedFlowViewDelegate,GoodsDetailTableViewHelperDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIButton * buyBtn;
    UIButton * minusBtn;
    UIButton * plusBtn;
}
@property (nonatomic,strong)UIScrollView * bgScrollV;
@property (nonatomic,retain)PagedFlowView * sameView;
@property (nonatomic,strong)UIView * titlebg;
@property (nonatomic,strong)UILabel * titleL;
@property (nonatomic,strong)UILabel * secondTitleL;
@property (nonatomic,strong)NSString * secondTitleStr;
@property (nonatomic,strong)UIView * bottomBg;
@property (nonatomic,strong)UIView * priceBg;
@property (nonatomic,strong)UIButton * mCardBtn;
@property (nonatomic,strong)UIButton * normalCardBtn;
@property (nonatomic,strong)NSString * mPriceStr;
@property (nonatomic,strong)UILabel * mPriceL;
@property (nonatomic,strong)NSString * mUnivalentStr;
@property (nonatomic,strong)UILabel * mUnivalentL;

@property (nonatomic,strong)NSString * nPriceStr;
@property (nonatomic,strong)UILabel * nPriceL;
@property (nonatomic,strong)NSString * nUnivalentStr;
@property (nonatomic,strong)UILabel * nUnivalentL;

@property (nonatomic,strong)UILabel * numL;
@property (nonatomic,strong)UILabel * mCardLabel;
@property (nonatomic,strong)UILabel * yunfeiL;
@property (nonatomic,assign)float yunfei;

@property (nonatomic,strong)UILabel * allnumL;
@property (nonatomic,strong)UILabel * allPriceL;
@property (nonatomic,strong)NSString * allPriceStr;
@property (nonatomic,assign)float allPrice;
@property (nonatomic,assign)float mPrice;
@property (nonatomic,assign)float nPrice;

@property (nonatomic,assign)int mcardNum;
@property (nonatomic,assign)int bookNum;
@property (nonatomic,assign)BOOL useMCard;
@property (nonatomic,assign)int useHowManyMCard;

@property (nonatomic,assign)BOOL haveMCardPrice;

@property (nonatomic,strong)UIView * nnView;
@property (nonatomic,strong)UILabel * nnPriceL;
@property (nonatomic,strong)UILabel * nnUnivalentL;

@property (nonatomic,strong)UIImageView * picon;
@property (nonatomic,assign)NSInteger totalNum;
@property (nonatomic,strong)NSArray * picsArray;
@property (nonatomic,strong)NSArray * desPicsArray;

@property (nonatomic,strong)UIView * detailTableV;
@property (nonatomic,strong)GoodsDetailTableViewHelper * goodsDetailHelper;
@property (nonatomic,strong)NSString * productId;

@property (nonatomic,strong)NSDictionary * backInfoDict;


@end
