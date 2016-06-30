//
//  YZShoppingCarVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingCarVC.h"
#import "YZShoppingCarPageVC.h"

@implementation YZShoppingCarVC

- (NSString *)title {
    return @"我的狗窝";
}

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(inner_Pop:)];
    YZShoppingCarPageVC *pageVC = [[YZShoppingCarPageVC alloc] init];
    [self addChildViewController:pageVC];
    [self.view addSubview:pageVC.view];
    [pageVC didMoveToParentViewController:self];
}

@end
