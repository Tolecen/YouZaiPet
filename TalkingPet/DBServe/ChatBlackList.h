//
//  ChatBlackList.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/22.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChatBlackList : NSManagedObject

@property (nonatomic, retain) NSString * mineId;
@property (nonatomic, retain) NSString * taId;

@end
