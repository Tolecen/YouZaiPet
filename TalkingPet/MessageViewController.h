//
//  MessageViewController.h
//  TalkingPet
//
//  Created by wangxr on 14-7-14.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "NotificationTableViewCell.h"
#import "TalkingTableViewCellDelegate.h"
#import "XHAudioPlayerHelper.h"
#import "TalkComment.h"
#import "PersonProfileViewController.h"
#import "TalkingDetailPageViewController.h"
#import "WXRTextViewController.h"
typedef enum
{
    MsgTypeC_R = 0,
    MsgTypeF,
    MsgTypeFans,
    MsgTypeSys
} TheMsgType;
@interface MessageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,TalkingTableViewCellDelegate,XHAudioPlayerHelperDelegate>
{
    NSString * currentPlayingUrl;
    NotificationTableViewCell * tempCommentCell;
    UIView *noContentView;
    UILabel * g;
    
    NSString * msgTypeStr;
    
    int sysNoti_page;
}
@property (nonatomic, strong)UITableView * notiTableView;
@property (nonatomic, strong)NSMutableArray * msgArray;
@property (nonatomic, strong)NSString * startId;
@property (nonatomic, assign)BOOL needRefreshMsg;
@property (nonatomic, assign)TheMsgType msgType;
@property (nonatomic,strong) XHAudioPlayerHelper * audioPlayer;
@end
