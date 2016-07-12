//
//  YZShangChengModel.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/7/6.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengModel.h"
#import "JSONValueTransformer.h"

@implementation YZShangChengModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation YZDogTypeAlphabetModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"dogTypeId"}];
}

@end

@implementation YZQuanSheModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"shopId"}];
}

@end

@implementation YZQuanSheDetailModel

@end

#pragma mark -- 狗狗对象

@implementation YZDogParents

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"parentsId"}];
}

@end

@implementation YZDogImage

@end

@interface YZDogModel()

@property (nonatomic, assign, readwrite) YZDogSex sex;

@property (nonatomic, assign, readwrite) NSInteger birtydayDays;

@property (nonatomic, copy, readwrite) NSString *birthdayString;

@property (nonatomic, copy, readwrite) NSString *createString;

@end

@implementation YZDogModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"dogId"}];
}

- (NSString *)birthdayString {
    if (!_birthdayString) {
        NSDate *birthdayDate = [[JSONValueTransformer alloc] NSDateFromNSNumber:self.birthday];
        _birthdayString = [[YZShangChengConst sharedInstance].dateFormatter stringFromDate:birthdayDate];
    }
    return _birthdayString;
}

- (NSString *)createString {
    if (!_createString) {
        NSDate *createDate = [[JSONValueTransformer alloc] NSDateFromNSNumber:self.createTime];
        _createString = [[YZShangChengConst sharedInstance].dateFormatter stringFromDate:createDate];
    }
    return _createString;
}

- (NSInteger)birtydayDays {
    return ceilf(([[NSDate date] timeIntervalSince1970] - [self.birthday floatValue]) / (24 * 60 * 60));
}

@end

@implementation YZDogDetailModel

@end

#pragma mark -- 商品,货物对象

@interface YZBrandModel()

@property (nonatomic, copy, readwrite) NSString *createString;

@end

@implementation YZBrandModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"brandId"}];
}

- (NSString *)createString {
    if (!_createString) {
        NSDate *createDate = [[JSONValueTransformer alloc] NSDateFromNSNumber:self.createTime];
        _createString = [[YZShangChengConst sharedInstance].dateFormatter stringFromDate:createDate];
    }
    return _createString;
}

@end

@interface YZGoodsModel()

@property (nonatomic, copy, readwrite) NSString *createString;

@end

@implementation YZGoodsModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"goodsId"}];
}

- (NSString *)createString {
    if (!_createString) {
        NSDate *createDate = [[JSONValueTransformer alloc] NSDateFromNSNumber:self.createTime];
        _createString = [[YZShangChengConst sharedInstance].dateFormatter stringFromDate:createDate];
    }
    return _createString;
}

@end

@implementation YZGoodsDetailModel

@end
