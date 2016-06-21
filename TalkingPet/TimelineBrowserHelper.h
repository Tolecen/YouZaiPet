//
//  TimelineBrowserHelper.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/30.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"
#import "NetServer.h"
#import "SystemServer.h"
#import "TFileManager.h"
#import "TalkingBrowse.h"
#import "UploadTaskTableViewCell.h"
#import "TimeLineTalkingTableViewCell.h"
#import "TimeLineSectionHeaderView.h"
#import "TalkingDetailPageViewController.h"
#import "PreviewStoryViewController.h"
@protocol TimeLineBrowserTableHelperDelegate <NSObject>
@optional
- (void)refreshTableDo;
-(void)scrollit;
-(void)footerDelegateToUserCenter;
@end
@class MainViewController;
@interface TimelineBrowserHelper : NSObject<UITableViewDataSource,UITableViewDelegate,RefreshAnimationEnded,RefreshAnimationEndedFooter,TalkingTableViewCellDelegate,TimeLineImagesLoadedDelegate,DeleteShuoShuoDelegate,TimeLineHeaderDelegate>
{
    int currentID;
    NSString * lastId;
    
    NSString * currentPetId;

    
    int currentCellIndex;
    
    BOOL isDragging;
}
@property (nonatomic,strong)UITableView * tableV;
//@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UIView * sectionView;
@property (nonatomic,weak)UIViewController * theController;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableDictionary * reqDict;
@property (nonatomic,strong)NSString * currentCommand;
@property (nonatomic,strong)NSString * currentOptions;
//@property (nonatomic,strong)NSArray * uploadArray;
@property (nonatomic,strong)UIView * theView;
@property (nonatomic,assign)CGFloat naviH;
@property (nonatomic,assign)BOOL needScrollTopDelegate;
@property (nonatomic,assign)CGFloat isInfont;
@property (nonatomic,assign)BOOL isRefreshing;
@property (nonatomic,assign)BOOL usePage;
@property (nonatomic,assign)BOOL canPlay;
@property (nonatomic,assign)BOOL showHead;
@property (nonatomic,assign)BOOL firPageLoaded;
@property (nonatomic,assign)BOOL iamActive;
@property (nonatomic,assign)BOOL headerCanRefresh;
@property (nonatomic,assign)BOOL footerCanRefresh;
@property (nonatomic,assign)BOOL cellNeedShowPublishTime;
@property (nonatomic,assign)BOOL footerShouldDelegateToUserCenter;
@property (nonatomic,assign) id<TimeLineBrowserTableHelperDelegate> delegate;

-(id)initWithController:(UIViewController *)thexController tableview:(UITableView *)theTable withHead:(BOOL)showHead header:(UIView *)header;
-(void)getHotShuoShuoListWithMark:(int)lastMark;
-(void)getAttentionShuoShuoListWithMark:(NSString *)lastMark;
-(void)loadFirstDataPageWithDict:(NSMutableDictionary *)theDict;
-(void)cellPlayAni:(UIScrollView *)scrollView;
-(NSMutableArray *)getModelArray:(NSArray *)array;
@end
