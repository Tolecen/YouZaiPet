//
//  UIActionSheet+block.h
//  TalkingPet
//
//  Created by wangxr on 15/7/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (block)<UIActionSheetDelegate>
@property (nonatomic,copy)void (^action)(NSInteger index);
-(void)showInView:(UIView *)view action:(void(^)(NSInteger index))action;
@end
