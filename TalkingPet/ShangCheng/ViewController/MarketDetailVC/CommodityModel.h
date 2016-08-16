//
//  CommodityModel.h
//  TalkingPet
//
//  Created by cc on 16/8/8.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZShangChengModel.h"

@interface CommodityModel : NSObject



@property (nonatomic, copy) NSString *name;//热销商品名
@property (nonatomic, copy) NSString *gid;//商品id
@property (nonatomic, assign) long long sale_flag;//类型
@property (nonatomic, copy) NSString *subname;//产品描述
@property (nonatomic, assign) long long sell_price;//预售价格
@property (nonatomic, assign) long long special_price;//特殊金额（定金，或者促销价格）
@property (nonatomic, copy) NSString *thumb;//背景图片
@property (nonatomic, copy) NSString *link;//展示的商品详情连接
@property (nonatomic, copy) NSString *typeName;//展示的商品所属类型
@property (nonatomic, copy) NSString *sales;//展示的商品销售数量
@property (nonatomic, copy) NSString *addtime;//展示的商品添加时间
@property (nonatomic, copy) NSString *shop_name;//品牌名
@property (nonatomic ,copy) NSString *content;//不知道什么鬼


+(YZGoodsModel*)replaceCommodityModelToYZGoodsModel:(CommodityModel*)model;

//用添加时间来排序
-(NSComparisonResult)compareModelUseTime:(CommodityModel
                                          *)model;
//用销售量来排序
-(NSComparisonResult)compareModelSales:(CommodityModel
                                        *)model;


@end
