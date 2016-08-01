//
//  YZShoppingCarVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingCarVC.h"
#import "YZShoppingCarPageVC.h"
#import "YZShoppingCarBottomBar.h"
#import "YZShoppingCarHelper.h"
#import "YZOrderConfimViewController.h"
#import "SVProgressHUD.h"
#import "Common.h"
@interface YZShoppingCarVC()<YZShoppingCarBottomBarDelegate>

@property (nonatomic, weak) YZShoppingCarBottomBar  *bottomBar;

@end

@implementation YZShoppingCarVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)title {
    return @"我的狗窝";
}

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(inner_Pop:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inner_ChangeShoppingCarItemSelectState:)
                                                 name:kShoppingCarChangeItemSelectStateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inner_ShoppingCarCalcutePrice:)
                                                 name:kShoppingCarCalcutePriceNotification
                                               object:nil];
    
    UIView *containerView = [[UIView alloc] init];
    [self.view addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view).mas_offset(0);
        make.bottom.mas_equalTo(self.view).mas_offset(-44);
    }];
    
    YZShoppingCarPageVC *pageVC = [[YZShoppingCarPageVC alloc] init];
    pageVC.selectIndex = self.selectedIndex;
    [self addChildViewController:pageVC];
    [containerView addSubview:pageVC.view];
    [pageVC didMoveToParentViewController:self];
    [pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(containerView).insets(UIEdgeInsetsZero);
    }];
    
    YZShoppingCarBottomBar *bottomBar = [[YZShoppingCarBottomBar alloc] initWithStyle:YZShoppingCarBottomBarStyle_ShoppingCar];
    bottomBar.delegate = self;
    [self.view addSubview:bottomBar];
    self.bottomBar = bottomBar;
    
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.bottomBar resetTotalPrice:[YZShoppingCarHelper instanceManager].totalPrice];
    [self.bottomBar changeSelectBtnState:[YZShoppingCarHelper instanceManager].shoppingCarCheckAllSelected];
    
    [Common clearCartCount];
}

- (void)inner_ChangeShoppingCarItemSelectState:(NSNotification *)notification {
    YZShoppingCarModel *shoppingCarModel = notification.object;
    [self.bottomBar resetTotalPrice:[YZShoppingCarHelper instanceManager].totalPrice];
    if (!shoppingCarModel.selected) {
        [self.bottomBar changeSelectBtnState:NO];
    } else {
        [self.bottomBar changeSelectBtnState:[YZShoppingCarHelper instanceManager].shoppingCarCheckAllSelected];
    }
}

- (void)inner_ShoppingCarCalcutePrice:(NSNotification *)notification {
    if ([YZShoppingCarHelper instanceManager].dogShangPinCache.count == 0 &&
        [YZShoppingCarHelper instanceManager].goodsShangPinCache.count == 0) {
        [self.bottomBar changeSelectBtnState:NO];
    }
    [self.bottomBar resetTotalPrice:[YZShoppingCarHelper instanceManager].totalPrice];
}

- (void)shoppingCarSelectAllWithSelectState:(BOOL)select {
    [[YZShoppingCarHelper instanceManager] shoppingCarSelectedAllWithSelectedState:select];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingCarSeletedAllBtnChangeStateNotification object:nil];
    if (select) {
        [self.bottomBar resetTotalPrice:[YZShoppingCarHelper instanceManager].totalPrice];
    } else {
        [self.bottomBar resetTotalPrice:0];
    }
}

- (void)shoppingCarClearPrice {
    if ([YZShoppingCarHelper instanceManager].totalPrice==0) {
        [SVProgressHUD showErrorWithStatus:@"请先选择要买的商品"];
        return;
    }
    YZOrderConfimViewController *viewC = [[YZOrderConfimViewController alloc] init];
    [self.navigationController pushViewController:viewC animated:YES];
}

@end
