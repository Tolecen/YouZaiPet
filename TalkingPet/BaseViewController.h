//
//  BaseViewController.h
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate>
{
    float navigationBarHeight;
    BOOL naviBgHidden;
    UIImage *newImage;
}
@property (nonatomic,assign)BOOL canScrollBack;
@property (nonatomic,assign)BOOL hideNaviBg;
- (void)buildViewWithSkintype;
-(void)removeNaviBg;
-(void)showNaviBg;
- (void)setBackButtonWithTarget:(SEL)selector;
- (void)setShadowBackButtonWithTarget:(SEL)selector;
- (void)setAnotherBackButtonWithTarget:(SEL)selector;
-(void)setRightButtonWithName:(NSString *)theName BackgroundImg:(NSString *)imgName Target:(SEL)selector;
@end
