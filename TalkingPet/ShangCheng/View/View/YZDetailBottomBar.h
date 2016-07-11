//
//  YZDetailBottomBar.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZShangChengConst.h"

@protocol YZDetailBottomBarDelegate <NSObject>

@optional
- (void)enterDogHomeAction;

@required
- (void)shareAction;
- (void)clearPriceAction;
- (void)addShoppingCarAction;

@end

@interface YZDetailBottomBar : UIView

@property (nonatomic, weak) id<YZDetailBottomBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(YZShangChengType)type;

@end
