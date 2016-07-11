//
//  Account.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-11.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface Account : JSONModel
@property (nonatomic, retain) NSString * userID;
@property (nonatomic,retain)NSString<Optional> * username;
@property (nonatomic,retain)NSString<Optional> * password;

@property (nonatomic, retain) NSString<Optional> * nickname;
@property (nonatomic, retain) NSString<Optional> * fansNo;
@property (nonatomic, retain) NSString<Optional> * attentionNo;
@property (nonatomic, retain) NSString<Optional> * gender;
@property (nonatomic, retain) NSDate <Optional>* birthday;
@property (nonatomic, retain) NSString<Optional> * ageStr;
//@property (nonatomic, retain) NSString<Optional> * breed;
@property (nonatomic, retain) NSString<Optional> * region;
@property (nonatomic, retain) NSString<Optional> * headImgURL;
@property (nonatomic, retain) NSString<Optional> * issue;//原创
@property (nonatomic, retain) NSString<Optional> * relay;//转发
@property (nonatomic, retain) NSString<Optional> * comment;//评论
@property (nonatomic, retain) NSString<Optional> * favour;//赞
@property (nonatomic, retain) NSString<Optional> * grade;//等级
@property (nonatomic, retain) NSString<Optional> * score;//积分
@property (nonatomic, retain) NSString<Optional> * coin;//宠币
@end
