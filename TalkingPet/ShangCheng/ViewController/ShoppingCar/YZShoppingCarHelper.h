//
//  YZShoppingCarHelper.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/13.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZShangChengModel.h"

extern NSString *const kShoppingCarSeletedAllBtnChangeStateNotification;
extern NSString *const kShoppingCarChangeItemSelectStateNotification;
extern NSString *const kShoppingCarCalcutePriceNotification;

@interface YZShoppingCarHelper : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *dogShangPinCache;
@property (nonatomic, strong, readonly) NSMutableArray *goodsShangPinCache;

@property (nonatomic, assign, readonly) long long totalPrice;
@property (nonatomic, assign) BOOL shoppingCarCheckAllSelected;

+ (instancetype)instanceManager;

- (void)addShoppingCarWithScene:(YZShangChengType)scene
                          model:(YZShangChengModel *)model;

- (void)updateShoppingCarGoodsCountWithModel:(YZShangChengModel *)model;

- (void)removeShoppingCarItemWithScene:(YZShangChengType)scene
                                 model:(YZShangChengModel *)model;

- (void)shoppingCarSelectedAllWithSelectedState:(BOOL)selected;

//- (BOOL)shoppingCarCheckAllSelected;

- (void)clearShoppingCar;

@end
