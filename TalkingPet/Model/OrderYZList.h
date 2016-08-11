//
//  OrderYZList.h
//  TalkingPet
//
//  Created by TaoXinle on 16/7/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "JSONModel.h"

@interface OrderYZList : JSONModel
@property (nonatomic,retain)NSString<Optional> * pay_status;
@property (nonatomic,retain)NSString<Optional> * post_status;
@property (nonatomic,retain)NSString<Optional> * pay_status_zh;
@property (nonatomic,retain)NSString<Optional> * time;
@property (nonatomic,retain)NSString<Optional> * order_no;
@property (nonatomic,retain)NSString<Optional> * total_amount;
@property (nonatomic,retain)NSString<Optional> * total_money;
@property (nonatomic,retain)NSString<Optional> * shippingfee;
@property (nonatomic,retain)NSArray<Optional> * goods;
@property (nonatomic,retain)NSString<Optional> * confirmUrl;
@property (nonatomic,retain)NSString<Optional> *model;
@end
