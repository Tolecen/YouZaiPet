//
//  UserServe.m
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "UserServe.h"
#import "DatabaseServe.h"
#import "RootViewController.h"

@implementation UserServe
static UserServe* userServe;
+ (UserServe*)sharedUserServe
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        userServe =[[self alloc] init];
        userServe.currentPetSignatured = NO;
        [[NSNotificationCenter defaultCenter] addObserver:userServe selector:@selector(activityOfCurrentPet) name:@"WXRLoginSucceed" object:nil];
        userServe.userName = [DatabaseServe getActionAccount].username;
        if (userServe.userName) {
            userServe.userID = [DatabaseServe getActionAccount].userID;
            userServe.currentPet = [DatabaseServe getActionPetWithWithUsername:userServe.userName];
            userServe.petArr = [NSMutableArray arrayWithArray:[DatabaseServe getUnactionPetsWithWithUsername:userServe.userName]];
           
        }
    });
    return userServe;
}
- (void)activityOfCurrentPet
{
    self.currentPetSignatured = NO;
    if (self.currentPet) {
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"activity" forKey:@"command"];
        [mDict setObject:@"partake" forKey:@"options"];
        [mDict setObject:self.currentPet.petID forKey:@"petId"];
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            for (NSDictionary * dic in responseObject[@"value"]) {
                if ([dic[@"code"] isEqualToString:@"signIn"]&&[dic[@"state"] integerValue] != 1) {
                    self.currentPetSignatured = YES;
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRUsersignInOrNo" object:self userInfo:nil];
//            [[RootViewController sharedRootViewController].mainVC mainViewNeedSignIn];
        } failure:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRUsersignInOrNo" object:self userInfo:nil];
//        [[RootViewController sharedRootViewController].mainVC mainViewNeedSignIn];
    }
}
@end
