//
//  YZOrderConfimViewController.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/28.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZOrderConfimViewController.h"
#import "YZShoppingCarHelper.h"
#import "YZShoppingCarBottomBar.h"
#import "OrderListSingleCell.h"
#import "YZOrderConfimNoAddressCell.h"
#import "YZOrderConfimAddressCell.h"
#import "YZOrderConfimModeCell.h"
#import "OrderFooterView.h"
#import "ReceiptAddress.h"
#import "AddressManageViewController.h"

@interface YZOrderConfimViewController()<UITableViewDelegate, UITableViewDataSource, YZShoppingCarBottomBarDelegate>

@property (nonatomic, weak) YZShoppingCarBottomBar  *bottomBar;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, copy) NSArray *orders;
@property (nonatomic, assign) NSInteger orderCount;
@property (nonatomic, strong) ReceiptAddress *address;

@property (nonatomic, assign) NSInteger paySelectedIndex;

@end

@implementation YZOrderConfimViewController

- (void)dealloc {
    _address = nil;
}

- (NSString *)title {
    return @"确认订单";
}

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(inner_Pop:)];
    self.paySelectedIndex = 0;
    
    NSInteger count = 0;
    self.orders = [[YZShoppingCarHelper instanceManager] orderMergeSelectDogsAndGoodsWithCount:&count];
    self.orderCount = count;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerClass:[OrderListSingleCell class] forCellReuseIdentifier:NSStringFromClass(OrderListSingleCell.class)];
    [tableView registerClass:[YZOrderConfimNoAddressCell class] forCellReuseIdentifier:NSStringFromClass(YZOrderConfimNoAddressCell.class)];
    [tableView registerClass:[YZOrderConfimAddressCell class] forCellReuseIdentifier:NSStringFromClass(YZOrderConfimAddressCell.class)];
    [tableView registerClass:[YZOrderConfimModeCell class] forCellReuseIdentifier:NSStringFromClass(YZOrderConfimModeCell.class)];

    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];

    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    YZShoppingCarBottomBar *bottomBar = [[YZShoppingCarBottomBar alloc] initWithStyle:YZShoppingCarBottomBarStyle_OrderConfim];
    bottomBar.delegate = self;
    [self.view addSubview:bottomBar];
    self.bottomBar = bottomBar;
    [self.bottomBar resetTotalPrice:[YZShoppingCarHelper instanceManager].totalPrice];

    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(bottomBar.mas_top);
    }];
}

- (void)shoppingCarClearPrice {
    [[YZShoppingCarHelper instanceManager] clearShoppingCar];
}

#pragma mark -- UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZOrderConfimNoAddressCell *noAddressCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(YZOrderConfimNoAddressCell.class)];
    YZOrderConfimAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(YZOrderConfimAddressCell.class)];
    OrderListSingleCell *orderListSingleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(OrderListSingleCell.class)];
    YZOrderConfimModeCell *confimModeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(YZOrderConfimModeCell.class)];
    if (indexPath.section == 0) {
        if (self.address) {
            addressCell.address = self.address;
            return addressCell;
        } else {
            WS(weakSelf);
            [noAddressCell setOrderConfimAddAddressBlock:^{
                AddressManageViewController *viewC = [[AddressManageViewController alloc] init];
                __weak __typeof(viewC) weakViewC = viewC;
                [viewC setUseAddress:^(ReceiptAddress *receiptAddress) {
                    weakSelf.address = receiptAddress;
                    [weakViewC.navigationController popViewControllerAnimated:YES];
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
                [weakSelf.navigationController pushViewController:viewC animated:YES];
            }];
            return noAddressCell;
        }
    } else if (indexPath.section == 1) {
        orderListSingleCell.goodInfo = self.orders[indexPath.row];
        return orderListSingleCell;
    } else if (indexPath.section == 2) {
        confimModeCell.icon = indexPath.row == 0 ? @"order_confim_ali" : @"order_confim_wx";
        confimModeCell.title = indexPath.row == 0 ? @"支付宝" : @"微信";
        if (indexPath.row == self.paySelectedIndex) {
            confimModeCell.btnSelected = YES;
        } else {
            confimModeCell.btnSelected = NO;
        }
        WS(weakSelf);
        [confimModeCell setChangeBtnSelected:^(YZOrderConfimModeCell *cell) {
            NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:cell];
            weakSelf.paySelectedIndex = indexPath.row;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }];
        return confimModeCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 2) {
        return 2;
    }
    return self.orders.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *header = @"header";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header];
        headerView.textLabel.font = [UIFont systemFontOfSize:14];
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        headerView.backgroundView = bgView;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:245/255.0f alpha:1];
        [bgView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(bgView);
            make.bottom.mas_equalTo(bgView).mas_offset(-0.5);
            make.height.mas_equalTo(.5);
        }];
    }
    if (section == 2) {
        headerView.textLabel.text = @"支付方式";
        return headerView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    static NSString *footer = @"footer";
    OrderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footer];
    if (view == nil) {
        view = [[OrderFooterView alloc] initWithReuseIdentifier:footer WithButton:NO];
    }
    if (section == 1) {
        view.desL.text = [NSString stringWithFormat:@"共 %ld 件 合计：￥%lld（含运费 ￥%@）", (unsigned long)self.orderCount, [YZShoppingCarHelper instanceManager].totalPrice, @"0"];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.address) {
            return 100.f;
        }
        return 64.f;
    }
    if (indexPath.section == 1) {
        return 90.f;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 45.f;
    }
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 30.f;
    }
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.address) {
            AddressManageViewController *viewC = [[AddressManageViewController alloc] init];
            __weak __typeof(viewC) weakViewC = viewC;
            WS(weakSelf);
            [viewC setUseAddress:^(ReceiptAddress *receiptAddress) {
                weakSelf.address = receiptAddress;
                [weakViewC.navigationController popViewControllerAnimated:YES];
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            [weakSelf.navigationController pushViewController:viewC animated:YES];
        }
    }
}

@end
