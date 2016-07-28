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
/*
 添加入购物车
 @param scene:添加购物车场景   狗狗详情，商品详情
 @param model:对应不同场景购物车商品对象
 @param clearPrice:是否是点击结算按钮加入购物车，如果点击结算按钮，select为YES
 */
- (void)addShoppingCarWithScene:(YZShangChengType)scene
                          model:(YZShangChengModel *)model
                     clearPrice:(BOOL)clearPrice;

- (void)updateShoppingCarGoodsCountWithModel:(YZShangChengModel *)model;
/*
 在购物车中点选选中按钮状态更新
 */
- (void)updateShoppingCarModelSelectStateWithModel:(YZShangChengModel *)model;
/*
 购物车删除商品
 */
- (void)removeShoppingCarItemWithScene:(YZShangChengType)scene
                                 model:(YZShangChengModel *)model;
/*
 购物车选中所有商品
 */
- (void)shoppingCarSelectedAllWithSelectedState:(BOOL)selected;
/*
 清空购物车
 */
- (void)clearShoppingCar;
/*
 用户切换更新购物车
 */
- (void)updateCurrentUserShoppingCar;

@end
