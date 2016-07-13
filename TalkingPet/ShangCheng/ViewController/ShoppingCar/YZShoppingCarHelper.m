//
//  YZShoppingCarHelper.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/13.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingCarHelper.h"

NSString *const kShangPinkey    = @"kShangPinkey";
NSString *const kItemNumberkey  = @"kItemNumberkey";

@interface YZShoppingCarHelper()

@property (nonatomic, strong, readwrite) NSMutableArray *dogShangPinCache;
@property (nonatomic, strong, readwrite) NSMutableArray *goodsShangPinCache;

@property (nonatomic, strong) NSMutableArray *shoppingCarContainsIds;

@end

@implementation YZShoppingCarHelper

+ (instancetype)instanceManager {
    static YZShoppingCarHelper *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[YZShoppingCarHelper alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dogShangPinCache = [[NSMutableArray alloc] init];
        self.goodsShangPinCache = [[NSMutableArray alloc] init];
        self.shoppingCarContainsIds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)inner_CheckShoppingCarContainsItem:(NSString *)itemId {
    if ([self.shoppingCarContainsIds containsObject:itemId]) {
        return YES;
    }
    return NO;
}

- (void)addShoppingCarWithScene:(YZShangChengType)scene
                          model:(YZShangChengModel *)model {
    if (scene == YZShangChengType_Dog) {
        YZDogDetailModel *dogModel = (YZDogDetailModel *)model;
        if (!dogModel.dogId || dogModel.dogId.length == 0) {
            return;
        }
        BOOL checkContains = [self inner_CheckShoppingCarContainsItem:dogModel.dogId];
        if (checkContains) {
            [self.dogShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([shoppingCarModel.shoppingCarFlag isEqualToString:dogModel.dogId]) {
                    shoppingCarModel.count += 1;
                    *stop = YES;
                }
            }];
        } else {
            YZShoppingCarModel *shoppingCarModel = [[YZShoppingCarModel alloc] init];
            shoppingCarModel.shoppingCarFlag = dogModel.dogId;
            shoppingCarModel.shoppingCarItem = dogModel;
            shoppingCarModel.count = 1;
            [self.dogShangPinCache addObject:shoppingCarModel];
            [self.shoppingCarContainsIds addObject:shoppingCarModel.shoppingCarFlag];
        }
    } else if (scene == YZShangChengType_Goods) {
        YZGoodsDetailModel *goodsModel = (YZGoodsDetailModel *)model;
        if (!goodsModel.goodsId || goodsModel.goodsId.length == 0) {
            return;
        }
        BOOL checkContains = [self inner_CheckShoppingCarContainsItem:goodsModel.goodsId];
        if (checkContains) {
            [self.goodsShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([shoppingCarModel.shoppingCarFlag isEqualToString:goodsModel.goodsId]) {
                    shoppingCarModel.count += 1;
                    *stop = YES;
                }
            }];
        } else {
            YZShoppingCarModel *shoppingCarModel = [[YZShoppingCarModel alloc] init];
            shoppingCarModel.shoppingCarFlag = goodsModel.goodsId;
            shoppingCarModel.shoppingCarItem = goodsModel;
            shoppingCarModel.count = 1;
            [self.goodsShangPinCache addObject:shoppingCarModel];
            [self.shoppingCarContainsIds addObject:shoppingCarModel.shoppingCarFlag];
        }
    }
}

- (void)clearShoppingCar {
    [self.dogShangPinCache removeAllObjects];
    [self.goodsShangPinCache removeAllObjects];
}

@end
