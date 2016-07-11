//
//  YZShangChengConst.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengConst.h"

NSString *const kCacheReferenceHeaderSizeHeightKey  = @"kCacheReferenceHeaderSizeHeightKey";

@implementation YZShangChengConst

+ (instancetype)sharedInstance {
    static YZShangChengConst *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[YZShangChengConst alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.dateFormatter.timeZone = [NSTimeZone localTimeZone];
        
        self.priceNumberFormatter = [[NSNumberFormatter alloc] init];
        self.priceNumberFormatter.roundingMode = kCFNumberFormatterRoundDown;
        self.priceNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        self.priceNumberFormatter.positivePrefix = @"¥";
        self.priceNumberFormatter.maximumFractionDigits = 2;
    }
    return self;
}

@end
