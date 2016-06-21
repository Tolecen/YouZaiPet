//
//  CheckUpdateViewController.h
//  TalkingPet
//
//  Created by wangxr on 14-8-27.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "SystemServer.h"
#import "WebContentViewController.h"
#import "WelcomeViewController.h"
@interface CheckUpdateViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIButton * imgV;
}
@property (nonatomic,strong) NSArray * titleArray;
@property (nonatomic,strong) UITableView * settingTableView;
@end
