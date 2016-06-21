//
//  ChatDetailTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/4.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "ChatMsg.h"
#import "Common.h"
@protocol ChatDetailTableViewCellDelegate <NSObject>
@optional
-(void)longPressed:(id)cell Index:(int)index;
-(void)audioClickedWithPath:(NSString *)path cell:(id)cell;
-(void)resendMsg:(ChatMsg *)chatMsg index:(int)index;
-(void)headTouchedWithMsg:(ChatMsg *)chatMsg;
@end
@interface ChatDetailTableViewCell : UITableViewCell
+(CGFloat)heightForRowWithMsg:(ChatMsg *)msg showTime:(BOOL)showTime;
@property (nonatomic,strong) EGOImageButton * avatarImgV;
@property (nonatomic,strong) UIImageView * bgImageV;
@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,strong) UIImageView * audioImageV;
@property (nonatomic,strong) UIButton * failedImageV;
@property (nonatomic,strong) UILabel * audioDurationL;
@property (nonatomic,strong) UILabel * timeL;
@property (nonatomic,assign) int cellIndex;
@property (nonatomic,assign) BOOL needShowTime;
@property (nonatomic,strong) ChatMsg * chatMsg;
@property (nonatomic,strong) NSString * taAvatarUrl;
@property (nonatomic,assign) id <ChatDetailTableViewCellDelegate> delegate;
@property (nonatomic,strong) UIActivityIndicatorView * statusIndicator;
@end
