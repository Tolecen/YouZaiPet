//
//  ShareServe.m
//  TalkingPet
//
//  Created by wangxr on 14-8-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ShareServe.h"
#import "SVProgressHUD.h"

@implementation ShareServe
+(void)buildShareSDK
{
    [ShareSDK registerApp:@"2f37350b8994"];
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"1804983872"
                               appSecret:@"2ebcf3586c64b5bf32dac1d67f1fcdf"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectQQWithQZoneAppKey:@"1102327672"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //    [ShareSDK connectQQWithAppId:@"1102327672" qqApiCls:[QQApi class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wxb62f795f2bc6b770" wechatCls:[WXApi class]];
}
+(void)authSineWithSucceed:(void (^)(BOOL state))success
{
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
        success(YES);
    }else{
        [ShareSDK authWithType:ShareTypeSinaWeibo options:nil result:^(SSAuthState state, id<ICMErrorInfo> error) {
            if (state == SSAuthStateSuccess) {
                success(YES);
            }
            if (state == SSAuthStateFail||state == SSAuthStateCancel) {
                success(NO);
            }
        }];
    }
}
+(void)shareToSineWithContent:(NSString*)content imageUrl:(NSString*)url Succeed:(void (^)())success
{
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:url?[ShareSDK imageWithUrl:url]:nil
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [SVProgressHUD showWithStatus:@"正在分享,请稍后"];
                        }
                        if (state == SSResponseStateCancel)
                        {
                            [SVProgressHUD dismiss];
                        }
                        if (state == SSResponseStateSuccess) {
                            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                            if (success) {
                                success();
                            }
                        }
                        if (state == SSResponseStateFail) {
                            [SVProgressHUD dismiss];
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"  message:[NSString stringWithFormat:@"发送失败!%@",[error errorDescription]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                            [alertView show];
                        }
                    }];
}
+(void)shareToQQWithTitle:(NSString*)title Content:(NSString*)content imageUrl:(NSString*)url webUrl:(NSString*)web Succeed:(void (^)())success
{
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:url?[ShareSDK imageWithUrl:url]:nil
                                                title:title
                                                  url:web
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [ShareSDK shareContent:publishContent
                      type:ShareTypeQQ
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [SVProgressHUD showWithStatus:@"正在分享,请稍后"];
                        }
                        if (state == SSResponseStateCancel)
                        {
                            [SVProgressHUD dismiss];
                        }
                        if (state == SSResponseStateSuccess) {
                            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                            if (success) {
                                success();
                            }
                        }
                        if (state == SSResponseStateFail) {
                            [SVProgressHUD dismiss];
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"  message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                            [alertView show];
                        }
                    }];
}
+(void)shareToFriendCircleWithTitle:(NSString*)title Content:(NSString*)content imageUrl:(NSString*)url webUrl:(NSString*)web Succeed:(void (^)())success
{
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:url?[ShareSDK imageWithUrl:url]:nil
                                                title:title
                                                  url:web
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiTimeline
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [SVProgressHUD showWithStatus:@"正在分享,请稍后"];
                        }
                        if (state == SSResponseStateCancel)
                        {
                            [SVProgressHUD dismiss];
                        }
                        if (state == SSResponseStateSuccess) {
                            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                            if (success) {
                                success();
                            }
                        }
                        if (state == SSResponseStateFail) {
                            [SVProgressHUD dismiss];
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"  message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                            [alertView show];
                        }
                    }];
}
+(void)shareToWeixiFriendWithTitle:(NSString*)title Content:(NSString*)content imageUrl:(NSString*)url webUrl:(NSString*)web Succeed:(void (^)())success
{
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:url?[ShareSDK imageWithUrl:url]:nil
                                                title:title
                                                  url:web
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiSession
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [SVProgressHUD showWithStatus:@"正在分享,请稍后"];
                        }
                        if (state == SSResponseStateCancel)
                        {
                            [SVProgressHUD dismiss];
                        }
                        if (state == SSResponseStateSuccess) {
                            
                            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                            if (success) {
                                success();
                            }
                        }
                        if (state == SSResponseStateFail) {
                            [SVProgressHUD dismiss];
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"  message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                            [alertView show];
                        }
                    }];
}
+(void)shareNumberUpWithPetalkId:(NSString *)petalkId
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"interaction" forKey:@"command"];
    [mDict setObject:@"share" forKey:@"options"];
    [mDict setObject:petalkId forKey:@"petalkId"];
    if ([UserServe sharedUserServe].userID) {
        [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    }else
    {
        [mDict setObject:@"0" forKey:@"petId"];
    }
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"message"]) {
            [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+(void)getCurrentUserInfoWithPlatformSinaSuccess:(void (^)(NSDictionary * dict))success
{
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"userInfoUid:%@,nickName:%@,error:%@",userInfo.uid,userInfo.nickname,error);
        //        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        //        [dict setObject:userInfo.uid forKey:@"userId"];
        //        [dict setObject:userInfo.nickname forKey:@"nickname"];
        //        [dict setObject:userInfo.profileImage forKey:@"img"];
        //        [dict setObject:[NSString stringWithFormat:@"%d",userInfo.gender] forKey:@"gender"];
        if (userInfo.uid) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setObject:[@"sina" stringByAppendingString:userInfo.uid]  forKey:@"id"];
            [dict setObject:userInfo.nickname forKey:@"name"];
            success(dict);
        }
        [SVProgressHUD dismiss];
    }];
}
+(void)getCurrentUserInfoWithPlatformQQ
{
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [ShareSDK getUserInfoWithType:ShareTypeQQ authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"userInfoUid:%@,nickName:%@,error:%@",userInfo.uid,userInfo.nickname,error);
    }];
}
+(void)getCurrentUserInfoWithPlatformWeChat
{
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"userInfoUid:%@,nickName:%@,error:%@",userInfo.uid,userInfo.nickname,error);
    }];
}
@end
