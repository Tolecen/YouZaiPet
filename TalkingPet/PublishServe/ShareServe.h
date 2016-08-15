//
//  ShareServe.h
//  TalkingPet
//
//  Created by wangxr on 14-8-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#ifndef DevelopModeUU
#define SHAREBASEURL @"http://www.chongwushuo.com/h5/index.html?petakeID="
#define GOODSBASEURL @"http://www.chongwushuo.com/h5/goods/%@.html"
#define INTERACTIONBASEURL @"http://www.chongwushuo.com/h5/topic/index.html?id=%@"
#define ONETOPICBASEURL @"http://www.chongwushuo.com/h5/oneTopic/index.html?id=%@"
#else
#define SHAREBASEURL @"http://testapi.buybestpet.com/h5/index.html?petakeID="
#define GOODSBASEURL @"http://testwww.chongwushuo.com/h5/goods/%@.html"
#define INTERACTIONBASEURL @"http://testwww.chongwushuo.com/h5/topic/index.html?id=%@"
#define ONETOPICBASEURL @"http://testwww.chongwushuo.com/h5/oneTopic/index.html?id=%@"
#endif
@interface ShareServe : NSObject
+(void)buildShareSDK;
+(void)authSineWithSucceed:(void (^)(BOOL state))success;
+(void)shareToSineWithContent:(NSString*)content imageUrl:(NSString*)url Succeed:(void (^)())success;
+(void)shareToQQWithTitle:(NSString*)title Content:(NSString*)content imageUrl:(NSString*)url webUrl:(NSString*)web Succeed:(void (^)())success;
+(void)shareToFriendCircleWithTitle:(NSString*)title Content:(NSString*)content imageUrl:(NSString*)url webUrl:(NSString*)web Succeed:(void (^)())success;
+(void)shareToWeixiFriendWithTitle:(NSString*)title Content:(NSString*)content imageUrl:(NSString*)url webUrl:(NSString*)web Succeed:(void (^)())succes;

+(void)shareNumberUpWithPetalkId:(NSString *)petalkId;
+(void)getCurrentUserInfoWithPlatformSinaSuccess:(void (^)(NSDictionary * dict))success;
+(void)getCurrentUserInfoWithPlatformQQ;
+(void)getCurrentUserInfoWithPlatformWeChat;

@end
