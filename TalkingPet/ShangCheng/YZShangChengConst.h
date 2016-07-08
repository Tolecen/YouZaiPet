//
//  YZShangChengConst.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YZShangChengType) {
    YZShangChengType_Dog    = (0),
    YZShangChengType_Goods  = (1)
};

typedef NS_ENUM(NSUInteger, YZDogSize) {
    YZDogSize_All     = (100),
    YZDogSize_Small   = (1),
    YZDogSize_Middle  = (2),
    YZDogSize_Big     = (3)
};

typedef NS_ENUM(NSUInteger, YZDogSex) {
    YZDogSex_All    = (100),
    YZDogSex_Male   = (0),
    YZDogSex_Female = (1)
};

typedef NS_ENUM(NSUInteger, YZDogValueRange) {
    YZDogValueRange_All     = (100),
    YZDogValueRange_3k      = (0),
    YZDogValueRange_3_5k    = (1),
    YZDogValueRange_5_10k   = (2),
    YZDogValueRange_10k     = (3)
};

typedef NS_ENUM(NSUInteger, YZDogAgeRange) {
    YZDogAgeRange_All   = (100),
    YZDogAgeRange_OM    = (0),
    YZDogAgeRange_0_3M  = (1),
    YZDogAgeRange_3_6M  = (2),
    YZDogAgeRange_6_12M = (3),
    YZDogAgeRange_1Y    = (4)
};

@interface YZShangChengConst : NSObject

@property (nonatomic, strong) NSNumberFormatter *priceNumberFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

+ (instancetype)sharedInstance;

@end
