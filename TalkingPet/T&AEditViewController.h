//
//  T&AEditViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/7/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"

@interface T_AEditViewController : BaseViewController
@property (nonatomic,copy)void(^finish) (NSString * time,NSString * address);
-(void)setTimeString:(NSString*)time andAddress:(NSString*)address;
@end
