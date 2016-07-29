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

+ (void)confirmReceviedGoodWithGoodUrl:(NSString *)goodUrl
                               success:(void (^)(id result))success
                               failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)cancelOrderWithOrderNo:(NSString *)orderNo
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)getAddressCodeWithsuccess:(void (^)(id result))success
failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)addAddressWithAdress:(ReceiptAddress *)address
                     success:(void (^)(id result))success
                     failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

@end
