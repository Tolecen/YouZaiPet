//
//  SystemServer.m
//  TalkingPet
//
//  Created by wangxr on 14-8-18.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "SystemServer.h"
#import "DatabaseServe.h"
#import "NetServer.h"
#import "RootViewController.h"
#import "SectionMSgViewController.h"
#import "YZShoppingCarHelper.h"

@implementation SystemServer
static SystemServer* systemServer;
+ (SystemServer*)sharedSystemServer
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        systemServer =[[self alloc] init];
        systemServer.canPlayAudio = YES;
        systemServer.agreeUserAgreement = YES;
        systemServer.shouldReNewTree = YES;
        systemServer.autoSinaWeiBo = [DatabaseServe autoShareSinaWeiBo];
        systemServer.autoFriendCircle = [DatabaseServe autoShareFriendCircle];
        systemServer.savePublishImg = [DatabaseServe savePublishImg];
        systemServer.saveOriginalImg = [DatabaseServe saveOriginalImg];
        systemServer.skinType = [DatabaseServe skinType];
        systemServer.appstoreIsInReview = NO;
        systemServer.autoPlay = NO;
        systemServer.inPay = NO;
        systemServer.metionTokenOutTime = NO;
        systemServer.leftMenuBarShowed = NO;
        systemServer.systemNetStatus = SystemNetStatusReachableViaWiFi;
        systemServer.chatClient=[EmsgClient sharedInstance];
        [systemServer.chatClient setDelegate:systemServer];
        systemServer.publishstatu = PublishStatuPetalk;
        [[NSNotificationCenter defaultCenter] addObserver:systemServer selector:@selector(userOrPetChanged) name:@"WXRLoginSucceed" object:nil];
    });
    return systemServer;
}
-(void)chatClientAuth
{
    if (![UserServe sharedUserServe].account) {
        return;
    }
    if(![systemServer.chatClient isAuthed])
    {
//        if (!systemServer.chatClient.jid) {
//            return;
//        }
        BOOL successed=[systemServer.chatClient auth:[NSString stringWithFormat:@"%@@%@",[UserServe sharedUserServe].userID,DomainName] withPassword:[NSString stringWithFormat:@"%@",[UserServe sharedUserServe].userID]];
        
        if(successed)//连接成功
        {
            NSLog(@"%@ account auth success",[UserServe sharedUserServe].userID);
        }
        else{//连接失败
//            NSLog(@"auth failed");
        }
    }
    else{
        
    }
}
-(void)userOrPetChanged
{
    /*
    self.shouldReNewTree = YES;
    NSString * currentChatUser = [[UserServe sharedUserServe].userName stringByAppendingString:[UserServe sharedUserServe].userID];
    if (![currentChatUser isEqualToString:[SystemServer sharedSystemServer].currentChatUserId]) {
        [systemServer.chatClient logout];
    }
    
    
    [SystemServer sharedSystemServer].currentChatUserId = currentChatUser;
    [self chatClientAuth];
    NSLog(@"catch you changed!");
     
     */
    [[YZShoppingCarHelper instanceManager] updateCurrentUserShoppingCar];
}
-(void)didAuthSuccessed
{
    NSLog(@"auth Success");
}
-(void) didKilledByServer
{
    NSLog(@"killed by server");
}
-(void)autoReconnect
{
    
}

/*登陆服务器失败*/
-(void) didAuthFailed:(NSString *)error
{
    
}
/*发送信息成功*/
-(void) didSendMessageSuccessed:(long)tag
{
    NSLog(@"msg sended of tag : %ld",tag);
    if (tag==0) {
        return;
    }
    [DatabaseServe updateMsgStatusWithTag:tag Status:@"success"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgSended" object:[NSNumber numberWithLong:tag] userInfo:nil];
}
/*发送带附件信息百分比*/
-(void) didUploadPercent:(float)percent tag:(long)tag msgId:(NSString *)msgId
{
    
}
/*上传附件完成*/
-(void) didUploadComplete:(NSString *)key tag:(long)tag msgId:(NSString *)msgId
{
    [DatabaseServe updateMsgContentWithId:msgId Content:key];
    NSDictionary * filedict = [NSDictionary dictionaryWithObjectsAndKeys:key,@"path",msgId,@"msgId",@"uploaded",@"status", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgFileStatusChanged" object:filedict userInfo:nil];
}
/*发送信息失败*/
-(void) didSendMessageFailed:(long)tag
{
    [DatabaseServe updateMsgStatusWithTag:tag Status:@"failed"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgFailed" object:[NSNumber numberWithLong:tag] userInfo:nil];
}
/*登录超时的回调*/
-(void) reciveAuthTimeOut
{
    
}

/*收到消息*/
-(void) didReceivedMessage:(EmsgMsg *)msg
{
    ChatMsg *chatmsg=[[ChatMsg alloc] init];
    chatmsg.isMe=NO;
    chatmsg.type=msg.contenttype;
    chatmsg.date=msg.timeSp;
    chatmsg.time=msg.contentlength;
    chatmsg.content=msg.content;
    chatmsg.fromid = [msg.fromjid componentsSeparatedByString:@"@"][0];
    chatmsg.msgid = msg.gid;
    chatmsg.contentLength = msg.contentlength;
    
//    self.navigationControllerd = (UINavigationController *)[RootViewController sharedRootViewController].frostedViewController.contentViewController;
    if (!self.leftMenuBarShowed&&![chatmsg.fromid isEqualToString:[SystemServer sharedSystemServer].currentTalkingPet]) {
        [DatabaseServe setNeedNotiNormalChatWithStatus:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNormalChatNoti" object:nil userInfo:nil];
        
    }
    [DatabaseServe saveNormalChatMsg:chatmsg];
    
    if (![DatabaseServe ifExistMsgPet:chatmsg.fromid]) {
        [NetServer getUserInfoById:chatmsg.fromid success:^(AFHTTPRequestOperation *operation, id responseObject) {
            Pet * theP = [[Pet alloc] init];
            theP.petID = [[responseObject objectForKey:@"value"] objectForKey:@"id"];
            theP.nickname = [[responseObject objectForKey:@"value"] objectForKey:@"nickName"];
            theP.headImgURL = [[responseObject objectForKey:@"value"] objectForKey:@"headPortrait"];
            [DatabaseServe saveMsgPetInfo:theP];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatUserInfoGeted" object:theP userInfo:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
    if (![self.currentTalkingPet isEqualToString:chatmsg.fromid]) {
        [SoundSong soundSong];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgReceived" object:chatmsg userInfo:nil];
//    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
/*收到离线消息*/
-(void) didReceivedOfflineMessageArray:(NSArray *)array
{
    for (int i = 0; i<array.count; i++) {
        EmsgMsg * msg = array[i];
        ChatMsg *chatmsg=[[ChatMsg alloc] init];
        chatmsg.isMe=NO;
        chatmsg.type=msg.contenttype;
        chatmsg.date=msg.timeSp;
        chatmsg.time=msg.contentlength;
        chatmsg.content=msg.content;
        chatmsg.fromid = [msg.fromjid componentsSeparatedByString:@"@"][0];
        chatmsg.msgid = msg.gid;
        chatmsg.contentLength = msg.contentlength;
        
//        self.navigationControllerd = (UINavigationController *)[RootViewController sharedRootViewController].frostedViewController.contentViewController;
        if (!self.leftMenuBarShowed&&![chatmsg.fromid isEqualToString:[SystemServer sharedSystemServer].currentTalkingPet]) {
            [DatabaseServe setNeedNotiNormalChatWithStatus:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNormalChatNoti" object:nil userInfo:nil];
        }
        
        [DatabaseServe saveNormalChatMsg:chatmsg];
        
        if (![DatabaseServe ifExistMsgPet:chatmsg.fromid]) {
            [NetServer getUserInfoById:chatmsg.fromid success:^(AFHTTPRequestOperation *operation, id responseObject) {
                Pet * theP = [[Pet alloc] init];
                theP.petID = [[responseObject objectForKey:@"value"] objectForKey:@"id"];
                theP.nickname = [[responseObject objectForKey:@"value"] objectForKey:@"nickName"];
                theP.headImgURL = [[responseObject objectForKey:@"value"] objectForKey:@"headPortrait"];
                [DatabaseServe saveMsgPetInfo:theP];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatUserInfoGeted" object:theP userInfo:nil];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalChatMsgReceived" object:chatmsg userInfo:nil];
    }
    if (array.count>0) {
//        if (![self.currentTalkingPet isEqualToString:chatmsg.fromid]) {
            [SoundSong soundSong];
//        }
    }
    
}
-(void) willDisconnectWithError:(NSError *)err
{
    
}
-(void)getUserInfoById
{

}

@end
