//
//  StoryRecorderView.h
//  TalkingPet
//
//  Created by wangxr on 15/7/14.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryRecorderView : UIView
@property (nonatomic,copy)void(^finish) (NSData * sound,NSString * duration);
-(void)showWithView:(UIView *)view finish:(void(^) (NSData * sound,NSString * duration))finish;
@end
