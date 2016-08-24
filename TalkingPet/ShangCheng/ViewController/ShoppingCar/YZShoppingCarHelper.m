//
//  YZShoppingCarHelper.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/13.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingCarHelper.h"
#import "OrderYZGoodInfo.h"
#import "Common.h"
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
        
        NSString *cacheDogKey = [self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey];
        NSString *cacheGoodsKey = [self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey];
        NSString *cacheIdKey = [self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey];
        id cacheDogs = [[NSUserDefaults standardUserDefaults] objectForKey:cacheDogKey];
        id cacheGoods = [[NSUserDefaults standardUserDefaults] objectForKey:cacheGoodsKey];
        id cacheIds = [[NSUserDefaults standardUserDefaults] objectForKey:cacheIdKey];
        if (cacheDogs) {
            if ([[NSKeyedUnarchiver unarchiveObjectWithData:cacheDogs] isKindOfClass:[NSArray class]]) {
                [self.dogShangPinCache addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:cacheDogs]];
            } else {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheDogKey];
            }
        }
        if (cacheGoods) {
            if ([[NSKeyedUnarchiver unarchiveObjectWithData:cacheGoods] isKindOfClass:[NSArray class]]) {
                [self.goodsShangPinCache addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:cacheGoods]];
            } else {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheGoodsKey];
            }
        }
        if (cacheIds) {
            if ([[NSKeyedUnarchiver unarchiveObjectWithData:cacheIds] isKindOfClass:[NSArray class]]) {
                [self.shoppingCarContainsIds addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:cacheIds]];
            } else {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheIdKey];
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

- (void)addShoppingCarWithDict:(NSDictionary *)dict
                     clearPrice:(BOOL)clearPrice {
    NSString * cartId = [NSString stringWithFormat:@"%@",dict[@"id"]];
    if ([[dict objectForKey:@"model"] isEqualToString:@"Dog"]) {
        YZDogModel *dogModel = [[YZDogModel alloc] init];
        dogModel.dogId = [NSString stringWithFormat:@"%@",dict[@"gid"]];
        if (!dogModel.dogId || dogModel.dogId.length == 0) {
            return;
        }
        BOOL checkContains = [self inner_CheckShoppingCarContainsItem:dogModel.dogId];
        if (checkContains) {
            if (clearPrice) {
                [self.dogShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarDogModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([shoppingCarModel.dogId isEqualToString:dogModel.dogId]) {
                        shoppingCarModel.selected = YES;
                        *stop = YES;
                    }
                }];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.dogShangPinCache]
                                                          forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
            }
        } else {
            YZShoppingCarDogModel *shoppingCarModel = [[YZShoppingCarDogModel alloc] init];
            shoppingCarModel.shoppingCarFlag = dogModel.dogId;
            shoppingCarModel.count = 1;
            shoppingCarModel.name = [dict objectForKey:@"name"];
            shoppingCarModel.dogId = dogModel.dogId;
            shoppingCarModel.sex = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"sex"]] intValue]==0?YZDogSex_Male:YZDogSex_Female;
            NSString * saleFlag = [NSString stringWithFormat:@"%@",[dict objectForKey:@"sale_flag"]];
            if ([saleFlag intValue]==0) {
                shoppingCarModel.sellPrice = [[dict objectForKey:@"sell_price"] longLongValue];
            }
            else if ([saleFlag intValue]==1) {
                shoppingCarModel.sellPrice = [[dict objectForKey:@"special_price"] longLongValue];
            }
            else if ([saleFlag intValue]==2) {
                shoppingCarModel.sellPrice = [[dict objectForKey:@"special_price"] longLongValue];
            }
            else if ([saleFlag intValue]==3) {
                shoppingCarModel.sellPrice = [[dict objectForKey:@"sell_price"] longLongValue]-[[dict objectForKey:@"special_price"] longLongValue];
            }

//            shoppingCarModel.sellPrice = [[dict objectForKey:@"sell_price"] longLongValue];
            shoppingCarModel.thumb = [dict objectForKey:@"thumb"];
            shoppingCarModel.birtydayDays = [[NSString stringWithFormat:@"%@",[[dict objectForKey:@"days"] objectForKey:@"age"]] integerValue];
            shoppingCarModel.birthdayString = [dict objectForKey:@"birthday"];
            shoppingCarModel.shopId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"shop_id"]];
            shoppingCarModel.shopNo = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"shop_no"]] longLongValue];
            shoppingCarModel.shopThumb = [dict objectForKey:@"shop_thumb"];
            shoppingCarModel.shopName = [dict objectForKey:@"shop_name"];
            if (clearPrice) {
                shoppingCarModel.selected = YES;
            }
            
            [self.dogShangPinCache addObject:shoppingCarModel];
            [self.shoppingCarContainsIds addObject:dogModel.dogId];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.dogShangPinCache]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.shoppingCarContainsIds]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
            
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            [Common addCountForCart];
        }
    } else  {
        YZGoodsDetailModel *goodsModel = [[YZGoodsDetailModel alloc] init];
        goodsModel.goodsId = [NSString stringWithFormat:@"%@",dict[@"gid"]];
        if (!goodsModel.goodsId || goodsModel.goodsId.length == 0) {
            return;
        }
        BOOL checkContains = [self inner_CheckShoppingCarContainsItem:goodsModel.goodsId];
        if (checkContains) {
            if (clearPrice) {
                [self.goodsShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarGoodsModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([shoppingCarModel.goodsId isEqualToString:goodsModel.goodsId]) {
                        shoppingCarModel.count = shoppingCarModel.count+1;
                        shoppingCarModel.selected = YES;
                        *stop = YES;
                    }
                }];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goodsShangPinCache]
                                                          forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
            }
            else
            {
                [self.goodsShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarGoodsModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([shoppingCarModel.goodsId isEqualToString:goodsModel.goodsId]) {
                        shoppingCarModel.count = shoppingCarModel.count+1;
                        *stop = YES;
                    }
                }];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goodsShangPinCache]
                                                          forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
            }
        } else {
            YZShoppingCarGoodsModel *shoppingCarModel = [[YZShoppingCarGoodsModel alloc] init];
            shoppingCarModel.shoppingCarFlag = goodsModel.goodsId;
            shoppingCarModel.count = 1;
            shoppingCarModel.name = [dict objectForKey:@"name"];
            shoppingCarModel.goodsId = goodsModel.goodsId;
            NSString * saleFlag = [NSString stringWithFormat:@"%@",[dict objectForKey:@"sale_flag"]];
            if ([saleFlag intValue]==0) {
                shoppingCarModel.sellPrice = [[dict objectForKey:@"sell_price"] longLongValue];
            }
            else if ([saleFlag intValue]==1) {
                shoppingCarModel.sellPrice = [[dict objectForKey:@"special_price"] longLongValue];
            }
            else if ([saleFlag intValue]==2) {
                shoppingCarModel.sellPrice = [[dict objectForKey:@"special_price"] longLongValue];
            }
            else if ([saleFlag intValue]==3) {
                shoppingCarModel.sellPrice = [[dict objectForKey:@"sell_price"] longLongValue]-[[dict objectForKey:@"special_price"] longLongValue];
            }
            shoppingCarModel.thumb = [dict objectForKey:@"thumb"];
            shoppingCarModel.brandName = [dict objectForKey:@"shop_name"];
            if (clearPrice) {
                shoppingCarModel.selected = YES;
            }
            [self.goodsShangPinCache addObject:shoppingCarModel];
            [self.shoppingCarContainsIds addObject:goodsModel.goodsId];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goodsShangPinCache]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.shoppingCarContainsIds]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            [Common addCountForCart];
        }
    }
}


- (void)addShoppingCarWithScene:(YZShangChengType)scene
                          model:(YZShangChengModel *)model
                     clearPrice:(BOOL)clearPrice {
    if (scene == YZShangChengType_Dog) {
        YZDogModel *dogModel = (YZDogModel *)model;
        if (!dogModel.dogId || dogModel.dogId.length == 0) {
            return;
        }
        BOOL checkContains = [self inner_CheckShoppingCarContainsItem:dogModel.dogId];
        if (checkContains) {
            if (clearPrice) {
                [self.dogShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarDogModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([shoppingCarModel.dogId isEqualToString:dogModel.dogId]) {
                        shoppingCarModel.selected = YES;
                        *stop = YES;
                    }
                }];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.dogShangPinCache]
                                                          forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
            }
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
            if (clearPrice) {
                shoppingCarModel.selected = YES;
            }

            [self.dogShangPinCache addObject:shoppingCarModel];
            [self.shoppingCarContainsIds addObject:shoppingCarModel.shoppingCarFlag];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.dogShangPinCache]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.shoppingCarContainsIds]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
            
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            [Common addCountForCart];
        }
    } else if (scene == YZShangChengType_Goods) {
        YZGoodsDetailModel *goodsModel = (YZGoodsDetailModel *)model;
        if (!goodsModel.goodsId || goodsModel.goodsId.length == 0) {
            return;
        }
        BOOL checkContains = [self inner_CheckShoppingCarContainsItem:goodsModel.goodsId];
        if (checkContains) {
            if (clearPrice) {
                [self.goodsShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarGoodsModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([shoppingCarModel.goodsId isEqualToString:goodsModel.goodsId]) {
                        shoppingCarModel.selected = YES;
                        *stop = YES;
                    }
                }];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goodsShangPinCache]
                                                          forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
            }
        } else {
            YZShoppingCarGoodsModel *shoppingCarModel = [[YZShoppingCarGoodsModel alloc] init];
            shoppingCarModel.shoppingCarFlag = goodsModel.goodsId;
            shoppingCarModel.count = 1;
            shoppingCarModel.name = goodsModel.name;
            shoppingCarModel.goodsId = goodsModel.goodsId;
            shoppingCarModel.sellPrice = goodsModel.sellPrice;
            shoppingCarModel.thumb = goodsModel.thumb;
            shoppingCarModel.brandName = goodsModel.brand.brand;
            if (clearPrice) {
                shoppingCarModel.selected = YES;
            }
            [self.goodsShangPinCache addObject:shoppingCarModel];
            [self.shoppingCarContainsIds addObject:shoppingCarModel.shoppingCarFlag];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goodsShangPinCache]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.shoppingCarContainsIds]
                                                      forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            [Common addCountForCart];
        }
    }
}

- (NSString *)inner_CacheUserDefaultKeyWithRelativeKey:(NSString *)key  {
    return [NSString stringWithFormat:@"%@_%@",key, [UserServe sharedUserServe].userID];
}

- (void)updateShoppingCarGoodsCountWithModel:(YZShangChengModel *)model {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goodsShangPinCache]
                                              forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

-(void)removeAllFromCart
{
    [self.shoppingCarContainsIds removeAllObjects];
    [self.dogShangPinCache removeAllObjects];
    [self.goodsShangPinCache removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.dogShangPinCache]
                                              forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goodsShangPinCache]
                                              forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.shoppingCarContainsIds]
                                              forKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

- (NSArray *)orderMergeSelectDogsAndGoodsWithCount:(NSInteger *)count {
    NSMutableArray *orders = [[NSMutableArray alloc] init];
    NSInteger __block allSelectCount = 0;
    [self.dogShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarDogModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (shoppingCarModel.selected) {
            allSelectCount += shoppingCarModel.count;
            OrderYZGoodInfo *orderInfo = [self inner_TransformFromShoppingCarDogModel:shoppingCarModel];
            [orders addObject:orderInfo];
        }
    }];
    
    [self.goodsShangPinCache enumerateObjectsUsingBlock:^(YZShoppingCarGoodsModel *shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (shoppingCarModel.selected) {
            allSelectCount += shoppingCarModel.count;
            OrderYZGoodInfo *orderInfo = [self inner_TransformFromShoppingCarGoodsModel:shoppingCarModel];
            [orders addObject:orderInfo];
        }
    }];
    
    *count = allSelectCount;
    return orders.copy;
}

- (OrderYZGoodInfo *)inner_TransformFromShoppingCarDogModel:(YZShoppingCarDogModel *)shoppingCarModel {
    OrderYZGoodInfo *orderInfo = [[OrderYZGoodInfo alloc] init];
    orderInfo.thumb = shoppingCarModel.thumb;
    orderInfo.product_name = shoppingCarModel.name;
    orderInfo.shop_name = shoppingCarModel.shopName;
    orderInfo.goodId = shoppingCarModel.dogId;
    orderInfo.unit_price = [NSString stringWithFormat:@"%lld", shoppingCarModel.sellPrice];
    orderInfo.total = [NSString stringWithFormat:@"%ld", (unsigned long)shoppingCarModel.count];
    return orderInfo;
}

- (OrderYZGoodInfo *)inner_TransformFromShoppingCarGoodsModel:(YZShoppingCarGoodsModel *)shoppingCarModel {
    OrderYZGoodInfo *orderInfo = [[OrderYZGoodInfo alloc] init];
    orderInfo.thumb = shoppingCarModel.thumb;
    orderInfo.product_name = shoppingCarModel.name;
    orderInfo.shop_name = shoppingCarModel.brandName;
    orderInfo.goodId = shoppingCarModel.goodsId;
    orderInfo.unit_price = [NSString stringWithFormat:@"%lld", shoppingCarModel.sellPrice];
    orderInfo.total = [NSString stringWithFormat:@"%ld", (unsigned long)shoppingCarModel.count];
    return orderInfo;
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey]];
}

- (void)updateCurrentUserShoppingCar {
    [self.dogShangPinCache removeAllObjects];
    [self.goodsShangPinCache removeAllObjects];
    [self.shoppingCarContainsIds removeAllObjects];
    self.totalPrice = 0;
    NSString *cacheDogKey = [self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheDogKey];
    NSString *cacheGoodsKey = [self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheGoodsKey];
    NSString *cacheIdKey = [self inner_CacheUserDefaultKeyWithRelativeKey:kShoppingCarCacheContainsIdKey];
    id cacheDogs = [[NSUserDefaults standardUserDefaults] objectForKey:cacheDogKey];
    id cacheGoods = [[NSUserDefaults standardUserDefaults] objectForKey:cacheGoodsKey];
    id cacheIds = [[NSUserDefaults standardUserDefaults] objectForKey:cacheIdKey];
    if (cacheDogs) {
        if ([[NSKeyedUnarchiver unarchiveObjectWithData:cacheDogs] isKindOfClass:[NSArray class]]) {
            [self.dogShangPinCache addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:cacheDogs]];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheDogKey];
        }
    }
    if (cacheGoods) {
        if ([[NSKeyedUnarchiver unarchiveObjectWithData:cacheGoods] isKindOfClass:[NSArray class]]) {
            [self.goodsShangPinCache addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:cacheGoods]];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheGoodsKey];
        }
    }
    if (cacheIds) {
        if ([[NSKeyedUnarchiver unarchiveObjectWithData:cacheIds] isKindOfClass:[NSArray class]]) {
            [self.shoppingCarContainsIds addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:cacheIds]];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheIdKey];
        }
    }
}

- (long long)totalPrice {
    return [self calcuteShoppingCarTotalPrice];
}

@end
