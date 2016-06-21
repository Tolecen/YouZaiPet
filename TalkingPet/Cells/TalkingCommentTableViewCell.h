//
//  TalkingCommentTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "Common.h"
#import "TalkComment.h"
#import "TalkingTableViewCellDelegate.h"
#import "OHAttributedLabel.h"
#import "WebContentViewController.h"
@class RootViewController;
@interface TalkingCommentTableViewCell : UITableViewCell<OHAttributedLabelDelegate>
@property (nonatomic,strong) EGOImageButton * commentAvatarV;
@property (nonatomic,strong) UILabel * commentNameL;
@property (nonatomic,strong) UILabel * commentTimeL;
@property (nonatomic,strong) UILabel * commentL;
@property (nonatomic,strong) UILabel * forwardedL;
@property (nonatomic,strong) UIImageView * darenV;
@property (nonatomic,strong) TalkComment * talkingComment;

@property (nonatomic,strong) UIButton * playRecordBtn;
@property (nonatomic,strong) UIImageView * playRecordImgV;
@property (nonatomic,strong) UILabel * recordDurationLabel;

@property (nonatomic,assign) BOOL needShowSepLine;
@property (nonatomic,strong) UIView * sepLine;


@property (nonatomic,assign) id<TalkingTableViewCellDelegate> delegate;
+(CGSize)heightForRowWithComment:(TalkComment *)comment;
//+(CGFloat)widthForRowWithComment:(TalkComment *)comment;
-(void)refreshCell;
@end
