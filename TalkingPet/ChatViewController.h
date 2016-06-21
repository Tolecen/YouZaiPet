//
//  ChatViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14/12/29.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ChatDetailViewController.h"
#import "MsgPetEntity.h"
#import "MJRefresh.h"
@interface ChatViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ChatDetailPageDelegate>
{
    int currentPage;
    UILabel * g;
}
@property (nonatomic,strong) UITableView * msgTableV;
@property (nonatomic,strong) NSMutableArray * msgArray;
@end
