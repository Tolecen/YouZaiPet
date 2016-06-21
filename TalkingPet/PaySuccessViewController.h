//
//  PaySuccessViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/6/16.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailViewController.h"
@interface PaySuccessViewController : BaseViewController
@property (nonatomic,strong)UIImageView * successV;
@property (nonatomic,strong)NSString * price;
@property (nonatomic,strong)NSString * orderId;
@property (nonatomic,copy)void(^back) ();
@end
