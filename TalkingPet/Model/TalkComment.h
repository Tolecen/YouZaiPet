//
//  TalkComment.h
//  TalkingPet
//
//  Created by Tolecen on 14-8-9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TalkingBrowse;
@interface TalkComment : NSObject
@property (nonatomic,strong)NSString * commentId;
@property (nonatomic,strong)NSString * petAvatarURL;
@property (nonatomic,strong)NSString * petNickname;
@property (nonatomic,strong)NSString * petID;
@property (nonatomic,strong)NSString * commentType;
@property (nonatomic,strong)NSString * contentType;
@property (nonatomic,strong)NSString * content;
@property (nonatomic,strong)NSMutableAttributedString* contentStr;
@property (nonatomic,strong)NSString * commentTime;
@property (nonatomic,strong)NSString * usercenterCommentTime;
@property (nonatomic,strong)NSString * audioUrl;
@property (nonatomic,strong)NSString * audioDuration;

@property (nonatomic,strong)NSString * aimPetNickname;
@property (nonatomic,strong)NSString * aimPetID;
@property (nonatomic,strong)NSString * talkId;
@property (nonatomic,strong)NSString * talkThumbnail;
@property (nonatomic,assign)BOOL haveAimPet;
@property (nonatomic,strong)TalkingBrowse * talking;
@property (nonatomic,assign)float cWidth;
@property (nonatomic,assign)float cHeight;

- (id)initWithHostInfo:(NSDictionary*)info;
- (id)initWithHuDongCommentInfo:(NSDictionary*)info;
@end
