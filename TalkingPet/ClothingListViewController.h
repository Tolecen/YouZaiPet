//
//  ClothingListViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/5/29.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "PagedFlowView.h"
#import "EGOImageButton.h"
#import "ClothDetailViewController.h"
#import "MJRefresh.h"
#import "TOWebViewController.h"
@interface ClothingListViewController : BaseViewController<PagedFlowViewDelegate,PagedFlowViewDataSource,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UIView * topbg;
@property (nonatomic,strong) NSArray * headerArray;
@property (nonatomic,retain)PagedFlowView * sameView;
@property (nonatomic,strong)UITableView * listTableV;
@property (nonatomic,strong)NSMutableArray * goodsArray;
@property (nonatomic,assign)int pageIndex;
@property (nonatomic,strong)NSString * squareKey;
@property (nonatomic,strong)NSString * goodsKey;
@end
