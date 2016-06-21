//
//  RootViewController.h
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "TopViewController.h"
#import "OpenImageViewController.h"
@interface RootViewController : UIViewController
@property (nonatomic,assign)UIViewController * currentViewController;
@property (nonatomic,retain)RESideMenu * sideMenu;
@property (nonatomic,retain)TopViewController * topVC;
+ (RootViewController*)sharedRootViewController;
- (void)showLoginViewController;
- (void)showHotUserViewController;
-(void)showTaglistViewControllerWithTag:(NSString *)theTag;
-(void)processWithDict:(NSDictionary *)infoDict;
-(void)showPetaikAlertWithTitle:(NSString*)title message:(NSString*)message;
@end
