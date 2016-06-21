//
//  DiaryPageViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/5/27.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryLayouter.h"
@interface DiaryView : UIView
{
    UIImageView * shadowView;
}
@property (nonatomic,retain)UIImageView * imageView;
-(void)setImage:(UIImage*)image;
-(void)layoutLeftShadowView;
-(void)layoutRightShadowView;
@end
@interface DiaryPageViewController : UIViewController
@property (nonatomic,retain)DiaryLayouter * layouter;
@property (nonatomic,assign) NSInteger index;
@end
