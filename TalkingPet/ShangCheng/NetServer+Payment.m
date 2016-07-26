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
    [httpClient postPath:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (success) {
            success(operation, JSON);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)fetchOrderListWithPageIndex:(NSInteger)pageIndex
                            success:(void (^)(id))success
                            failure:(void (^)(NSError *, AFHTTPRequestOperation *))failure {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"token"] = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];;
//    params[@"uid"] = [UserServe sharedUserServe].userID;
    params[@"uid"] = @"333";
//    params[@"get"] = @"";
    NSString *path = [[NSString alloc] initWithFormat:@"%@/orders/rows",BasePayUrl];
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