//
//  ChatListTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 14/12/29.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "ChatListMsg.h"
#import "Common.h"
@interface ChatListTableViewCell : UITableViewCell
@property (nonatomic,strong) EGOImageView * avatarImageV;
@property (nonatomic,strong) UILabel * nameL;
@property (nonatomic,strong) UILabel * contentL;
@property (nonatomic,strong) UILabel * timeL;
@property (nonatomic,strong) ChatListMsg * chatListMsg;
@property (nonatomic,strong) UIImageView * unreadBgV;
@property (nonatomic,strong) UILabel * unreadLabel;
@end
