//
//  PublishServer.m
//  TalkingPet
//
//  Created by wangxr on 15/1/29.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PublishServer.h"
#import "RootViewController.h"
#import "SCNavigationController.h"
#import "InitializeData.h"
#import "SignInHistoryViewController.h"
#import "ShareServe.h"
#import "SVProgressHUD.h"
#import "SystemServer.h"
#import <objc/runtime.h>
#import "ImageAssetsViewController.h"
#import "EndtInteractionViewController.h"
#import "StoryTitleViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation InteractionPublisher
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.publishID =gen_uuid();
        self.URLArray = [NSMutableArray array];
        self.pathArray = [NSMutableArray array];
    }
    return self;
}
@end
@implementation Publisher
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.publishID =gen_uuid();
    }
    return self;
}
@end
@implementation PetalkPublisher

@end

@implementation StoryPublisher
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.publishID =gen_uuid();
        self.publishModel = 2;
        self.storyItem = [NSMutableArray array];
    }
    return self;
}
@end
@implementation PublishServer
static PublishServer* publishServer;
+(PublishServer*)sharedPublishServer{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        publishServer = [[PublishServer alloc] init];
        publishServer.publishArray = [NSMutableArray array];
        publishServer.interactionDic = [NSMutableDictionary dictionary];
    });
    return publishServer;
}
+(void)rePublishWithPublishID:(NSString *)publishID
{
    for (Publisher * pp in publishServer.publishArray) {
        if ([pp.publishID isEqualToString:publishID]) {
            if ([pp isKindOfClass:[PetalkPublisher class]]) {
                [self rePublishPetalkWithPublishID:publishID];
            }
            if ([pp isKindOfClass:[StoryPublisher class]]) {
                [self publishStoryPublisher:(StoryPublisher*)pp];
            }
        }
    }
}
+(void)cancelPublishWithPublishID:(NSString *)publishID
{
    for (Publisher*dic in publishServer.publishArray) {
        if ([dic.publishID isEqualToString:publishID]) {
            [publishServer.publishArray removeObject:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRPublishServerBeginPublish" object:nil];
            break;
        }
    }
}

//签到
+(void)signInWithNavigationController:(UINavigationController *)controller completion:(void (^)(void))completion
{
    if ([UserServe sharedUserServe].currentPetSignatured) {
        SignInHistoryViewController * signInHistoryVC = [[SignInHistoryViewController alloc] init];
        signInHistoryVC.title = @"今日已签到";
        [controller pushViewController:signInHistoryVC animated:YES];
    }else
    {
        [SVProgressHUD showWithStatus:@"签到中,请稍后"];
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"activity" forKey:@"command"];
        [mDict setObject:@"signIn" forKey:@"options"];
        [mDict setObject:@"signInNormal" forKey:@"code"];
        [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            [[RootViewController sharedRootViewController] showPetaikAlertWithTitle:[NSString stringWithFormat:@"%@签到成功!",[UserServe sharedUserServe].currentPet.nickname] message:[NSString stringWithFormat:@"恭喜获得%@积分",responseObject[@"value"]]];
            
            [UserServe sharedUserServe].currentPetSignatured = YES;
            //本地用户积分累加
            [UserServe sharedUserServe].currentPet.score = [NSString stringWithFormat:@"%d",[[UserServe sharedUserServe].currentPet.score intValue]+[responseObject[@"value"] intValue]];
            [DatabaseServe activatePet:[UserServe sharedUserServe].currentPet WithUsername:[UserServe sharedUserServe].userName];
            
            SignInHistoryViewController * signInHistoryVC = [[SignInHistoryViewController alloc] init];
            signInHistoryVC.title = @"签到成功";
            [controller pushViewController:signInHistoryVC animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRUsersignInOrNo" object:self userInfo:nil];
            if (completion) {
                completion();
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}
+(void)loadHotTag
{
    dispatch_queue_t queue = dispatch_queue_create("com.pet.getHotTag", NULL);
    dispatch_async(queue, ^{
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
        [mDict setObject:@"tag" forKey:@"command"];
        [mDict setObject:@"all" forKey:@"options"];
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray * arr = [responseObject objectForKey:@"value"];
            NSMutableArray * sectionArr = [NSMutableArray array];
            for (NSDictionary * dic in arr) {
                if ([[dic objectForKey:@"id"] intValue] == 1) {
                    [[NSUserDefaults standardUserDefaults] setObject:dic[@"tags"] forKey:@"WXRPublishHotTagArray"];
                }else{
                    [sectionArr addObject:dic];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:sectionArr forKey:@"WXRPublishTagSectionArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    });
}
@end
@implementation PublishServer (Story)
+(void)publishStoryWithTag:(Tag *)tag completion:(void (^)(void))completion
{
    [self loadHotTag];
    UIViewController * viewController = [RootViewController sharedRootViewController];
    StoryTitleViewController * vc = [[StoryTitleViewController alloc] init];
    vc.tag = tag;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [viewController presentViewController:nav animated:YES completion:completion];
}
+(void)publishStory:(StoryPublish*)story
{
    [SVProgressHUD showWithStatus:@"处理中,请稍后"];
    dispatch_queue_t queue = dispatch_queue_create("com.pet.organizedStoryData", NULL);
    __block StoryPublisher * publisher = [[StoryPublisher alloc] init];
    dispatch_async(queue, ^{
        publisher.title = story.title;
        publisher.tagID = story.tag.tagID;
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"1",@"img":story.cover}];
        [publisher.storyItem addObject:dic];
        publisher.fileNo = 1;
        publisher.thum = story.cover;
        float width = ScreenWidth;
        UIImageView * view = [[UIImageView alloc] init];
        for (int i = 0; i<story.storyItems.count; i++) {
            NSDictionary * storyDic = story.storyItems[i];
            if ([storyDic[@"type"] isEqualToString:@"img"]) {
                UIImage * image = storyDic[@"img"];
                if (image.size.width>width*2) {
                    view.frame = CGRectMake(0, 0, width*2, width*2*image.size.height/image.size.width);
                    view.image = image;
                    UIGraphicsBeginImageContext(view.bounds.size);
                    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
                    image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                }
                NSString * scaleWH = [NSString stringWithFormat:@"%f",image.size.width/image.size.height];
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"2",@"img":image,@"scaleWH":scaleWH}];
                [publisher.storyItem addObject:dic];
                publisher.fileNo += 1;
                if (storyDic[@"text"]) {
                    [dic setObject:storyDic[@"text"] forKey:@"text"];
                }
                if (storyDic[@"sound"]) {
                    [dic setObject:storyDic[@"sound"] forKey:@"sound"];
                    [dic setObject:storyDic[@"duration"] forKey:@"duration"];
                    publisher.fileNo += 1;
                }
            }
            else if ([storyDic[@"type"] isEqualToString:@"set"]) {
                UIImage * image = [UIImage imageWithCGImage:[(ALAsset*)storyDic[@"set"]defaultRepresentation].fullScreenImage];
                if (image.size.width>width*2) {
                    view.frame = CGRectMake(0, 0, width*2, width*2*image.size.height/image.size.width);
                    view.image = image;
                    UIGraphicsBeginImageContext(view.bounds.size);
                    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
                    image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                }
                NSString * scaleWH = [NSString stringWithFormat:@"%f",image.size.width/image.size.height];
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"2",@"img":image,@"scaleWH":scaleWH}];
                [publisher.storyItem addObject:dic];
                publisher.fileNo += 1;
                if (storyDic[@"text"]) {
                    [dic setObject:storyDic[@"text"] forKey:@"text"];
                }
                if (storyDic[@"sound"]) {
                    [dic setObject:storyDic[@"sound"] forKey:@"sound"];
                    [dic setObject:storyDic[@"duration"] forKey:@"duration"];
                    publisher.fileNo += 1;
                }
            }
            else if ([storyDic[@"type"] isEqualToString:@"text"]) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"3",@"text":storyDic[@"text"]}];
                [publisher.storyItem addObject:dic];
            }
            else if ([storyDic[@"type"] isEqualToString:@"t&a"]) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"4",@"address":storyDic[@"address"],@"time":storyDic[@"time"]}];
                [publisher.storyItem addObject:dic];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self publishStoryPublisher:publisher];
            [SVProgressHUD dismiss];
        });
    });
}
+(void)publishStoryPublisher:(StoryPublisher*)publisher
{
    for (int i = 0; i<publishServer.publishArray.count; i++) {
        StoryPublisher * pp = publishServer.publishArray[i];
        if ([pp.publishID isEqualToString:publisher.publishID]) {
            [publishServer.publishArray removeObject:pp];
            break;
        }
    }
    [publishServer.publishArray insertObject:publisher atIndex:0];
    publisher.failure = NO;
    __block NSMutableArray * blockArr = publishServer.publishArray;
    __block StoryPublisher * pp = publisher;
    __block NSError * error;
    __block float sumSize = 0.0;
    __block float currutSize = 0.0;
    __block int sumUpdata = 0;
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyyMMdd";
    NSString *pathTime = [dateF stringFromDate:[NSDate date]];
    dateF.dateFormat = @"yyyy.MM.dd";
    __block NSString * blockTime = [dateF stringFromDate:[NSDate date]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRPublishServerBeginPublish" object:nil];
    void (^publishStoryBlock)(StoryPublisher*,NSError * ) = ^(StoryPublisher*blockPublisher,NSError * theError) {
        if (error) {
            [NetServer getUploadToken];
            blockPublisher.failure = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@PublishFailure",blockPublisher.publishID] object:nil];
        }else{
            blockPublisher.percent = 1.0;
            [[NSNotificationCenter defaultCenter] postNotificationName:blockPublisher.publishID object:nil userInfo:@{@"written":@"1.0"}];
            NSMutableDictionary * talkDic = [NSMutableDictionary dictionary];
            NSMutableArray * arr = [NSMutableArray array];
            if (blockPublisher.tagID) {
                [arr addObject:@{@"id":blockPublisher.tagID}];
            }
            [talkDic setObject:arr forKey:@"tags"];
            [talkDic setObject:blockPublisher.title forKey:@"description"];
            [talkDic setObject:[NSString stringWithFormat:@"2"] forKey:@"model"];
            NSString * coverurl = [blockPublisher.storyItem firstObject][@"url"];
            [talkDic setObject:coverurl forKey:@"photoUrl"];
            [talkDic setObject:coverurl forKey:@"thumbUrl"];
            [talkDic setObject:@[] forKey:@"decorations"];
            NSMutableDictionary * finalDict = [NetServer commonDict];
            [finalDict setObject:@"petalk" forKey:@"command"];
            [finalDict setObject:@"create" forKey:@"options"];
            NSMutableArray * pieces = [NSMutableArray array];
            for (NSDictionary * dic in blockPublisher.storyItem) {
                NSDictionary * piec ;
                if ([dic[@"type"] intValue]==1) {
                    piec = @{@"type":@"1",@"typeVals":@[dic[@"url"],blockPublisher.title,blockTime]};
                }
                if ([dic[@"type"] intValue]==2) {
                    piec = @{@"type":@"2",@"typeVals":@[dic[@"imgurl"],dic[@"scaleWH"],dic[@"text"]?dic[@"text"]:@"",dic[@"soundurl"]?dic[@"soundurl"]:@"",dic[@"duration"]?dic[@"duration"]:@""]};
                }
                if ([dic[@"type"] intValue]==3) {
                    piec = @{@"type":@"3",@"typeVals":@[dic[@"text"]]};
                }
                if ([dic[@"type"] intValue]==4) {
                    piec = @{@"type":@"4",@"typeVals":@[dic[@"address"],dic[@"time"]]};
                }
                [pieces addObject:piec];
            }
            [pieces addObject:@{@"type":@"5",@"typeVals":@[]}];
            [talkDic setObject:pieces forKey:@"storyPieces"];
            [finalDict setObject:talkDic forKey:@"petalkDTO"];
            [NetServer requestWithParameters:finalDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [blockArr removeObject:pp];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRPublishServerPublishSuccess" object:nil];
                SystemServer * sys = [SystemServer sharedSystemServer];
                NSString * petalkID = [[responseObject objectForKey:@"value"] objectForKey:@"petalkId"];
                NSString * nickname = [[responseObject objectForKey:@"value"] objectForKey:@"petNickName"];
                NSString * thumbnail = [[responseObject objectForKey:@"value"] objectForKey:@"thumbUrl"];
                NSString * content = [[responseObject objectForKey:@"value"] objectForKey:@"description"];
                if (sys.autoFriendCircle) {
                    [ShareServe shareToFriendCircleWithTitle:[NSString stringWithFormat:@"听%@的宠物说",nickname] Content:[NSString stringWithFormat:@"听,爱宠有话说。分享自%@的宠物说:\"%@\"",nickname,content] imageUrl:thumbnail webUrl:[NSString stringWithFormat:SHAREBASEURL@"%@",petalkID] Succeed:^{
                        [ShareServe shareNumberUpWithPetalkId:petalkID];
                    }];
                }
                if (sys.autoSinaWeiBo) {
                    [ShareServe shareToSineWithContent:[NSString stringWithFormat:@"听,爱宠有话说。分享自%@的宠物说:\"%@\"%@%@",nickname,content,SHAREBASEURL,petalkID] imageUrl:thumbnail Succeed:^{
                        [ShareServe shareNumberUpWithPetalkId:petalkID];
                    }];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                blockPublisher.failure = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@PublishFailure",blockPublisher.publishID] object:nil];
            }];
            
        }
    };
    for (int i = 0; i< publisher.storyItem.count; i++) {
        NSMutableDictionary * dic = publisher.storyItem[i];
        if ([dic[@"type"] intValue] == 1) {
            if (dic[@"url"]) {
                sumUpdata++;
                continue;
            }
            NSData * imageData = UIImageJPEGRepresentation((UIImage *)dic[@"img"],0.8);
            sumSize+=imageData.length;
            NSString * upLoadPath = [NSString stringWithFormat:@"img/content/%@/%@_Cover.jpg",pathTime,publisher.publishID];
            [NetServer uploadFile:imageData withUpLoadPath:upLoadPath fileType:@"img" ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                currutSize+=bytesWritten;
                publisher.percent =currutSize/sumSize;
                [[NSNotificationCenter defaultCenter] postNotificationName:publisher.publishID object:nil userInfo:@{@"written":[NSString stringWithFormat:@"%f",publisher.percent]}];
            } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [dic setObject:[BaseQiNiuDownloadURL stringByAppendingString:upLoadPath] forKey:@"url"];
                sumUpdata++;
                if (sumUpdata == publisher.fileNo) {
                    publishStoryBlock(publisher,error);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *theError) {
                NSLog(@"dddddddddddddddddddd:%@",theError);
                sumUpdata++;
                error = [NSError errorWithDomain:@"上传失败" code:404 userInfo:nil];
                if (sumUpdata == publisher.fileNo) {
                    publishStoryBlock(publisher,error);
                }
            }];
        }
        if ([dic[@"type"] intValue] == 2) {
            if (dic[@"imgurl"]) {
                sumUpdata++;
            }else
            {
                NSData * imageData = UIImageJPEGRepresentation((UIImage *)dic[@"img"],0.8);
                sumSize+=imageData.length;
                NSString * upLoadPath = [NSString stringWithFormat:@"img/content/%@/%@_%d.jpg",pathTime,publisher.publishID,i];
                [NetServer uploadFile:imageData withUpLoadPath:upLoadPath fileType:@"img" ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                    currutSize+=bytesWritten;
                    publisher.percent =currutSize/sumSize;
                    [[NSNotificationCenter defaultCenter] postNotificationName:publisher.publishID object:nil userInfo:@{@"written":[NSString stringWithFormat:@"%f",publisher.percent]}];
                } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [dic setObject:[BaseQiNiuDownloadURL stringByAppendingString:upLoadPath] forKey:@"imgurl"];
                    sumUpdata++;
                    if (sumUpdata == publisher.fileNo) {
                        publishStoryBlock(publisher,error);
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *theError) {
                    NSLog(@"dddddddddddddddddddd:%@",theError);
                    sumUpdata++;
                    error = [NSError errorWithDomain:@"上传失败" code:404 userInfo:nil];
                    if (sumUpdata == publisher.fileNo) {
                        publishStoryBlock(publisher,error);
                    }
                }];
            }
            if (dic[@"sound"]) {
                if (dic[@"soundurl"]) {
                    sumUpdata++;
                }else
                {
                    NSData * audioData = dic[@"sound"];
                    sumSize+=audioData.length;
                    NSString * upLoadPath = [NSString stringWithFormat:@"audio/comment/%@/%@_%d.wav",pathTime,publisher.publishID,i];
                    [NetServer uploadFile:audioData withUpLoadPath:upLoadPath fileType:@"wav" ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                        currutSize+=bytesWritten;
                        publisher.percent =currutSize/sumSize;
                        [[NSNotificationCenter defaultCenter] postNotificationName:publisher.publishID object:nil userInfo:@{@"written":[NSString stringWithFormat:@"%f",publisher.percent]}];
                    } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [dic setObject:[BaseQiNiuDownloadURL stringByAppendingString:upLoadPath] forKey:@"soundurl"];
                        sumUpdata++;
                        if (sumUpdata == publisher.fileNo) {
                            publishStoryBlock(publisher,error);
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"dddddddddddddddddddd:%@",error);
                        sumUpdata++;
                        error = [NSError errorWithDomain:@"上传失败" code:404 userInfo:nil];
                        if (sumUpdata == publisher.fileNo) {
                            publishStoryBlock(publisher,error);
                        }
                    }];
                }
            }
        }
    }
    if (sumUpdata == publisher.fileNo) {
        publishStoryBlock(publisher,error);
    }
}
@end
@implementation PublishServer (Petalk)
+(void)publishPetalkWithTag:(Tag*)tag completion:(void (^)(void))completion
{
    [SystemServer sharedSystemServer].publishstatu = PublishStatuPetalk;
    [self showCameraWithTag:tag completion:completion];
}
+(void)publishPictureWithTag:(Tag *)tag completion:(void (^)(void))completion
{
    [SystemServer sharedSystemServer].publishstatu = PublishStatuPicture;
    [self showCameraWithTag:tag completion:completion];
}
+ (void)showCameraWithTag:(Tag*)tag completion:(void (^)(void))completion
{
    [self loadAccessoryTree];
    [self loadHotTag];
    UIViewController * viewController = [RootViewController sharedRootViewController];
    SCNavigationController *nav = [[SCNavigationController alloc] init];
    nav.con.tag = tag;
    [nav showCameraWithParentController:viewController completion:completion];
}
+(void)loadAccessoryTree
{
    if ([SystemServer sharedSystemServer].shouldReNewTree) {
        dispatch_queue_t queue = dispatch_queue_create("com.pet.getTree", NULL);
        dispatch_async(queue, ^{
            NSMutableDictionary* mDict = [NetServer commonDict];
            [mDict setObject:@"decoration" forKey:@"command"];
            [mDict setObject:@"tree" forKey:@"options"];
            [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
            [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSMutableDictionary * newDic = [NSMutableDictionary dictionary];
                NSArray * arr = [responseObject objectForKey:@"value"][@"children"];
                for (NSDictionary * dic in arr) {
                    [newDic setObject:dic[@"children"] forKey:dic[@"type"]];
                }
                [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:@"WXRPublishAccessoryTree2"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [SystemServer sharedSystemServer].shouldReNewTree = NO;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (![[NSUserDefaults standardUserDefaults] objectForKey:@"WXRPublishAccessoryTree2"]) {
                    [InitializeData intialzeAccessoryTree];
                }
            }];
        });
    }
}
+(void)publishPetalk:(TalkingPublish*)talkingPublish model:(int)model
{
    PetalkPublisher * publisher = [[PetalkPublisher alloc] init];
    publisher.publishModel = model;
    publisher.thum = talkingPublish.thumImg;
    [PublishServer publishPetalk:talkingPublish publisher:publisher];
}
+(void)publishPetalk:(TalkingPublish*)talkingPublish publisher:(PetalkPublisher *)publisher
{
    for (int i = 0; i<publishServer.publishArray.count; i++) {
         PetalkPublisher * pp = publishServer.publishArray[i];
        if ([pp.publishID isEqualToString:publisher.publishID]) {
            [publishServer.publishArray removeObject:pp];
            break;
        }
    }
    [publishServer.publishArray insertObject:publisher atIndex:0];
    __block PetalkPublisher* blockPP = publisher;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRPublishServerBeginPublish" object:nil];
    
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyyMMdd";
    NSString *pathTime = [dateF stringFromDate:[NSDate date]];
    
    NSString * imgUpLoadPath = [NSString stringWithFormat:@"img/content/%@/%@.jpg",pathTime,publisher.publishID];
    NSString * thumUpLoadPath = [NSString stringWithFormat:@"img/content/%@/thum%@.jpg",pathTime,publisher.publishID];
    NSString * audioUpLoadPath = [NSString stringWithFormat:@"audio/comment/%@/%@.wav",pathTime,publisher.publishID];
    
    NSData * publishImgData = UIImageJPEGRepresentation(talkingPublish.publishImg , 0.8);
    NSData * thumImgData = UIImageJPEGRepresentation(talkingPublish.thumImg , 0.8);
    
    long long imageDataSize = (long long)publishImgData.length;
    long long audioDataSize = (long long)talkingPublish.publishAudioData.length;
    long long thumbImgDataSize = (long long)thumImgData.length;
    __block long long totalDataSize = imageDataSize+audioDataSize+thumbImgDataSize;
    __block double WrittingSize = 0;
    
    __block BOOL publishImg = [publisher.publishImgURL boolValue];
    __block BOOL thumImg = [publisher.thumImgURL boolValue];
    __block BOOL publishAudio = [publisher.publishAudioPath boolValue];
    __block BOOL canPublish = publisher.publishModel?publishImg&&thumImg:publishImg&&thumImg&&publishAudio;
    if (canPublish) {
        [self fileUploadEndPublishPetalk:talkingPublish publisher:publisher];
    }
    //上传原图
    if (!publishImg) {
        [NetServer uploadFile:publishImgData withUpLoadPath:imgUpLoadPath fileType:@"img" ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            WrittingSize+=bytesWritten;
            blockPP.percent =WrittingSize/totalDataSize;
            [[NSNotificationCenter defaultCenter] postNotificationName:publisher.publishID object:nil userInfo:@{@"written":[NSString stringWithFormat:@"%f",WrittingSize/totalDataSize]}];
            
        } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            publisher.publishImgURL = [BaseQiNiuDownloadURL stringByAppendingString:imgUpLoadPath];
            publishImg = YES;
            canPublish = publisher.publishModel?publishImg&&thumImg:publishImg&&thumImg&&publishAudio;
            if (canPublish) {
                [self fileUploadEndPublishPetalk:talkingPublish publisher:publisher];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            publishImg = YES;
            canPublish = publisher.publishModel?publishImg&&thumImg:publishImg&&thumImg&&publishAudio;
            if (canPublish) {
                [self fileUploadEndPublishPetalk:talkingPublish publisher:publisher];
            }
        }];
    }
    //上传缩略图
    if (!thumImg) {
        [NetServer uploadFile:thumImgData withUpLoadPath:thumUpLoadPath fileType:@"img" ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            WrittingSize+=bytesWritten;
            blockPP.percent =WrittingSize/totalDataSize;
            [[NSNotificationCenter defaultCenter] postNotificationName:publisher.publishID object:nil userInfo:@{@"written":[NSString stringWithFormat:@"%f",WrittingSize/totalDataSize]}];
        } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            publisher.thumImgURL = [BaseQiNiuDownloadURL stringByAppendingString:thumUpLoadPath];
            thumImg = YES;
            canPublish = publisher.publishModel?publishImg&&thumImg:publishImg&&thumImg&&publishAudio;
            if (canPublish) {
                [self fileUploadEndPublishPetalk:talkingPublish publisher:publisher];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            thumImg = YES;
            canPublish = publisher.publishModel?publishImg&&thumImg:publishImg&&thumImg&&publishAudio;
            if (canPublish) {
                [self fileUploadEndPublishPetalk:talkingPublish publisher:publisher];
            }
        }];
    }
    //上传录音
    if (!publisher.publishModel&&!publishAudio) {
        [NetServer uploadFile:talkingPublish.publishAudioData withUpLoadPath:audioUpLoadPath fileType:@"wav" ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            WrittingSize+=bytesWritten;
            blockPP.percent =WrittingSize/totalDataSize;
            [[NSNotificationCenter defaultCenter] postNotificationName:publisher.publishID object:nil userInfo:@{@"written":[NSString stringWithFormat:@"%f",WrittingSize/totalDataSize]}];
        } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            publisher.publishAudioURL = [BaseQiNiuDownloadURL stringByAppendingString:audioUpLoadPath];
            publishAudio = YES;
            canPublish = publisher.publishModel?publishImg&&thumImg:publishImg&&thumImg&&publishAudio;
            if (canPublish) {
                [self fileUploadEndPublishPetalk:talkingPublish publisher:publisher];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            publishAudio = YES;
            canPublish = publisher.publishModel?publishImg&&thumImg:publishImg&&thumImg&&publishAudio;
            if (canPublish) {
                [self fileUploadEndPublishPetalk:talkingPublish publisher:publisher];
            }
        }];
    }
}
+(void)fileUploadEndPublishPetalk:(TalkingPublish*)talkingPublish publisher:(PetalkPublisher *)publisher
{
    [NetServer getUploadToken];
    if (publisher.publishModel?publisher.publishImgURL&&publisher.thumImgURL:publisher.publishImgURL&&publisher.thumImgURL&&publisher.publishAudioURL) {
        NSMutableDictionary * decDic = [NSMutableDictionary dictionary];
        [decDic setObject:[NSString stringWithFormat:@"%ld",(long)talkingPublish.animationImg.tagID] forKey:@"decorationId"];
        [decDic setObject:[NSString stringWithFormat:@"%f",talkingPublish.animationImg.width] forKey:@"width"];
        [decDic setObject:[NSString stringWithFormat:@"%f",talkingPublish.animationImg.height] forKey:@"height"];
        [decDic setObject:[NSString stringWithFormat:@"%f",talkingPublish.animationImg.centerX] forKey:@"centerX"];
        [decDic setObject:[NSString stringWithFormat:@"%f",talkingPublish.animationImg.centerY] forKey:@"centerY"];
        [decDic setObject:@"0.0" forKey:@"rotationX"];
        [decDic setObject:@"0.0" forKey:@"rotationY"];
        [decDic setObject:[NSString stringWithFormat:@"%f",talkingPublish.animationImg.rotationZ] forKey:@"rotationZ"];
        
        NSMutableDictionary * talkDic = [NSMutableDictionary dictionary];
        NSMutableArray * arr = [NSMutableArray array];
        for (Tag * tag in talkingPublish.tagArray) {
            NSDictionary * dic = @{@"id":tag.tagID};
            [arr addObject:dic];
        }
        [talkDic setObject:arr forKey:@"tags"];
        [talkDic setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
        [talkDic setObject:[NSString stringWithFormat:@"%ld",(long)talkingPublish.audioDuration] forKey:@"audioSecond"];
        if (talkingPublish.location) {
            [talkDic setObject:talkingPublish.location.address forKey:@"positionName"];
            [talkDic setObject:[NSString stringWithFormat:@"%f",talkingPublish.location.lon] forKey:@"positionLon"];
            [talkDic setObject:[NSString stringWithFormat:@"%f",talkingPublish.location.lat] forKey:@"positionLat"];
        }
        if (talkingPublish.textDescription) {
            [talkDic setObject:talkingPublish.textDescription forKey:@"description"];
        }
        
        [talkDic setObject:[NSString stringWithFormat:@"%d",publisher.publishModel] forKey:@"model"];
        [talkDic setObject:publisher.publishImgURL forKey:@"photoUrl"];
        [talkDic setObject:publisher.thumImgURL forKey:@"thumbUrl"];
        if (!publisher.publishModel) {
            [talkDic setObject:publisher.publishAudioURL forKey:@"audioUrl"];
            [talkDic setObject:@[decDic] forKey:@"decorations"];
        }else{
            [talkDic setObject:@[] forKey:@"decorations"];
        }
        NSMutableDictionary * finalDict = [NetServer commonDict];
        [finalDict setObject:@"petalk" forKey:@"command"];
        [finalDict setObject:@"create" forKey:@"options"];
        [finalDict setObject:talkDic forKey:@"petalkDTO"];
        
        __block NSMutableArray * blockArr = publishServer.publishArray;
        __block TalkingPublish * blockTalk = talkingPublish;
        __block PetalkPublisher * blockPublisher = publisher;
        [NetServer requestWithParameters:finalDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            NSString * issue = [NSString stringWithFormat:@"%d",[[UserServe sharedUserServe].currentPet.issue intValue]+1];
            [UserServe sharedUserServe].currentPet.issue = issue;
            [DatabaseServe activatePet:[UserServe sharedUserServe].currentPet WithUsername:[UserServe sharedUserServe].userName];
            for (Publisher * pp in blockArr) {
                if ([pp.publishID isEqualToString:publisher.publishID]) {
                    [blockArr removeObject:pp];
                    break;
                }
            }
            [PublishServer cleanDraftDataWithPublisher:publisher];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRPublishServerPublishSuccess" object:nil];
            if ([SystemServer sharedSystemServer].savePublishImg) {
                UIImageWriteToSavedPhotosAlbum(talkingPublish.publishImg, nil, nil, nil);
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                if (![defaults objectForKey:@"WXRFristSavePublishImg"]) {
                    [SVProgressHUD showSuccessWithStatus:@"图片已保存到相册\n图片保存可在设置中修改"];
                    [defaults setObject:@"yes" forKey:@"WXRFristSavePublishImg"];
                    [defaults synchronize];
                }
            }
            if ([SystemServer sharedSystemServer].saveOriginalImg&&talkingPublish.originalImg) {
                UIImageWriteToSavedPhotosAlbum(talkingPublish.originalImg, nil, nil, nil);
            }
            SystemServer * sys = [SystemServer sharedSystemServer];
            NSString * petalkID = [[responseObject objectForKey:@"value"] objectForKey:@"petalkId"];
            NSString * nickname = [[responseObject objectForKey:@"value"] objectForKey:@"petNickName"];
            NSString * thumbnail = [[responseObject objectForKey:@"value"] objectForKey:@"thumbUrl"];
            NSString * content = [[responseObject objectForKey:@"value"] objectForKey:@"description"];
            if (sys.autoFriendCircle) {
                [ShareServe shareToFriendCircleWithTitle:[NSString stringWithFormat:@"听%@的宠物说",nickname] Content:[NSString stringWithFormat:@"听,爱宠有话说。分享自%@的宠物说:\"%@\"",nickname,content] imageUrl:thumbnail webUrl:[NSString stringWithFormat:SHAREBASEURL@"%@",petalkID] Succeed:^{
                    [ShareServe shareNumberUpWithPetalkId:petalkID];
                }];
            }
            if (sys.autoSinaWeiBo) {
                [ShareServe shareToSineWithContent:[NSString stringWithFormat:@"听,爱宠有话说。分享自%@的宠物说:\"%@\"%@%@",nickname,content,SHAREBASEURL,petalkID] imageUrl:thumbnail Succeed:^{
                    [ShareServe shareNumberUpWithPetalkId:petalkID];
                }];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发布失败");
            [PublishServer publishPetalkFailure:blockTalk publisher:blockPublisher];
        }];
    }else
    {
        NSLog(@"文件上传失败");
        [PublishServer publishPetalkFailure:talkingPublish publisher:publisher];
    }
}
+(void)publishPetalkFailure:(TalkingPublish*)talkingPublish publisher:(PetalkPublisher *)publisher
{
    NSData * publishImgData = UIImageJPEGRepresentation(talkingPublish.publishImg , 0.8);
    NSData * thumImgData = UIImageJPEGRepresentation(talkingPublish.thumImg , 0.8);
    
    if (!publisher.publishImgPath) {
        publisher.publishImgPath = [NSString stringWithFormat:@"/%@img.jpg",publisher.publishID];
        if ([publishImgData writeToFile:[subdirectoryw stringByAppendingString:publisher.publishImgPath] atomically:YES]) {
            NSLog(@"write failed img success");
        }
        else
        {
            NSLog(@"write failed img failed");
        }
    }
    if (!publisher.thumImgPath) {
        publisher.thumImgPath = [NSString stringWithFormat:@"/%@thumb.jpg",publisher.publishID];
        if ([thumImgData writeToFile:[subdirectoryw stringByAppendingString:publisher.thumImgPath] atomically:YES]) {
            NSLog(@"write failed thumbimg success");
        }
        else
        {
            NSLog(@"write failed thumbimg failed");
        }
    }
    if (!publisher.publishAudioPath) {
        publisher.publishAudioPath = [NSString stringWithFormat:@"/%@audio.caf",publisher.publishID];
        if ([talkingPublish.publishAudioData writeToFile:[subdirectoryw stringByAppendingString:publisher.publishAudioPath] atomically:YES]) {
            NSLog(@"write failed audio success");
        }
        else
        {
            NSLog(@"write failed audio failed");
        }
    }
    for (int i = 0; i<publishServer.publishArray.count; i++) {
        Publisher * pp = publishServer.publishArray[i];
        if ([pp.publishID isEqualToString:publisher.publishID]) {
            pp.failure = YES;
            break;
        }
    }
    DraftModel * petalkDraft = [[DraftModel alloc] init];
    petalkDraft.publishModel = [NSNumber numberWithInt:publisher.publishModel];
    petalkDraft.publishID = publisher.publishID;
    petalkDraft.publishImgURL = publisher.publishImgURL;
    petalkDraft.publishImgPath = publisher.publishImgPath;
    petalkDraft.thumImgURL = publisher.thumImgURL;
    petalkDraft.thumImgPath = publisher.thumImgPath;
    petalkDraft.publishAudioURL = publisher.publishAudioURL;
    petalkDraft.publishAudioPath = publisher.publishAudioPath;
    petalkDraft.currentPetID = [UserServe sharedUserServe].currentPet.petID;
    petalkDraft.tagID = ((Tag*)[talkingPublish.tagArray firstObject]).tagID;
    petalkDraft.audioDuration = [NSString stringWithFormat:@"%ld",(long)talkingPublish.audioDuration];
    if (talkingPublish.animationImg.tagID) {
        petalkDraft.decorationId = [NSString stringWithFormat:@"%ld",(long)talkingPublish.animationImg.tagID];
        petalkDraft.width = [NSString stringWithFormat:@"%f",talkingPublish.animationImg.width];
        petalkDraft.height = [NSString stringWithFormat:@"%f",talkingPublish.animationImg.height];
        petalkDraft.centerX = [NSString stringWithFormat:@"%f",talkingPublish.animationImg.centerX];
        petalkDraft.centerY = [NSString stringWithFormat:@"%f",talkingPublish.animationImg.centerY];
        petalkDraft.rotationZ = [NSString stringWithFormat:@"%f",talkingPublish.animationImg.rotationZ];
    }
    if (talkingPublish.location) {
        petalkDraft.locationAddress = talkingPublish.location.address;
        petalkDraft.locationLon = [NSString stringWithFormat:@"%f",talkingPublish.location.lon];
        petalkDraft.locationLat = [NSString stringWithFormat:@"%f",talkingPublish.location.lat];
    }
    petalkDraft.textDescription = talkingPublish.textDescription;
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy.MM.dd HH:mm";
    petalkDraft.lastEnditDate = [dateF stringFromDate:[NSDate date]];
    [DatabaseServe savePetalkDraft:petalkDraft];
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@PublishFailure",publisher.publishID] object:nil];
}
+(void)rePublishPetalkWithPublishID:(NSString *)publishID
{
    DraftModel * petalkDraft = [DatabaseServe petalkDraftWithPublishId:publishID];
    if (!petalkDraft) {
        [PublishServer cancelPublishWithPublishID:publishID];
        [SVProgressHUD showErrorWithStatus:@"草稿已被删除"];
        return;
    }
    PetalkPublisher * publisher = [[PetalkPublisher alloc] init];
    publisher.publishModel = [petalkDraft.publishModel intValue];
    publisher.publishID = petalkDraft.publishID;
    publisher.publishImgURL = petalkDraft.publishImgURL;
    publisher.publishImgPath = petalkDraft.publishImgPath;
    publisher.thumImgURL = petalkDraft.thumImgURL;
    publisher.thumImgPath = petalkDraft.thumImgPath;
    publisher.publishAudioURL = petalkDraft.publishAudioURL;
    publisher.publishAudioPath = petalkDraft.publishAudioPath;
    TalkingPublish*talkP = [[TalkingPublish alloc]init];
    if (petalkDraft.tagID) {
        Tag * tag = [[Tag alloc] init];
        tag.tagID = petalkDraft.tagID;
        talkP.tagArray = @[tag];
    }
    if (publisher.publishModel==0) {
        talkP.animationImg = animationImgMake([petalkDraft.decorationId integerValue], [petalkDraft.width floatValue], [petalkDraft.height floatValue], [petalkDraft.centerX floatValue], [petalkDraft.centerY floatValue], 0.0, 0.0, [petalkDraft.rotationZ floatValue]);
        talkP.audioDuration = [petalkDraft.audioDuration integerValue];
    }
    if (petalkDraft.locationAddress) {
        talkP.location = [[Location alloc] init];
        talkP.location.address = petalkDraft.locationAddress;
        talkP.location.lon = [petalkDraft.locationLon floatValue];
        talkP.location.lat = [petalkDraft.locationLat floatValue];
    }
    talkP.textDescription = petalkDraft.textDescription;
    talkP.publishImg = [UIImage imageWithData:[NSData dataWithContentsOfFile:[subdirectoryw stringByAppendingString:publisher.publishImgPath]]];
    talkP.thumImg = [UIImage imageWithData:[NSData dataWithContentsOfFile:[subdirectoryw stringByAppendingString:publisher.thumImgPath]]];
    talkP.publishAudioData = [NSData dataWithContentsOfFile:[subdirectoryw stringByAppendingString:publisher.publishAudioPath]];
    publisher.thum = talkP.thumImg;
    [PublishServer publishPetalk:talkP publisher:publisher];
}
+(void)cleanDraftDataWithPublisher:(PetalkPublisher*)publisher
{
    [DatabaseServe deletePetalkDraftWithPublishId:publisher.publishID];
    if (publisher.publishImgPath) {
        [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:publisher.publishImgPath] error:nil];
    }
    if (publisher.thumImgPath) {
        [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:publisher.thumImgPath] error:nil];
    }
    if (publisher.publishAudioPath) {
        [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:publisher.publishAudioPath] error:nil];
    }
    
}
@end
static const void * assetsLibraryKey =&assetsLibraryKey;
@implementation PublishServer (Interaction)
@dynamic assetsLibrary;
-(void)setAssetsLibrary:(ALAssetsLibrary *)assetsLibrary
{
    objc_setAssociatedObject(self, assetsLibraryKey, assetsLibrary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(ALAssetsLibrary *)assetsLibrary
{
    ALAssetsLibrary * assetsLibrary = objc_getAssociatedObject(self, assetsLibraryKey);
    if (!assetsLibrary) {
        assetsLibrary = [[ALAssetsLibrary alloc]init];
        self.assetsLibrary = assetsLibrary;
    }
    return assetsLibrary;
}
+(void)editInteractionWithPicture:(NSString *)interactionID
{
    UIViewController * controller = [RootViewController sharedRootViewController];
    ImageAssetsViewController * imageAssetsVC = [[ImageAssetsViewController alloc] init];
    imageAssetsVC.finish = ^(NSMutableArray*assetArray,NSMutableArray *appends){
        EndtInteractionViewController * edit = [[EndtInteractionViewController alloc] init];
        edit.selectedArray = assetArray;
        edit.topicId = interactionID;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:edit];
        [controller presentViewController:nav animated:NO completion:nil];
    };
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:imageAssetsVC];
    [controller presentViewController:nav animated:YES completion:nil];
}
+(void)editInteractionWithoutPicture:(NSString *)interactionID
{
    UIViewController * controller = [RootViewController sharedRootViewController];
    EndtInteractionViewController * edit = [[EndtInteractionViewController alloc] init];
    edit.topicId = interactionID;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:edit];
    [controller presentViewController:nav animated:YES completion:nil];
}
+(void)publishInteractionWithPublisher:(InteractionPublisher*)publisher
{
    NSMutableArray * publisherArr = [[PublishServer sharedPublishServer].interactionDic objectForKey:publisher.interactionID];
    if (!publisherArr) {
        publisherArr = [NSMutableArray array];
        [[PublishServer sharedPublishServer].interactionDic setObject:publisherArr forKey:publisher.interactionID];
    }
    void (^publishInteractionBlock)(InteractionPublisher*,NSArray*,NSError * ) = ^(InteractionPublisher*blockPublisher,NSArray *sacleArr,NSError * error) {
        if (error) {
            [NetServer getUploadToken];
            [self publishInteractionFailureWithPublisher:publisher];
        }else{
            publisher.percent = 1.0;
            [[NSNotificationCenter defaultCenter] postNotificationName:publisher.publishID object:nil userInfo:@{@"written":@"1.0"}];
            NSMutableArray * arr = [NSMutableArray array];
            for (int  i = 0; i< publisher.URLArray.count; i++) {
                NSDictionary *dic = @{@"pic":publisher.URLArray[i],@"scaleWH":sacleArr[i]};
                [arr addObject:dic];
            }
            NSMutableDictionary* usersDict = [NetServer commonDict];
            [usersDict setObject:@"topic" forKey:@"command"];
            [usersDict setObject:@"createTalk" forKey:@"options"];
            [usersDict setObject:blockPublisher.interactionID forKey:@"topicId"];
            [usersDict setObject:arr forKey:@"pictures"];
            [usersDict setObject:blockPublisher.text forKey:@"content"];
            if ([UserServe sharedUserServe].currentPet.petID) {
                [usersDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
            }
            [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self cleanDraftDataWithInteractionPublisher:publisher];
                [publisherArr removeObject:publisher];
                NSString * notificationName = [NSString stringWithFormat:@"WXRPublishServerPublishInteractionSuccess_%@",publisher.interactionID];
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self publishInteractionFailureWithPublisher:publisher];
            }];
        }
    };
    if (![publisherArr containsObject:publisher]) {
         [publisherArr insertObject:publisher atIndex:0];
    }
    publisher.failure = NO;
    NSString * notificationName = [NSString stringWithFormat:@"WXRPublishServerBeginPublishInteraction_%@",publisher.interactionID];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    NSError * error;
    __block float sumSize = 0.0;
    __block float currutSize = 0.0;
    __block int sumUpdata = 0;
    NSMutableArray * sacleArr = [NSMutableArray array];
    for (int i = 0; i<publisher.pathArray.count; i++) {
        NSString * path =publisher.pathArray[i];
        NSData * imageData = [NSData dataWithContentsOfFile:[subdirectoryw stringByAppendingString:path]];
        UIImage * image = [UIImage imageWithData:imageData];
        [sacleArr addObject:[NSString stringWithFormat:@"%f",image.size.width/image.size.height]];
        if (![publisher.URLArray[i] isKindOfClass:[NSNull class]]) {
            sumUpdata++;
            continue;
        }
        sumSize+=imageData.length;
        NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
        dateF.dateFormat = @"yyyyMMdd";
        NSString *pathTime = [dateF stringFromDate:[NSDate date]];
        NSString * upLoadPath = [NSString stringWithFormat:@"img/content/%@/%@_%d.jpg",pathTime,publisher.publishID,i];
        [NetServer uploadFile:imageData withUpLoadPath:upLoadPath fileType:@"img" ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            currutSize+=bytesWritten;
            publisher.percent =currutSize/sumSize;
            [[NSNotificationCenter defaultCenter] postNotificationName:publisher.publishID object:nil userInfo:@{@"written":[NSString stringWithFormat:@"%f",publisher.percent]}];
        } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [publisher.URLArray replaceObjectAtIndex:i withObject:[BaseQiNiuDownloadURL stringByAppendingString:upLoadPath]];
            sumUpdata++;
            if (sumUpdata == publisher.pathArray.count) {
                publishInteractionBlock(publisher,sacleArr,error);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            sumUpdata++;
            error = [NSError errorWithDomain:@"上传失败" code:404 userInfo:nil];
            if (sumUpdata == publisher.pathArray.count) {
                publishInteractionBlock(publisher,sacleArr,error);
            }
        }];
    }
    if (sumUpdata == publisher.pathArray.count) {
        publishInteractionBlock(publisher,sacleArr,error);
    }
}
+(void)publishInteractionFailureWithPublisher:(InteractionPublisher*)publisher
{
    publisher.failure = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@PublishFailure",publisher.publishID] object:nil];
}
+(void)cancelPublishInteractionWithPublishID:(NSString *)publishID interactionID:(NSString*)interactionID
{
    NSMutableArray * interactionArray = [PublishServer sharedPublishServer].interactionDic[interactionID];
    for (InteractionPublisher * publisher in interactionArray) {
        if ([publisher.publishID isEqualToString:publishID]) {
            [self cleanDraftDataWithInteractionPublisher:publisher];
            [interactionArray removeObject:publisher];
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"WXRPublishServerBeginPublishInteraction_%@",publisher.interactionID] object:nil];
            break;
        }
    }
}
+(void)cleanDraftDataWithInteractionPublisher:(InteractionPublisher*)publisher
{
    for (NSString * path in publisher.pathArray) {
        [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:path] error:nil];
    }
}
@end