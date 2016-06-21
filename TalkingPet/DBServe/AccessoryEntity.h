//
//  AccessoryEntity.h
//  TalkingPet
//
//  Created by wangxr on 15/2/4.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AccessoryEntity : NSManagedObject

@property (nonatomic, retain) NSString * accId;
@property (nonatomic, retain) NSString * downLoadURL;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * fileType;
@property (nonatomic, retain) NSNumber * lastUseDate;
@property (nonatomic, retain) NSString * thumURL;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * useTimes;

@end
