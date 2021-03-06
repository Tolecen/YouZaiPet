//
//  NetServer+Payment.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/25.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "NetServer+Payment.h"

@implementation NetServer (Payment)

+ (void)inner_PayServerConfigWithWithPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:path]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSLog(@"req:%@,path:%@",parameters,path);
    [httpClient postPath:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (success) {
            success(operation, JSON);
        }
        NSLog(@"responseData:%@",JSON);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)fetchOrderListWithPageIndex:(NSInteger)pageIndex Option:(NSString *)option
                            success:(void (^)(id))success
                            failure:(void (^)(NSError *, AFHTTPRequestOperation *))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    
    //    params[@"uid"] = @"333";
    //    params[@"get"] = @"";
    
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/orders/rows",BasePayUrl];
    if (![option isEqualToString:@"allList"]) {
        path = [[NSString alloc] initWithFormat:@"%@/orders/rows/status/%@",BasePayUrl,option];
    }
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)fetchUpaidedCountersuccess:(void (^)(id))success
                            failure:(void (^)(NSError *, AFHTTPRequestOperation *))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
    params[@"uid"] = [UserServe sharedUserServe].userID;
    
    //    params[@"uid"] = @"333";
    //    params[@"get"] = @"";
    
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/counter/orders",BasePayUrl];

    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)fetchCartCountersuccess:(void (^)(id))success
                           failure:(void (^)(NSError *, AFHTTPRequestOperation *))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
    params[@"uid"] = [UserServe sharedUserServe].userID;
    
    //    params[@"uid"] = @"333";
    //    params[@"get"] = @"";
    
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/counter/carts",BasePayUrl];
    
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)fetchOrderDetailWithOrderNo:(NSString *)orderNo
                            success:(void (^)(id))success
                            failure:(void (^)(NSError *, AFHTTPRequestOperation *))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/orders/details/order_no/%@",BasePayUrl,orderNo];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}


+ (void)confirmReceviedGoodWithGoodUrl:(NSString *)goodUrl paras:(NSArray *)paras
                               success:(void (^)(id))success
                               failure:(void (^)(NSError *, AFHTTPRequestOperation *))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    
    if (paras) {
        params[@"front"] = paras[0];
        params[@"back"] = paras[1];
        
        params[@"picked_up"] = paras[2];
        
    }
    
    NSString *path = goodUrl;
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}


+ (void)cancelOrderWithOrderNo:(NSString *)orderNo
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *, AFHTTPRequestOperation *))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/orders/cancel/order_no/%@",BasePayUrl,orderNo];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

//取消订单
+ (void)cancleOrderWithOrderNo:(NSString *)orderNo
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *, AFHTTPRequestOperation *))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //params[@"order_no"] = orderNo;
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/orders/cancell/order_no/%@",BasePayUrl,orderNo];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}


+ (void)deleteOrderWithOrderNo:(NSString *)orderNo
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *, AFHTTPRequestOperation *))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/orders/dele/order_no/%@",BasePayUrl,orderNo];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)getAddressCodeWithsuccess:(void (^)(id))success
                          failure:(void (^)(NSError *, AFHTTPRequestOperation *))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/address/areas",BasePayUrl];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)addAddressWithAdress:(ReceiptAddress *)address
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *, AFHTTPRequestOperation *))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    params[@"consignee"] = address.receiptName;
    params[@"address"] = address.address;
    params[@"province"] = address.provinceCode;
    params[@"city"] = address.cityCode;
    params[@"area"] = address.quCode;
    params[@"telphone"] = address.phoneNo;
    params[@"default"] = [NSString stringWithFormat:@"%d",address.action];
    if (address.cardId>0) {
        params[@"card_id"] = address.cardId;
    }
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/address/add",BasePayUrl];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)deleteAddressWithAdressId:(NSString *)addressId
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/address/dele/id/%@",BasePayUrl,addressId];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)setDefaultAddressWithAdressId:(NSString *)addressId
                              success:(void (^)(id result))success
                              failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/address/set/id/%@",BasePayUrl,addressId];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}


+ (void)editAddressWithAdress:(ReceiptAddress *)address
                      success:(void (^)(id result))success
                      failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    params[@"consignee"] = address.receiptName;
    params[@"address"] = address.address;
    params[@"province"] = address.provinceCode;
    params[@"city"] = address.cityCode;
    params[@"area"] = address.quCode;
    params[@"telphone"] = address.phoneNo;
    params[@"default"] = [NSString stringWithFormat:@"%d",address.action];
    if (address.cardId>0) {
        params[@"card_id"] = address.cardId;
    }
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/address/edit/id/%@",BasePayUrl,address.addressID];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)fentchAddressListsuccess:(void (^)(id result))success
                         failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/address/rows",BasePayUrl];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
    
}

+ (void)fentchDefaultAddressSuccess:(void (^)(id result))success
                            failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/address/shopping",BasePayUrl];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}


+ (void)getKuaJingGoodsSuccess:(void (^)(id result))success
                       failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    params[@"source"] = @"app";
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/payment/mustcardid",BasePayUrl];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)createOrderNoSuccess:(void (^)(id result))success
                     failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    params[@"source"] = @"app";
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/payment/order",BasePayUrl];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)regUserNewMethodDict:(NSDictionary *)dict Success:(void (^)(id result))success
                     failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/member/register",BasePayUrl];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:dict
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)resetPWD:(NSString *)pwd uname:(NSString *)uname Success:(void (^)(id result))success
                     failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/member/resetpwd",BasePayUrl];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"username"] = uname;
    params[@"password"] = pwd;
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)updateUserInfoHead:(NSString *)head nickname:(NSString *)nickname Success:(void (^)(id result))success
         failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/member/updateInfo",BasePayUrl];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"nickname"] = nickname;
    params[@"head"] = head;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}



+ (void)requestPaymentWithGoods:(NSArray *)array AddressId:(NSString *)addressId ChannelStr:(NSString *)channelStr Voucher:(NSString *)voucher success:(void (^)(id result))success
                        failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    params[@"source"] = @"app";
    params[@"goods"] = array;
    params[@"address_id"] = addressId;
    params[@"channel"] = channelStr;
    if (voucher) {
        params[@"voucher"] = voucher;
    }
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/payment/shopping",BasePayUrl];
    
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

//+ (void)getMarketDetailsuccess:(void (^)(id result))success
//                       failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
//{
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
//    params[@"uid"] = [UserServe sharedUserServe].userID;
//    NSString *path = [[NSString alloc] initWithFormat:@"%@/guider/rows",BasePayUrl];
//    params[@"source"] = @"app";
//
//
//
//    [NetServer inner_PayServerConfigWithWithPath:path
//                                      parameters:params
//                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                             success(responseObject);
//                                         }
//                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                             failure(error,operation);
//                                         }];
//
//
//
//}

//商城专题页面
+ (void)getMarketDetailsuccess:(void (^)(id result))success
                       failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/guider/rows",BasePayUrl];
    
    
    
    
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
    
    
    
}

+ (void)getMarketDetailGoodsWithlink:(NSString *)link success:(void (^)(id result))success
                             failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    
    [NetServer inner_PayServerConfigWithWithPath:link
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)fetchCartListSuccess:(void (^)(id result))success
                     failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    params[@"source"] = @"app";
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/cart/rows",BasePayUrl];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}


+ (void)addToCartwithId:(NSString *)goodId Success:(void (^)(id result))success
                     failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    params[@"source"] = @"app";
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/cart/add/id/%@",BasePayUrl,goodId];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

+ (void)deleteFromCartwithId:(NSString *)goodId Success:(void (^)(id result))success
                failure:(void (^)(NSError *error, AFHTTPRequestOperation *operation))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
    params[@"uid"] = [UserServe sharedUserServe].userID;
    //    params[@"order_no"] = orderNo;
    params[@"source"] = @"app";
    
    NSString *path = [[NSString alloc] initWithFormat:@"%@/cart/dele/id/%@",BasePayUrl,goodId];
    [NetServer inner_PayServerConfigWithWithPath:path
                                      parameters:params
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             success(responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             failure(error,operation);
                                         }];
}

@end
