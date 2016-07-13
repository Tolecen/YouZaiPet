//
//  YZShoppingCarPageVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingCarPageVC.h"
#import "YZShoppingDogVC.h"
#import "YZShoppingGoodsVC.h"

@interface YZShoppingCarPageVC()

@end

@implementation YZShoppingCarPageVC

- (NSArray *)configureViewControllerTitles {
    return @[@"狗狗", @"商品"];
}

- (NSArray *)configureViewControllerClasses {
    return @[[YZShoppingDogVC class],
             [YZShoppingGoodsVC class]];
}

- (void)configureMenuPageProperties {
    self.menuHeight = 40.f;
    self.titleSizeSelected = 15.f;
    self.titleSizeNormal = 15.f;
    self.pageAnimatable = YES;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.titleColorSelected = CommonGreenColor;
    self.postNotification = YES;
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width / 2;
    self.itemsWidths = @[@(itemWidth),
                         @(itemWidth)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

@end
