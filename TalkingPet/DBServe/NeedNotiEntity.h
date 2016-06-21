//
//  NeedNotiEntity.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/19.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NeedNotiEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * needNoti;
@property (nonatomic, retain) NSNumber * needNotiCount;
@property (nonatomic, retain) NSString * sidePetId;

@end
