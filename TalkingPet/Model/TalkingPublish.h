//
//  Talking.h
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationImg.h"
#import "Location.h"
#import "Accessory.h"

@interface TalkingPublish : NSObject
@property (nonatomic,strong)NSString* localID;
@property (nonatomic,strong)NSString * textDescription;
@property (nonatomic,strong)UIImage * originalImg;
@property (nonatomic,strong)UIImage * publishImg;
@property (nonatomic,strong)UIImage * thumImg;
@property (nonatomic,strong)NSData * originalAudioData;
@property (nonatomic,strong)NSData * publishAudioData;
@property (nonatomic,assign)NSInteger audioDuration;
@property (nonatomic,assign)NSInteger originalDuration;
@property (nonatomic,assign)AnimationImg  animationImg;
@property (nonatomic,strong)NSDate * lastEditTime;
@property (nonatomic,retain)Location*  location;
@property (nonatomic,retain)NSArray * tagArray;

@property (nonatomic,retain)Accessory * mouthAccessory;
@end
