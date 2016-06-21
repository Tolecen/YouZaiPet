//
//  ChatListMsg.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatListMsg : NSObject
@property (nonatomic,strong)NSString * type;
@property (nonatomic,strong)NSString * content;
@property (nonatomic,strong)NSString * sendTime;
@property (nonatomic,strong)NSString * sidePetId;
@property (nonatomic,strong)NSString * sidePetNickname;
@property (nonatomic,strong)NSString * sidePetAvatarUrl;
@property (nonatomic,assign) int unreadCount;
@end
