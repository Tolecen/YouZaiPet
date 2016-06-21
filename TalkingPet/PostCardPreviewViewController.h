//
//  PostCardPreviewViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/5/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "PTEHorizontalTableView.h"
#import "PostCardThumbTableViewCell.h"
#import "AllAroundPullView.h"
#import "WebContentViewController.h"
#import "OrderListViewController.h"
#import "TalkingBrowse.h"
#import "PostCardFullScreenPreviewViewController.h"
#import "OrderConfirmViewController.h"
#import "GoodsDetailTableViewHelper.h"
#import "AnimationHelper.h"
#import "PostCardView.h"
#import "ConsultIconView.h"
#import "TishiNewView.h"
@class RootViewController;
@interface PostCardPreviewViewController : BaseViewController<PTETableViewDelegate,GoodsDetailTableViewHelperDelegate,PCOrderListDelegate,UIAlertViewDelegate>
{
    UIButton * buyBtn;
    UIButton * dingzhiB;
}
@property (nonatomic,strong)UIScrollView * bgScrollV;
@property (nonatomic,strong)UIView * topBgV;
@property (nonatomic,strong)UIView * imageVBg;
@property (nonatomic,strong)UIView * spritesView;
@property (nonatomic,strong)UIImageView * templateImageV;
@property (nonatomic,strong)UIScrollView * bigScroll;
@property (nonatomic,strong)PTEHorizontalTableView * thumbTableView;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * myShuoShuoArray;
@property (nonatomic,strong)UIView * titleBgV;
@property (nonatomic,strong)UILabel * titleL;
@property (nonatomic,strong)UILabel * priceL;
@property (nonatomic,strong)NSString * postCardTitileStr;
@property (nonatomic,strong)NSString * priceStr;
@property (nonatomic,strong)NSString * univalent;
@property (nonatomic,strong)UIView * contentBgV;
@property (nonatomic,strong)UILabel * contentTitileL;
@property (nonatomic,strong)UILabel * contentL;
@property (nonatomic,strong)NSString * contentStr;
@property (nonatomic,strong)UILabel * numL;
@property (nonatomic,strong)UIImageView * picon;
@property (nonatomic,assign)NSInteger postCardNum;
@property (nonatomic,strong)UILabel * allPriceL;
@property (nonatomic,strong)NSString * allPrice;
@property (nonatomic,strong)NSString * allPriceStr;
@property (nonatomic,strong)UIButton * scrollLeftBtn;
@property (nonatomic,strong)UIButton * scrollRightBtn;

@property (nonatomic,strong)NSDictionary * pcJsonDict;

@property (nonatomic,strong)EGOImageView * headerV;
@property (nonatomic,strong)EGOImageView * contentImageV;
@property (nonatomic,strong)EGOImageView * erweimaV;
@property (nonatomic,strong)UILabel * pcContentL;
@property (nonatomic,strong)UILabel * nicknameL;
@property (nonatomic,strong)UILabel * timeL;
@property (nonatomic,strong)UILabel * timeL2;

@property (nonatomic,strong)UILabel * yunfeiL;
@property (nonatomic,assign)float yunfei;

@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)NSString * lastId;

@property (nonatomic,strong)NSMutableDictionary * listDict;

@property (nonatomic,strong)UIView * detailV;
@property (nonatomic,strong)GoodsDetailTableViewHelper * goodsDetailHelper;
@property (nonatomic,strong)NSDictionary * backInfoDict;

@property (nonatomic,strong)PostCardView * pView;
@property (nonatomic,strong)PostCardView * currentPView;
@property (nonatomic,assign)CGRect originCurrentRect;

@property (nonatomic,strong)UIButton * tolistBtn;

@property (nonatomic,assign)NSInteger totalShuoShuoNum;
@end
