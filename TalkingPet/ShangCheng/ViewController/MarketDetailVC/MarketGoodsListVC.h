//
//  MarketGoodsListVC.h
//  TalkingPet
//
//  Created by cc on 16/8/10.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengGoodsListVC.h"
#import "CommodityModel.h"

@interface MarketGoodsListVC : BaseViewController


@property (nonatomic, copy) NSString *link;//展示的商品请求数据连接
@property(nonatomic,copy)NSArray *titleArr;
@end
