//
//  SquareViewController.h
//  TalkingPet
//
//  Created by wangxr on 14/11/17.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"

@interface SquareViewController : BaseViewController
@property (nonatomic,retain)UIScrollView * scrollView;
- (void)beginRefreshing;
@end
