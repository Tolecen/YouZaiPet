//
//  TishiNewView.h
//  TalkingPet
//
//  Created by Tolecen on 15/7/25.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TishiNewView : UIView
@property (nonatomic, copy) void(^dismissHandle)();
-(void)show;
@end
