//
//  PrizeListViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/6.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PrizeTableViewCell.h"
#import "EGOImageButton.h"
#import "PagedFlowView.h"
#import "PrizeDetailViewController.h"
#import "TOWebViewController.h"
@interface PrizeListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,PagedFlowViewDataSource,PagedFlowViewDelegate,ReSetStatusOfActiveDelegate>
{
    BOOL firstInThisPage;
}
@property (nonatomic,strong) NSArray * headerArray;
@property (nonatomic,strong) NSMutableArray * awardArary;
@property (nonatomic,strong) UITableView * listTableV;
@property (nonatomic,strong) UIScrollView * headerScrollV;
@property (nonatomic,retain)PagedFlowView * sameView;
@property (nonatomic,strong) UIView * headerBgV;
@property (nonatomic,strong) NSString * lastId;
@property (nonatomic,strong) NSString * squareKey;
@end
