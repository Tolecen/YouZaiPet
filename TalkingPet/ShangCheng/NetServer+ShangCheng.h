//
//  NetServer+ShangCheng.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/7/6.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "NetServer.h"
#import "YZShangChengConst.h"

@interface NetServer (ShangCheng)

//1003_狗狗详情
+ (void)getDogDetailInfoWithDogId:(NSString *)dogId
                          success:(void(^)(id data))success
                          failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//1004_狗狗搜索（不带任何查询条件即为所有的列表）
+ (void)searchDogListWithType:(NSString *)type
                         size:(YZShangChengDogSize)size
                          sex:(YZDogSex)sex
                    sellPrice:(YZDogValueRange)sellPrice
                         area:(NSInteger)areaCode
                          age:(YZDogAgeRange)age
                       shopId:(NSString *)shopId
                    pageIndex:(NSInteger)pageIndex
                      success:(void(^)(id data, NSInteger nextPageIndex))success
                      failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//1005_狗狗用品详情
+ (void)getDogGoodsDetailInfoWithGoodsId:(NSString *)goodsId
                                 success:(void(^)(id data))success
                                 failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//1006_狗狗用品搜索

//1008_犬舍详情
+ (void)getQuanSheDetailInfoWithShopId:(NSString *)shopId
                               success:(void(^)(id data))success
                               failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

//1009_犬舍搜索
+ (void)searchQuanSheListWithShopName:(NSString *)shopName
                            pageIndex:(NSInteger)pageIndex
                              success:(void(^)(id data, NSInteger nextPageIndex))success
                              failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

@end
