//
//  YZGoodsDetailCollectionHeaderView.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/11.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZShangChengModel.h"

@protocol YZGoodsHeaderDelegate <NSObject>

- (void)reloadHeaderWithWebHeight:(CGFloat)height;

@end

@interface YZGoodsDetailCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) YZGoodsDetailModel *detailModel;

@property (nonatomic, weak) id<YZGoodsHeaderDelegate> delegate;

@end
