//
//  PublishStoryViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/7/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "StoryPublish.h"

@interface PublishStoryViewController : BaseViewController
@property (nonatomic,retain)StoryPublish * story;
@property (nonatomic,retain)NSArray* imgArr;
@end
