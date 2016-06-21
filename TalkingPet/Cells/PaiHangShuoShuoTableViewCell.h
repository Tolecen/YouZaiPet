//
//  PaiHangShuoShuoTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/14.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkingBrowse.h"
#import "TalkingTableViewCellDelegate.h"
#import "EGOImageButton.h"
#import "TFileManager.h"
#import "StoryCellView.h"
@class  RootViewController;
@protocol ImagesLoadedDelegate <NSObject>
@optional
-(void)ImagesLoadedCellIndex:(int)cellIndex;
@end
@interface PaiHangShuoShuoTableViewCell : UITableViewCell<EGOImageButtonDelegate>
{
    UITapGestureRecognizer * playTap;
}
@property (nonatomic,assign) TalkingBrowse * talking;
@property (nonatomic,assign) id<TalkingTableViewCellDelegate> delegate;
@property (nonatomic,assign) id<ImagesLoadedDelegate> imgdelegate;
@property (nonatomic,strong) EGOImageButton * contentImgV;
//@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,strong) UIImageView * aniImageV;
@property (nonatomic,strong) EGOImageButton * publisherAvatarV;
@property (nonatomic,strong) UILabel * publisherNameL;
@property (nonatomic,strong) UIImageView * topImagev;
@property (nonatomic,strong) UILabel * topLabel;
@property (nonatomic,strong) UILabel * reduLabel;
@property (nonatomic,strong) UIView * bottomBG;
@property (nonatomic,strong) UIButton * commentBtn;
@property (nonatomic,strong) UIButton * favorBtn;
//@property (nonatomic,strong) UIButton * shareBtn;
//@property (nonatomic,strong) UILabel * forwardLabel;
@property (nonatomic,strong) UILabel * commentLabel;
@property (nonatomic,strong) UILabel * favorLabel;
//@property (nonatomic,strong) UILabel * shareLabel;
@property (nonatomic,strong) UIImageView * favorImgV;
@property (nonatomic,assign) NSInteger cellIndex;
@property (nonatomic,assign) NSInteger lastIndex;
@property (nonatomic,retain)UIImageView * genderIV;

@property (nonatomic,strong) UIView * progressView;

@property (nonatomic,strong) UIImageView * bigZanImageV;

@property (nonatomic,strong) UIImageView * loadingBGV;
@property (nonatomic,strong) UIImageView * loadingImgV;
@property (nonatomic,strong) UIImageView * playBtnImageV;
@property (nonatomic,strong) UIActivityIndicatorView * loadingV;

@property (nonatomic,strong) NSString * currentPlayingUrl;

@property (nonatomic,strong) UIImageView * contentTypeImgV;

@property (nonatomic,strong) UIImageView * darenV;

@property (nonatomic,strong) UIView * bg;

@property (nonatomic,strong) StoryCellView * storyView;


-(void)showPlayBtn;
-(void)setProgressViewProgress:(float)progressAdded;
-(void)reSetProgressViewProgress;
-(void)showLoading;
-(void)hideLoading;
-(void)refreshCell;

@end
