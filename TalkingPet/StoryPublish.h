//
//  StoryPublish.h
//  TalkingPet
//
//  Created by wangxr on 15/7/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tag.h"
@interface StoryPublish : NSObject
@property (nonatomic,retain)UIImage * cover;
@property (nonatomic,retain)NSString * title;
@property (nonatomic,retain)Tag * tag;
@property (nonatomic,retain)NSMutableArray * storyItems;
@end
