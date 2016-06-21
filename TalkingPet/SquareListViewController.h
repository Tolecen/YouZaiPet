//
//  SquareListViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/1/29.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "SquareIteam.h"
#import "InteractionListViewController.h"
#import "GetQuanViewController.h"
@class RootViewController;
@interface SquareListViewController : BaseViewController
@property (nonatomic,retain) NSString * squaerCode;
+(void)actionTheSquareIteam:(SquareIteam*)iteam withNavigationController:(UINavigationController *)navigationController;
@end
