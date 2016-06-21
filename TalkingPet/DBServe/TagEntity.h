//
//  TagEntity.h
//  TalkingPet
//
//  Created by wangxr on 15/2/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TagEntity : NSManagedObject

@property (nonatomic, retain) NSString * tagID;
@property (nonatomic, retain) NSString * tagName;
@property (nonatomic, retain) NSNumber * lastUseTime;
@property (nonatomic, retain) NSNumber * useTimes;

@end
