//
//  PostCardFullScreenPreviewViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/5/22.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "TalkingBrowse.h"
#import "PostCardView.h"
#import "SVProgressHUD.h"
@class  RootViewController,PostCardPreviewViewController;
@interface PostCardFullScreenPreviewViewController : BaseViewController<UIScrollViewDelegate,UIAlertViewDelegate>
@property(nonatomic)NSUInteger orietation;
@property (nonatomic,strong)UIImageView * bgImageV;
@property (nonatomic,strong)NSMutableDictionary * listDict;
@property (nonatomic,strong)NSMutableArray * myShuoShuoArray;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)NSString * lastId;
@property (nonatomic,strong)UIScrollView * pScrollV;
@property (nonatomic,strong)PostCardView * pViewLeft;
@property (nonatomic,strong)PostCardView * pViewCenter;
@property (nonatomic,strong)PostCardView * pViewBottom;
@property (nonatomic,strong)PostCardView * currentPView;
@property (nonatomic,assign)float originOffsetX;
@property (nonatomic,assign)CGRect originCurrentRect;
@property (nonatomic,strong)UIButton * dingzhiB;
@property (nonatomic,assign)NSInteger totalShuoShuoNum;
@property (nonatomic,strong)UILabel * numL;
@property (nonatomic,strong)UISlider * slider;
@end
