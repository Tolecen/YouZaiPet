//
//  NetServer+ShangCheng.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/7/6.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "NetServer+ShangCheng.h"
#import "JSONModelError.h"

@implementation NetServer (ShangCheng)

+ (void)getDogTypeAlphabetSuccess:(void(^)(NSArray *indexKeys, NSArray *alphabet, NSArray *hots))success
                          failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"dogTypeAlphabet";
    [NetServer requestWithParameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSMutableArray *alphabetOutput = [[NSMutableArray alloc] init];
                                 NSDictionary *alphabetDict = responseObject[@"value"];
                                 
                                 NSMutableArray *allKeys = [[NSMutableArray alloc] initWithArray:alphabetDict.allKeys];
                                 [allKeys removeObject:@"00"];
                                 NSArray *sortedKeys =
                                 [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
                                     return [obj1 compare:obj2 options:NSNumericSearch];
                                 }];
                                 
                                 JSONModelError *error = nil;
                                 NSArray *hotAlphabetOutput = [YZDogTypeAlphabetModel arrayOfModelsFromDictionaries:alphabetDict[@"00"] error:&error];
                                 
                                 [sortedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
                                     JSONModelError *error = nil;
                                     NSArray *singleAlphabetOutput = [YZDogTypeAlphabetModel arrayOfModelsFromDictionaries:alphabetDict[key] error:&error];
                                     [alphabetOutput addObject:singleAlphabetOutput];
                                 }];
                                 
                                 success(sortedKeys, alphabetOutput.copy, hotAlphabetOutput);
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}

+ (void)getDogDetailInfoWithDogId:(NSString *)dogId
                          success:(void(^)(YZDogDetailModel *detailModel))success
                          failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"dogDetail";
    parameters[@"id"] = dogId;
    [NetServer requestWithParameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 JSONModelError *error = nil;
                                 NSDictionary *value = responseObject[@"value"];
                                 YZDogDetailModel *detailModel = [[YZDogDetailModel alloc] initWithDictionary:value
                                                                                                        error:&error];
                                 success(detailModel);
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}

+ (void)searchDogListWithType:(NSString *)type
                      keyword:(NSString *)keyword
                         size:(YZDogSize)size
                          sex:(YZDogSex)sex
                    sellPrice:(YZDogValueRange)sellPrice
                         area:(NSString *)areaCode
                          age:(YZDogAgeRange)age
                       shopId:(NSString *)shopId
                    pageIndex:(NSInteger)pageIndex
                      success:(void(^)(NSArray *items, NSInteger nextPageIndex))success
                      failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"dogSearch";
    if (areaCode) {
        parameters[@"area"] = areaCode;
    }
    if (shopId) {
        parameters[@"shopId"] = shopId;
    }
    if (keyword) {
        parameters[@"keyword"] = keyword;
    }
    parameters[@"pageIndex"] = @(pageIndex);
    parameters[@"pageSize"] = @(20);
    if (type && ![type isEqualToString:@""]) {
        parameters[@"type"] = type;
    } else {
        [parameters removeObjectForKey:@"type"];
    }
    if (size == YZDogSize_All) {
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
                sellPriceString = @"3000_5000";
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
                                 NSArray *value = responseObject[@"value"];
                                 JSONModelError *error = nil;
                                 NSArray *responseItems = [YZDogModel arrayOfModelsFromDictionaries:value
                                                                                              error:&error];
                                 if (responseItems && responseItems.count > 0) {
                                     NSInteger newPageIndex = pageIndex + 1;
                                     success(responseItems, newPageIndex);
                                 } else {
                                     success(nil, pageIndex);
                                 }
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}

+ (void)getDogGoodsDetailInfoWithGoodsId:(NSString *)goodsId
                                 success:(void(^)(YZGoodsDetailModel *detailModel))success
                                 failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"generalDetail";
    parameters[@"id"] = goodsId;
    [NetServer requestWithParameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 JSONModelError *error = nil;
                                 NSDictionary *value = responseObject[@"value"];
                                 YZGoodsDetailModel *detailModel = [[YZGoodsDetailModel alloc] initWithDictionary:value
                                                                                                            error:&error];
                                 success(detailModel);
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}

+ (void)searchGoodsListWithKeyword:(NSString *)keyword
                         pageIndex:(NSInteger)pageIndex
                           success:(void(^)(NSArray *items, NSInteger nextPageIndex))success
                           failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"generalSearch";
    parameters[@"pageIndex"] = @(pageIndex);
    parameters[@"pageSize"] = @(20);
    if (keyword && ![keyword isEqualToString:@""]) {
        parameters[@"keyword"] = keyword;
    } else {
        [parameters removeObjectForKey:@"name"];
    }
    [NetServer requestWithParameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSArray *value = responseObject[@"value"];
                                 YZShangChengModel *error = nil;
                                 NSArray *responseItems = [YZGoodsModel arrayOfModelsFromDictionaries:value
                                                                                                error:&error];
                                 if (responseItems && responseItems.count > 0) {
                                     NSInteger newPageIndex = pageIndex + 1;
                                     success(responseItems, newPageIndex);
                                 } else {
                                     success(nil, pageIndex);
                                 }
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}

+ (void)getQuanSheDetailInfoWithShopId:(NSString *)shopId
                               success:(void(^)(YZQuanSheDetailModel *quanSheDetail))success
                               failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"shopDetail";
    parameters[@"shopId"] = shopId;
    [NetServer requestWithParameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 JSONModelError *error = nil;
                                 NSDictionary *value = responseObject[@"value"];
                                 YZQuanSheDetailModel *detailModel = [[YZQuanSheDetailModel alloc] initWithDictionary:value
                                                                                                                error:&error];
                                 success(detailModel);
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}

+ (void)searchQuanSheListWithShopName:(NSString *)shopName
                            pageIndex:(NSInteger)pageIndex
                              success:(void(^)(NSArray *items, NSInteger nextPageIndex))success
                              failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    parameters[@"command"] = @"mall";
    parameters[@"options"] = @"shopSearch";
    parameters[@"kewords"] = shopName;
    parameters[@"pageIndex"] = @(pageIndex);
    parameters[@"pageSize"] = @(20);
    
    [NetServer requestWithParameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSArray *value = responseObject[@"value"];
                                 JSONModelError *error = nil;
                                 NSArray *responseItems = [YZQuanSheModel arrayOfModelsFromDictionaries:value
                                                                                                  error:&error];
                                 if (responseItems && responseItems.count > 0) {
                                     NSInteger newPageIndex = pageIndex + 1;
                                     success(responseItems, newPageIndex);
                                 } else {
                                     success(nil, pageIndex);
                                 }
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 failure(error, operation);
                             }];
}


+ (void)getDogGoodsDetailInfoWithParameters:(NSDictionary *)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/market/search",BasePayUrl];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:path]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSLog(@"req:%@,path:%@",parameters,path);
    [httpClient getPath:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (success) {
            success(JSON);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error, operation);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}
+ (void)getDogGoodsDetailTagSuccess:(void(^)(id responseObject))success
                            failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = [[NSString alloc] initWithFormat:@"%@/market/categories/flag/goods",BasePayUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:path]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient getPath:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (success) {
            success(JSON);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error, operation);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}


@end
