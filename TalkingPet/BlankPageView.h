//
//  BlankPageView.h
//  TalkingPet
//
//  Created by 王潇然 on 15/8/18.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlankPageView : UIView
-(void)showWithView:(UIView*)view image:(UIImage*)image buttonImage:(UIImage*)bImage action:(void(^)())action;
@end
