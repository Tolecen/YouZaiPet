//
//  SlightEditBar.h
//  TalkingPet
//
//  Created by wangxr on 14/11/3.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SlightEditBar;
@protocol SlightEditBarDelegate <NSObject>
@optional
-(void)slightEditBarEnlargedAction:(SlightEditBar*)bar;
-(void)slightEditBarReducedAction:(SlightEditBar*)bar;
-(void)slightEditBarRotateLeftAction:(SlightEditBar*)bar;
-(void)slightEditBarRotateRightAction:(SlightEditBar*)bar;
-(void)slightEditBarResetAction:(SlightEditBar*)bar;
@end
@interface SlightEditBar : UIView
@property (nonatomic,assign)id<SlightEditBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SlightEditBarDelegate>)delegate;
@end
