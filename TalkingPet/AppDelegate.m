//
//  AppDelegate.m
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "AppDelegate.h"
#include <netdb.h>
#import <dlfcn.h>
#import "RootViewController.h"
#import "ShareServe.h"
#import "MobClick.h"
#import "InitializeData.h"
#import "GTScrollNavigationBar.h"
#import "Pingpp.h"
#import "TFileManager.h"
//#ifndef DevelopModeUU
//#define QINIUDomain @"images"
//#else
//#define QINIUDomain @"testimages"
//
//#endif

#import "NetServer+ShangCheng.h"
#import "NetServer+Payment.h"

@interface AppDelegate ()<UIAlertViewDelegate>
@property (nonatomic,retain)NSString * devicePushToken;
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    canUseActive = NO;
    [MobClick startWithAppkey:@"2f37350b8994" reportPolicy:SEND_ON_EXIT channelId:@""];
    [ShareServe buildShareSDK];
    
    
    //#warning This should be removed in next version
    [DatabaseServe clearDatabase];
    
    
    
    
    
    [MagicalRecord setupCoreDataStack];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    RootViewController*rootVC = [RootViewController sharedRootViewController];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    [InitializeData intialzeAccessoryDataSource];
    [self startUp];
    if ([UserServe sharedUserServe].userName) {
        NSString * currentChatUser = [[UserServe sharedUserServe].userName stringByAppendingString:[UserServe sharedUserServe].userID];
        [SystemServer sharedSystemServer].currentChatUserId = currentChatUser;
        //        [[SystemServer sharedSystemServer] chatClientAuth];
        //        [self synchronousPetlist];
        [self getCurrentUserInfo];
        [[UserServe sharedUserServe] activityOfCurrentPet];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadUserAPNSToken) name:@"WXRLoginSucceed" object:nil];//当登录用户发生改变时发送向服务端发送APNSToken
    
    //推送
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        //这里还是原来的代码
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    
    if (launchOptions) {
        //截取apns推送的消息
        NSDictionary* pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        [self processNotification:pushInfo];
    }
    
    [self checkNetwork];
    [NetServer getAddressCodeWithsuccess:^(id result) {
        NSLog(@"areas:%@",result);
        if (result && [result[@"code"] intValue]==200) {
            NSData * address = [NSJSONSerialization dataWithJSONObject:result[@"data"] options:NSJSONWritingPrettyPrinted error:nil];
            [TFileManager writeAddressFile:address];
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
    //    [self performSelector:@selector(saaaaa) withObject:nil afterDelay:2];
    return YES;
}
-(void)uploadUserAPNSToken
{
    if ([UserServe sharedUserServe].userName&&self.devicePushToken) {
        NSMutableDictionary* dict = [NetServer commonDict];
        [dict setObject:@"message" forKey:@"command"];
        [dict setObject:@"MPTS" forKey:@"options"];
        [dict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
        [dict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
        [dict setObject:@"1" forKey:@"type"];
        [dict setObject:self.devicePushToken forKey:@"token"];
        [NetServer requestWithParameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"uploadTokenSuccess:%@",responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}
#pragma mark 推送
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"嘻嘻嘻嘻 My token is: %@", deviceToken);
    //    NSString* tokenStr = [deviceToken description];
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"regisger success:%@", deviceTokenStr);
    //注册成功，将deviceToken保存到应用服务器数据库中
    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenStr = %@",deviceTokenStr);
    //NSLog(@"%d", tokenStr.length);
    self.devicePushToken = deviceTokenStr;
    [self uploadUserAPNSToken];
    
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"呜呜呜呜 Failed to get token, error: %@", error);
    self.devicePushToken = @"";
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (appActive) {
        [NetServer getAllMsgCountSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    else{
        [self processNotification:userInfo];
    }
}

//本地消息回调
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"%@,  %d",notification.alertBody, (int)[UIApplication sharedApplication].applicationIconBadgeNumber);
    //    [[RuYiCaiNetworkManager sharedManager] showMessage:notification.alertBody withTitle:nil buttonTitle:notification.alertAction];
}

- (void)processNotification:(NSDictionary*)dic
{
    [[RootViewController sharedRootViewController] processWithDict:dic];
}
-(void)startUp
{
    NSMutableDictionary* dict = [NetServer commonDict];
    [dict setObject:@"system" forKey:@"command"];
    [dict setObject:@"startUp" forKey:@"options"];
    [dict setObject:QINIUDomain forKey:@"domain"];
    [NetServer requestWithParameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SystemServer * us = [SystemServer sharedSystemServer];
        us.uploadToken = [responseObject objectForKey:@"qiniuToken"];
        us.layout = [[responseObject objectForKey:@"layout"] intValue];
        NSString * reviewStatus = [responseObject objectForKey:@"audit"];
        if (reviewStatus) {
            us.appstoreIsInReview = [[responseObject objectForKey:@"audit"] isEqualToString:@"true"]?YES:NO;
        }
        NSString * openPic = [responseObject objectForKey:@"pic"];
        
        NSString *documentsw = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
        NSString *openImgDirectory = [documentsw stringByAppendingPathComponent:@"OpenImages"];
        BOOL isDirss2 = FALSE;
        BOOL isDirExistss2 = [[NSFileManager defaultManager] fileExistsAtPath:openImgDirectory isDirectory:&isDirss2];
        
        if (!(isDirExistss2 && isDirss2))
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:openImgDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if (openPic&&openPic.length>1) {
            
            NSString * fileName = [[openPic componentsSeparatedByString:@"/"] lastObject];
            
            
            NSString *writableFilePath = [openImgDirectory stringByAppendingPathComponent:fileName];
            BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:writableFilePath];
            if (!success) {
                NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:openImgDirectory];
                NSString *fileName;
                while (fileName= [dirEnum nextObject]) {
                    [[NSFileManager defaultManager] removeItemAtPath: [NSString stringWithFormat:@"%@/%@",openImgDirectory,fileName] error:nil];
                }
                [NetServer downloadCommonImageFileWithUrl:openPic Success:^(id responseObject) {
                    if ([responseObject writeToFile:writableFilePath atomically:YES]) {
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
            
            
        }
        else
        {
            NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:openImgDirectory];
            NSString *fileName;
            while (fileName= [dirEnum nextObject]) {
                [[NSFileManager defaultManager] removeItemAtPath: [NSString stringWithFormat:@"%@/%@",openImgDirectory,fileName] error:nil];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"system" forKey:@"command"];
    [mDict setObject:@"version" forKey:@"options"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = responseObject[@"value"];
        
        NSArray *localVersion = [CurrentVersion componentsSeparatedByString:@"."];
        NSArray *serverVersion = [dic[@"vname"] componentsSeparatedByString:@"."];
        
        int hVFirst = [[NSString stringWithFormat:@"%@",[localVersion objectAtIndex:0]] intValue];
        int hVSecond = [[NSString stringWithFormat:@"%@",[localVersion objectAtIndex:1]] intValue];
        int hVThird = [[NSString stringWithFormat:@"%@",[localVersion objectAtIndex:2]] intValue];
        int lVFirst = [[NSString stringWithFormat:@"%@",[serverVersion objectAtIndex:0]] intValue];
        int lVSecond = [[NSString stringWithFormat:@"%@",[serverVersion objectAtIndex:1]] intValue];
        int lVThird = [[NSString stringWithFormat:@"%@",[serverVersion objectAtIndex:2]] intValue];
        
        if (hVFirst<lVFirst) {
            if ([dic[@"compulsively"] isEqualToString:@"true"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本，您的版本已经不符合最低版本要求，请您前往App Store下载，否则会影响您的正常使用哦" delegate:self cancelButtonTitle:@"好的，现在去" otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
                //                NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id914242691"];
                //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本,请前往App Store下载!" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:@"现在去", nil];
                alert.tag = 2;
                [alert show];
            }
        }
        else if (hVFirst==lVFirst&&hVSecond<lVSecond){
            if ([dic[@"compulsively"] isEqualToString:@"true"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本，您的版本已经不符合最低版本要求，请您前往App Store下载，否则会影响您的正常使用哦" delegate:self cancelButtonTitle:@"好的，现在去" otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
                //                NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id914242691"];
                //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本,请前往App Store下载!" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:@"现在去", nil];
                alert.tag = 2;
                [alert show];
            }
            
        }
        else if(hVFirst==lVFirst&&hVSecond==lVSecond&&hVThird<lVThird){
            if ([dic[@"compulsively"] isEqualToString:@"true"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本，您的版本已经不符合最低版本要求，请您前往App Store下载，否则会影响您的正常使用哦" delegate:self cancelButtonTitle:@"好的，现在去" otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
                //                NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id914242691"];
                //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"检测到有新版本,请前往App Store下载!" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:@"现在去", nil];
                alert.tag = 2;
                [alert show];
            }
        }
        
        //        if (![dic[@"vname"] isEqualToString:CurrentVersion]) {
        //
        //
        //        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)showNewVersionAlert
{
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id914242691"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
    }
    else{
        if (buttonIndex == 1) {
            NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id914242691"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
        }
    }
}

-(void)getCurrentUserInfo
{
    if (![UserServe sharedUserServe].userID) {
        return;
    }
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"account" forKey:@"command"];
    [mDict setObject:@"userInfo" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    //    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = [responseObject objectForKey:@"value"];
        //        [DatabaseServe activatePet:[UserServe sharedUserServe].account WithUsername:[UserServe sharedUserServe].userName];
        
        Account * acc = [[Account alloc]initWithDictionary:dict error:nil];
        [DatabaseServe activateUeserWithAccount:acc];
        [UserServe sharedUserServe].account = [DatabaseServe getActionAccount];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
-(void)synchronousPetlist
{
    /*
     NSMutableDictionary* mDict = [NetServer commonDict];
     [mDict setObject:@"pet" forKey:@"command"];
     [mDict setObject:@"user" forKey:@"options"];
     [mDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
     [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
     [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
     int d = 0;
     UserServe * userServe = [UserServe sharedUserServe];
     NSArray * petlist = responseObject[@"value"];
     NSMutableArray * petArr = [NSMutableArray array];
     for (NSDictionary * petDic in petlist) {
     if ([petDic[@"active"] isEqualToString:@"false"]) {
     Pet * pet = [[Pet alloc] init];
     pet.petID = petDic[@"id"];
     pet.nickname = petDic[@"nickName"];
     pet.headImgURL = petDic[@"headPortrait"];
     pet.gender = petDic[@"gender"];
     pet.breed = petDic[@"type"];
     pet.region = petDic[@"address"];
     pet.birthday = [NSDate dateWithTimeIntervalSince1970:[petDic[@"birthday"] doubleValue]/1000];
     pet.fansNo = (petDic[@"counter"])[@"fans"];
     pet.attentionNo = (petDic[@"counter"])[@"focus"];
     pet.issue = (petDic[@"counter"])[@"issue"];
     pet.relay = (petDic[@"counter"])[@"relay"];
     pet.comment = (petDic[@"counter"])[@"comment"];
     pet.favour = (petDic[@"counter"])[@"favour"];
     pet.grade = [petDic[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];
     pet.score = petDic[@"score"];
     pet.coin = petDic[@"coin"];
     pet.ifDaren = [petDic[@"star"] isEqualToString:@"1"]?YES:NO;
     [petArr addObject:pet];
     [DatabaseServe savePet:pet WithUsername:userServe.userName];
     }else{
     d = 1;
     userServe.currentPet = ({
     Pet * pet = [[Pet alloc] init];
     pet.petID = petDic[@"id"];
     pet.nickname = petDic[@"nickName"];
     pet.headImgURL = petDic[@"headPortrait"];
     pet.gender = petDic[@"gender"];
     pet.breed = petDic[@"type"];
     pet.region = petDic[@"address"];
     pet.birthday = [NSDate dateWithTimeIntervalSince1970:[petDic[@"birthday"] doubleValue]/1000];
     pet.fansNo = (petDic[@"counter"])[@"fans"];
     pet.attentionNo = (petDic[@"counter"])[@"focus"];
     pet.issue = (petDic[@"counter"])[@"issue"];
     pet.relay = (petDic[@"counter"])[@"relay"];
     pet.comment = (petDic[@"counter"])[@"comment"];
     pet.favour = (petDic[@"counter"])[@"favour"];
     pet.grade = [petDic[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];
     pet.score = petDic[@"score"];
     pet.coin = petDic[@"coin"];
     pet;
     });
     }
     }
     if (d==1) {
     userServe.petArr = petArr;
     [DatabaseServe activatePet:userServe.currentPet WithUsername:userServe.userName];
     }
     else
     {
     [self noActivePetThenFail];
     }
     
     } failure:nil];
     */
}
-(void)noActivePetThenFail
{
    NSString * uName = [UserServe sharedUserServe].userName;
    if (uName) {
        if ([uName hasPrefix:@"sina"]) {
            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        }
    }
    [SFHFKeychainUtils deleteItemForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
    [SFHFKeychainUtils deleteItemForUsername:[NSString stringWithFormat:@"%@%@SKey",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
    [DatabaseServe unActivateUeser];
    [UserServe sharedUserServe].userName = nil;
    [UserServe sharedUserServe].userID = nil;
    //    [UserServe sharedUserServe].petArr = nil;
    [UserServe sharedUserServe].account = nil;
    //        [SFHFKeychainUtils deleteItemForUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,[UserServe sharedUserServe].userID] andServiceName:CHONGWUSHUOTOKENSTORESERVICE error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRLoginSucceed" object:self userInfo:nil];
    [[SystemServer sharedSystemServer].chatClient logout];
    [SVProgressHUD showErrorWithStatus:@"获取宠物信息失败，需要重新登录"];
    //    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请重新登录" delegate:self cancelButtonTitle:@"好的，知道了" otherButtonTitles:nil, nil];
    ////    alert.tag = 503;
    //    [alert show];
    
}

-(void)checkNetwork
{
    //    NSURL *url = [NSURL URLWithString:@"http://www.chongwushuo.com"];
    //    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //    [httpClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    //
    //    }];
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if (reach.isReachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reach.currentReachabilityStatus==ReachableViaWiFi) {
                NSLog(@"ReachableViaWiFi1");
                [SystemServer sharedSystemServer].systemNetStatus = SystemNetStatusReachableViaWiFi;
                NSString * playMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"playmodeofaudio"];
                if (!playMode) {
                    [SystemServer sharedSystemServer].autoPlay = YES;
                }
                else{
                    if ([playMode isEqualToString:@"always"]) {
                        [SystemServer sharedSystemServer].autoPlay = YES;
                    }
                    else if ([playMode isEqualToString:@"never"]){
                        [SystemServer sharedSystemServer].autoPlay = NO;
                    }
                    else
                        [SystemServer sharedSystemServer].autoPlay = YES;
                }
                
                NSString * firstIn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
                if (!firstIn) {
                    [SystemServer sharedSystemServer].autoPlay = NO;
                }
            }
            else if (reach.currentReachabilityStatus==ReachableViaWWAN){
                NSLog(@"ReachableViaWWAN1");
                [SystemServer sharedSystemServer].systemNetStatus = SystemNetStatusReachableViaWWAN;
                NSString * playMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"playmodeofaudio"];
                if (!playMode) {
                    [SystemServer sharedSystemServer].autoPlay = NO;
                }
                else{
                    if ([playMode isEqualToString:@"always"]) {
                        [SystemServer sharedSystemServer].autoPlay = YES;
                    }
                    else if ([playMode isEqualToString:@"never"]){
                        [SystemServer sharedSystemServer].autoPlay = NO;
                    }
                    else
                        [SystemServer sharedSystemServer].autoPlay = NO;
                }
                NSString * firstIn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
                if (!firstIn) {
                    [SystemServer sharedSystemServer].autoPlay = NO;
                }
            }
        });
        
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"UNReachable1");
            [SystemServer sharedSystemServer].systemNetStatus = SystemNetStatusNotReachable;
        });
    }
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reachability.currentReachabilityStatus==ReachableViaWiFi) {
                NSLog(@"ReachableViaWiFi2");
                [SystemServer sharedSystemServer].systemNetStatus = SystemNetStatusReachableViaWiFi;
                
                NSString * playMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"playmodeofaudio"];
                if (!playMode) {
                    [SystemServer sharedSystemServer].autoPlay = YES;
                }
                else{
                    if ([playMode isEqualToString:@"always"]) {
                        [SystemServer sharedSystemServer].autoPlay = YES;
                    }
                    else if ([playMode isEqualToString:@"never"]){
                        [SystemServer sharedSystemServer].autoPlay = NO;
                    }
                    else
                        [SystemServer sharedSystemServer].autoPlay = YES;
                }
                NSString * firstIn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
                if (!firstIn) {
                    [SystemServer sharedSystemServer].autoPlay = NO;
                }
                //                [SystemServer sharedSystemServer].autoPlay = YES;
            }
            else if (reachability.currentReachabilityStatus==ReachableViaWWAN){
                NSLog(@"ReachableViaWWAN2");
                [SystemServer sharedSystemServer].systemNetStatus = SystemNetStatusReachableViaWWAN;
                NSString * playMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"playmodeofaudio"];
                if (!playMode) {
                    [SystemServer sharedSystemServer].autoPlay = NO;
                }
                else{
                    if ([playMode isEqualToString:@"always"]) {
                        [SystemServer sharedSystemServer].autoPlay = YES;
                    }
                    else if ([playMode isEqualToString:@"never"]){
                        [SystemServer sharedSystemServer].autoPlay = NO;
                    }
                    else
                        [SystemServer sharedSystemServer].autoPlay = NO;
                }
                NSString * firstIn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
                if (!firstIn) {
                    [SystemServer sharedSystemServer].autoPlay = NO;
                }
            }
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_catchStatus" object:@"haveNet" userInfo:nil];
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"UNReachable2");
            [SystemServer sharedSystemServer].systemNetStatus = SystemNetStatusNotReachable;
        });
    };
    
    [reach startNotifier];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        //        [[RootViewController sharedRootViewController].mainVC.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //    [self processNotification:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"type",@"11",@"id", nil]];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    appActive = NO;
    canUseActive = YES;
    [[SystemServer sharedSystemServer].chatClient closeSocket];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [SystemServer sharedSystemServer].inPay = NO;
    if (canUseActive) {
        //        [[SystemServer sharedSystemServer] chatClientAuth];
    }
    appActive = YES;
    //    [self processNotification:[NSDictionary dictionaryWithObjectsAndKeys:@"7",@"type",@"1",@"id", nil]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self getUploadToken];
    
    [NetServer getAllMsgCountSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    NSString * urlStr = [NSString stringWithFormat:@"%@",url];
    if ([urlStr hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return [ShareSDK handleOpenURL:url wxDelegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([SystemServer sharedSystemServer].inPay) {
        [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
            // result : success, fail, cancel, invalid
            NSString *msg;
            if (error == nil) {
                NSLog(@"PingppError is nil");
                msg = result;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaymentResultReceived" object:@"success" userInfo:nil];
            }
            else if([result isEqualToString:@"cancel"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaymentResultReceived" object:@"cancel" userInfo:nil];
            }
            else {
                NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                msg = [NSString stringWithFormat:@"result=%@ PingppError: code=%lu msg=%@", result, (unsigned long)error.code, [error getMsg]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaymentResultReceived" object:@"fail" userInfo:nil];
            }
            //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            //            [alert show];
        }];
        [SystemServer sharedSystemServer].inPay = NO;
        return  YES;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@",url];
    if ([urlStr hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    if ([urlStr hasPrefix:@"wx"]&&[urlStr rangeOfString:@"code="].location !=NSNotFound) {
        NSArray * sA = [urlStr componentsSeparatedByString:@"code="];
        NSString * bs = sA[1];
        NSArray *bA = [bs componentsSeparatedByString:@"&"];
        NSString * finalS = bA[0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXOauthCodeGeted" object:finalS userInfo:nil];
    }
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}
-(void) onReq:(BaseReq*)req
{
    NSLog(@"on req:%@",req);
}
-(void) onResp:(BaseResp*)resp
{
    NSLog(@"req:%@",resp);
}
-(void)getUploadToken
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"fs" forKey:@"command"];
    [mDict setObject:@"uptoken" forKey:@"options"];
    [mDict setObject:QINIUDomain forKey:@"domain"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SystemServer * us = [SystemServer sharedSystemServer];
        us.uploadToken = [responseObject objectForKey:@"value"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get upload token failed with error:%@",error);
    }];
}
@end
