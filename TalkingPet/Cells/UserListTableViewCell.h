//
//  UserListTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-22.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@class RootViewController;
@protocol UserCellAttentionDelegate <NSObject>
@optional
-(void)toUserPage:(NSDictionary *)petDict;
-(void)attentionDelegate:(NSDictionary *)dict Index:(NSInteger)index;
-(void)removeThisPetFromBlackList:(NSDictionary *)dict cellIndex:(NSInteger)cellIndex;
@end
@interface UserListTableViewCell : UITableViewCell
@property (nonatomic,strong) EGOImageButton * commentAvatarV;
@property (nonatomic,strong) UILabel * commentNameL;
@property (nonatomic,strong) UIImageView * darenV;
@property (nonatomic,strong) UILabel * talkNoL;
@property (nonatomic,strong) UILabel * fansNoL;
@property (nonatomic,strong) UIButton * relationBtn;
@property (nonatomic,strong) NSDictionary * petDict;
@property (nonatomic,strong) NSString * relationShip;
@property (nonatomic,assign) int listType;
@property (nonatomic,assign) NSInteger cellIndex;
@property (nonatomic,assign) id<UserCellAttentionDelegate> delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellType:(int)type ListType:(int)listType;
@end
