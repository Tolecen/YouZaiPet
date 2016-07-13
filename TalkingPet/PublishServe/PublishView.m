//
//  PublishView.m
//  TalkingPet
//
//  Created by wangxr on 15/1/29.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PublishView.h"
#import "RootViewController.h"
#import "Common.h"
@interface PublishView ()
{
//    UIImageView * headView;
    UIButton * petalkB;
    UIButton * pictureB;
    UIButton * storyB;
    UIImageView * image;
}
@property (nonatomic,copy)void(^action) (NSInteger index);
@end
@implementation PublishView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        headView = [[UIImageView  alloc] initWithFrame:CGRectMake(55, 100, 210, 137)];
//        headView.image = [UIImage imageNamed:@"PublishHeader"];
//        [self addSubview:headView];
        
        petalkB = [UIButton buttonWithType:UIButtonTypeCustom];
        [petalkB setBackgroundImage:[UIImage imageNamed:@"PublishPetalk"] forState:UIControlStateNormal];
        [petalkB addTarget:self action:@selector(petalkAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:petalkB];
        pictureB = [UIButton buttonWithType:UIButtonTypeCustom];
        [pictureB setBackgroundImage:[UIImage imageNamed:@"PublishPicture"] forState:UIControlStateNormal];
        [pictureB addTarget:self action:@selector(pictureAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pictureB];
        
        storyB = [UIButton buttonWithType:UIButtonTypeCustom];
        [storyB setBackgroundImage:[UIImage imageNamed:@"publishStory"] forState:UIControlStateNormal];
        [storyB addTarget:self action:@selector(storyAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:storyB];
        
        image = [[UIImageView alloc] initWithFrame:CGRectZero];
        image.image = [UIImage imageNamed:@"camera"];
        [self addSubview:image];
        self.frame = [RootViewController sharedRootViewController].view.bounds;
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    headView.center = CGPointMake(CGRectGetMidX([self bounds]), headView.center.y);
    storyB.frame = CGRectMake(CGRectGetMidX([self bounds])-130, frame.size.height, 60, 86);
    petalkB.frame = CGRectMake(CGRectGetMidX([self bounds])-30, frame.size.height, 60, 86);
    pictureB.frame = CGRectMake(CGRectGetMidX([self bounds])+70, frame.size.height, 60, 86);
    image.frame = CGRectMake(self.publishox, frame.size.height-60, 40, 40);
//    image.center = CGPointMake(CGRectGetMidX([self bounds]), frame.size.height-24);
}
- (void)showWithAction:(void (^)(NSInteger index))action
{
    image.frame = CGRectMake(self.publishox-1, self.frame.size.height-50-1, 42, 42);
    self.action = action;
    [RootViewController sharedRootViewController].view.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    [[RootViewController sharedRootViewController].view addSubview:self];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [UIView animateWithDuration:0.3
                              delay:0.05
             usingSpringWithDamping:0.45
              initialSpringVelocity:7.5
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             storyB.frame = CGRectMake(CGRectGetMidX([self bounds])-130, self.frame.size.height-200,60, 86);
                             image.transform = CGAffineTransformMakeRotation(M_PI_4);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        [UIView animateWithDuration:0.3
                              delay:0.1
             usingSpringWithDamping:0.45
              initialSpringVelocity:7.5
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             petalkB.frame = CGRectMake(CGRectGetMidX([self bounds])-30, self.frame.size.height-200, 60, 86);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        [UIView animateWithDuration:0.3
                              delay:0.15
             usingSpringWithDamping:0.45
              initialSpringVelocity:7.5
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             pictureB.frame = CGRectMake(CGRectGetMidX([self bounds])+70, self.frame.size.height-200,60, 86);
                         }
                         completion:^(BOOL finished){
                             [RootViewController sharedRootViewController].view.userInteractionEnabled = YES;
                             self.userInteractionEnabled = YES;
//                             [self addtishi];
                         }];
    }else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             storyB.frame = CGRectMake(CGRectGetMidX([self bounds])-130, self.frame.size.height-200, 60, 86);
                             petalkB.frame = CGRectMake(CGRectGetMidX([self bounds])-30, self.frame.size.height-200, 60, 86);
                             pictureB.frame = CGRectMake(CGRectGetMidX([self bounds])+70, self.frame.size.height-200,60, 86);
                             image.transform = CGAffineTransformMakeRotation(M_PI_4);
                         } completion:^(BOOL finished) {
                             [RootViewController sharedRootViewController].view.userInteractionEnabled = YES;
                             self.userInteractionEnabled = YES;
//                             [self addtishi];
                         }];
    }
}
//-(void)addtishi
//{
//    if ([Common ifHaveGuided:@"gushi1"]) {
//        return;
//    }
//    TishiNewView * tishiN = [[TishiNewView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    [tishiN show];
//    tishiN.dismissHandle = ^{
//        //        [self addtishi2];
//    };
//    
//    CGRect u = [[UIApplication sharedApplication].keyWindow convertRect:storyB.frame fromView:self];
//    
//    UIImageView * h = [[UIImageView alloc] initWithFrame:CGRectMake(u.origin.x-20, u.origin.y+u.size.height-10-178, 247, 178)];
//    [h setImage:[UIImage imageNamed:@"story_p"]];
//    [tishiN addSubview:h];
//    
//    [Common setGuided:@"gushi1"];
//}
- (void)dismiss
{
    [RootViewController sharedRootViewController].view.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
                            pictureB.frame = CGRectMake(CGRectGetMidX([self bounds])+70, self.frame.size.height,60, 86);
                        } completion:^(BOOL finished) {
                            
                        } ];
    [UIView animateWithDuration:0.3
                          delay:0.15
         options:UIViewAnimationOptionLayoutSubviews animations:^{
             petalkB.frame = CGRectMake(CGRectGetMidX([self bounds])-30, self.frame.size.height, 60, 86);
         } completion:^(BOOL finished) {
             
         } ];
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
                            storyB.frame = CGRectMake(CGRectGetMidX([self bounds])-130, self.frame.size.height,60, 86);
                            image.transform = CGAffineTransformMakeRotation(0);
                        } completion:^(BOOL finished) {
                            [RootViewController sharedRootViewController].view.userInteractionEnabled = YES;
                            [self removeFromSuperview];
                        } ];
}
- (void)petalkAction
{
    [UIView animateWithDuration:0.2 animations:^{
        petalkB.frame = CGRectInset(petalkB.frame, -10, -10);
        pictureB.frame = CGRectInset(pictureB.frame, 10, 10);
        storyB.frame = CGRectInset(storyB.frame, 10, 10);
        petalkB.alpha = 0;
        pictureB.alpha = 0;
        storyB.alpha = 0;
    } completion:^(BOOL finished) {
        if (_action) {
            _action(0);
        }
    }];
}
- (void)pictureAction
{
    [UIView animateWithDuration:0.2 animations:^{
        pictureB.frame = CGRectInset(pictureB.frame, -10, -10);
        petalkB.frame = CGRectInset(petalkB.frame, 10, 10);
        storyB.frame = CGRectInset(storyB.frame, 10, 10);
        petalkB.alpha = 0;
        pictureB.alpha = 0;
        storyB.alpha = 0;
    } completion:^(BOOL finished) {
        if (_action) {
            _action(1);
        }
    }];
}
- (void)storyAction
{
    [UIView animateWithDuration:0.2 animations:^{
        storyB.frame = CGRectInset(storyB.frame, -10, -10);
        petalkB.frame = CGRectInset(petalkB.frame, 10, 10);
        pictureB.frame = CGRectInset(pictureB.frame, 10, 10);
        petalkB.alpha = 0;
        pictureB.alpha = 0;
        storyB.alpha = 0;
    } completion:^(BOOL finished) {
        if (_action) {
            _action(2);
        }
    }];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}
@end
