//
//  SystemSetEntity.h
//  TalkingPet
//
//  Created by wangxr on 15/3/3.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SystemSetEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * autoFriendCircle;
@property (nonatomic, retain) NSNumber * autoSinaWeiBo;
@property (nonatomic, retain) NSNumber * skinType;
@property (nonatomic, retain) NSNumber * savePublishImg;
@property (nonatomic, retain) NSNumber * saveOriginalImg;

@end
