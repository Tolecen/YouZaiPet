//
//  Account.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-11.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "Account.h"

@implementation Account
+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *dic = @{@"id":@"userID",
                          @"counter.fans":@"fansNo",
                          @"counter.focus":@"attentionNo",
                          @"head":@"headImgURL",
                          @"counter.issue":@"issue",
                          @"counter.relay":@"relay",
                          @"counter.comment":@"comment",
                          @"counter.favour":@"favour",
                          @"":@"",
                          };
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
}
@end
