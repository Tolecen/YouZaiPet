//
//  YZAgeSlider.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/25.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZShangChengConst.h"

@class YZAgeSlider;
@protocol YZAgeSliderDelegate <NSObject>

- (void)sliderDidSelectAge:(YZDogAgeRange)age;

@end

@interface YZAgeSlider : UIControl

@property (nonatomic, weak) id<YZAgeSliderDelegate> sliderDelegate;

@end
