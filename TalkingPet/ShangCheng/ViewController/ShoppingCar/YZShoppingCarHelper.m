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

//内存中的狗和商品数组
@property (nonatomic, strong, readwrite) NSMutableArray *dogShangPinCache;
@property (nonatomic, strong, readwrite) NSMutableArray *goodsShangPinCache;

@property (nonatomic, strong) NSMutableArray *shoppingCarContainsIds;
@property (nonatomic, assign, readwrite) long long totalPrice;

//userdefaults中的针对不同用户的狗和商品数组
@property (nonatomic, strong) NSMutableArray *dogUserDefaultCache;
@property (nonatomic, strong) NSMutableArray *goodsUserDefaultCache;

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
        
        self.dogUserDefaultCache = [[NSMutableArray alloc] init];
        self.goodsUserDefaultCache = [[NSMutableArray alloc] init];

        id cacheDogs = [[NSUserDefaults standardUserDefaults] objectForKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
        id cacheGoods = [[NSUserDefaults standardUserDefaults] objectForKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
        id cacheIds = [[NSUserDefaults standardUserDefaults] objectForKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
        if (cacheDogs) {
            [self.dogUserDefaultCache addObjectsFromArray:cacheDogs];
            [cacheDogs enumerateObjectsUsingBlock:^(NSString *JSONString, NSUInteger idx, BOOL * _Nonnull stop) {
                YZShoppingCarDogModel *shoppingCarModel = [[YZShoppingCarDogModel alloc] initWithString:JSONString
                                                                                                  error:nil];
                [self.dogShangPinCache addObject:shoppingCarModel];
            }];
        }
        if (cacheGoods) {
            [self.goodsUserDefaultCache addObjectsFromArray:cacheGoods];
            [cacheGoods enumerateObjectsUsingBlock:^(NSString *JSONString, NSUInteger idx, BOOL * _Nonnull stop) {
                YZShoppingCarGoodsModel *shoppingCarModel = [[YZShoppingCarGoodsModel alloc] initWithString:JSONString
                                                                                                      error:nil];
                [self.goodsShangPinCache addObject:shoppingCarModel];
            }];
        }
        if (cacheIds) {
            [self.shoppingCarContainsIds addObjectsFromArray:cacheIds];
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
            shoppingCarModel.shoppingCarItem = dogModel;
            shoppingCarModel.count = 1;
            [self.dogShangPinCache addObject:shoppingCarModel];
            [self.shoppingCarContainsIds addObject:shoppingCarModel.shoppingCarFlag];
            
            NSString *shoppingCarJSONString = [shoppingCarModel toJSONString];
            [self.dogUserDefaultCache addObject:shoppingCarJSONString];
            [[NSUserDefaults standardUserDefaults] setObject:self.dogUserDefaultCache forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
            [[NSUserDefaults standardUserDefaults] setObject:self.shoppingCarContainsIds forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
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
            shoppingCarModel.shoppingCarItem = goodsModel;
            shoppingCarModel.count = 1;
            [self.goodsShangPinCache addObject:shoppingCarModel];
            [self.shoppingCarContainsIds addObject:shoppingCarModel.shoppingCarFlag];
            
            NSString *shoppingCarJSONString = [shoppingCarModel toJSONString];
            [self.goodsUserDefaultCache addObject:shoppingCarJSONString];
            [[NSUserDefaults standardUserDefaults] setObject:self.goodsUserDefaultCache forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
            [[NSUserDefaults standardUserDefaults] setObject:self.shoppingCarContainsIds forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (NSString *)inner_CacheUserDefaultKeyWithRelativeKey:(NSString *)key  {
    return [NSString stringWithFormat:@"%@_%@",key, [UserServe sharedUserServe].userID];
}

- (void)updateShoppingCarGoodsCountWithModel:(YZShangChengModel *)model {
    
}

- (void)removeShoppingCarItemWithScene:(YZShangChengType)scene model:(YZShangChengModel *)model {
    YZShoppingCarModel *shoppingCarModel = (YZShoppingCarModel *)model;
    [self.shoppingCarContainsIds removeObject:shoppingCarModel.shoppingCarFlag];
    NSString *shoppingCarJSONString = [shoppingCarModel toJSONString];
    if (scene == YZShangChengType_Dog) {
        [self.dogShangPinCache removeObject:model];
        [self.dogUserDefaultCache removeObject:shoppingCarJSONString];
        [[NSUserDefaults standardUserDefaults] setObject:self.dogUserDefaultCache
                                                  forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
        [[NSUserDefaults standardUserDefaults] setObject:self.shoppingCarContainsIds
                                                  forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (scene == YZShangChengType_Goods) {
        [self.goodsShangPinCache removeObject:model];
        [self.goodsUserDefaultCache removeObject:shoppingCarJSONString];
        [[NSUserDefaults standardUserDefaults] setObject:self.goodsUserDefaultCache
                                                  forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
        [[NSUserDefaults standardUserDefaults] setObject:self.shoppingCarContainsIds
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
}

- (BOOL)shoppingCarCheckAllSelected {
    if (self.dogShangPinCache.count == 0 &&
        self.goodsShangPinCache.count == 0) {
        return NO;
    }
    BOOL __block selectAllDog = YES;
    BOOL __block selectAllGoods = YES;
    [self.dogShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarDogModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!shoppingCarModel.selected) {
            selectAllDog = NO;
            *stop = YES;
        }
    }];
    if (!selectAllDog) {
        return NO;
    }
    [self.goodsShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarGoodsModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!shoppingCarModel.selected) {
            selectAllGoods = NO;
            *stop = YES;
        }
    }];
    if (!selectAllGoods) {
        return NO;
    }
    return YES;
}

- (long long)calcuteShoppingCarTotalPrice {
    long long __block __totalPrice = 0;
    [self.dogShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarDogModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (shoppingCarModel.selected) {
            YZDogModel *detailModel = shoppingCarModel.shoppingCarItem;
            __totalPrice += detailModel.sellPrice;
        }
    }];
    
    [self.goodsShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarGoodsModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (shoppingCarModel.selected) {
            YZGoodsDetailModel *detailModel = shoppingCarModel.shoppingCarItem;
            __totalPrice += (detailModel.sellPrice * shoppingCarModel.count);
        }
    }];
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
