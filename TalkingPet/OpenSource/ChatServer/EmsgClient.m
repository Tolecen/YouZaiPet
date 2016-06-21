//
//  EmsgClient.m
//  sockettest
//
//  Created by cyt on 14/11/18.
//  Copyright (c) 2014年 cyt. All rights reserved.
//

#import "EmsgClient.h"
#import "JSONKit.h"
#import "Define.h"
#import "ChatMsg.h"
//#import "QiniuManager.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "NetServer.h"
//#define TOKEN   @"eau6doiUgYfcnZiqzWl_xs6amhn5VZ5jC4IPpDwd:W5i_7-lKNHCvgSXXwEJDxdZNtBM=:eyJzY29wZSI6ImVtc2ciLCJpbnNlcnRPbmx5IjowLCJmc2l6ZUxpbWl0IjowLCJkZWFkbGluZSI6MTQxNjY0OTgxMSwiZGV0ZWN0TWltZSI6MH0="

Reachability  *hostReach;

@implementation EmsgClient

@synthesize jid,pwd,token;
static  EmsgClient  *mEmsgClient =nil;
NSTimer *_recnnecttimer;
NSTimer *_hearttimer;
AsyncSocket *asyncSocket;

//for  static   method
+ (EmsgClient *)sharedInstance
{
    @synchronized(self){
        if(mEmsgClient  ==nil){
          mEmsgClient  = [[self  alloc]init];
         [mEmsgClient setIsLogOut:YES];
            mEmsgClient.connecting = NO;
         [mEmsgClient registerNetWorkStatus];
        }
    }
    return  mEmsgClient;
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];

    if (status == NotReachable) {
        [self   closeSocket];
        isNetWorkAvailable  =  NO;
    }else{
        isNetWorkAvailable  =   YES;
//        [self   autoReconnect];
        if (self.jid&&self.pwd) {
            [self connectServer:self.jid withPassword:self.pwd];
        }
        

    }
}
-(void)registerNetWorkStatus{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [[Reachability reachabilityWithHostname:@"www.baidu.com"] retain];
    [hostReach startNotifier];
}
//设置当前代理对象
-(void)setDelegate:(id)thedelegeate{
    delegate   =thedelegeate;
}
//判断当前认证状态
-(BOOL)isAuthed
{
    if(asyncSocket!=nil)
    {
        if(asyncSocket.isConnected&&hasAuth)
        {
            return YES;
        }
        else{
            return  NO;
        }
    }
    else{
        return NO; 
    }

}
//关闭socket通道
-(void)closeSocket{

    hasAuth=NO;
    self.connecting = NO;
    if(asyncSocket!=nil)
    {
        [asyncSocket disconnect];
        [asyncSocket release];
        asyncSocket=nil;
    }
    if(_hearttimer!=nil)
    {
        [_hearttimer invalidate];
        _hearttimer=nil;
    }
    if(_recnnecttimer!=nil)
    {
        [_recnnecttimer invalidate];
        _recnnecttimer=nil;
    }


}
/*
 关闭消息服务引擎 
 */
-(void)logout
{

    [self   closeSocket];
    [mEmsgClient setIsLogOut:YES];
    [hostReach stopNotifier];

    if(self.jid!=nil)
    {
//        [self.jid release];
        self.jid=nil;
    }
    if(self.pwd!=nil)
    {
//        [self.pwd release];
        self.pwd=nil;
    }
    if(self.token!=nil)
    {
//        [self.token release];
        self.token=nil;
    }
    
    if(packetdata!=nil)
    {
//        [packetdata release];
        packetdata=nil;
    }

}
-(BOOL)auth:(NSString *)_jid withPassword:(NSString *)_password
{
    if(self.jid!=nil)
    {
//        [self.jid release];
        self.jid=nil;
    }
    self.jid=_jid;
    if(self.pwd!=nil)
    {
//        [self.pwd release];
        self.pwd=nil;
    }
    self.pwd=_password;
    return [self connectServer:_jid withPassword:_password];
}
-(BOOL)connectServer:(NSString *)_jid withPassword:(NSString *)_password
{
    if (self.connecting||hasAuth) {
        return YES;
    }
    NSError *err = nil;
    
    if(asyncSocket!=nil)
    {
        asyncSocket.delegate=nil;
        [asyncSocket release];
        asyncSocket=nil;
    }
    asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
    if(![asyncSocket connectToHost:SOCKET_IP onPort:SOCKET_PORT withTimeout:-1 error:&err])//连接失败
    {
        return NO;
    }
   
    self.connecting = YES;
    NSMutableDictionary *envelope=[NSMutableDictionary dictionary];
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    [envelope setObject:cfuuidString forKey:@"id"];
    [envelope setObject:[NSNumber numberWithInt:MSG_TYPE_OPEN_SESSION] forKey:@"type"];
    [envelope setObject:_jid forKey:@"jid"];
    [envelope setObject:_password forKey:@"pwd"];
    
    
    NSMutableDictionary *root=[NSMutableDictionary dictionaryWithCapacity:1];
    [root setObject:envelope forKey:@"envelope"];
    
    
    NSString *logininfo=[NSString stringWithFormat:@"%@%@",[root JSONString],END_TAG];
    NSData *data = [logininfo dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:data withTimeout:-1 tag:0];
    return YES;
}

/*发送普通文本聊天消息*/
-(void)sendMessage:(NSString *)msgToId content:(NSString *)content targetType:(MsgType)mTargetType  tag:(long)tag
{
    int type = mTargetType == SINGLECHAT ? MSG_TYPE_CHAT : MSG_TYPE_GROUP_CHAT;
    
    NSMutableDictionary *envelope=[NSMutableDictionary dictionary];
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    [envelope setObject:cfuuidString forKey:@"id"];
    [envelope setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [envelope setObject:msgToId forKey:@"to"];
    [envelope setObject:self.jid forKey:@"from"];
    [envelope setObject:[NSNumber numberWithInt:1] forKey:@"ack"];
    
    
    NSMutableDictionary *root=[NSMutableDictionary dictionaryWithCapacity:1];
    [root setObject:envelope forKey:@"envelope"];
    
    
    NSMutableDictionary *payload=[NSMutableDictionary dictionary];
    [payload setObject:content forKey:@"content"];
    [root setObject:payload forKey:@"payload"];

    
    NSString *sendcontent=[NSString stringWithFormat:@"%@%@",[root JSONString],END_TAG];
    NSData *data = [sendcontent dataUsingEncoding:NSUTF8StringEncoding];
   
    @try {
         [asyncSocket writeData:data withTimeout:-1 tag:tag];
    }
    @catch (NSException *exception) {
        if([delegate respondsToSelector:@selector(didSendMessageFailed:)])//发送数据失败
        {
            [delegate didSendMessageFailed:tag];
        }
    }
}

/*发送普通文本聊天消息 外面带入msgId*/
-(void)sendMessage:(NSString *)msgToId content:(NSString *)content targetType:(MsgType)mTargetType  tag:(long)tag msgId:(NSString *)msgId
{
    int type = mTargetType == SINGLECHAT ? MSG_TYPE_CHAT : MSG_TYPE_GROUP_CHAT;
    
    NSMutableDictionary *envelope=[NSMutableDictionary dictionary];
    
    [envelope setObject:msgId forKey:@"id"];
    [envelope setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [envelope setObject:msgToId forKey:@"to"];
    [envelope setObject:self.jid forKey:@"from"];
    [envelope setObject:[NSNumber numberWithInt:1] forKey:@"ack"];
    
    
    NSMutableDictionary *root=[NSMutableDictionary dictionaryWithCapacity:1];
    [root setObject:envelope forKey:@"envelope"];
    
    
    NSMutableDictionary *payload=[NSMutableDictionary dictionary];
    [payload setObject:content forKey:@"content"];
    [root setObject:payload forKey:@"payload"];
    
    
    NSString *sendcontent=[NSString stringWithFormat:@"%@%@",[root JSONString],END_TAG];
    NSData *data = [sendcontent dataUsingEncoding:NSUTF8StringEncoding];
    
    @try {
        [asyncSocket writeData:data withTimeout:-1 tag:tag];
    }
    @catch (NSException *exception) {
        if([delegate respondsToSelector:@selector(didSendMessageFailed:)])//发送数据失败
        {
            [delegate didSendMessageFailed:tag];
        }
    }
}

-(void)getToken
{
    [self getToken];
   
}
/*发送数据流*/
-(void)sendData:(NSData *)data attrs:(NSMutableArray*)attrs withName:(NSString *)name toid:(NSString *)msgToId targetType:(MsgType)mTargetType  tag:(long)tag msgId:(NSString *)msgId
{
    /*
    NSDate *date=[NSDate date];
    long currenttimesp=[date timeIntervalSince1970];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    long timesp=[defaults integerForKey:TOKEN_EXPIRED];
    if(self.token==nil||timesp<currenttimesp)//如果没有token，需要从服务器端获取   24小时更新一次
    {
        AFHTTPRequestOperation *manager = [AFHTTPRequestOperation manager];
        __block EmsgClient *_client=self;
        NSDictionary *parameters = @{@"body": @"{}"};
        [manager GET:TOKEN_URL parameters:parameters
        success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSDictionary *dic=responseObject;
            _client.token=[dic objectForKey:@"entity"];//解析获取token
            [_client uploadData:data attrs:attrs withName:name toid:msgToId targetType:mTargetType tag:tag];
            
            [defaults setInteger:currenttimesp+24*60*60 forKey:TOKEN_EXPIRED];
            [defaults synchronize];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if([_client->delegate respondsToSelector:@selector(didSendMessageFailed:)])
            {
                [_client->delegate didSendMessageFailed:tag];
            }
        }];
    }
    else
    {
     */
        [self uploadData:data attrs:attrs withName:name toid:msgToId targetType:mTargetType tag:tag msgId:msgId];
//  }
}
//使用默认文件服务器 上传图片
-(void)sendImageData:(NSData *)data attrs:(NSMutableArray *)attrs withName:(NSString *)name toid:(NSString *)msgToId targetType:(MsgType)mTargetType tag:(long)tag
{
     [self getImageMustable:attrs];
     [self sendData:data attrs:attrs withName:name toid:msgToId targetType:mTargetType tag:tag msgId:nil];
}
//使用自备文件服务器 上传图片
-(void)sendImageTextData:(NSMutableArray *)attrs message:(NSString *)message toid:(NSString *)msgToId targetType:(MsgType)mTargetType tag:(long)tag
{
    [self getImageMustable:attrs];
    [self didsendData:attrs key:message toid:msgToId targetType:mTargetType tag:tag];
}
//组拼一个audio结构
-(NSMutableArray *)getAudioMustable:(NSMutableArray *)attrs during:(int)audioLasts
{
 NSString *mDuring = [NSString stringWithFormat:@"%d",audioLasts];
 NSMutableDictionary *Content_type=[NSMutableDictionary dictionaryWithCapacity:1];
 [Content_type setObject:@"audio" forKey:@"Content-type"];
 [Content_type setObject:mDuring  forKey:@"Content-length"];
 if(attrs ==nil){//如果没有创建扩展的协议map 则自己创建一个构造了图片协议的map集合
  attrs =[NSMutableArray array];
 }
 [attrs addObject:Content_type];
    return attrs;
}

//组拼一个image结构
-(void)getImageMustable:(NSMutableArray *)attrs
{
 NSMutableDictionary *Content_type=[NSMutableDictionary dictionaryWithCapacity:1];
 [Content_type setObject:@"image" forKey:@"Content-type"];
 if(attrs ==nil){//如果没有创建扩展的协议map 则自己创建一个构造了图片协议的map集合
  attrs =[NSMutableArray array];
 }
 [attrs addObject:Content_type];
}

//使用自备文件服务器 上传语音
-(void)sendAudioTextData:(NSMutableArray *)attrs message:(NSString *)message toid:(NSString *)msgToId targetType:(MsgType)mTargetType during:(int)audioLasts tag:(long)tag
{
 [self getAudioMustable:attrs during:audioLasts];

 [self didsendData:attrs key:message toid:msgToId targetType:mTargetType tag:tag];
}


//使用默认文件服务器 上传语音
-(void)sendAudioData:(NSData *)data attrs:(NSMutableArray *)attrs withName:(NSString *)name toid:(NSString *)msgToId targetType:(MsgType)mTargetType during:(int)audioLasts tag:(long)tag
{
  [self getAudioMustable:attrs during:audioLasts];

  [ self sendData:data attrs:attrs withName:name toid:msgToId targetType:mTargetType tag:tag msgId:nil];
}

-(void)sendAudioData:(NSData *)data attrs:(NSMutableArray *)attrs withName:(NSString *)name toid:(NSString *)msgToId targetType:(MsgType)mTargetType during:(int)audioLasts tag:(long)tag msgId:(NSString *)msgId
{
    NSLog(@"msg to send id : %ld",tag);
//    [self getAudioMustable:attrs during:audioLasts];
    
    [ self sendData:data attrs:[self getAudioMustable:attrs during:audioLasts] withName:name toid:msgToId targetType:mTargetType tag:tag msgId:msgId];
}


-(void)uploadData:(NSData *)data attrs:(NSMutableArray*)attrs withName:(NSString *)name toid:(NSString *)msgToId targetType:(MsgType)mTargetType  tag:(long)tag msgId:(NSString *)msgId
{
    NSDictionary * attrd = [NSDictionary dictionary];
    for(int i=0;i<[attrs count];i++)
    {
        attrd = [attrs objectAtIndex:i];
    }
    __block EmsgClient *_client=self;
    NSString * fileType = [attrd objectForKey:@"Content-type"];
    if ([fileType isEqualToString:@"audio"]) {
        [NetServer uploadAudio:data MsgId:msgId Type:@"chat" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            if([_client->delegate respondsToSelector:@selector(didUploadPercent:tag:msgId:)])
            {
                [_client->delegate didUploadPercent:(float)(totalBytesWritten/totalBytesExpectedToWrite) tag:tag msgId:msgId];
            }
        } Success:^(id responseObject, NSString *fileURL) {
            if([_client->delegate respondsToSelector:@selector(didUploadComplete:tag:msgId:)])
            {
                [_client->delegate didUploadComplete:fileURL tag:tag msgId:msgId];
            }
            
            [_client didsendData:attrs key:fileURL toid:msgToId targetType:mTargetType tag:tag];
        } failure:^(NSError *error) {
            if([_client->delegate respondsToSelector:@selector(didSendMessageFailed:)])
            {
                [_client->delegate didSendMessageFailed:tag];
            }

        }];
    }
    else if ([fileType isEqualToString:@"image"]){
        [NetServer uploadImageData:data Type:@"chat" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            if([_client->delegate respondsToSelector:@selector(didUploadPercent:tag:msgId:)])
            {
                [_client->delegate didUploadPercent:(float)(totalBytesWritten/totalBytesExpectedToWrite) tag:tag msgId:msgId];
            }
            
        } Success:^(id responseObject, NSString *fileURL) {
            if([_client->delegate respondsToSelector:@selector(didUploadComplete:tag:msgId:)])
            {
                [_client->delegate didUploadComplete:fileURL tag:tag msgId:msgId];
            }
            [_client didsendData:attrs key:fileURL toid:msgToId targetType:mTargetType tag:tag];
        } failure:^(NSError *error) {
            if([_client->delegate respondsToSelector:@selector(didSendMessageFailed:)])
            {
                [_client->delegate didSendMessageFailed:tag];
            }
        }];
    }
    
    /*
    QiniuManager *manager=[QiniuManager defaultManager];
    __block EmsgClient *_client=self;
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    name=[NSString stringWithFormat:@"%@_%@",cfuuidString,name];
    [manager uploadData:self.token data:data withKey:name complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        int statusCode=[info statusCode];
        if(statusCode==HTTP_RESULT_OK)//上传成功
        {
            if([_client->delegate respondsToSelector:@selector(didUploadComplete:tag:)])
            {
                [_client->delegate didUploadComplete:key tag:tag];
            }
            [_client didsendData:attrs key:key toid:msgToId targetType:mTargetType tag:tag];
        }
        else{//上传失败
            if([_client->delegate respondsToSelector:@selector(didSendMessageFailed:)])
            {
                [_client->delegate didSendMessageFailed:tag];
            }
        }
    } progress:^(NSString *key, float percent) {
        if([_client->delegate respondsToSelector:@selector(didUploadPercent:tag:)])
        {
            [_client->delegate didUploadPercent:percent tag:tag];
        }
    }];
     */
}


-(void)didsendData:(NSMutableArray*)attrs key:(NSString *)key toid:(NSString *)msgToId targetType:(MsgType)mTargetType  tag:(long)tag
{
    int type = mTargetType == SINGLECHAT ? MSG_TYPE_CHAT : MSG_TYPE_GROUP_CHAT;
    
    NSMutableDictionary *envelope=[NSMutableDictionary dictionary];
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    [envelope setObject:cfuuidString forKey:@"id"];
    [envelope setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [envelope setObject:msgToId forKey:@"to"];
    [envelope setObject:self.jid forKey:@"from"];
    [envelope setObject:[NSNumber numberWithInt:1] forKey:@"ack"];
    
    
    NSMutableDictionary *root=[NSMutableDictionary dictionaryWithCapacity:1];
    [root setObject:envelope forKey:@"envelope"];
    
    
    NSMutableDictionary *payload=[NSMutableDictionary dictionary];
    [payload setObject:key forKey:@"content"];
    
    for(int i=0;i<[attrs count];i++)
    {
        [payload setObject:[attrs objectAtIndex:i] forKey:@"attrs"];
    }
    [root setObject:payload forKey:@"payload"];
    
    
    NSString *sendcontent=[NSString stringWithFormat:@"%@%@",[root JSONString],END_TAG];
    NSData *data = [sendcontent dataUsingEncoding:NSUTF8StringEncoding];
    @try {
        [asyncSocket writeData:data withTimeout:-1 tag:tag];
    }
    @catch (NSException *exception) {
        if([delegate respondsToSelector:@selector(didSendMessageFailed:)])//发送数据失败
        {
            [delegate didSendMessageFailed:tag];
        }
    }
}
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString*)host port:(UInt16)port {
    [asyncSocket readDataWithTimeout:-1 tag:0];
}

-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag {
    
    
    [sock readDataWithTimeout:-1 tag:0];
    PacketType pakcetType=[self isPacketEnd:data];
    if(pakcetType==PACKET_KILL)//服务器强制断开数据流 强制下线
    {
        [packetdata release];
        packetdata=nil;
        
        hasAuth=NO;
        self.connecting = NO;
       
        if(_hearttimer!=nil)//  强制下线 关闭心跳包
        {
            [_hearttimer invalidate];
            _hearttimer=nil;
        }
        
        if([delegate respondsToSelector:@selector(didKilledByServer)])
        {
            [delegate didKilledByServer];
            [self logout];


        }
    }
    else if(pakcetType==PACKET_HEART)//心跳包数据流
    {
        [packetdata release];
        packetdata=nil;
        
    }
    else if(pakcetType==PACKET_NOTEND)//由于太长的数据无法一次读入所以需要做特殊处理
    {
       
    }
    else if(pakcetType==PACKET_END){//普通数据读取完成
        NSString *msg = [[NSString alloc] initWithData:packetdata encoding:NSUTF8StringEncoding];
        [packetdata release];
        packetdata=nil;
        
        NSRange foundEnd=[msg rangeOfString:END_TAG options:NSBackwardsSearch];
        NSString *msgdictory = [msg substringToIndex:foundEnd.location];
        NSDictionary *dic=[msgdictory objectFromJSONString];
        NSDictionary *envelope=[dic objectForKey:@"envelope"];
        
        int type=[[envelope objectForKey:@"type"] intValue];
        
        if(type==MSG_TYPE_OPEN_SESSION)//登陆验证返回
        {
            NSDictionary *entity=[dic objectForKey:@"entity"];
            NSString *result=[entity objectForKey:@"result"];
            if(result!=nil&&[result isEqual:@"ok"])//登陆成功
            {
                hasAuth=YES;
                self.connecting = NO;
               [mEmsgClient setIsLogOut:NO];
                [self sendHeartPacket];//发送心跳包
                if([delegate respondsToSelector:@selector(didAuthSuccessed)])
                {
                    [delegate didAuthSuccessed];
                }
                NSString * theId = [[dic objectForKey:@"envelope"] objectForKey:@"id"];
                [self sendAckMsg:theId];
                NSDictionary *delay=[dic objectForKey:@"delay"];
                NSArray *array=[delay objectForKey:@"packets"];
                if(array!=nil)
                {
                    NSMutableArray *msgArray=[[NSMutableArray alloc] init];
                    for(int i=0;i<[array count];i++)
                    {
                      NSDictionary *dic=[array objectAtIndex:i];
                      NSDictionary *envelope=[dic objectForKey:@"envelope"];
                      NSDictionary *payload=[dic objectForKey:@"payload"];
                      
                      int ack=[[envelope objectForKey:@"ack"] intValue];
                      NSString *fromjid=[envelope objectForKey:@"from"];
                      NSString *msgid=[envelope objectForKey:@"id"];
                      NSString *time=[envelope objectForKey:@"ct"];
                      NSString *content=[payload objectForKey:@"content"];
                      NSDictionary *attrs=[payload objectForKey:@"attrs"];
                        
                      int type=[[envelope objectForKey:@"type"] intValue];
                      NSDate* date = [NSDate date];
                      double timeSp=[date timeIntervalSince1970];
                      if(time!=nil)
                      {
                         timeSp=[time doubleValue]/1000.0f;
                      }
                      EmsgMsg *msg=[[EmsgMsg alloc] init];
                      msg.type=type;
                      msg.contenttype=@"";
                      msg.gid = msgid;
                      msg.contenttype=MSG_TYPE_TEXT;
                      if(attrs!=nil)
                      {
                         NSString *Content_type=[attrs objectForKey:@"Content-type"];
                         msg.contenttype=Content_type;
                         NSString *Content_length=[attrs objectForKey:@"Content-length"];
                         msg.contentlength=Content_length;
                      }
                      msg.content=content;
                      msg.fromjid=fromjid;
                      msg.timeSp=timeSp;
                      [msgArray addObject:msg];
                      [msg release];
                        
                    
                      if(ack==1)
                      {
                         [self sendAckMsg:msgid];//普通消息需要回执
                      }

                    }
                    if([msgArray count]>0)//离线消息
                    {
                        if([delegate respondsToSelector:@selector(didReceivedOfflineMessageArray:)])
                        {
                            [delegate didReceivedOfflineMessageArray:msgArray];
                        }
                    }
                    [msgArray release];
                }
            }
            else{
                hasAuth=NO;
                self.connecting = NO;
                if([delegate respondsToSelector:@selector(didAuthFailed:)])
                {
                    NSString *reason=[entity objectForKey:@"reason"];
                    [delegate didAuthFailed:reason];
                }
            }
        }
        else if(type==MSG_TYPE_CHAT||type==MSG_TYPE_GROUP_CHAT)//聊天消息返回
        {
            
            NSDictionary *payload=[dic objectForKey:@"payload"];
            NSString *content=[payload objectForKey:@"content"];
            NSString *fromjid=[envelope objectForKey:@"from"];
            NSString *msgid=[envelope objectForKey:@"id"];
            NSDictionary *attrs=[payload objectForKey:@"attrs"];
            int ack=[[envelope objectForKey:@"ack"] intValue];
            
            if(ack==1)
            {
                [self sendAckMsg:msgid];//普通消息需要回执
            }
            NSDate* date = [NSDate date];
            double timeSp=[date timeIntervalSince1970];
            EmsgMsg *msg=[[EmsgMsg alloc] init];
            msg.type=SINGLECHAT;
            msg.contenttype=MSG_TYPE_TEXT;
            if(attrs!=nil)
            {
                NSString *Content_type=[attrs objectForKey:@"Content-type"];
                msg.contenttype=Content_type;
                NSString *Content_length=[attrs objectForKey:@"Content-length"];
                msg.contentlength=Content_length;
            }
            msg.content=content;
            msg.fromjid=fromjid;
            msg.timeSp=timeSp;
            msg.gid = msgid;
            if([delegate respondsToSelector:@selector(didReceivedMessage:)])
            {
                [delegate didReceivedMessage:msg];
            }
            [msg release];
        }
        
        else if(type==MSG_TYPE_STATE)//ack  返回  暂不处理
        {
            
        }
        [msg release];
    }
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
    
    if([delegate respondsToSelector:@selector(didSendMessageSuccessed:)])//发送数据成功
    {
        [delegate didSendMessageSuccessed:tag];
    }

}
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    if([delegate respondsToSelector:@selector(willDisconnectWithError:)])
    {
        [delegate willDisconnectWithError:err];
    }
}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    if(hasAuth  )//开启断线重连
    {
        if(_hearttimer!=nil)//断线重连过程不发送心跳包
        {
            [_hearttimer invalidate];
            _hearttimer=nil;
        }
        [self autoReconnect];
    }
    hasAuth=NO;
    self.connecting = NO;

 if([delegate respondsToSelector:@selector(reciveAuthTimeOut)])
  {
    [delegate reciveAuthTimeOut];
  }

}

-(int)isPacketEnd:(NSData *)data
{
    if(packetdata==nil)
    {
         packetdata=[[NSMutableData alloc] initWithCapacity:1];
    }
    [packetdata appendData:data];
    NSString *msg = [[NSString alloc] initWithData:packetdata encoding:NSUTF8StringEncoding];
    NSRange foundEnd=[msg rangeOfString:END_TAG options:NSBackwardsSearch];
    
    if(foundEnd.location!=NSNotFound)
    {
        NSRange foundkill=[msg rangeOfString:SERVER_KILL options:NSBackwardsSearch];
        NSRange foundHeart=[msg rangeOfString:HEART_BEAT options:NSBackwardsSearch];
        if(foundkill.location!=NSNotFound)
        {
            
            return PACKET_KILL;
        }
        else if(foundHeart.location!=NSNotFound)
        {
            return PACKET_HEART;
        }
        NSString *msgdictory = [msg substringToIndex:foundEnd.location];
        NSDictionary *dic=[msgdictory objectFromJSONString];
        if([dic isKindOfClass:[NSDictionary class]])
        {
            return PACKET_END;
        }
    }
    return PACKET_NOTEND;
}
/*发送消息回执*/
-(void)sendAckMsg:(NSString *)msgid
{
    NSMutableDictionary *envelope=[NSMutableDictionary dictionary];
    [envelope setObject:msgid forKey:@"id"];
    [envelope setObject:[NSNumber numberWithInt:MSG_TYPE_STATE] forKey:@"type"];
    [envelope setObject:SERVER_ACK forKey:@"to"];
    [envelope setObject:self.jid forKey:@"from"];
    
    
    NSMutableDictionary *root=[NSMutableDictionary dictionaryWithCapacity:1];
    [root setObject:envelope forKey:@"envelope"];
    
    NSString *sendcontent=[NSString stringWithFormat:@"%@%@",[root JSONString],END_TAG];
    NSData *data = [sendcontent dataUsingEncoding:NSUTF8StringEncoding];
    @try {
        [asyncSocket writeData:data withTimeout:-1 tag:0];
    }
    @catch (NSException *exception) {
        
    }
    
}
/*断线自动重连*/
-(void)autoReconnect
{
    
    [self   stopReconnect];
    _recnnecttimer=[NSTimer scheduledTimerWithTimeInterval:RECONNECT_FREQ
                                                    target:self
                                                  selector:@selector(time_to_connect)
                                                  userInfo:nil
                                                   repeats:YES] ;

    [[NSRunLoop currentRunLoop] addTimer:_recnnecttimer forMode:NSRunLoopCommonModes];
}
-(void)stopReconnect{

    if(_recnnecttimer!=nil)
    {
        [_recnnecttimer invalidate];
        _recnnecttimer=nil;
    }
}
-(void)time_to_connect
{
	if( [self isLogOut])return;

   if([self connectServer:self.jid withPassword:self.pwd])//连接成功 断开自动重连
   {
      if(_recnnecttimer!=nil)
      {
        [_recnnecttimer invalidate];
        _recnnecttimer=nil;
      }
    }
}
/*心跳包*/
-(void)sendHeartPacket
{
    [self   stopHeartPacket];
    _hearttimer=[NSTimer scheduledTimerWithTimeInterval:HEART_BEAT_FREQ
                                                target:self
                                              selector:@selector(time_to_send_heart)
                                              userInfo:nil
                                               repeats:YES] ;
     [[NSRunLoop currentRunLoop] addTimer:_hearttimer forMode:NSRunLoopCommonModes];
}

-(void)stopHeartPacket
{
    if(_hearttimer!=nil)
    {
        [_hearttimer invalidate];
        _hearttimer=nil;
    }
}

-(void)time_to_send_heart
{
    if([self isLogOut])return;

    NSData *data = [HEART_BEAT dataUsingEncoding:NSUTF8StringEncoding];
    @try {
        [asyncSocket writeData:data withTimeout:-1 tag:0];
    }
    @catch (NSException *exception) {
        [self   closeSocket];
        [self   autoReconnect];
    }
}

-(void)dealloc
{
    [super dealloc];

    [asyncSocket release];
    asyncSocket=nil;
    [packetdata release];
    [self.jid release];
    [self.pwd release];
    [self.token release];
   
}
@end
