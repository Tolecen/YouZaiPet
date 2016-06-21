//
//  TalkingDetailPageViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
//#import "TalkingDetailTableViewCell.h"
#import "BrowserForwardedTalkingTableViewCell.h"
#import "TalkingCommentTableViewCell.h"
#import "FavorListTableViewCell.h"
#import "MJRefresh.h"
#import "PersonProfileViewController.h"
#import "InputView.h"
#import "TalkingBrowse.h"
#import "SVProgressHUD.h"
#import "TalkComment.h"
#import "TalkingTableViewCellDelegate.h"
#import "XHAudioPlayerHelper.h"
#import "TagTalkListViewController.h"
#import "MapViewController.h"
#import "PreviewStoryViewController.h"
typedef enum
{
    commentStyleNone = 0,
    commentStyleComment,
    commentStyleForward
}CommentStyle;

@protocol DeleteShuoShuoDelegate <NSObject>

@optional
-(void)shuoshuoDeletedSuccessWithIndex:(NSString *)shuoshuoId;
-(void)resetShuoShuoStatus:(TalkingBrowse *)talkingBrowse;
- (void)attentionPetWithTalkingBrowse2: (TalkingBrowse *)talkingBrowse;
-(void)changeCommentArrayWithTalking:(TalkingBrowse *)talkingBrowser;
@end
@interface TalkingDetailPageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MessageInputViewDelegate,TalkingTableViewCellDelegate,XHAudioPlayerHelperDelegate,FavorCellAttentionDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSString * currentPlayingUrl;
    
    TalkingCommentTableViewCell * tempCommentCell;
    
    BrowserForwardedTalkingTableViewCell * btcell;
    
    NSTimer * audioDurationTimer;
}
@property (nonatomic, strong)UITableView * contentTableView;
@property (nonatomic, strong)UIView * sectionBtnView;
@property (nonatomic, strong)UIButton * commentNumBtn;
@property (nonatomic, strong)UIButton * favorNumBtn;
@property (nonatomic, strong)UIImageView * bottomImageV;
@property (nonatomic, assign)BOOL showFavorList;
@property (nonatomic,assign) BOOL shouldRequestInfo;
@property (nonatomic,strong) UIButton * commentBtn;
@property (nonatomic,strong) UIButton * favorBtn;
@property (nonatomic,strong) UIButton * shareBtn;
@property (nonatomic,strong) UILabel * forwardLabel;
@property (nonatomic,strong) UILabel * commentLabel;
@property (nonatomic,strong) UILabel * favorLabel;
@property (nonatomic,strong) UIImageView * favorImgV;
@property (nonatomic,strong) UILabel * shareLabel;
@property (nonatomic,strong) NSString * textPlaceholderStr;

@property (nonatomic,strong) UIImageView * bigZanImageV;

//@property (nonatomic,assign) BOOL commentStyleForward;
@property (nonatomic,assign) CommentStyle commentStyle;
@property (nonatomic,strong) InputView * inputView;

@property (nonatomic,strong) TalkingBrowse * talking;
@property (nonatomic,strong) TalkComment * currentTalkComment;
@property (nonatomic,assign) NSInteger currentTalkCommentIndex;
@property (nonatomic,assign) NSInteger caiNum;
@property (nonatomic,assign) NSInteger theIndex;

@property (nonatomic,strong) NSMutableArray * commentArray;
@property (nonatomic,strong) NSMutableArray * commentHeightArray;
@property (nonatomic,strong) NSMutableArray * favorArray;
@property (nonatomic,strong) NSString * replyToId;
@property (nonatomic,strong) NSString * replyToName;
@property (nonatomic,strong) XHAudioPlayerHelper * audioPlayer;
@property (nonatomic,assign) float firstRowHeight;

@property (nonatomic,assign) BOOL shouldDismiss;
@property (nonatomic,assign) BOOL canEditComment;

@property (nonatomic,assign) BOOL iamActive;

@property (nonatomic,assign) id<DeleteShuoShuoDelegate> delegate;
-(void)showCommentBarWithPetId:(NSString *)petId PetNickname:(NSString *)nickname;
@end
