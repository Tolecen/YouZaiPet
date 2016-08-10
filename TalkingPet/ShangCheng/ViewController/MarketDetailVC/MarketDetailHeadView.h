//
//  MarketDetailHeadView.h
//  TalkingPet
//
//  Created by cc on 16/8/8.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommodityModel.h"

typedef void(^MarktBlock)();
@interface MarketDetailHeadView : UIView
@property(nonatomic,strong)CommodityModel *model;
@property(nonatomic,copy)MarktBlock block;

@end
