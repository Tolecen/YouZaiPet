//
//  YZDropMenuSizeView.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/24.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZShangChengConst.h"

@interface YZDropMenuSizeView : UIView

@property (nonatomic, copy) void(^sizeViewSelectSizeBlock)(YZDogSize size);

@end
