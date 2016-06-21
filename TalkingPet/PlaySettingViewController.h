//
//  PlaySettingViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14/11/17.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef enum
{
    PlayOnlyInWIFI = 0,
    PlayAlways,
    PlayNever
} PlayMode;
@interface PlaySettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * settingTableView;
@property (nonatomic,assign) PlayMode playMode;
@end
