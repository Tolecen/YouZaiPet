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


@property (nonatomic, retain) NSNumber * daren;
@property (nonatomic, retain) NSString * attentionNo;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * breed;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * fansNo;
@property (nonatomic, retain) NSString * favour;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * headImgURL;
@property (nonatomic, retain) NSString * issue;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSString * petID;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSString * relay;
@property (nonatomic, retain) NSString * grade;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * coin;
@property (nonatomic, retain) NSNumber * chatLimits;


@end
