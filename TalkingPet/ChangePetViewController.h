//
//  ChangePetViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/2/10.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NewUserViewController.h"
#import "SVProgressHUD.h"
@interface ChangePetViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,NewUserViewControllerDelegate>
{
    NSInteger currentInddex;
    UILabel * g;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,retain)NewUserViewController * editCurrentPetVC;
@property (nonatomic,retain)NewUserViewController * addNewPetVC;
@end
