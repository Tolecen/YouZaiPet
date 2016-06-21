
//
//  Define.h
//  sockettest
//
//  Created by cyt on 14/11/18.
//  Copyright (c) 2014年 cyt. All rights reserved.
//


#define END_TAG     @"\01"

#define HEART_BEAT  @"\02\01"

#define SERVER_KILL  @"\03\01"


#define MSG_TYPE_OPEN_SESSION    0
#define MSG_TYPE_CHAT            1
#define MSG_TYPE_GROUP_CHAT      2
#define MSG_TYPE_STATE           3

#define SERVER_ACK   @"server_ack"  //消息回执jid

#define  RECONNECT_FREQ     10   //自动重连时间间隔

#define  HEART_BEAT_FREQ     50  //心跳包间隔

typedef enum{
    SINGLECHAT=1,
    GROUPCHAT
}MsgType;


typedef enum{
    PACKET_NOTEND=-1,//不完整数据
    PACKET_END,//普通数据读取完成
    PACKET_KILL,//服务器强制断开数据流
    PACKET_HEART,//心跳包数据流
}PacketType;



#define MSG_TYPE_AUDIO @"audio"
#define MSG_TYPE_IMG   @"image"
#define MSG_TYPE_TEXT  @"text"


#define  HTTP_RESULT_OK   200

#define  SOCKET_IP   @"server.lcemsg.com"
#define  SOCKET_PORT  4222
#define  TOKEN_URL  @"http://202.85.214.60/uptoken/"

#define   TOKEN_EXPIRED      @"token_expired"