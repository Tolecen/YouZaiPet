//
//  DatabaseServe.h
//  TalkingPet
//
//  Created by wangxr on 14-7-16.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkingPublish.h"
#import "Account.h"
#import "Pet.h"
#import "ChatMsg.h"
#import "ChatListMsg.h"
#import "Accessory.h"
#import "Tag.h"
#import "DraftModel.h"

@interface DatabaseServe : NSObject
+ (void)clearDatabase;
@end
@interface DatabaseServe (User)

+(void)activateUeserWithAccount:(Account*)account;
+(void)unActivateUeser;
+(void)savePet:(Pet*)pet WithUsername:(NSString*)username;
+(void)setChatSettingForPetId:(NSString *)petId setting:(int)setting;
+(int)getChatSettingForCurrentPet;
+(void)activatePet:(Pet*)pet WithUsername:(NSString*)username;
+(Account*)getActionAccount;
+(Account*)getLastActionedAccount;
+(Pet*)getActionPetWithWithUsername:(NSString*)username;
+(NSArray*)getUnactionPetsWithWithUsername:(NSString*)username;
+(void)deletePet:(Pet*)Pet;



@end
@interface DatabaseServe (SystemSet)
+(void)setSavePublishImg:(BOOL)yesOrNo;
+(void)setSaveOriginalImg:(BOOL)yesOrNo;
+(BOOL)savePublishImg;
+(BOOL)saveOriginalImg;
+(void)setAutoShareSinaWeiBo:(BOOL)yesOrNo;
+(void)setAutoShareFriendCircle:(BOOL)yesOrNo;
+(void)setSkinType:(NSInteger)skinType;
+(BOOL)autoShareSinaWeiBo;
+(BOOL)autoShareFriendCircle;
+(NSInteger)skinType;
@end

@interface DatabaseServe (ChatMessage)

+(void)saveMsgPetInfo:(Pet *)pet;
+(BOOL)ifExistMsgPet:(NSString *)petId;

+(void)saveNormalChatMsg:(ChatMsg *)chatMsg;

+(void)updateMsgContentWithId:(NSString *)msgId Content:(NSString *)content;
+(void)updateMsgStatusWithTag:(long)tagId Status:(NSString *)status;

+(NSArray *)getMsgArrayByPage:(int)thePage;
+(int)getAllUnreadNormalChatCount;
+(BOOL)needNotiNormalChatInOtherPage;
+(void)setNeedNotiNormalChatWithStatus:(int)status;

+(NSArray *)getDetailMsgArrayByPage:(int)thePage PetId:(NSString *)petId;
+(void)setUnreadCount:(int)unread petId:(NSString *)petId;
+(void)deleteAllMsgForPetId:(NSString *)petId;

+(void)deleteMsgById:(NSString *)msgId SidePetId:(NSString *)sidePetId;

+(void)AddPetToChatBlackList:(NSString *)petId;
+(void)removePetFromChatBlackList:(NSString *)petId;
+(BOOL)ifThisPetInMyBlackList:(NSString *)petId;

@end
@interface DatabaseServe (Accessory)

+(void)saveAccessory:(Accessory*)acc;
+(NSArray *)getNewAccessorysWithType:(NSString*)type size:(NSInteger)size;
+(NSArray *)getHotAccessorysWithType:(NSString*)type size:(NSInteger)size;

@end
@interface DatabaseServe (Tag)

+(void)saveTag:(Tag*)tag;
+(NSArray *)getNewTagArrayWithSize:(NSInteger)size;
+(NSArray *)getHotTagArrayWithSize:(NSInteger)size;

@end
@interface DatabaseServe (PetalkDraft)

+(void)savePetalkDraft:(DraftModel *)petalkDraft;
+(void)deletePetalkDraftWithPublishId:(NSString*)publishId;
+(NSArray *)allPetalkDraftsWithCurrentPetID:(NSString*)petId;
+(DraftModel *)petalkDraftWithPublishId:(NSString*)publishId;

@end