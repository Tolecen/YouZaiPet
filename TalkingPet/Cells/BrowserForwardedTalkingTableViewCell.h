//
//  BrowserForwardedTalkingTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-12.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "TalkingBrowse.h"
#import "TalkingTableViewCellDelegate.h"
#import "TFileManager.h"
#import "SystemServer.h"
#import "EGOImageView.h"
#import "StoryCellView.h"
@class RootViewController;
typedef enum {
    TalkCellTypeOrigin = 0,
    TalkCellTypeForwarded,
    TalkCellTypeDetailPage,
    TalkCellTypeClearColorList,
    TalkCellTypeNotClearColorList
} TalkCellType;
@class Common;

@protocol ImagesLoadedDelegate <NSObject>
@optional
-(void)ImagesLoadedCellIndex:(int)cellIndex;
@end
@interface BrowserForwardedTalkingTableViewCell : UITableViewCell<EGOImageButtonDelegate>{
    UITapGestureRecognizer * playTap;
}

@property (nonatomic,assign) TalkingBrowse * talking;
@property (nonatomic,assign) id<TalkingTableViewCellDelegate> delegate;
@property (nonatomic,assign) id<ImagesLoadedDelegate> imgdelegate;
@property (nonatomic,strong) EGOImageButton * contentImgV;
@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,strong) UIImageView * aniImageV;
@property (nonatomic,strong) EGOImageButton * publisherAvatarV;
@property (nonatomic,strong) UILabel * publisherNameL;
@property (nonatomic,strong) UILabel * bL;
@property (nonatomic,strong) UILabel * publishTime;
@property (nonatomic,strong) UILabel * readNumL;
@property (nonatomic,strong) UIButton * relationBtn;
@property (nonatomic,strong) UILabel * addMarkLabel;
@property (nonatomic,strong) UIButton * tagBtn;
@property (nonatomic,strong) UIView * tagView;
@property (nonatomic,strong) UIImageView * tagImgV;
@property (nonatomic,strong) UILabel * tagLabel;
@property (nonatomic,strong) UIButton * locationBtn;
@property (nonatomic,strong) UIImageView * locationImgV;
@property (nonatomic,strong) UILabel * locationLabel;
@property (nonatomic,strong) EGOImageButton * forwardedAvatarV;
@property (nonatomic,strong) UILabel * forwardedNameL;
@property (nonatomic,strong) UILabel * forwardedTime;
@property (nonatomic,strong) UILabel * forwardedText;
@property (nonatomic,strong) UILabel * forwardedL;
@property (nonatomic,strong) UIView * bottomBG;
@property (nonatomic,strong) UIImageView * bigZanImageV;
@property (nonatomic,strong) UIView * zanView;
@property (nonatomic,strong) UIView * commentView;
@property (nonatomic,strong) UILabel * zanViewzanL;
@property (nonatomic,strong) UILabel * commentViewcommentL;
@property (nonatomic,assign) int zanAvatarNum;
@property (nonatomic,strong) UIView * sepLineV;
@property (nonatomic,assign) float firstRowHeight;
@property (nonatomic,strong) UIView * progressView;


@property (nonatomic,assign) NSInteger cellIndex;

@property (nonatomic,assign) NSInteger lastIndex;

@property (nonatomic,strong) UIButton * forwardBtn;
@property (nonatomic,strong) UIButton * commentBtn;
@property (nonatomic,strong) UIButton * favorBtn;
@property (nonatomic,strong) UIButton * shareBtn;
@property (nonatomic,strong) UILabel * forwardLabel;
@property (nonatomic,strong) UILabel * commentLabel;
@property (nonatomic,strong) UILabel * favorLabel;
@property (nonatomic,strong) UILabel * shareLabel;
@property (nonatomic,strong) UIImageView * favorImgV;
@property (nonatomic,strong) UIImageView * loadingBGV;
@property (nonatomic,strong) UIImageView * loadingImgV;
@property (nonatomic,strong) UIImageView * playBtnImageV;
@property (nonatomic,strong) UIActivityIndicatorView * loadingV;

@property (nonatomic,strong) UIView * contentTextBgV;
@property (nonatomic,strong) UIImageView * bgV;
@property (nonatomic,strong) UIImageView * genderImageV;

@property (nonatomic,strong) UIView * forwardView;
@property (nonatomic,assign) TalkCellType talkCellType;

@property (nonatomic,assign) BOOL needShowPublishTime;

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGFloat contentSizeH;
@property (nonatomic,assign) CGFloat contentSizeW;
@property (nonatomic,assign) CGFloat tagHeight;

@property (nonatomic,strong) UIImageView * gradeImageV;
@property (nonatomic,strong) UILabel * gradeLabel;

@property (nonatomic,strong) NSString * currentPlayingUrl;

@property (nonatomic,strong) UIImageView * contentTypeImgV;

@property (nonatomic,strong) UIImageView * darenV;

@property (nonatomic,strong) StoryCellView * storyView;
@property (nonatomic,strong) UILabel * storyTimeL;
@property (nonatomic,strong) UILabel * storyTitleL;
@property (nonatomic,strong) EGOImageView * storyImageV1;
@property (nonatomic,strong) EGOImageView * storyImageV2;

- (id)initWithStyle:(UITableViewCellStyle)style CellType:(TalkCellType)theCellType reuseIdentifier:(NSString *)reuseIdentifier;
+(CGFloat)heightForRowWithTalking:(TalkingBrowse *)theTalking CellType:(int)cellType;
-(void)showPlayBtn;
-(void)setProgressViewProgress:(float)progressAdded;
-(void)reSetProgressViewProgress;
-(void)showLoading;
-(void)hideLoading;
-(void)refreshCell;
@end
