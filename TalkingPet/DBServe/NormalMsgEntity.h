//
//  NormalMsgEntity.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/15.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NormalMsgEntity : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * contentLength;
@property (nonatomic, retain) NSNumber * isMe;
@property (nonatomic, retain) NSString * msgId;
@property (nonatomic, retain) NSString * receiver;
@property (nonatomic, retain) NSDate * sendDate;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSNumber * sendSuccess;
@property (nonatomic, retain) NSString * sidePetId;
@property (nonatomic, retain) NSNumber * tagId;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * sendStatus;
@property (nonatomic, retain) NSString * startSendTime;
@property (nonatomic, retain) NSString * mineId;

@end
