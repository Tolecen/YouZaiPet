//
//  SetViewController.h
//  TalkingPet
//
//  Created by wangxr on 14-7-14.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "UserServe.h"
#import "WelcomeViewController.h"
#import "PlaySettingViewController.h"
#import "ChatSettingViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "DraftsViewController.h"
#import "PicSaveSettingViewController.h"
//#import "TOWebViewController.h"
@interface SetViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    BOOL ifHasLogin;
    BOOL loggingOut;
}
@property (nonatomic,strong) UITableView * settingTableView;
@property (nonatomic,strong) NSArray * allArrayA;
@property (nonatomic,strong) NSArray * allArrayB;
@property (nonatomic,strong) NSArray * allArray;
@property (nonatomic,strong) NSArray * sectionFirstArray;
@property (nonatomic,strong) NSArray * sectionFirstArray_2;
@property (nonatomic,strong) NSArray * sectionFirstArraytwo;
@property (nonatomic,strong) NSArray * sectionSecondArray;
@property (nonatomic,strong) NSArray * sectionSecondArrayA;
@property (nonatomic,strong) NSArray * sectionSecondArrayB;
@property (nonatomic,strong) NSArray * sectionThirdArray;
@property (nonatomic,strong) NSArray * sectionForthArray;
@property (nonatomic,strong) NSArray * sectionForthArrayA;
@property (nonatomic,strong) NSArray * sectionForthArrayB;
@end
