//
//  NetServer+ShangCheng.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/7/6.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "NetServer+ShangCheng.h"

@implementation NetServer (ShangCheng)

+ (void)getDogDetailInfoWithDogId:(NSString *)dogId
                          success:(void(^)(id data))success
                          failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"dogDetail";
    parameters[@"id"] = dogId;
    [NetServer requestWithParameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}

+ (void)searchDogListWithType:(NSString *)type
                         size:(YZShangChengDogSize)size
                          sex:(YZDogSex)sex
                    sellPrice:(YZDogValueRange)sellPrice
                         area:(NSInteger)areaCode
                          age:(YZDogAgeRange)age
                       shopId:(NSString *)shopId
                    pageIndex:(NSInteger)pageIndex
                      success:(void(^)(id data, NSInteger nextPageIndex))success
                      failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"dogSearch";
    parameters[@"area"] = @(areaCode);
    parameters[@"shopId"] = shopId;
    parameters[@"pageIndex"] = @(pageIndex);
    parameters[@"pageSize"] = @(20);
    parameters[@"type"] = type;
    if (size == YZShangChengDogSize_All) {
        [parameters removeObjectForKey:@"size"];
    } else {
        parameters[@"size"] = @(size);
    }
    
    if (sex == YZDogSex_All) {
        [parameters removeObjectForKey:@"sex"];
    } else {
        parameters[@"sex"] = @(sex);
    }
    
    if (sellPrice == YZDogValueRange_All) {
        [parameters removeObjectForKey:@"sellPrice"];
    } else {
        NSString *sellPriceString = @"0_3000";
        switch (sellPrice) {
            case YZDogValueRange_3k:
                sellPriceString = @"0_3000";
                break;
            case YZDogValueRange_3_5k:
                sellPriceString = @"3000_6000";
                break;
            case YZDogValueRange_5_10k:
                sellPriceString = @"5000_10000";
                break;
            case YZDogValueRange_10k:
                sellPriceString = @"10000_";
                break;
            default:
                break;
        }
        parameters[@"sellPrice"] = sellPriceString;
    }
    
    if (age == YZDogAgeRange_All) {
        [parameters removeObjectForKey:@"age"];
    } else {
        NSString *ageString = @"0_3";
        switch (age) {
            case YZDogAgeRange_OM:
                ageString = @"_0";
                break;
            case YZDogAgeRange_0_3M:
                ageString = @"0_3";
                break;
            case YZDogAgeRange_3_6M:
                ageString = @"3_6";
                break;
            case YZDogAgeRange_6_12M:
                ageString = @"6_12";
                break;
            case YZDogAgeRange_1Y:
                ageString = @"12_";
                break;
            default:
                break;
        }
        parameters[@"age"] = ageString;
    }
    [NetServer requestWithParameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}

+ (void)getDogGoodsDetailInfoWithGoodsId:(NSString *)goodsId
                                 success:(void(^)(id data))success
                                 failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"generalDetail";
    parameters[@"id"] = goodsId;
    [NetServer requestWithParameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}

+ (void)getQuanSheDetailInfoWithShopId:(NSString *)shopId
                               success:(void(^)(id data))success
                               failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"shopDetail";
    parameters[@"shopId"] = shopId;
    [NetServer requestWithParameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}

+ (void)searchQuanSheListWithShopName:(NSString *)shopName
                            pageIndex:(NSInteger)pageIndex
                              success:(void(^)(id data, NSInteger nextPageIndex))success
                              failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"shopSearch";
    parameters[@"shopName"] = shopName;
    parameters[@"pageIndex"] = @(pageIndex);
    parameters[@"pageSize"] = @(20);
    [NetServer requestWithParameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}

@end
