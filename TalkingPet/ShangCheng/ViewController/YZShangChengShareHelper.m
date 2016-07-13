//
//  YZShangChengShareHelper.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/13.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengShareHelper.h"

@implementation YZShangChengShareHelper

+ (void)shareWithScene:(YZShangChengType)scene
                target:(NSObject *)target
                 model:(YZShangChengModel *)model
               success:(void(^)(void))success
               failure:(void(^)(void))failure {
    ShareSheet * shareSheet = [[ShareSheet alloc]initWithIconArray:@[@"weiChatFriend",@"friendCircle",@"sina",@"qq"] titleArray:@[@"微信好友",@"朋友圈",@"微博",@"QQ"] action:^(NSInteger index) {
        switch (index) {
            case 0:{
                [ShareServe shareToWeixiFriendWithTitle:nil Content:nil imageUrl:nil webUrl:nil Succeed:^{                    
                }];
            }break;
            case 1:{
                [ShareServe shareToFriendCircleWithTitle:nil Content:nil imageUrl:nil webUrl:nil Succeed:^{
                }];
            }break;
            case 2:{
                [ShareServe shareToSineWithContent:nil imageUrl:nil Succeed:^{
                }];
            }break;
            case 3:{
                [ShareServe shareToQQWithTitle:nil Content:nil imageUrl:nil webUrl:nil Succeed:^{
                }];
            }break;
            default:
                break;
        }
        
    }];
    [shareSheet show];
}

@end
