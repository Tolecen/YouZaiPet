//
//  UserListViewController.h
//  TalkingPet
//
//  Created by wangxr on 14-8-11.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
typedef enum UserListType{
    UserListTypeAttention,
    UserListTypeFans,
    UserListBlackList
}UserListType;
@interface UserListViewController : BaseViewController
{
    UILabel * g;
}
@property (nonatomic,assign) NSString * petID;
@property (nonatomic,assign) BOOL shouldSelectChatUser;
@property (nonatomic,assign) UserListType listType;
@end
