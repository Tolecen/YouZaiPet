//
//  YZShoppingCarBottomBar.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/13.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YZShoppingCarBottomBarStyle) {
    YZShoppingCarBottomBarStyle_ShoppingCar = (0),
    YZShoppingCarBottomBarStyle_OrderConfim = (1)
};

@class YZShoppingCarBottomBar;
@protocol YZShoppingCarBottomBarDelegate <NSObject>

@optional

- (void)shoppingCarClearPrice;

- (void)shoppingCarSelectAllWithSelectState:(BOOL)select;

@end

@interface YZShoppingCarBottomBar : UIView

@property (nonatomic, weak) id<YZShoppingCarBottomBarDelegate> delegate;

- (instancetype)initWithStyle:(YZShoppingCarBottomBarStyle)style;

- (void)changeSelectBtnState:(BOOL)state;

- (void)resetTotalPrice:(long long)totalPrice;

@end
