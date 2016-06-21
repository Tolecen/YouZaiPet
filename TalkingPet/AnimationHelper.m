//
//  AnimationHelper.m
//  TalkingPet
//
//  Created by Tolecen on 15/6/18.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "AnimationHelper.h"

@implementation AnimationHelper
+(void)shakeTheView:(UIView *)view
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shakeAnimation.duration = 0.25f;
    shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
    shakeAnimation.toValue = [NSNumber numberWithFloat:5];
    shakeAnimation.autoreverses = YES;
    [view.layer addAnimation:shakeAnimation forKey:nil];
}
@end
