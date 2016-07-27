//
//  NetServer+Payment.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/25.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "NetServer.h"

@interface NetServer (Payment)

+ (void)fetchOrderListWithPageIndex:(NSInteger)pageIndex Option:(NSString *)option
                            success:(void(^)(id result))success
                            failure:(void(^)(NSError *error, AFHTTPRequestOperation *operation))failure;

+ (void)fetchOrderDetailWithOrderNo:(NSString *)orderNo
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure;

@end
