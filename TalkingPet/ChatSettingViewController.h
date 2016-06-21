//
//  ChatSettingViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/20.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserListViewController.h"
@interface ChatSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * settingTableView;
@property (nonatomic,strong) NSString * whoCanTalkToMe;
@property (nonatomic,strong) UIView * sectionHeader;
@property (nonatomic,assign) int chatSetting;
@end
