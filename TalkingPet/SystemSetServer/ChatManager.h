//
//  ChatManager.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/6.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmsgClient.h"
@interface ChatManager : NSObject
@property (nonatomic, strong) EmsgClient * chatClient;
@end
