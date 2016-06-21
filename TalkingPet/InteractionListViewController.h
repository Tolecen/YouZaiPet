//
//  InteractionListViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/26.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TopicTableViewCell.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "InteractionBarViewController.h"
#import "MJRefresh.h"
@interface InteractionListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * listTableV;
@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) EGOImageButton * topImageV;
@property (nonatomic,strong) UILabel * topLabel;
@property (nonatomic,strong) UIView * topLbgV;
@property (nonatomic,strong) NSString * lastId;
@property (nonatomic,strong) NSMutableArray * listArray;
@end
