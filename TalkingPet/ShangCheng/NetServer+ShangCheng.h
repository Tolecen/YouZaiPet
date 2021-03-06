//
//  NetServer+ShangCheng.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/7/6.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "NetServer.h"
#import "YZShangChengModel.h"

@interface NetServer (ShangCheng)

//1001_犬种字母表
+ (void)getDogTypeAlphabetSuccess:(void(^)(NSArray *indexKeys, NSArray *alphabet, NSArray *hots))success
                          failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//1003_狗狗详情
+ (void)getDogDetailInfoWithDogId:(NSString *)dogId
                          success:(void(^)(YZDogDetailModel *detailModel))success
                          failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//1004_狗狗搜索（不带任何查询条件即为所有的列表）
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
                      failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//1005_狗狗用品详情
+ (void)getDogGoodsDetailInfoWithGoodsId:(NSString *)goodsId
                                 success:(void(^)(YZGoodsDetailModel *detailModel))success
                                 failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//1006_狗狗用品搜索
+ (void)searchGoodsListWithKeyword:(NSString *)keyword
                         pageIndex:(NSInteger)pageIndex
                           success:(void(^)(NSArray *items, NSInteger nextPageIndex))success
                           failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//1008_犬舍详情
+ (void)getQuanSheDetailInfoWithShopId:(NSString *)shopId
                               success:(void(^)(YZQuanSheDetailModel *quanSheDetail))success
                               failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//1009_犬舍搜索
+ (void)searchQuanSheListWithShopName:(NSString *)shopName
                            pageIndex:(NSInteger)pageIndex
                              success:(void(^)(NSArray *items, NSInteger nextPageIndex))success
                              failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//商品搜索

+ (void)getDogGoodsDetailInfoWithParameters:(NSDictionary *)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//分类标签获取
+ (void)getDogGoodsDetailTagSuccess:(void(^)(id responseObject))success
                            failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

@end
