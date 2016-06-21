//
//  Tag.h
//  TalkingPet
//
//  Created by wangxr on 14-8-19.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject
@property (nonatomic,retain)NSString * tagID;
@property (nonatomic,retain)NSString * tagName;
@property (nonatomic,retain)NSString * iconURL;
@property (nonatomic,retain)NSString * backGroundURL;
@property (nonatomic,retain)NSString * tagDetailUrl;
@property (nonatomic,assign)BOOL deleted;
@end
