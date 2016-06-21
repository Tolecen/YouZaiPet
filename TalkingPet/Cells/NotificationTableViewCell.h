//
//  NotificationTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-17.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"
#import "TalkingTableViewCellDelegate.h"
#import "Common.h"
typedef enum
{
    notiStyleAttention = 0,
    notiStyleComment,
    notiStyleForward,
    notiStyleSystem
}NotiStyle;
@interface NotificationTableViewCell : UITableViewCell<TalkingTableViewCellDelegate>
@property (nonatomic,strong) EGOImageButton * userAvatarV;
@property (nonatomic,strong) UILabel * userNameL;
@property (nonatomic,strong) UILabel * actionTimeL;
@property (nonatomic,strong) UILabel * actionContentL;
@property (nonatomic,strong) UILabel * actionStyleL;
@property (nonatomic,strong) EGOImageView * actionImgV;
@property (nonatomic,assign) NotiStyle notiStyle;
@property (nonatomic,strong) NSDictionary * notiDict;
@property (nonatomic,strong) UIButton * playRecordBtn;
@property (nonatomic,strong) UIImageView * playRecordImgV;
@property (nonatomic,strong) UILabel * recordDurationLabel;
@property (nonatomic,assign) id<TalkingTableViewCellDelegate> delegate;
+(CGFloat)heightForRowWithComment:(NSDictionary *)noti;
+(CGFloat)heightForRowWithSysNoti:(NSDictionary *)noti;
//-(void)refreshCell;
@end
