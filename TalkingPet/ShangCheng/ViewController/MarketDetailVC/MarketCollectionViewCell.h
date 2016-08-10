//
//  MarketCollectionViewCell.h
//  TalkingPet
//
//  Created by cc on 16/8/8.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommodityModel.h"
@interface MarketCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)CommodityModel *model;

-(void)hiedenLabel;

@end
