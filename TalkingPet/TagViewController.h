//
//  TagViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/2/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "MoreTagViewController.h"
#import "Tag.h"
#import "SelectTagDelegate.h"

/**
 *  用上面定义的changeColor声明一个Block,声明的这个Block必须遵守声明的要求。
 */


@interface TagViewController : BaseViewController


@property (nonatomic,assign)UIViewController<SelectTagDelegate> * delegate;

@end
