//
//  SectionMSgViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14/10/23.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTableViewCell.h"
#import "MessageViewController.h"
#import "ChatViewController.h"
#import "DatabaseServe.h"
@class RootViewController;
@interface SectionMSgViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    int c_r_count;
    int f_count;
    int fans_count;
    int sys_count;
    int normalChat_count;

//    UINavigationController *navigationControllerd;
    
    BOOL needNotiNormalChat;
}
@property (nonatomic,strong) UIView * headerV;
@property (nonatomic,strong) UITableView * msgTableV;
@end
