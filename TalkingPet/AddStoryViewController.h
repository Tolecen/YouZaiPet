//
//  AddStoryViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/7/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "StoryPublish.h"

@interface AddStoryViewController : BaseViewController
@property (nonatomic,retain)StoryPublish * story;
@property (nonatomic,retain)NSMutableArray * imageArr;
@end
