//
//  TimeLineTalkingTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/30.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"
#import "TalkingTableViewCellDelegate.h"
#import "TalkingBrowse.h"
#import "StoryCellView.h"
@protocol TimeLineImagesLoadedDelegate <NSObject>
@optional
-(void)ImagesLoadedCellIndex:(int)cellIndexSection;
@end
@interface TimeLineTalkingTableViewCell : UITableViewCell<TalkingTableViewCellDelegate,EGOImageButtonDelegate>

@property (nonatomic,strong) UIImageView * contentTypeV;
@property (nonatomic,strong) UIImageView * dotImageV;
@property (nonatomic,strong) UIView * underDotLineV;
@property (nonatomic,strong) UIView * leftLineV;
@property (nonatomic,strong) UIView * topLineV;
@property (nonatomic,strong) UIView * rightLineV;
@property (nonatomic,strong) UIView * bottomLineV;
@property (nonatomic,strong) UIView * lastbottomLineV;
@property (nonatomic,strong) EGOImageButton * contentImageV;
@property (nonatomic,strong) UIImageView * contentTypeImgV;
@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,strong) UIImageView * aniImageV;
@property (nonatomic,strong) UIButton * tagBtn;
@property (nonatomic,strong) UIView * tagView;
@property (nonatomic,strong) UIImageView * tagImgV;
@property (nonatomic,strong) UILabel * tagLabel;
@property (nonatomic,strong) UIButton * locationBtn;
@property (nonatomic,strong) UIImageView * bigZanImageV;
@property (nonatomic,strong) UIImageView * locationImgV;
@property (nonatomic,strong) UILabel * locationLabel;
@property (nonatomic,strong) UIView * bottomBG;
@property (nonatomic,strong) UIButton * forwardBtn;
@property (nonatomic,strong) UIButton * commentBtn;
@property (nonatomic,strong) UIButton * favorBtn;
@property (nonatomic,strong) UIButton * shareBtn;
@property (nonatomic,strong) UILabel * forwardLabel;
@property (nonatomic,strong) UILabel * commentLabel;
@property (nonatomic,strong) UILabel * favorLabel;
@property (nonatomic,strong) UILabel * shareLabel;
@property (nonatomic,strong) UIImageView * favorImgV;
@property (nonatomic,assign) NSInteger lastIndex;

@property (nonatomic,strong) UILabel * zanL;
@property (nonatomic,strong) UILabel * commentL;


@property (nonatomic,strong) StoryCellView * storyView;
@property (nonatomic,assign) TalkingBrowse * talking;
@property (nonatomic,assign) id<TalkingTableViewCellDelegate> delegate;
@property (nonatomic,assign) id<TimeLineImagesLoadedDelegate> imgdelegate;
@property (nonatomic,assign) int cellIndex;
@property (nonatomic,assign) BOOL showTheHead;
@property (nonatomic,strong) UIView * forwardView;
@property (nonatomic,strong) UILabel * forwardNameL;
@property (nonatomic,strong) UILabel * forwardContentL;
+(CGFloat)heightForRowWithTalking:(TalkingBrowse *)theTalking CellType:(int)cellType;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHead:(BOOL)showHead;
@end
