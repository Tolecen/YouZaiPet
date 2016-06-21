//
//  GetQuanViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/7/23.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "QuanViewController.h"
@interface GetQuanViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSMutableArray * quanArray;
@property (nonatomic,strong)NSString * activityId;
@end
