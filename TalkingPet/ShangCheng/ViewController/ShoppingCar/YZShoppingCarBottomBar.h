//
//  YZShoppingCarBottomBar.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/13.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZShoppingCarBottomBar;
@protocol YZShoppingCarBottomBarDelegate <NSObject>

- (void)shoppingCarClearPrice;

- (void)shoppingCarSelectAllWithSelectState:(BOOL)select;

@end

@interface YZShoppingCarBottomBar : UIView

@property (nonatomic, weak) id<YZShoppingCarBottomBarDelegate> delegate;

- (void)changeSelectBtnState:(BOOL)state;

- (void)resetTotalPrice:(long long)totalPrice;

@end
