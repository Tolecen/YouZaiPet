//
//  YZShoppingCarHelper.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/13.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZShangChengModel.h"

@interface YZShoppingCarHelper : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *dogShangPinCache;
@property (nonatomic, strong, readonly) NSMutableArray *goodsShangPinCache;

+ (instancetype)instanceManager;

- (void)addShoppingCarWithScene:(YZShangChengType)scene
                          model:(YZShangChengModel *)model;

- (void)clearShoppingCar;

@end
