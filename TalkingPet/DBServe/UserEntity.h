//
//  UserEntity.h
//  TalkingPet
//
//  Created by wangxr on 14-8-26.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * action;
@property (nonatomic, retain) NSString * passWord;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * actiontime;

@end
