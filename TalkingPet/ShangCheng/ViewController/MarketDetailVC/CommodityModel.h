//
//  CommodityModel.h
//  TalkingPet
//
//  Created by cc on 16/8/8.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommodityModel : NSObject



@property (nonatomic, copy) NSString *name;//热销商品名
@property (nonatomic, copy) NSString *gid;//商品id
@property (nonatomic, assign) long long sale_flag;//类型
@property (nonatomic, copy) NSString *subname;//产品描述
@property (nonatomic, assign) long long sell_price;//预售价格
@property (nonatomic, assign) long long special_price;//特殊金额（定金，或者促销价格）
@property (nonatomic, copy) NSString *thumb;//背景图片



@end
