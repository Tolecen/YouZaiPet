//
//  TopViewController.h
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopViewController : UIViewController
@property (nonatomic,readonly,weak)UINavigationController * currentC;
-(void)showTabBar;
@end
