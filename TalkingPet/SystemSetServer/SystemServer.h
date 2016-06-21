//
//  SystemServer.h
//  TalkingPet
//
//  Created by wangxr on 14-8-18.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmsgClient.h"
#import "ChatMsg.h"
#import "Pet.h"
#import "SoundSong.h"
@class RootViewController,SectionMSgViewController;
typedef enum
{
    // Apple NetworkStatus Compatible Names.
    SystemNetStatusNotReachable     = 0,
    SystemNetStatusReachableViaWiFi = 2,
    SystemNetStatusReachableViaWWAN = 1
} SystemNetStatus;

typedef enum
{
    // Apple NetworkStatus Compatible Names.
    PublishStatuPetalk     = 0,
    PublishStatuPicture
} PublishStatus;
@interface SystemServer : NSObject<EmsgClientProtocol>
@property (nonatomic, assign) BOOL autoSinaWeiBo;
@property (nonatomic, assign) BOOL autoFriendCircle;
@property (nonatomic, assign) BOOL savePublishImg;
@property (nonatomic, assign) BOOL saveOriginalImg;
@property (nonatomic, assign) BOOL shouldReNewTree;
@property (nonatomic, assign) BOOL metionTokenOutTime;
@property (nonatomic, assign) NSUInteger skinType;
@property (nonatomic, retain) NSString * uploadToken;
@property (nonatomic, retain) NSString * currentChatUserId;
@property (nonatomic, assign) int  layout;
@property (nonatomic, assign) float navigationBarHigh;
@property (nonatomic, assign) BOOL canPlayAudio;
@property (nonatomic, assign) BOOL agreeUserAgreement;
@property (nonatomic, assign) BOOL appstoreIsInReview;
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, assign) BOOL inPay;
@property (nonatomic, assign) NSString * currentTalkingPet;
@property (nonatomic, assign) BOOL needConnectChatServer;
@property (nonatomic, assign) SystemNetStatus systemNetStatus;
@property (nonatomic, strong) EmsgClient * chatClient;
@property (nonatomic, assign) PublishStatus publishstatu;
@property (nonatomic, assign) BOOL leftMenuBarShowed;
+ (SystemServer*)sharedSystemServer;
-(void)chatClientAuth;
@end
