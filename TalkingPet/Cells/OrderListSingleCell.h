//
//  OrderListSingleCell.h
//  TalkingPet
//
//  Created by Tolecen on 16/7/26.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "OrderYZGoodInfo.h"
@interface OrderListSingleCell : UITableViewCell

@property (nonatomic,strong)EGOImageView * goodPicV;
@property (nonatomic,strong)UILabel * goodNameL;
@property (nonatomic,strong)UILabel * goodDesL;
@property (nonatomic,strong)UILabel * moneyL;
@property (nonatomic,strong)UILabel * amountL;
@property (nonatomic,strong)OrderYZGoodInfo * goodInfo;
@property (nonatomic,strong)UIButton * btn1;

@end
