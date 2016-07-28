//
//  OrderYZGoodInfo.m
//  TalkingPet
//
//  Created by TaoXinle on 16/7/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "OrderYZGoodInfo.h"

@implementation OrderYZGoodInfo
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"link.confirm": @"confirmUrl"}];
}
@end
