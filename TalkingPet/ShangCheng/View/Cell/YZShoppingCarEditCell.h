//
//  YZShoppingCarEditCell.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/28.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZShoppingCarEditCell : UITableViewCell

@property (nonatomic, weak) UIButton *selectBtn;

@property (nonatomic, weak) UIImageView *thumbImageV;

@property (nonatomic, weak) UILabel *priceLb;

@property (nonatomic, weak) UILabel *yunfeiLb;

@property (nonatomic, assign) BOOL selectToBuy;

- (void)setUpContentViewsWithSuperView:(UIView *)superView;

@end
