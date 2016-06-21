//
//  PrizeDetailViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/10.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PagedFlowView.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "PersonProfileViewController.h"
#import "SVProgressHUD.h"
#import "TagTalkListViewController.h"
#import "MyTaskViewController.h"
@protocol ReSetStatusOfActiveDelegate <NSObject>

@optional
-(void)resetStatusforIndex:(int)index withStatus:(int)status;
@end
@interface PrizeDetailViewController : BaseViewController<PagedFlowViewDataSource,PagedFlowViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UIScrollView * bgScrollV;
@property (nonatomic,retain)PagedFlowView * sameView;
@property (nonatomic,strong) NSMutableArray * joinerArray;
@property (nonatomic,strong) NSArray * headerArray;
@property (nonatomic,strong) UIButton * actionBtn;
@property (nonatomic,strong) UIButton * todoBtn;
@property (nonatomic,strong) UIButton * tomissionBtn;
@property (nonatomic,strong) UILabel * numL;
@property (nonatomic,strong) UILabel * timeL;
@property (nonatomic,strong) UILabel * canyuL;
@property (nonatomic,strong) UILabel * desL;
@property (nonatomic,strong) NSString * awardId;
@property (nonatomic,strong) NSString * tagId;
@property (nonatomic,assign) int canShowUNum;
@property (nonatomic,assign) int status;
@property (nonatomic,assign) int currentCategory;
@property (nonatomic,assign) int cellIndex;
@property (nonatomic,assign) BOOL fromTaskPage;
@property (nonatomic,assign) BOOL firstGet;
@property (nonatomic,assign) id <ReSetStatusOfActiveDelegate>delegate;
@end
