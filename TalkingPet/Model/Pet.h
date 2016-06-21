//
//  Pet.h
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pet : NSObject
@property (nonatomic, retain) NSString * petID;
@property (nonatomic, assign) BOOL ifDaren;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * fansNo;
@property (nonatomic, retain) NSString * attentionNo;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * ageStr;
@property (nonatomic, retain) NSString * breed;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSString * headImgURL;
@property (nonatomic, retain) NSString * issue;//原创
@property (nonatomic, retain) NSString * relay;//转发
@property (nonatomic, retain) NSString * comment;//评论
@property (nonatomic, retain) NSString * favour;//赞
@property (nonatomic, retain) NSString * grade;//等级
@property (nonatomic, retain) NSString * score;//积分
@property (nonatomic, retain) NSString * coin;//宠币
@end
