//
//  MarketDetailModel.h
//  TalkingPet
//
//  Created by cc on 16/8/8.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommodityModel.h"
@interface MarketDetailModel : NSObject

@property (nonatomic, copy) NSString *title;//描述
@property (nonatomic, copy) NSString *subtitle;//商品id
@property (nonatomic, copy) NSString *thumb;//背景图片
@property (nonatomic,copy)NSArray *items;//展示的商品

+(NSArray *)infoModelWith:(NSDictionary *)dict;


@end
