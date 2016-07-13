//
//  YZShoppingPageContainerVC.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZShoppingCarHelper.h"

@interface YZShoppingPageContainerVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

- (Class)registerCellClass;

@end
