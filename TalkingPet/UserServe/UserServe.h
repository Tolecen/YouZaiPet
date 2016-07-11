//
//  UserServe.h
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pet.h"
#import "JSONModel.h"
#import "Account.h"
@interface UserServe : NSObject
//@property (nonatomic,retain)Pet<Optional> * currentPet;
//@property (nonatomic,assign)NSNumber<Optional> *currentPetSignatured;
@property (nonatomic,strong) NSString * userID;
@property (nonatomic,strong) NSString * userName;
@property (nonatomic,strong)Account * account;
//@property (nonatomic,strong) NSMutableArray<Optional> * petArr;

//@property (nonatomic, assign) NSNumber<Optional>* ifDaren;


+ (UserServe*)sharedUserServe;
- (void)activityOfCurrentPet;//当前宠物的活动列表,暂时用来判断该宠物是否签到
@end
