//
//  OrderYZGoodInfo.h
//  TalkingPet
//
//  Created by TaoXinle on 16/7/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "JSONModel.h"

@interface OrderYZGoodInfo : JSONModel
@property (nonatomic,retain)NSString<Optional> * thumb;
@property (nonatomic,retain)NSString<Optional> *product_name;
@property (nonatomic,retain)NSString<Optional> *order_no;
@property (nonatomic,retain)NSString<Optional> *shop_name;
@property (nonatomic,retain)NSString<Optional> *unit_price;
@property (nonatomic,retain)NSString<Optional> *total;
@property (nonatomic,retain)NSString<Optional> *real_amount;
@property (nonatomic,retain)NSString<Optional> *real_shipping;
@property (nonatomic,retain)NSString<Optional> *confirmUrl;
@end
