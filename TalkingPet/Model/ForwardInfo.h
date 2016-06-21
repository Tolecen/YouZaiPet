//
//  ForwardInfo.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-11.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pet.h"
@interface ForwardInfo : NSObject
@property (nonatomic,strong)NSString * forwardPetId;
@property (nonatomic,strong)NSString * forwardPetAvatar;
@property (nonatomic,strong)NSString * forwardPetNickname;
@property (nonatomic,strong)NSString * forwardDescription;
@property (nonatomic,strong)NSString * forwardTime;
@end
