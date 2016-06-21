//
//  MoreTagViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/2/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectTagDelegate.h"
@interface MoreTagViewController : BaseViewController
@property (nonatomic,assign)UIViewController<SelectTagDelegate> * delegate;
@property (nonatomic,retain)NSArray * tagArray;
@end
