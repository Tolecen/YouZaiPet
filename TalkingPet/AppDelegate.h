//
//  AppDelegate.h
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    BOOL appActive;
    BOOL canUseActive;
}
@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) RootViewController * rootVC;

@end
