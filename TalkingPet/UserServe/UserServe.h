//
//  UserServe.h
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pet.h"

@interface UserServe : NSObject
@property (nonatomic,retain)Pet * currentPet;
@property (nonatomic,assign)BOOL currentPetSignatured;
@property (nonatomic,strong) NSString * userID;
@property (nonatomic,strong) NSString * userName;
@property (nonatomic,strong) NSMutableArray * petArr;
+ (UserServe*)sharedUserServe;
- (void)activityOfCurrentPet;//当前宠物的活动列表,暂时用来判断该宠物是否签到
@end
