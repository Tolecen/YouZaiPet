//
//  AddStoryItemView.m
//  TalkingPet
//
//  Created by wangxr on 15/7/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "AddStoryItemView.h"
@interface AddStoryItemView ()
{
    UIButton * addTimeB;
    UIButton * addImgB;
    UIButton * addTextB;
    UIImageView * image;
    UILabel * cancelL;
}
@property (nonatomic,copy)void(^action) (NSInteger index);
@end
@implementation AddStoryItemView
- (void)dealloc
{
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.95];
        
        addTimeB = [UIButton buttonWithType:UIButtonTypeCustom];
        [addTimeB setBackgroundImage:[UIImage imageNamed:@"storyAddTime"] forState:UIControlStateNormal];
        [addTimeB addTarget:self action:@selector(addTimeAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addTimeB];
        addImgB = [UIButton buttonWithType:UIButtonTypeCustom];
        [addImgB setBackgroundImage:[UIImage imageNamed:@"storyAddImage"] forState:UIControlStateNormal];
        [addImgB addTarget:self action:@selector(addImgAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addImgB];
        
        addTextB = [UIButton buttonWithType:UIButtonTypeCustom];
        [addTextB setBackgroundImage:[UIImage imageNamed:@"storyAddText"] forState:UIControlStateNormal];
        [addTextB addTarget:self action:@selector(addTextAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addTextB];
        
        image = [[UIImageView alloc] initWithFrame:CGRectZero];
        image.image = [UIImage imageNamed:@"cancelAddStoryItem"];
        [self addSubview:image];
        
        cancelL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        cancelL.text = @"取消";
        cancelL.font = [UIFont systemFontOfSize:10];
        cancelL.textAlignment = NSTextAlignmentCenter;
        cancelL.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
        [self addSubview:cancelL];
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    addTimeB.frame = CGRectMake(10, frame.size.height-80, 46, 63);
    addImgB.frame = CGRectMake(10, frame.size.height-80, 46, 63);
    addTextB.frame = CGRectMake(10, frame.size.height-80, 46, 63);
    image.frame = CGRectMake(10, frame.size.height-80, 46, 46);
    cancelL.center = CGPointMake(image.center.x, image.center.y+33);
}
- (void)showAtView:(UIView *)view WithAction:(void (^)(NSInteger index))action;
{
    self.action = action;
    self.frame = view.bounds;
    view.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    [view addSubview:self];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [UIView animateWithDuration:0.3
                              delay:0.15
             usingSpringWithDamping:0.45
              initialSpringVelocity:7.5
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             addTimeB.frame = CGRectOffset(addTimeB.frame,13,-139);
                             addImgB.frame = CGRectOffset(addImgB.frame, 104, -107);
                             addTextB.frame = CGRectOffset(addTextB.frame, 139, -13);
                             image.transform = CGAffineTransformMakeRotation(M_PI_4);
                         }
                         completion:^(BOOL finished){
                             view.userInteractionEnabled = YES;
                             self.userInteractionEnabled = YES;
                         }];
    }else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             addTimeB.frame = CGRectOffset(addTimeB.frame,13,-139);
                             addImgB.frame = CGRectOffset(addImgB.frame, 104, -107);
                             addTextB.frame = CGRectOffset(addTextB.frame, 139, -13);
                             image.transform = CGAffineTransformMakeRotation(M_PI_4);
                         } completion:^(BOOL finished) {
                             view.userInteractionEnabled = YES;
                             self.userInteractionEnabled = YES;
                         }];
    }
}
- (void)dismiss
{
    self.superview.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
                            addTimeB.frame = CGRectOffset(addTimeB.frame,-13,139);
                            addImgB.frame = CGRectOffset(addImgB.frame, -104, 107);
                            addTextB.frame = CGRectOffset(addTextB.frame, -139, 13);
                            image.transform = CGAffineTransformMakeRotation(0);
                            image.transform = CGAffineTransformMakeRotation(0);
                        } completion:^(BOOL finished) {
                            self.superview.userInteractionEnabled = YES;
                            [self removeFromSuperview];
                        } ];
}
-(void)addTimeAction
{
    [UIView animateWithDuration:0.2 animations:^{
        addTimeB.frame = CGRectInset(addTimeB.frame, -10, -10);
        addImgB.frame = CGRectInset(addImgB.frame, 10, 10);
        addTextB.frame = CGRectInset(addTextB.frame, 10, 10);
        addTimeB.alpha = 0;
        addImgB.alpha = 0;
        addTextB.alpha = 0;
    } completion:^(BOOL finished) {
        if (_action) {
            _action(0);
        }
    }];
}
-(void)addImgAction
{
    [UIView animateWithDuration:0.2 animations:^{
        addTimeB.frame = CGRectInset(addTimeB.frame, 10, 10);
        addImgB.frame = CGRectInset(addImgB.frame, -10, -10);
        addTextB.frame = CGRectInset(addTextB.frame, 10, 10);
        addTimeB.alpha = 0;
        addImgB.alpha = 0;
        addTextB.alpha = 0;
    } completion:^(BOOL finished) {
        if (_action) {
            _action(1);
        }
    }];
}
-(void)addTextAction
{
    [UIView animateWithDuration:0.2 animations:^{
        addTimeB.frame = CGRectInset(addTimeB.frame, 10, 10);
        addImgB.frame = CGRectInset(addImgB.frame, 10, 10);
        addTextB.frame = CGRectInset(addTextB.frame, -10, -10);
        addTimeB.alpha = 0;
        addImgB.alpha = 0;
        addTextB.alpha = 0;
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
