//
//  UINavigationController+Autorotate.m
//  TalkingPet
//
//  Created by wangxr on 15/5/25.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "UINavigationController+Autorotate.h"

@implementation UINavigationController (Autorotate)
- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}
@end
