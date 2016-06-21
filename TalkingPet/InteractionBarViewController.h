//
//  InteractionBarViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/25.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "XLHeaderView.h"
#import "TopicTableViewCell.h"
#import "HuDongListTableViewCell.h"
#import "MJRefresh.h"
#import "PersonProfileViewController.h"
#import "InteractionDetailViewController.h"
#import "SystemServer.h"
#import "TalkComment.h"
@class RootViewController;
@interface InteractionBarViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,HuDongListCellDelegate,ReSetInteractionListDelegate>
@property (nonatomic,strong) UITableView * listTableV;
@property (nonatomic, strong) XLHeaderView *headerView;
@property (nonatomic,strong) NSString * bgImageUrl;
@property (nonatomic,strong) NSString * titleStr;
@property (nonatomic,strong) NSString * topicId;
@property (nonatomic,strong) NSString * lastId;
@property (nonatomic,strong) NSMutableArray * listArray;
@property (nonatomic,strong) NSMutableArray * hotListArray;
@property (nonatomic,assign) int state;
@end
