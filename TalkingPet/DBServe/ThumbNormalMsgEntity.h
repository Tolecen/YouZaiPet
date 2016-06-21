//
//  ThumbNormalMsgEntity.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/19.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ThumbNormalMsgEntity : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * mineId;
@property (nonatomic, retain) NSDate * sendDate;
@property (nonatomic, retain) NSString * sidePetAvatarUrl;
@property (nonatomic, retain) NSString * sidePetId;
@property (nonatomic, retain) NSString * sidePetNickname;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * unreadCount;

@end
