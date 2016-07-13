//
//  YZShangChengShareHelper.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/13.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareServe.h"
#import "ShareSheet.h"
#import "YZShangChengModel.h"

@interface YZShangChengShareHelper : NSObject

+ (void)shareWithScene:(YZShangChengType)scene
                target:(NSObject *)target
                 model:(YZShangChengModel *)model
               success:(void(^)(void))success
               failure:(void(^)(void))failure;

@end
