//
//  PublishServer.h
//  TalkingPet
//
//  Created by wangxr on 15/1/29.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublishView.h"
#import "Tag.h"
#import "TalkingPublish.h"
#import "StoryPublish.h"
@class ALAssetsLibrary;

#define subdirectoryw [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"FailedFiles"]

@interface InteractionPublisher : NSObject
@property (nonatomic,retain)NSString * publishID;

@property (nonatomic,retain)NSString * interactionID;
@property (nonatomic,assign)BOOL failure;
@property (nonatomic,assign)float percent;

@property (nonatomic,retain)NSString * text;
@property (nonatomic,retain)NSMutableArray * URLArray;
@property (nonatomic,retain)NSMutableArray * pathArray;

@end

@interface Publisher : NSObject
@property (nonatomic,retain)NSString * publishID;

@property (nonatomic,retain)UIImage * thum;
@property (nonatomic,assign)int publishModel;
@property (nonatomic,assign)BOOL failure;
@property (nonatomic,assign)float percent;
@end
@interface PetalkPublisher : Publisher

@property (nonatomic,retain)NSString * publishImgURL;
@property (nonatomic,retain)NSString * thumImgURL;
@property (nonatomic,retain)NSString * publishAudioURL;

@property (nonatomic,retain)NSString * publishImgPath;
@property (nonatomic,retain)NSString * thumImgPath;
@property (nonatomic,retain)NSString * publishAudioPath;

@end
@interface StoryPublisher :Publisher
@property (nonatomic,assign)int fileNo;
@property (nonatomic,retain)NSString * title;
@property (nonatomic,retain)NSString * tagID;
@property (nonatomic,retain)NSMutableArray * storyItem;
@end
@interface PublishServer : NSObject
@property (nonatomic,retain)NSMutableArray * publishArray;
@property (nonatomic,retain)NSMutableDictionary * interactionDic;
+(PublishServer*)sharedPublishServer;
+(void)rePublishWithPublishID:(NSString *)publishID;
+(void)cancelPublishWithPublishID:(NSString *)publishID;

+(void)signInWithNavigationController:(UINavigationController *)controller completion:(void (^)(void))completion;
@end
@interface PublishServer (Story)
+(void)publishStoryWithTag:(Tag *)tag completion:(void (^)(void))completion;
+(void)publishStory:(StoryPublish*)Story;
+(void)publishStoryPublisher:(StoryPublisher*)publisher;
@end
@interface PublishServer (Petalk)

+(void)publishPetalkWithTag:(Tag*)tag completion:(void (^)(void))completion;
+(void)publishPictureWithTag:(Tag *)tag completion:(void (^)(void))completion;

+(void)publishPetalk:(TalkingPublish*)talkingPublish model:(int)model;
+(void)rePublishPetalkWithPublishID:(NSString *)publishID;
@end
@interface PublishServer (Interaction)
@property (nonatomic,retain,readonly)ALAssetsLibrary *assetsLibrary;
+(void)editInteractionWithPicture:(NSString *)interactionID;
+(void)editInteractionWithoutPicture:(NSString *)interactionID;;
+(void)publishInteractionWithPublisher:(InteractionPublisher*)publisher;
+(void)cancelPublishInteractionWithPublishID:(NSString *)publishID interactionID:(NSString*)interactionID;
@end
