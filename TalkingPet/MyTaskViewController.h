//
//  MyTaskViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MJRefresh.h"
#import "EGOImageView.h"
#import "AllTaskHistoryViewController.h"
#import "MyTaskTableViewCell.h"
#import "WebContentViewController.h"
#import "TagTalkListViewController.h"
#import "PrizeDetailViewController.h"
#import "SVProgressHUD.h"
@interface MyTaskViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ReSetTimeDelegate>
@property (nonatomic,strong) UITableView * listTableV;
@property (nonatomic,strong) UILabel * doneLabel;
@property (nonatomic,strong) UILabel * notDoneLabel;
@property (nonatomic,strong) NSMutableArray * actArray;
@property (nonatomic,strong) NSString * lastId;
@property (nonatomic,assign) BOOL fromDetailPage;
@end
