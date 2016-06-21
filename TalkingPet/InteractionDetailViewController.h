//
//  InteractionDetailViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/30.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "XLHeaderView.h"
#import "HuDongDetailTableViewCell.h"
#import "HuDongImageTableViewCell.h"
#import "HuDongListTableViewCell.h"
#import "PersonProfileViewController.h"
#import "InputView.h"
#import "TalkingCommentTableViewCell.h"
#import "MJRefresh.h"
#import "TalkingTableViewCellDelegate.h"
@protocol ReSetInteractionListDelegate <NSObject>

@optional
-(void)resetStatusforIndex:(int)index section:(int)section withStatus:(NSArray *)commentArray commentCount:(int)commentCount;
@end
@class RootViewController;
@interface InteractionDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,HuDongListCellDelegate,MessageInputViewDelegate,TalkingTableViewCellDelegate>
{
    BOOL pushed;
}
@property (nonatomic,strong) UITableView * detailTableV;
@property (nonatomic, strong) XLHeaderView *headerView;
@property (nonatomic,strong)NSString * bgImageUrl;
@property (nonatomic,strong)NSString * titleStr;
@property (nonatomic,strong)NSArray * imageArray;
@property (nonatomic,strong)NSMutableArray * commentArray;
@property (nonatomic,strong)NSString * hudongId;
@property (nonatomic,strong)NSMutableDictionary * contentDict;
@property (nonatomic,strong) InputView * inputView;
@property (nonatomic,strong)NSString * replyToId;
@property (nonatomic,strong)NSString * lastId;
@property (nonatomic,assign)int cellIndex;
@property (nonatomic,assign)int sectionIndex;
@property (nonatomic,assign)id <ReSetInteractionListDelegate>delegate;
@end
