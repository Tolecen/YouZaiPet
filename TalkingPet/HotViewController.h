//
//  HotViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/5/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BrowserTableHelper.h"
@interface HotViewController : BaseViewController
@property (nonatomic,retain)UICollectionView * hotView;
@property (nonatomic, strong)UITableView * contentTableView;
@property (nonatomic,strong) BrowserTableHelper * tableViewHelper;
- (void)beginRefreshing;
@end
