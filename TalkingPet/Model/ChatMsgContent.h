//
//  ChatMsgContent.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/4.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMsgContent : NSObject
@property (nonatomic,strong) NSString * msgType;
@property (nonatomic,strong) NSString * msgContent;
@property (nonatomic,strong) NSString * audioDuration;
@property (nonatomic,assign) BOOL isMe;
@end
