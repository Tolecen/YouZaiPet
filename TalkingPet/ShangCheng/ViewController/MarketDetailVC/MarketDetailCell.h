//
//  MarketDetailCell.h
//  TalkingPet
//
//  Created by cc on 16/8/7.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketDetailModel.h"
#import "CommodityModel.h"


typedef void(^MarkBlock)(CommodityModel *model);
@interface MarketDetailCell : UITableViewCell
@property(nonatomic,strong)MarketDetailModel *model;
@property(nonatomic,copy)MarkBlock block;
@end
