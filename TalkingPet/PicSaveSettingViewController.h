//
//  PicSaveSettingViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/3.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SwitchBtnTableViewCell.h"
@interface PicSaveSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SwitchBtnCellDelegate>
@property (nonatomic,strong) UITableView * settingTableView;
@end
