//
//  UIActionSheet+block.m
//  TalkingPet
//
//  Created by wangxr on 15/7/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "UIActionSheet+block.h"
#import <objc/runtime.h>

static const void *actionKey = &actionKey;
@implementation UIActionSheet (block)
@dynamic action;
- (void (^)(NSInteger index))action
{
    return objc_getAssociatedObject(self, actionKey);
}

- (void)setAction:(void (^)(NSInteger index))action
{
    self.delegate = self;
    objc_setAssociatedObject(self, actionKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.action) {
        self.action(buttonIndex);
    }
}
-(void)showInView:(UIView *)view action:(void(^)(NSInteger index))action;
{
    self.action = action;
    [self showInView:view];
}
@end
