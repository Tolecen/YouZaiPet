//
//  AddStoryItemView.h
//  TalkingPet
//
//  Created by wangxr on 15/7/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStoryItemView : UIView
- (void)showAtView:(UIView *)view WithAction:(void (^)(NSInteger index))action;
@end
