//
//  NetServer+Payment.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/25.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "NetServer.h"
#import "ReceiptAddress.h"
@interface NetServer (Payment)

+ (void)fetchOrderListWithPageIndex:(NSInteger)pageIndex Option:(NSString *)option
                            success:(void(^)(id result))success
                            failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)fetchOrderDetailWithOrderNo:(NSString *)orderNo
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)confirmReceviedGoodWithGoodUrl:(NSString *)goodUrl paras:(NSArray *)paras
                               success:(void (^)(id result))success
                               failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)cancelOrderWithOrderNo:(NSString *)orderNo
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;
+ (void)deleteOrderWithOrderNo:(NSString *)orderNo
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;
+ (void)getAddressCodeWithsuccess:(void (^)(id result))success
failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)addAddressWithAdress:(ReceiptAddress *)address
                     success:(void (^)(id result))success
                     failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)deleteAddressWithAdressId:(NSString *)addressId
                     success:(void (^)(id result))success
                     failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)setDefaultAddressWithAdressId:(NSString *)addressId
                              success:(void (^)(id result))success
                              failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)editAddressWithAdress:(ReceiptAddress *)address
                     success:(void (^)(id result))success
                     failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)fentchAddressListsuccess:(void (^)(id result))success
                     failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)fentchDefaultAddressSuccess:(void (^)(id result))success
                         failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)createOrderNoSuccess:(void (^)(id result))success
                    failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)requestPaymentWithGoods:(NSArray *)array AddressId:(NSString *)addressId ChannelStr:(NSString *)channelStr Voucher:(NSString *)voucher success:(void (^)(id result))success
                        failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)getMarketDetailsuccess:(void (^)(id result))success
                       failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;
+ (void)getMarketDetailGoodsWithlink:(NSString *)link success:(void (^)(id result))success
                             failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;
@end
