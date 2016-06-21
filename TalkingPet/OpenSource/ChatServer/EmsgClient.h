//
//  EmsgClient.h
//  sockettest
//
//  Created by cyt on 14/11/18.
//  Copyright (c) 2014年 cyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "Define.h"
#import "EmsgMsg.h"

@interface EmsgClient : NSObject
{

    NSString *jid;
    NSString *pwd;
    NSString *token;
    
    id delegate;
    NSMutableData *packetdata;
    BOOL hasAuth;
    BOOL _isLogOut   ;
    BOOL isNetWorkAvailable;


}

@property(nonatomic,retain) NSString *jid;
@property(nonatomic,retain) NSString *pwd;
@property(nonatomic,retain) NSString *token;
@property(atomic) BOOL isLogOut;
@property(atomic) BOOL connecting;
/*!
 @method
 @brief 获取单实例
 @discussion
 @result EmsgClient实例对象
 */
+(EmsgClient *)sharedInstance;

/*!
 @method
 @brief 发起重新连接的请求
 @discussion
 */
-(void)autoReconnect;

/*!
 @method
 @brief 登陆认证
 @discussion
 @param jid 登录账户
 @param password 登录密码
 */

-(BOOL)auth:(NSString *)jid withPassword:(NSString *)password;

/*!
 @method
 @brief 发送普通文本消息
 @discussion
 @param msgToId 发送给对方的账户
 @param content 发送消息内容
 @param mTargetType 消息类型 SINGLECHAT单聊  GROUPCHAT 群聊
 @param tag 可用于区分消息的条目
 */
-(void)sendMessage:(NSString *)msgToId content:(NSString *)content targetType:(MsgType)mTargetType tag:(long)tag;
-(void)sendMessage:(NSString *)msgToId content:(NSString *)content targetType:(MsgType)mTargetType  tag:(long)tag msgId:(NSString *)msgId;

/*!
 @method
 @brief 发送图片文件信息
 @discussion
 @param data 图片文件的数据类
 @param attrs 用于消息扩展
 @param name  文件名称
 @param msgToId 发送给对方的账户
 @param mTargetType 消息类型 SINGLECHAT单聊  GROUPCHAT 群聊
 @param tag 可用于区分消息的条目
 */
-(void)sendImageData:(NSData *)data attrs:(NSMutableArray*)attrs withName:(NSString *)name toid:(NSString *)msgToId targetType:(MsgType)mTargetType  tag:(long)tag;


/*!
 @method
 @brief 发送图片文件信息（自备文件服务器）
 @discussion
 @param attrs 用于消息扩展
 @param message 用于描述当前文件在文件服务器的位置信息
 @param msgToId 发送给对方的账户
 @param mTargetType 消息类型 SINGLECHAT单聊  GROUPCHAT 群聊
 @param tag 可用于区分消息的条目
 */
-(void)sendImageTextData:(NSMutableArray *)attrs message:(NSString *)message toid:(NSString *)msgToId targetType:(MsgType)mTargetType tag:(long)tag;


/*!
 @method
 @brief 发送音频文件信息（自备文件服务器）
 @discussion
 @param attrs 用于消息扩展
 @param message 用于描述当前文件在文件服务器的位置信息
 @param msgToId 发送给对方的账户
 @param mTargetType 消息类型 SINGLECHAT单聊  GROUPCHAT 群聊
 @param audioLasts 音频文件持续时间
 @param tag 可用于区分消息的条目
 */
-(void)sendAudioTextData:(NSMutableArray *)attrs message:(NSString *)message toid:(NSString *)msgToId targetType:(MsgType)mTargetType during:(int)audioLasts tag:(long)tag;

/*!
 @method
 @brief 发送音频文件信息（使用sdk默认文件服务器）
 @discussion
 @param data 音频文件的数据类
 @param attrs 用于消息扩展
 @param name  文件名称
 @param msgToId 发送给对方的账户
 @param mTargetType 消息类型 SINGLECHAT单聊  GROUPCHAT 群聊
 @param audioLasts 音频文件持续时间
 @param tag 可用于区分消息的条目
 */
-(void)sendAudioData:(NSData *)data attrs:(NSMutableArray*)attrs withName:(NSString *)name toid:(NSString *)msgToId targetType:(MsgType)mTargetType during:(int)audioLasts tag:(long)tag ;

-(void)sendAudioData:(NSData *)data attrs:(NSMutableArray *)attrs withName:(NSString *)name toid:(NSString *)msgToId targetType:(MsgType)mTargetType during:(int)audioLasts tag:(long)tag msgId:(NSString *)msgId;

/*!
 @method
 @brief 判断消息服务引擎状态
 @discussion
 @return YES 消息服务运行正常  NO 消息服务异常需要重新建立连接
 */
-(BOOL)isAuthed;

/*!
 @method
 @brief 登出消息服务
 @discussion 使用在不需要消息服务时关闭消息服务以节省内存占用
 */
-(void)logout;
-(void)closeSocket;

/*!
 @method
 @brief 设置消息服务引擎的回调
 @discussion 通过传递引用消息服务相关类的指针 实现对EmsgClientProtocol 下所有方法的回调
 */
-(void)setDelegate:(id) delegeate;

@end
@protocol EmsgClientProtocol

@optional
-(void)autoReconnect;
/*登陆服务器成功*/
-(void) didAuthSuccessed;
/*登陆服务器失败*/
-(void) didAuthFailed:(NSString *)error;
/*发送信息成功*/
-(void) didSendMessageSuccessed:(long)tag;
/*发送带附件信息百分比*/
-(void) didUploadPercent:(float)percent tag:(long)tag msgId:(NSString *)msgId;
/*上传附件完成*/
-(void) didUploadComplete:(NSString *)key tag:(long)tag msgId:(NSString *)msgId;
/*发送信息失败*/
-(void) didSendMessageFailed:(long)tag;
/*登录超时的回调*/
-(void) reciveAuthTimeOut;

/*收到消息*/
-(void) didReceivedMessage:(EmsgMsg *)msg;
/*收到离线消息*/
-(void) didReceivedOfflineMessageArray:(NSArray *)array;
-(void) willDisconnectWithError:(NSError *)err;
/*收到强制下线消息*/
-(void) didKilledByServer;
@end