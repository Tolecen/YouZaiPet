//
//  OrderDetailViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/6/11.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderYZList.h"
#import "OrderYZGoodInfo.h"
@interface OrderDetailViewController : BaseViewController<UIAlertViewDelegate>
@property (nonatomic,retain)NSString * orderID;
@property (nonatomic,copy)void(^ deleteThisOrder)();
@property (nonatomic,copy)void(^ actionOrder)();
-(void)buildWithSimpleDic:(NSDictionary*)dic;

@property (nonatomic,strong)OrderYZList * myOrder;
@end
