//
//  YZShoppingCarEditCell.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/28.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZShangChengModel.h"
#import "YZQuansheHeaderView.h"

@interface YZShoppingCarEditCell : UITableViewCell

@property (nonatomic, weak) UIButton *selectBtn;

@property (nonatomic, weak) UIImageView *thumbImageV;

@property (nonatomic, weak) UILabel *priceLb;
@property (nonatomic, weak) UILabel *originpriceLb;

@property (nonatomic, weak) UILabel *yunfeiLb;

@property (nonatomic, weak) YZQuansheHeaderView *quansheHeaderV;

@property (nonatomic, strong) YZShoppingCarModel *detailModel;

- (void)setUpContentViewsWithSuperView:(UIView *)superView;

@end
