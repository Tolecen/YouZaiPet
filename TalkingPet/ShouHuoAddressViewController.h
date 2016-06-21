//
//  ShouHuoAddressViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/4/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ShouHuoInfoTableViewCell.h"
#import "SVProgressHUD.h"
@interface ShouHuoAddressViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ShouHuoCellDelegate>
{
    BOOL fromHeightChanged;
}
@property (nonatomic,strong) UITableView * infoTableV;
@property (nonatomic,strong) NSMutableArray * titleArray;
@property (nonatomic,strong) NSArray * placeholderArray;
@property (nonatomic,strong) NSMutableArray * heightArray;
@end
