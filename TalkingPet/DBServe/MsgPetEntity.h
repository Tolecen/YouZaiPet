//
//  MsgPetEntity.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MsgPetEntity : NSManagedObject

@property (nonatomic, retain) NSString * petId;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * avatarUrl;

@end
