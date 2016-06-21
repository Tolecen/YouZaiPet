//
//  CreateTagViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/2/10.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectTagDelegate.h"
@interface CreateTagViewController : BaseViewController
@property (nonatomic,assign)UIViewController<SelectTagDelegate> * delegate;
@end
