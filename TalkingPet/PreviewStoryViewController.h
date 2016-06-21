//
//  PreviewStoryViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/7/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "TalkingBrowse.h"
@class StoryPublish;

@interface PreviewStoryViewController : BaseViewController
-(void)loadPreviewStoryViewWithStory:(StoryPublish*)story;
-(void)loadPreviewStoryViewWithDictionary:(TalkingBrowse*)dic;
@end
