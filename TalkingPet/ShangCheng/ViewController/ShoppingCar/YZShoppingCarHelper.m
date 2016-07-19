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

NSString *const kShoppingCarSeletedAllBtnChangeStateNotification = @"kShoppingCarSeletedAllBtnChangeStateNotification";
NSString *const kShoppingCarChangeItemSelectStateNotification = @"kShoppingCarChangeItemSelectStateNotification";
NSString *const kShoppingCarCalcutePriceNotification  = @"kShoppingCarCalcutePriceNotification";

NSString *const kShoppingCarCacheUserDefaultKey     = @"kShoppingCarCacheUserDefaultKey";
NSString *const kShoppingCarCacheDogKey             = @"kShoppingCarCacheDogKey";
NSString *const kShoppingCarCacheGoodsKey           = @"kShoppingCarCacheGoodsKey";
NSString *const kShoppingCarCacheContainsIdKey      = @"kShoppingCarCacheContainsIdKey";

@interface YZShoppingCarHelper()

@property (nonatomic, strong, readwrite) NSMutableArray *dogShangPinCache;
@property (nonatomic, strong, readwrite) NSMutableArray *goodsShangPinCache;

@property (nonatomic, strong) NSMutableArray *shoppingCarContainsIds;
@property (nonatomic, assign, readwrite) long long totalPrice;

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
        
        id cacheDogs = [[NSUserDefaults standardUserDefaults] objectForKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
        id cacheGoods = [[NSUserDefaults standardUserDefaults] objectForKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
        id cacheIds = [[NSUserDefaults standardUserDefaults] objectForKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
        if (cacheDogs) {
            if ([[NSKeyedUnarchiver unarchiveObjectWithData:cacheDogs] isKindOfClass:[NSArray class]]) {
                [self.dogShangPinCache addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:cacheDogs]];
            } else {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kShoppingCarCacheDogKey];
            }
        }
        if (cacheGoods) {
            if ([[NSKeyedUnarchiver unarchiveObjectWithData:cacheGoods] isKindOfClass:[NSArray class]]) {
                [self.goodsShangPinCache addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:cacheGoods]];
            } else {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kShoppingCarCacheGoodsKey];
            }
        }
        if (cacheIds) {
            if ([[NSKeyedUnarchiver unarchiveObjectWithData:cacheIds] isKindOfClass:[NSArray class]]) {
                [self.shoppingCarContainsIds addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:cacheIds]];
            } else {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kShoppingCarCacheContainsIdKey];
            }
        }
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
        YZDogModel *dogModel = (YZDogModel *)model;
        if (!dogModel.dogId || dogModel.dogId.length == 0) {
            return;
        }
        BOOL checkContains = [self inner_CheckShoppingCarContainsItem:dogModel.dogId];
        if (checkContains) {
        } else {
            YZShoppingCarDogModel *shoppingCarModel = [[YZShoppingCarDogModel alloc] init];
            shoppingCarModel.shoppingCarFlag = dogModel.dogId;
            shoppingCarModel.count = 1;
            shoppingCarModel.name = dogModel.name;
            shoppingCarModel.dogId = dogModel.dogId;
            shoppingCarModel.sex = dogModel.sex;
            shoppingCarModel.sellPrice = dogModel.sellPrice;
            shoppingCarModel.thumb = dogModel.thumb;
            shoppingCarModel.birtydayDays = dogModel.birtydayDays;
            shoppingCarModel.birthdayString = dogModel.birthdayString;
            shoppingCarModel.shopId = dogModel.shop.shopId;
            shoppingCarModel.shopNo = dogModel.shop.shopNo;
            shoppingCarModel.shopThumb = dogModel.shop.thumb;
            shoppingCarModel.shopName = dogModel.shop.shopName;

            [self.dogShangPinCache addObject:shoppingCarModel];
            [self.shoppingCarContainsIds addObject:shoppingCarModel.shoppingCarFlag];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.dogShangPinCache]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.shoppingCarContainsIds]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else if (scene == YZShangChengType_Goods) {
        YZGoodsDetailModel *goodsModel = (YZGoodsDetailModel *)model;
        if (!goodsModel.goodsId || goodsModel.goodsId.length == 0) {
            return;
        }
        BOOL checkContains = [self inner_CheckShoppingCarContainsItem:goodsModel.goodsId];
        if (checkContains) {
        } else { 
            YZShoppingCarGoodsModel *shoppingCarModel = [[YZShoppingCarGoodsModel alloc] init];
            shoppingCarModel.shoppingCarFlag = goodsModel.goodsId;
            shoppingCarModel.count = 1;
            shoppingCarModel.name = goodsModel.name;
            shoppingCarModel.goodsId = goodsModel.goodsId;
            shoppingCarModel.sellPrice = goodsModel.sellPrice;
            shoppingCarModel.thumb = goodsModel.thumb;
            [self.goodsShangPinCache addObject:shoppingCarModel];
            [self.shoppingCarContainsIds addObject:shoppingCarModel.shoppingCarFlag];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goodsShangPinCache]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.shoppingCarContainsIds]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (NSString *)inner_CacheUserDefaultKeyWithRelativeKey:(NSString *)key  {
    return [NSString stringWithFormat:@"%@_%@",key, [UserServe sharedUserServe].userID];
}

- (void)updateShoppingCarGoodsCountWithModel:(YZShangChengModel *)model {
    
}

- (void)updateShoppingCarModelSelectStateWithModel:(YZShangChengModel *)model {
    if ([model isKindOfClass:[YZShoppingCarDogModel class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.dogShangPinCache]
                                                  forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
    } else if ([model isKindOfClass:[YZShoppingCarGoodsModel class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goodsShangPinCache]
                                                  forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeShoppingCarItemWithScene:(YZShangChengType)scene model:(YZShangChengModel *)model {
    YZShoppingCarModel *shoppingCarModel = (YZShoppingCarModel *)model;
    [self.shoppingCarContainsIds removeObject:shoppingCarModel.shoppingCarFlag];
    if (scene == YZShangChengType_Dog) {
        [self.dogShangPinCache removeObject:model];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.dogShangPinCache]
                                                  forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.shoppingCarContainsIds]
                                                  forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (scene == YZShangChengType_Goods) {
        [self.goodsShangPinCache removeObject:model];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goodsShangPinCache]
                                                  forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.shoppingCarContainsIds]
                                                  forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)shoppingCarSelectedAllWithSelectedState:(BOOL)selected {
    [self.dogShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarDogModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        shoppingCarModel.selected = selected;
    }];
    
    [self.goodsShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarGoodsModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        shoppingCarModel.selected = selected;
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.dogShangPinCache]
                                              forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goodsShangPinCache]
                                              forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (long long)calcuteShoppingCarTotalPrice {
    long long __block __totalPrice = 0;
    BOOL __block selectAllDog = YES;
    BOOL __block selectAllGoods = YES;

    if (self.dogShangPinCache.count == 0 &&
        self.goodsShangPinCache.count == 0) {
        self.shoppingCarCheckAllSelected = NO;
        return __totalPrice;
    }

    [self.dogShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarDogModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (shoppingCarModel.selected) {
            __totalPrice += shoppingCarModel.sellPrice;
        } else {
            selectAllDog = NO;
        }
    }];
    
    [self.goodsShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarGoodsModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (shoppingCarModel.selected) {
            __totalPrice += (shoppingCarModel.sellPrice * shoppingCarModel.count);
        } else {
            selectAllGoods = NO;
        }
    }];
    self.shoppingCarCheckAllSelected = selectAllDog && selectAllGoods;
    return __totalPrice;
}

- (void)clearShoppingCar {
    [self.dogShangPinCache removeAllObjects];
    [self.goodsShangPinCache removeAllObjects];
    [self.shoppingCarContainsIds removeAllObjects];
    self.totalPrice = 0;
}

- (long long)totalPrice {
    return [self calcuteShoppingCarTotalPrice];
}

@end
