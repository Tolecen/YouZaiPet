//
//  BrowseTalkingTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-12.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "TalkingBrowse.h"
#import "TalkingTableViewCellDelegate.h"
#import "XHAudioPlayerHelper.h"
#import "TFileManager.h"
@class Common;
@interface BrowseTalkingTableViewCell : UITableViewCell<XHAudioPlayerHelperDelegate>
{
    
}

@property (nonatomic,strong) TalkingBrowse * talking;
@property (nonatomic,assign) id<TalkingTableViewCellDelegate> delegate;

@property (nonatomic,strong) EGOImageButton * contentImgV;
@property (nonatomic,strong) UIImageView * aniImageV;
@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,strong) EGOImageButton * publisherAvatarV;
@property (nonatomic,strong) UILabel * publisherNameL;
@property (nonatomic,strong) UILabel * publishTime;
@property (nonatomic,strong) UIButton * relationBtn;
@property (nonatomic,strong) UIButton * tagBtn;
@property (nonatomic,strong) UIImageView * tagImgV;
@property (nonatomic,strong) UILabel * tagLabel;
@property (nonatomic,strong) UIButton * locationBtn;
@property (nonatomic,strong) UIImageView * locationImgV;
@property (nonatomic,strong) UILabel * locationLabel;

@property (nonatomic,strong) UIButton * forwardBtn;
@property (nonatomic,strong) UIButton * commentBtn;
@property (nonatomic,strong) UIButton * favorBtn;
@property (nonatomic,strong) UIButton * shareBtn;
@property (nonatomic,strong) UILabel * forwardLabel;
@property (nonatomic,strong) UILabel * commentLabel;
@property (nonatomic,strong) UILabel * favorLabel;
@property (nonatomic,strong) UILabel * shareLabel;

@property (nonatomic,strong) UIImageView * loadingBGV;
@property (nonatomic,strong) UIImageView * loadingImgV;

@property (nonatomic,strong) XHAudioPlayerHelper * audioPlayer;

-(void)hideLoading;
@end
