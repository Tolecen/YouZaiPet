//
//  BrowserTableHelper.h
//  TalkingPet
//
//  Created by Tolecen on 14/8/14.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"
#import "NetServer.h"
#import "UserServe.h"
#import "SystemServer.h"
#import "TFileManager.h"
#import "XHAudioPlayerHelper.h"
#import "UploadTaskTableViewCell.h"
#import "TalkingTableViewCellDelegate.h"
#import "TalkingDetailPageViewController.h"
#import "TagTalkListViewController.h"
#import "MapViewController.h"
#import "BowserZanTableViewCell.h"
#import "BrowserCommentTableViewCell.h"
#import "PromptView.h"
typedef enum {
    TableViewTypeHot = 0,
    TableViewTypeAttention,
    TableViewTypeTagList
} TableViewType;
@class BrowserForwardedTalkingTableViewCell;
@class EGOImageButton;
@class MainViewController;
@protocol BrowserTableHelperDelegate <NSObject>
@optional
- (void)refreshTableDo;
-(void)scrollit;
-(void)naviOriginY:(float)originY;
-(void)footerDelegateToUserCenter;
-(void)resultCount:(int)count;
@end
@interface BrowserTableHelper : NSObject<UITableViewDataSource,UITableViewDelegate,XHAudioPlayerHelperDelegate,TalkingTableViewCellDelegate,DeleteShuoShuoDelegate,UIAlertViewDelegate,AttentionDelegate,ImagesLoadedDelegate,RefreshAnimationEnded,RefreshAnimationEndedFooter>{
    NSString * currentPlayingUrl;
    int currentID;
    NSString * lastId;
    
    NSString * currentPetId;
    
    BrowserForwardedTalkingTableViewCell * btcell;
    
    NSTimer * audioDurationTimer;
    
    int currentCellIndex;
    
    CGFloat lastOffsetY;
    BOOL isDecelerating;
    BOOL dragging;
    
    UIView * footerV;
}
//@property (nonatomic) UIEdgeInsets originalInsets;
@property (nonatomic,strong)UITableView * tableV;
//@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UIView * sectionView;
@property (nonatomic,weak)UIViewController * theController;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableDictionary * reqDict;
@property (nonatomic,strong)NSString * currentCommand;
@property (nonatomic,strong)NSString * currentOptions;
@property (nonatomic,strong)NSArray * uploadArray;
@property (nonatomic,strong)UIView * theView;
@property (nonatomic,assign)CGFloat naviH;
@property (nonatomic,assign)CGFloat isInfont;
@property (nonatomic,assign)TableViewType tableViewType;
@property (nonatomic,assign)BOOL isRefreshing;
@property (nonatomic,assign)BOOL usePage;
@property (nonatomic,assign)BOOL canPlay;
@property (nonatomic,assign)BOOL firPageLoaded;
@property (nonatomic,assign)BOOL needScrollTopDelegate;
@property (nonatomic,assign)BOOL iamActive;
@property (nonatomic,assign)BOOL headerCanRefresh;
@property (nonatomic,assign)BOOL footerCanRefresh;
@property (nonatomic,assign)BOOL cellNeedShowPublishTime;
@property (nonatomic,assign)BOOL footerShouldDelegateToUserCenter;
@property (nonatomic,assign)BOOL needShowZanAndComment;
//@property (nonatomic,assign)BOOL canJudgePlay;
@property (nonatomic,assign) id<BrowserTableHelperDelegate> delegate;

@property (nonatomic,strong) XHAudioPlayerHelper * audioPlayer;
-(id)initWithController:(UIViewController *)thexController Tableview:(UITableView *)theTable SectionView:(UIView *)sectionV;
-(NSMutableArray *)getModelArray:(NSArray *)array;
-(void)loadDataWithLastMark:(int)lastMark;
-(void)getAttentionShuoShuoListWithMark:(NSString *)lastMark;
-(void)loadFirstDataPageWithDict:(NSMutableDictionary *)theDict;
-(void)cellPlayAni:(UIScrollView *)scrollView;
-(void)stopAudio;
@end
