//
//  ConfirmDogReceivedVC.h
//  TalkingPet
//
//  Created by Tolecen on 16/8/12.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderYZList.h"
#import "OrderYZGoodInfo.h"
#import "OrderListSingleCell.h"
#import "OrderHeaderView.h"
#import "OrderFooterView.h"
#import "TTImageHelper.h"
#import "NetServer.h"
#import "NetServer+Payment.h"
@interface ConfirmDogReceivedVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,strong)OrderYZList * myOrder;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView * lk;
@property (nonatomic,strong)UIView * lk2;
@property (nonatomic,strong)UIView * footerV;
@property (nonatomic,strong)UILabel * orderNoL;
@property (nonatomic,strong)UILabel * orderTimeL;

@property (nonatomic,strong)UIButton * btn1;
@property (nonatomic,strong)UIButton * btn2;
@property (nonatomic,strong)UIButton * btn3;

@property (nonatomic,strong)UIButton * currentBTn;

@property (nonatomic,copy)void(^back) ();

@end
