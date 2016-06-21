//
//  DatabaseServe.m
//  TalkingPet
//
//  Created by wangxr on 14-7-16.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "DatabaseServe.h"
#import "PetEntity.h"
#import "UserEntity.h"
#import "SystemSetEntity.h"
#import "MsgPetEntity.h"
#import "ThumbNormalMsgEntity.h"
#import "NormalMsgEntity.h"
#import "NeedNotiEntity.h"
#import "ChatBlackList.h"
#import "AccessoryEntity.h"
#import "TFileManager.h"
#import "TagEntity.h"
#import "PetalkDraft.h"

@implementation DatabaseServe
+ (void)clearDatabase
{
    NSString * firstIn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"firstIn%@",@"3.0.0"]];
    NSString * firstIn2 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
    if (!firstIn && !firstIn2) {
        NSString *storeURL = [NSPersistentStore MR_applicationStorageDirectory];
        NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:storeURL];
        NSString *fileName;
        while (fileName= [dirEnum nextObject]) {
            [[NSFileManager defaultManager] removeItemAtPath: [NSString stringWithFormat:@"%@/%@",storeURL,fileName] error:nil];
        }
    }
}
@end
@implementation DatabaseServe(User)
+(void)activateUeserWithAccount:(Account*)account
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"action!=0"];
    UserEntity * user = [UserEntity MR_findFirstWithPredicate:predicate];
    if (user) {
        user.action = [[NSNumber alloc] initWithBool:NO];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",account.username];
    user = [UserEntity MR_findFirstWithPredicate:predicate];
    if (user) {
        user.action = [[NSNumber alloc] initWithBool:YES];
        user.actiontime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
//        user.passWord = account.password;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            UserEntity * user = [UserEntity MR_createInContext:localContext];
            user.action = [[NSNumber alloc] initWithBool:YES];
            user.actiontime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
            user.userID = account.userID;
            user.userName = account.username;
//            user.passWord = account.password;
        }];
    }
}
+(void)unActivateUeser
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"action!=0"];
    UserEntity * user = [UserEntity MR_findFirstWithPredicate:predicate];
    if (user) {
        user.action = [[NSNumber alloc] initWithBool:NO];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}
+(void)savePet:(Pet*)pet WithUsername:(NSString*)username
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"petID==[c]%@",pet.petID];
    PetEntity * petE = [PetEntity MR_findFirstWithPredicate:predicate];
    if (petE) {
        petE.action = [[NSNumber alloc] initWithBool:NO];
        petE.daren = [NSNumber numberWithBool:pet.ifDaren];
        petE.owner = username;
        petE.petID = pet.petID;
        petE.nickname = pet.nickname;
        petE.headImgURL = pet.headImgURL;
        petE.gender = pet.gender;
        petE.breed = pet.breed;
        petE.region = pet.region;
        petE.fansNo = pet.fansNo;
        petE.attentionNo = pet.attentionNo;
        petE.birthday = pet.birthday;
        petE.issue = pet.issue;
        petE.relay = pet.relay;
        petE.comment = pet.comment;
        petE.favour = pet.favour;
        petE.grade = pet.grade;
        petE.score = pet.score;
        petE.coin = pet.coin;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            PetEntity * petE = [PetEntity MR_createInContext:localContext];
            petE.action = [[NSNumber alloc] initWithBool:NO];
            petE.daren = [NSNumber numberWithBool:pet.ifDaren];
            petE.owner = username;
            petE.petID = pet.petID;
            petE.nickname = pet.nickname;
            petE.headImgURL = pet.headImgURL;
            petE.gender = pet.gender;
            petE.breed = pet.breed;
            petE.region = pet.region;
            petE.fansNo = pet.fansNo;
            petE.attentionNo = pet.attentionNo;
            petE.birthday = pet.birthday;
            petE.issue = pet.issue;
            petE.relay = pet.relay;
            petE.comment = pet.comment;
            petE.favour = pet.favour;
            petE.grade = pet.grade;
            petE.score = pet.score;
            petE.coin = pet.coin;
        }];
    }
}
+(void)setChatSettingForPetId:(NSString *)petId setting:(int)setting
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"petID==[c]%@",petId];
    PetEntity * petE = [PetEntity MR_findFirstWithPredicate:predicate];
    if (petE) {
        petE.chatLimits = [NSNumber numberWithInt:setting];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}
+(int)getChatSettingForCurrentPet
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"petID==[c]%@",[UserServe sharedUserServe].currentPet.petID];
    PetEntity * petE = [PetEntity MR_findFirstWithPredicate:predicate];
    if (petE) {
        return [petE.chatLimits intValue];
    }
    else
        return 0;
}
+(void)activatePet:(Pet*)pet WithUsername:(NSString*)username
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"owner==[c]%@&&action!=0",username];
    PetEntity * petE = [PetEntity MR_findFirstWithPredicate:predicate];
    if (petE) {
        petE.action = [[NSNumber alloc] initWithBool:NO];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    predicate = [NSPredicate predicateWithFormat:@"petID==[c]%@",pet.petID];
    petE = [PetEntity MR_findFirstWithPredicate:predicate];
    if (petE) {
        petE.action = [[NSNumber alloc] initWithBool:YES];
        petE.daren = [NSNumber numberWithBool:pet.ifDaren];
        petE.owner = username;
        petE.petID = pet.petID;
        petE.nickname = pet.nickname;
        petE.headImgURL = pet.headImgURL;
        petE.gender = pet.gender;
        petE.breed = pet.breed;
        petE.region = pet.region;
        petE.fansNo = pet.fansNo;
        petE.attentionNo = pet.attentionNo;
        petE.birthday = pet.birthday;
        petE.issue = pet.issue;
        petE.relay = pet.relay;
        petE.comment = pet.comment;
        petE.favour = pet.favour;
        petE.grade = pet.grade;
        petE.score = pet.score;
        petE.coin = pet.coin;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            PetEntity * petE = [PetEntity MR_createInContext:localContext];
            petE.action = [[NSNumber alloc] initWithBool:YES];
            petE.daren = [NSNumber numberWithBool:pet.ifDaren];
            petE.owner = username;
            petE.petID = pet.petID;
            petE.nickname = pet.nickname;
            petE.headImgURL = pet.headImgURL;
            petE.gender = pet.gender;
            petE.breed = pet.breed;
            petE.region = pet.region;
            petE.fansNo = pet.fansNo;
            petE.attentionNo = pet.attentionNo;
            petE.birthday = pet.birthday;
            petE.issue = pet.issue;
            petE.relay = pet.relay;
            petE.comment = pet.comment;
            petE.favour = pet.favour;
            petE.grade = pet.grade;
            petE.score = pet.score;
            petE.coin = pet.coin;
        }];
    }
}
+(Account*)getActionAccount
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"action!=0"];
    UserEntity * user = [UserEntity MR_findFirstWithPredicate:predicate];
    Account * acc = [[Account alloc] init];
    acc.username = user.userName;
//    acc.password = user.passWord;
    acc.userID = user.userID;
    return acc;
}
+(Account*)getLastActionedAccount
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"action=0"];
    UserEntity * user = [[UserEntity MR_findAllSortedBy:@"actiontime" ascending:YES withPredicate:predicate] lastObject];
    Account * acc = [[Account alloc] init];
    acc.username = user.userName;
//    acc.password = user.passWord;
    acc.userID = user.userID;
    return acc;
}
+(Pet*)getActionPetWithWithUsername:(NSString*)username
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"action!=0&&owner ==%@",username];
    PetEntity * petE = [PetEntity MR_findFirstWithPredicate:predicate];
    Pet * pet = [[Pet alloc] init];
    pet.petID = petE.petID;
    pet.nickname = petE.nickname;
    pet.headImgURL = petE.headImgURL;
    pet.gender = petE.gender;
    pet.breed = petE.breed;
    pet.region = petE.region;
    pet.fansNo = petE.fansNo;
    pet.attentionNo = petE.attentionNo;
    pet.birthday = petE.birthday;
    pet.issue = petE.issue;
    pet.relay = petE.relay;
    pet.comment = petE.comment;
    pet.favour = petE.favour;
    pet.grade = petE.grade;
    pet.score = petE.score;
    pet.coin = petE.coin;
    pet.ifDaren = [petE.daren boolValue];
    return pet;
}
+(NSArray*)getUnactionPetsWithWithUsername:(NSString*)username
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"action==0&&owner ==%@",username];
    NSArray * petEArr = [PetEntity MR_findAllWithPredicate:predicate];
    NSMutableArray * arr = [NSMutableArray array];
    for (PetEntity * petE in petEArr) {
        Pet * pet = [[Pet alloc] init];
        pet.petID = petE.petID;
        pet.nickname = petE.nickname;
        pet.headImgURL = petE.headImgURL;
        pet.gender = petE.gender;
        pet.breed = petE.breed;
        pet.region = petE.region;
        pet.fansNo = petE.fansNo;
        pet.attentionNo = petE.attentionNo;
        pet.birthday = petE.birthday;
        pet.issue = petE.issue;
        pet.relay = petE.relay;
        pet.comment = petE.comment;
        pet.favour = petE.favour;
        pet.grade = petE.grade;
        pet.score = petE.score;
        pet.coin = petE.coin;
        pet.ifDaren = [petE.daren boolValue];
        [arr addObject:pet];
    }
    return arr;
}
+(void)deletePet:(Pet*)pet
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"petID==[c]%@",pet.petID];
    [PetEntity MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
@end
@implementation DatabaseServe(SystemSet)
+(void)setSavePublishImg:(BOOL)yesOrNo
{
    SystemSetEntity * sys = [SystemSetEntity MR_findFirst];
    if (sys) {
        sys.savePublishImg = [NSNumber numberWithBool:yesOrNo];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            SystemSetEntity * sysE = [SystemSetEntity MR_createInContext:localContext];
            sysE.savePublishImg = [NSNumber numberWithBool:yesOrNo];
        }];
    }
}
+(void)setSaveOriginalImg:(BOOL)yesOrNo
{
    SystemSetEntity * sys = [SystemSetEntity MR_findFirst];
    if (sys) {
        sys.saveOriginalImg = [NSNumber numberWithBool:yesOrNo];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            SystemSetEntity * sysE = [SystemSetEntity MR_createInContext:localContext];
            sysE.saveOriginalImg = [NSNumber numberWithBool:yesOrNo];
        }];
    }
}
+(BOOL)savePublishImg
{
    SystemSetEntity * sys = [SystemSetEntity MR_findFirst];
    if (!sys) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            SystemSetEntity * sysE = [SystemSetEntity MR_createInContext:localContext];
            sysE.autoFriendCircle = [NSNumber numberWithBool:YES];
            sysE.savePublishImg = [NSNumber numberWithBool:YES];
        }];
        return  YES;
    }
    return [sys.savePublishImg boolValue];
}
+(BOOL)saveOriginalImg
{
    SystemSetEntity * sys = [SystemSetEntity MR_findFirst];
    return [sys.saveOriginalImg boolValue];
}
+(void)setAutoShareSinaWeiBo:(BOOL)yesOrNo
{
    SystemSetEntity * sys = [SystemSetEntity MR_findFirst];
    if (sys) {
        sys.autoSinaWeiBo = [NSNumber numberWithBool:yesOrNo];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            SystemSetEntity * sysE = [SystemSetEntity MR_createInContext:localContext];
            sysE.autoSinaWeiBo = [NSNumber numberWithBool:yesOrNo];
        }];
    }
}
+(void)setAutoShareFriendCircle:(BOOL)yesOrNo;
{
    SystemSetEntity * sys = [SystemSetEntity MR_findFirst];
    if (sys) {
        sys.autoFriendCircle = [NSNumber numberWithBool:yesOrNo];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            SystemSetEntity * sysE = [SystemSetEntity MR_createInContext:localContext];
            sysE.autoFriendCircle = [NSNumber numberWithBool:yesOrNo];
        }];
    }
}
+(BOOL)autoShareSinaWeiBo
{
    SystemSetEntity * sys = [SystemSetEntity MR_findFirst];
    return [sys.autoSinaWeiBo boolValue];
}
+(BOOL)autoShareFriendCircle
{
    SystemSetEntity * sys = [SystemSetEntity MR_findFirst];
    if (!sys) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            SystemSetEntity * sysE = [SystemSetEntity MR_createInContext:localContext];
            sysE.autoFriendCircle = [NSNumber numberWithBool:YES];
            sysE.savePublishImg = [NSNumber numberWithBool:YES];
        }];
        return  YES;
    }
    return [sys.autoFriendCircle boolValue];
}
+(void)setSkinType:(NSInteger)skinType
{
    SystemSetEntity * sys = [SystemSetEntity MR_findFirst];
    if (sys) {
        sys.skinType = [NSNumber numberWithInteger:skinType];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            SystemSetEntity * sysE = [SystemSetEntity MR_createInContext:localContext];
            sysE.skinType = [NSNumber numberWithInteger:skinType];
        }];
    }
}
+(NSInteger)skinType
{
    SystemSetEntity * sys = [SystemSetEntity MR_findFirst];
//    if (!sys) {
//        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//            SystemSetEntity * sysE = [SystemSetEntity MR_createInContext:localContext];
//            sysE.skinType = [NSNumber numberWithInteger:0];
//        }];
//        return  0;
//    }
    return [sys.skinType integerValue];
}
@end


@implementation DatabaseServe (ChatMessage)
+(void)saveMsgPetInfo:(Pet *)pet
{
    NSPredicate * predicate = predicate = [NSPredicate predicateWithFormat:@"petId==[c]%@",pet.petID];
    MsgPetEntity * petE = [MsgPetEntity MR_findFirstWithPredicate:predicate];
    if (petE) {
        petE.petId = pet.petID;
        petE.nickname = pet.nickname;
        petE.avatarUrl = pet.headImgURL;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            MsgPetEntity * petE = [MsgPetEntity MR_createInContext:localContext];
            petE.petId = pet.petID;
            petE.nickname = pet.nickname;
            petE.avatarUrl = pet.headImgURL;
        }];
    }

}
+(BOOL)ifExistMsgPet:(NSString *)petId
{
    NSPredicate * predicate = predicate = [NSPredicate predicateWithFormat:@"petId==[c]%@",petId];
    MsgPetEntity * petE = [MsgPetEntity MR_findFirstWithPredicate:predicate];
    if (petE) {
        return YES;
    }else
    {
        return NO;
    }

}
+(void)saveNormalChatMsg:(ChatMsg *)chatMsg
{
    NSPredicate * thePredicate = [NSPredicate predicateWithFormat:@"msgId==[c]%@",chatMsg.msgid];
    NormalMsgEntity * nE = [NormalMsgEntity MR_findFirstWithPredicate:thePredicate];
    if (nE) {
        nE.sidePetId = chatMsg.fromid;
        nE.isMe = [NSNumber numberWithBool:chatMsg.isMe];
        nE.sendDate = [NSDate dateWithTimeIntervalSince1970:chatMsg.date];
        nE.startSendTime = [NSString stringWithFormat:@"%f",chatMsg.date];
        nE.content = chatMsg.content;
        nE.mineId = [UserServe sharedUserServe].currentPet.petID;
        nE.type = chatMsg.type;
        nE.tagId = [NSNumber numberWithLong:chatMsg.tagId];
        nE.msgId = chatMsg.msgid;
        nE.contentLength = chatMsg.contentLength;
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    else{
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NormalMsgEntity * msgE = [NormalMsgEntity MR_createInContext:localContext];
            msgE.sidePetId = chatMsg.fromid;
            msgE.isMe = [NSNumber numberWithBool:chatMsg.isMe];
            msgE.sendDate = [NSDate dateWithTimeIntervalSince1970:chatMsg.date];
            msgE.startSendTime = [NSString stringWithFormat:@"%f",chatMsg.date];
            msgE.content = chatMsg.content;
            msgE.mineId = [UserServe sharedUserServe].currentPet.petID;
            msgE.type = chatMsg.type;
            msgE.tagId = [NSNumber numberWithLong:chatMsg.tagId];
            msgE.msgId = chatMsg.msgid;
            msgE.contentLength = chatMsg.contentLength;
        }];
    }
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sidePetId==[c]%@ AND mineId==[c]%@",chatMsg.fromid,[UserServe sharedUserServe].currentPet.petID];
    ThumbNormalMsgEntity * thumbE = [ThumbNormalMsgEntity MR_findFirstWithPredicate:predicate];
    if (thumbE) {
        thumbE.sidePetId = chatMsg.fromid;
        if (!chatMsg.isMe) {
            thumbE.unreadCount = [NSNumber numberWithInt:[thumbE.unreadCount intValue]+1];
        }
        
        thumbE.content = chatMsg.content;
        thumbE.mineId = [UserServe sharedUserServe].currentPet.petID;
        thumbE.type = chatMsg.type;
        thumbE.sendDate = [NSDate dateWithTimeIntervalSince1970:chatMsg.date];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            ThumbNormalMsgEntity * thumbME = [ThumbNormalMsgEntity MR_createInContext:localContext];
            thumbME.sidePetId = chatMsg.fromid;
            thumbME.content = chatMsg.content;
            thumbE.unreadCount = [NSNumber numberWithInt:1];
            thumbME.mineId = [UserServe sharedUserServe].currentPet.petID;
            thumbME.type = chatMsg.type;
            thumbME.sendDate = [NSDate dateWithTimeIntervalSince1970:chatMsg.date];
            
        }];
    }
//    
//    NSPredicate * predicate3 = [NSPredicate predicateWithFormat:@"sidePetId==[c]%@",[UserServe sharedUserServe].currentPet.petID];
//    NeedNotiEntity * needNoti = [NeedNotiEntity MR_findFirstWithPredicate:predicate3];
//    if (needNoti) {
//        needNoti.sidePetId = [UserServe sharedUserServe].currentPet.petID;
//        needNoti.needNoti = [NSNumber numberWithInt:1];
//        needNoti.needNotiCount = [NSNumber numberWithInt:([needNoti.needNotiCount intValue]+1)];
//        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    }
//    else
//    {
//        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//            NeedNotiEntity * needNoti = [NeedNotiEntity MR_createInContext:localContext];
//            needNoti.sidePetId = [UserServe sharedUserServe].currentPet.petID;
//            needNoti.needNoti = [NSNumber numberWithInt:1];
//            needNoti.needNotiCount = [NSNumber numberWithInt:1];
//            
//        }];
//    }
    
}

+(void)updateMsgContentWithId:(NSString *)msgId Content:(NSString *)content
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"msgId==[c]%@",msgId];
    NormalMsgEntity * thumbE = [NormalMsgEntity MR_findFirstWithPredicate:predicate];
    if (thumbE) {
        thumbE.content = content;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

+(void)updateMsgStatusWithTag:(long)tagId Status:(NSString *)status
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"tagId==[c]%@",[NSNumber numberWithLong:tagId]];
    NormalMsgEntity * thumbE = [NormalMsgEntity MR_findFirstWithPredicate:predicate];
    if (thumbE) {
        thumbE.sendStatus = status;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

+(int)getAllUnreadNormalChatCount
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mineId==[c]%@",[UserServe sharedUserServe].currentPet.petID];
    NSArray * dsArray = [ThumbNormalMsgEntity MR_findAllWithPredicate:predicate];
    int g = 0;
    for (int i = 0; i<dsArray.count; i++) {
        ThumbNormalMsgEntity * thumbM = dsArray[i];
        g = g + [thumbM.unreadCount intValue];
    }
    return g;

}

+(BOOL)needNotiNormalChatInOtherPage
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sidePetId==[c]%@",[UserServe sharedUserServe].currentPet.petID];
    NeedNotiEntity * needNoti = [NeedNotiEntity MR_findFirstWithPredicate:predicate];
    if (needNoti) {
        if ([needNoti.needNoti intValue]==1) {
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
}

+(void)setNeedNotiNormalChatWithStatus:(int)status
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sidePetId==[c]%@",[UserServe sharedUserServe].currentPet.petID];
    NeedNotiEntity * needNoti = [NeedNotiEntity MR_findFirstWithPredicate:predicate];
    if (needNoti) {
        needNoti.sidePetId = [UserServe sharedUserServe].currentPet.petID;
        needNoti.needNoti = [NSNumber numberWithInt:status];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NeedNotiEntity * needNoti = [NeedNotiEntity MR_createInContext:localContext];
            needNoti.sidePetId = [UserServe sharedUserServe].currentPet.petID;
            needNoti.needNoti = [NSNumber numberWithInt:status];
//            needNoti.needNotiCount = [NSNumber numberWithInt:1];
            
        }];
    }
}

+(int)needNotiNormalChatNumInOtherPage
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sidePetId==[c]%@",[UserServe sharedUserServe].currentPet.petID];
    NeedNotiEntity * needNoti = [NeedNotiEntity MR_findFirstWithPredicate:predicate];
    if (needNoti) {
        return [needNoti.needNotiCount intValue];
    }
    else
        return 0;
}


+(NSArray *)getMsgArrayByPage:(int)thePage
{

    //  NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"senTime" ascending:NO];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mineId==[c]%@",[UserServe sharedUserServe].currentPet.petID];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"sendDate" ascending:NO];
    NSFetchRequest * fetchRequest = [ThumbNormalMsgEntity MR_requestAllWithPredicate:predicate];
    [fetchRequest setFetchOffset:thePage*20];
    [fetchRequest setFetchLimit:20];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray * dsArray = [ThumbNormalMsgEntity MR_executeFetchRequest:fetchRequest];
    NSMutableArray * dg = [NSMutableArray array];
    for (int i = 0; i<dsArray.count; i++) {
        ThumbNormalMsgEntity * thumbM = dsArray[i];
        ChatListMsg * chatListMsg = [[ChatListMsg alloc] init];
        chatListMsg.type = thumbM.type;
        chatListMsg.content = thumbM.content;
        chatListMsg.sendTime = [NSString stringWithFormat:@"%f",[thumbM.sendDate timeIntervalSince1970]];
        chatListMsg.sidePetId = thumbM.sidePetId;
        chatListMsg.unreadCount = [thumbM.unreadCount intValue];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"petId==[c]%@",thumbM.sidePetId];
        MsgPetEntity * petE = [MsgPetEntity MR_findFirstWithPredicate:predicate];
        if (petE) {
            
            chatListMsg.sidePetNickname = petE.nickname;
            chatListMsg.sidePetAvatarUrl = petE.avatarUrl;
        }else
        {
            chatListMsg.sidePetNickname = @"user";
            chatListMsg.sidePetAvatarUrl = @"user";
        }
        [dg addObject:chatListMsg];
        
    }
    return dg;
}

+(NSArray *)getDetailMsgArrayByPage:(int)thePage PetId:(NSString *)petId
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sidePetId==[c]%@ AND mineId==[c]%@",petId,[UserServe sharedUserServe].currentPet.petID];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"sendDate" ascending:NO];
    NSFetchRequest * fetchRequest = [NormalMsgEntity MR_requestAllWithPredicate:predicate];
    [fetchRequest setFetchOffset:20*thePage];
    [fetchRequest setFetchLimit:20];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray * dsArray = [NormalMsgEntity MR_executeFetchRequest:fetchRequest];
    NSMutableArray * msgArray = [NSMutableArray array];
    
    for (int i = (int)dsArray.count-1; i>=0; i--) {
        NormalMsgEntity * sMsg = dsArray[i];
        ChatMsg * chatMsg = [[ChatMsg alloc] init];
        chatMsg.msgid = sMsg.msgId;
        chatMsg.isMe = [sMsg.isMe boolValue];
        chatMsg.fromid = sMsg.sidePetId;
        chatMsg.type = sMsg.type;
        chatMsg.status = sMsg.sendStatus;
        if ([chatMsg.status isEqualToString:@"sending"]) {
            if ([[NSDate date] timeIntervalSince1970]-[sMsg.startSendTime doubleValue]>60) {
                chatMsg.status = @"failed";
            }
        }
        chatMsg.tagId = [sMsg.tagId longValue];
        chatMsg.content = sMsg.content;
        chatMsg.contentLength = sMsg.contentLength;
        chatMsg.date = [sMsg.sendDate timeIntervalSince1970];
        [msgArray addObject:chatMsg];
    }
    return msgArray;
    
}

+(void)setUnreadCount:(int)unread petId:(NSString *)petId
{
    NSPredicate * predicate = predicate = [NSPredicate predicateWithFormat:@"sidePetId==[c]%@ AND mineId==[c]%@",petId,[UserServe sharedUserServe].currentPet.petID];
    ThumbNormalMsgEntity * thumbE = [ThumbNormalMsgEntity MR_findFirstWithPredicate:predicate];
    if (thumbE) {
        thumbE.unreadCount = [NSNumber numberWithInt:unread];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }

}

+(void)deleteAllMsgForPetId:(NSString *)petId
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sidePetId==[c]%@ AND mineId==[c]%@",petId,[UserServe sharedUserServe].currentPet.petID];
    [ThumbNormalMsgEntity MR_deleteAllMatchingPredicate:predicate];
    [NormalMsgEntity MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

+(void)deleteMsgById:(NSString *)msgId SidePetId:(NSString *)sidePetId
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"msgId==[c]%@",msgId];
    [NormalMsgEntity MR_deleteAllMatchingPredicate:predicate];
    
    NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"sidePetId==[c]%@ AND mineId==[c]%@",sidePetId,[UserServe sharedUserServe].currentPet.petID];
    NormalMsgEntity * nE = [NormalMsgEntity MR_findFirstWithPredicate:predicate2 sortedBy:@"sendDate" ascending:NO];
    if (nE) {
       NSPredicate * predicate3 = [NSPredicate predicateWithFormat:@"sidePetId==[c]%@ AND mineId==[c]%@",sidePetId,[UserServe sharedUserServe].currentPet.petID];
        ThumbNormalMsgEntity * er = [ThumbNormalMsgEntity MR_findFirstWithPredicate:predicate3];
        if (er) {
            er.content = nE.content;
        }
        
    }
    else
    {
        NSPredicate * predicate3 = [NSPredicate predicateWithFormat:@"sidePetId==[c]%@ AND mineId==[c]%@",sidePetId,[UserServe sharedUserServe].currentPet.petID];
        [ThumbNormalMsgEntity MR_deleteAllMatchingPredicate:predicate3];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

+(void)AddPetToChatBlackList:(NSString *)petId
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"taId==[c]%@ AND mineId==[c]%@",petId,[UserServe sharedUserServe].currentPet.petID];
    ChatBlackList * chtL = [ChatBlackList MR_findFirstWithPredicate:predicate];
    if (!chtL) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            ChatBlackList * chL = [ChatBlackList MR_createInContext:localContext];
            chL.taId = petId;
            chL.mineId = [UserServe sharedUserServe].currentPet.petID;
            
        }];
    }

}

+(void)removePetFromChatBlackList:(NSString *)petId
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"taId==[c]%@ AND mineId==[c]%@",petId,[UserServe sharedUserServe].currentPet.petID];
//    ChatBlackList * chtL = [ChatBlackList MR_findFirstWithPredicate:predicate];
    [ChatBlackList MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

+(BOOL)ifThisPetInMyBlackList:(NSString *)petId
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"taId==[c]%@ AND mineId==[c]%@",petId,[UserServe sharedUserServe].currentPet.petID];
    ChatBlackList * chtL = [ChatBlackList MR_findFirstWithPredicate:predicate];
    if (chtL) {
        return YES;
    }
    else
        return NO;
}

@end
@implementation DatabaseServe(Accessory)

+(void)saveAccessory:(Accessory*)acc
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"accId==[c]%@",acc.accID];
    AccessoryEntity * accE = [AccessoryEntity MR_findFirstWithPredicate:predicate];
    if (accE) {
        accE.thumURL = [NSString stringWithFormat:@"%@",acc.thumbnail];
        accE.type = acc.type;
        accE.fileName = acc.fileName;
        accE.fileType = acc.fileType;
        accE.downLoadURL = acc.url;
        accE.useTimes = [NSNumber numberWithInt:[accE.useTimes intValue]+1];
        accE.lastUseDate = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            AccessoryEntity * accE = [AccessoryEntity MR_createInContext:localContext];
            accE.accId = acc.accID;
            accE.thumURL = [NSString stringWithFormat:@"%@",acc.thumbnail];
            accE.type = acc.type;
            accE.fileName = acc.fileName;
            accE.fileType = acc.fileType;
            accE.downLoadURL = acc.url;
            accE.useTimes = [NSNumber numberWithInt:1];
            accE.lastUseDate = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        }];
    }
}
+(NSArray *)getNewAccessorysWithType:(NSString*)type size:(NSInteger)size
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"type==[c]%@",type];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"lastUseDate" ascending:NO];
    NSFetchRequest * fetchRequest = [AccessoryEntity MR_requestAllWithPredicate:predicate];
    [fetchRequest setFetchOffset:0];
    [fetchRequest setFetchLimit:size];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray * array = [AccessoryEntity MR_executeFetchRequest:fetchRequest];
    NSMutableArray * accArr = [NSMutableArray array];
    for (AccessoryEntity * accE in array) {
        Accessory * acc = [Accessory new];
        acc.fileName = accE.fileName;
        acc.fileType = accE.fileType;
        acc.type = accE.type;
        acc.accID = accE.accId;
        acc.thumbnail = [NSURL URLWithString:accE.thumURL];
        acc.url = accE.downLoadURL;
        acc.loading = NO;
        if ([acc.fileType isEqualToString:@"zip"]) {
            acc.exsit = [TFileManager ifExsitFolder:acc.fileName];
        }
        if ([acc.fileType isEqualToString:@"png"]) {
            acc.exsit = [TFileManager ifExsitFile:[NSString stringWithFormat:@"%@.%@",acc.fileName,acc.fileType]];
        }
        [accArr addObject:acc];
    }
    return accArr;
}
+(NSArray *)getHotAccessorysWithType:(NSString*)type size:(NSInteger)size
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"type==[c]%@",type];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"useTimes" ascending:NO];
    NSFetchRequest * fetchRequest = [AccessoryEntity MR_requestAllWithPredicate:predicate];
    [fetchRequest setFetchOffset:0];
    [fetchRequest setFetchLimit:size];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray * array = [AccessoryEntity MR_executeFetchRequest:fetchRequest];
    NSMutableArray * accArr = [NSMutableArray array];
    for (AccessoryEntity * accE in array) {
        Accessory * acc = [Accessory new];
        acc.fileName = accE.fileName;
        acc.fileType = accE.fileType;
        acc.type = accE.type;
        acc.accID = accE.accId;
        acc.thumbnail = [NSURL URLWithString:accE.thumURL];
        acc.url = accE.downLoadURL;
        acc.loading = NO;
        if ([acc.fileType isEqualToString:@"zip"]) {
            acc.exsit = [TFileManager ifExsitFolder:acc.fileName];
        }
        if ([acc.fileType isEqualToString:@"png"]) {
            acc.exsit = [TFileManager ifExsitFile:[NSString stringWithFormat:@"%@.%@",acc.fileName,acc.fileType]];
        }
        [accArr addObject:acc];
    }
    return accArr;
}
@end
@implementation DatabaseServe(Tag)
+(void)saveTag:(Tag*)tag
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"tagID==[c]%@",tag.tagID];
    TagEntity * tagE = [TagEntity MR_findFirstWithPredicate:predicate];
    if (tagE) {
        tagE.tagID = tag.tagID;
        tagE.tagName = tag.tagName;
        tagE.useTimes = [NSNumber numberWithInt:[tagE.useTimes intValue]+1];
        tagE.lastUseTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            TagEntity * tagE = [TagEntity MR_createInContext:localContext];
            tagE.tagID = tag.tagID;
            tagE.tagName = tag.tagName;
            tagE.useTimes = [NSNumber numberWithInt:1];
            tagE.lastUseTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        }];
    }
}
+(NSArray *)getNewTagArrayWithSize:(NSInteger)size
{
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"lastUseTime" ascending:NO];
    NSFetchRequest * fetchRequest = [TagEntity MR_requestAll];
    [fetchRequest setFetchOffset:0];
    [fetchRequest setFetchLimit:size];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray * array = [TagEntity MR_executeFetchRequest:fetchRequest];
    NSMutableArray * tagArr = [NSMutableArray array];
    for (TagEntity * tagE in array) {
        Tag * tag = [Tag new];
        tag.tagID = tagE.tagID;
        tag.tagName = tagE.tagName;
        [tagArr addObject:tag];
    }
    return tagArr;
}
+(NSArray *)getHotTagArrayWithSize:(NSInteger)size
{
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"useTimes" ascending:NO];
    NSFetchRequest * fetchRequest = [TagEntity MR_requestAll];
    [fetchRequest setFetchOffset:0];
    [fetchRequest setFetchLimit:size];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray * array = [TagEntity MR_executeFetchRequest:fetchRequest];
    NSMutableArray * tagArr = [NSMutableArray array];
    for (TagEntity * tagE in array) {
        Tag * tag = [Tag new];
        tag.tagID = tagE.tagID;
        tag.tagName = tagE.tagName;
        [tagArr addObject:tag];
    }
    return tagArr;
}
@end
@implementation DatabaseServe (PetalkDraft)

+(void)savePetalkDraft:(DraftModel *)petalkDraft
{
    NSPredicate * predicate = predicate = [NSPredicate predicateWithFormat:@"publishID==[c]%@",petalkDraft.publishID];
    PetalkDraft * entity = [PetalkDraft MR_findFirstWithPredicate:predicate];
    if (entity) {
        entity.publishImgPath = petalkDraft.publishImgPath;
        entity.publishImgURL = petalkDraft.publishImgURL;
        entity.thumImgPath = petalkDraft.thumImgPath;
        entity.thumImgURL = petalkDraft.thumImgURL;
        entity.publishAudioPath = petalkDraft.publishAudioPath;
        entity.publishAudioURL= petalkDraft.publishAudioURL;
        entity.lastEnditDate = petalkDraft.lastEnditDate;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }else
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            PetalkDraft * entity = [PetalkDraft MR_createInContext:localContext];
            entity.publishImgPath = petalkDraft.publishImgPath;
            entity.publishImgURL = petalkDraft.publishImgURL;
            entity.thumImgPath = petalkDraft.thumImgPath;
            entity.thumImgURL = petalkDraft.thumImgURL;
            entity.publishAudioPath = petalkDraft.publishAudioPath;
            entity.publishAudioURL= petalkDraft.publishAudioURL;
            entity.publishModel = petalkDraft.publishModel;
            entity.publishID = petalkDraft.publishID;
            entity.currentPetID = petalkDraft.currentPetID;
            entity.decorationId = petalkDraft.decorationId;
            entity.width = petalkDraft.width;
            entity.height = petalkDraft.height;
            entity.centerX = petalkDraft.centerX;
            entity.centerY = petalkDraft.centerY;
            entity.rotationZ = petalkDraft.rotationZ;
            entity.tagID = petalkDraft.tagID;
            entity.audioDuration = petalkDraft.audioDuration;
            entity.locationAddress = petalkDraft.locationAddress;
            entity.locationLon = petalkDraft.locationLon;
            entity.locationLat = petalkDraft.locationLat;
            entity.textDescription = petalkDraft.textDescription;
            entity.lastEnditDate = petalkDraft.lastEnditDate;
        }];
    }
}
+(void)deletePetalkDraftWithPublishId:(NSString*)publishId
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"publishID==[c]%@",publishId];
    [PetalkDraft MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
+(NSArray *)allPetalkDraftsWithCurrentPetID:(NSString*)petId
{
    NSPredicate * predicate = predicate = [NSPredicate predicateWithFormat:@"currentPetID==[c]%@",petId];
    NSArray * arr = [PetalkDraft MR_findAllWithPredicate:predicate];
    NSMutableArray * draftArr = [NSMutableArray array];
    for (PetalkDraft * entity  in arr) {
        DraftModel * model = [[DraftModel alloc] init];
        model.publishImgPath = entity.publishImgPath;
        model.publishImgURL = entity.publishImgURL;
        model.thumImgPath = entity.thumImgPath;
        model.thumImgURL = entity.thumImgURL;
        model.publishAudioPath = entity.publishAudioPath;
        model.publishAudioURL= entity.publishAudioURL;
        model.publishModel = entity.publishModel;
        model.publishID = entity.publishID;
        model.currentPetID = entity.currentPetID;
        model.decorationId = entity.decorationId;
        model.width = entity.width;
        model.height = entity.height;
        model.centerX = entity.centerX;
        model.centerY = entity.centerY;
        model.rotationZ = entity.rotationZ;
        model.tagID = entity.tagID;
        model.audioDuration = entity.audioDuration;
        model.locationAddress = entity.locationAddress;
        model.locationLon = entity.locationLon;
        model.locationLat = entity.locationLat;
        model.textDescription = entity.textDescription;
        model.lastEnditDate = entity.lastEnditDate;
        [draftArr insertObject:model atIndex:0];
    }
    return draftArr;
}
+(DraftModel *)petalkDraftWithPublishId:(NSString*)publishId
{
    NSPredicate * predicate = predicate = [NSPredicate predicateWithFormat:@"publishID==[c]%@",publishId];
    PetalkDraft * entity = [PetalkDraft MR_findFirstWithPredicate:predicate];
    DraftModel * model;
    if (entity) {
        model = [[DraftModel alloc] init];
        model.publishImgPath = entity.publishImgPath;
        model.publishImgURL = entity.publishImgURL;
        model.thumImgPath = entity.thumImgPath;
        model.thumImgURL = entity.thumImgURL;
        model.publishAudioPath = entity.publishAudioPath;
        model.publishAudioURL= entity.publishAudioURL;
        model.publishModel = entity.publishModel;
        model.publishID = entity.publishID;
        model.currentPetID = entity.currentPetID;
        model.decorationId = entity.decorationId;
        model.width = entity.width;
        model.height = entity.height;
        model.centerX = entity.centerX;
        model.centerY = entity.centerY;
        model.rotationZ = entity.rotationZ;
        model.tagID = entity.tagID;
        model.audioDuration = entity.audioDuration;
        model.locationAddress = entity.locationAddress;
        model.locationLon = entity.locationLon;
        model.locationLat = entity.locationLat;
        model.textDescription = entity.textDescription;
        model.lastEnditDate = entity.lastEnditDate;
    }
    return model;
}
@end