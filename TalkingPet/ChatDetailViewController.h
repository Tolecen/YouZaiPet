//
//  ChatDetailViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14/12/30.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "InputView.h"
#import "ChatMsg.h"
#import "Pet.h"
#import "ChatDetailTableViewCell.h"
#import "XHAudioPlayerHelper.h"
#import "TFileManager.h"
#import "PersonProfileViewController.h"
//#import "SRRefreshView.h"
@protocol ChatDetailPageDelegate <NSObject>
@optional
-(void)setUnreadCountForPet:(NSString *)petId UnreadCount:(int)unread;
@end
@interface ChatDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MessageInputViewDelegate,ChatDetailTableViewCellDelegate,XHAudioPlayerHelperDelegate,UIActionSheetDelegate>
{
    NSString * currentPlayingMsgId;
    UIMenuItem * copyItem;
    UIMenuItem * copyItem2;
    UIMenuController * menu;
    ChatMsg * currentMsg;
    int currentCellIndex;
    int currentPage;
    BOOL inMyBlackList;
    BOOL canSendMsg;
}
@property (nonatomic,strong) UITableView * msgTableV;
@property (nonatomic,strong) InputView * inputView;
//@property (nonatomic,strong) SRRefreshView * refreshView;
@property (nonatomic,strong) NSMutableArray * chatArray;
@property (nonatomic,strong) UIView * menuView;
@property (nonatomic,strong) UIImageView * bgvc;
@property (nonatomic,strong) UIView * msgMenuLineV;
@property (nonatomic,strong) UIButton * msgCopyBtn;
@property (nonatomic,strong) UIButton * MsgDelBtn;
@property (nonatomic,strong) UIRefreshControl *  refresh;
@property (nonatomic,strong) NSString * taId;
@property (nonatomic,strong) Pet * thePet;
@property (nonatomic,strong) XHAudioPlayerHelper * audioPlayer;
@property (nonatomic,assign) id <ChatDetailPageDelegate>delegate;
@property (nonatomic,strong) UILabel * cannotSendV;
@end
