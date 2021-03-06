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
#import "NetServer+Payment.h"
#import "SVProgressHUD.h"
#import "Pingpp.h"
#import "PaySuccessViewController.h"
@interface YZOrderConfimViewController()<UITableViewDelegate, UITableViewDataSource, YZShoppingCarBottomBarDelegate>
{
    BOOL haveKuajing;
}

@property (nonatomic, weak) YZShoppingCarBottomBar  *bottomBar;
@property (nonatomic, weak) UITableView *tableView;


@property (nonatomic, strong) ReceiptAddress *address;

@property (nonatomic, assign) NSInteger paySelectedIndex;

@property (nonatomic,strong)NSString * goodsString;
@property (nonatomic,strong)NSString * payChannel;
@property (nonatomic,strong)NSString * orderNo;

@property (nonatomic,strong)UIView * topv;

@end

@implementation YZOrderConfimViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _address = nil;
}

- (NSString *)title {
    
    return @"确认订单";
    
}

- (void)inner_getDefaultAddress {
    [SVProgressHUD showWithStatus:@"获取默认收货地址..."];
    [NetServer fentchDefaultAddressSuccess:^(id result) {
        [SVProgressHUD dismiss];
        if ([result[@"code"] intValue]==200) {
            id dic = result[@"data"];
            if (![dic isKindOfClass:[NSDictionary class]]) {
                return;
            }
            ReceiptAddress *address = [[ReceiptAddress alloc] init];
            address.addressID = dic[@"id"];
            address.receiptName = dic[@"consignee"];
            address.phoneNo = dic[@"telphone"];
            address.province = dic[@"area_zh"];
            address.city = @"";
            address.address = dic[@"address"];
            address.zipCode = @"100000";
            if (dic[@"address"]) {
                address.cardId = dic[@"address"];
            }
            
            address.action = [dic[@"default"] isEqualToString:@"1"];
            self.address = address;
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [SVProgressHUD dismiss];
    }];
}

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(inner_Pop:)];
    self.paySelectedIndex = 0;
    
    
    self.topv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    self.topv.backgroundColor = [UIColor colorWithR:252 g:241 b:219 alpha:1];
    
    UILabel * hhh = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 40)];
    hhh.backgroundColor = [UIColor clearColor];
    hhh.textColor = [UIColor colorWithR:226 g:163 b:135 alpha:1];
    hhh.font = [UIFont systemFontOfSize:14];
    hhh.numberOfLines = 2;
    hhh.lineBreakMode = NSLineBreakByCharWrapping;
    hhh.text = @"根据国家相关法律规定，您购买的商品需要填写身份证信息。";
    [self.topv addSubview:hhh];
    
    
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
    
    if (!self.orders) {
        NSInteger count = 0;
        self.orders = [[YZShoppingCarHelper instanceManager] orderMergeSelectDogsAndGoodsWithCount:&count];
        self.orderCount = count;
        self.totalPrice = [YZShoppingCarHelper instanceManager].totalPrice;
        [self.bottomBar resetTotalPrice:[YZShoppingCarHelper instanceManager].totalPrice];
    }
    else
    {
        self.orderNo = self.pOrderNo;
        [self.bottomBar resetTotalPrice:self.totalPrice];
    }
    
    
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(bottomBar.mas_top);
    }];
    
    
    [self inner_getDefaultAddress];
    
    [self getJingwaiGoods];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentResultReceived:) name:@"PaymentResultReceived" object:nil];
    
    if (!self.orderNo) {
        [self creatOrderNoWithSuccess:^(id result) {
            if ([result[@"code"] intValue]==200) {
                self.orderNo = [result[@"data"] objectForKey:@"order_no"];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
    
}



-(void)paymentResultReceived:(NSNotification *)noti
{
    NSString * result = noti.object;
    if ([result isEqualToString:@"success"]) {
        [self toSuccessPage];
    }
    else if ([result isEqualToString:@"cancel"]){
        [self payCancel];
    }
    else
    {
        [self payFailed];
    }
}

-(void)getJingwaiGoods
{
    [NetServer getKuaJingGoodsSuccess:^(id result) {
        if ([result[@"code"] intValue]==200) {
            NSArray * h = result[@"data"];
            for (int i = 0; i<self.orders.count; i++) {
                OrderYZGoodInfo * goodInfo = self.orders[i];
                for (int j = 0; j<h.count; j++) {
                    NSString * sid = [h[j] objectForKey:@"id"];
                    if ([sid isEqualToString:goodInfo.shop_id]) {
                        self.tableView.tableHeaderView = self.topv;
                        haveKuajing = YES;
                        break;
                    }
                }
            }
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
}

- (void)shoppingCarClearPrice {
    //    [[YZShoppingCarHelper instanceManager] clearShoppingCar];
    //    [self makePaymentInfo];
    if (!self.address) {
        [SVProgressHUD showErrorWithStatus:@"请先添加一个收货地址"];
        return;
    }
    if (haveKuajing && (!self.address.cardId || self.address.cardId.length<1)) {
        [SVProgressHUD showErrorWithStatus:@"根据国家相关法律规定，您购买的商品需要填写身份证信息。"];
        return;
    }
    if (self.orderNo) {
        [self makePaymentInfo];
    }
    else{
        [self creatOrderNoWithSuccess:^(id result) {
            if ([result[@"code"] intValue]==200) {
                self.orderNo = [result[@"data"] objectForKey:@"order_no"];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self makePaymentInfo];
            }
            else {
                if (result[@"message"]) {
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                }
                else
                    [SVProgressHUD showErrorWithStatus:@"订单创建失败，请稍后再试"];
            }
        }];
    }
}

-(void)creatOrderNoWithSuccess:(void (^)(id result))success
{
    [NetServer createOrderNoSuccess:^(id result) {
        success(result);
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [SVProgressHUD showErrorWithStatus:@"订单创建失败，请稍后再试"];
    }];
}

-(void)makePaymentInfo
{
    
    _goodsString = @"";
    NSMutableArray * arr = [NSMutableArray array];
    if (self.orders.count>0) {
        for (int i = 0; i<self.orders.count; i++) {
            OrderYZGoodInfo * goodInfo = self.orders[i];
            //            _goodsString = [_goodsString stringByAppendingFormat:@"%@\"%@.%@.%@\"%@",i==0?@"":@",",self.orderNo,goodInfo.goodId,goodInfo.total,i==self.orders.count-1?@"]":@""];
            [arr addObject:[NSString stringWithFormat:@"%@.%@.%@",self.orderNo,goodInfo.goodId,goodInfo.total]];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请先在购物车选择要购买的商品哦"];
        return;
    }
    //    _goodsString = [arr JSONRepresentation];
    NSLog(@"ffffff:%@",_goodsString);
    [NetServer requestPaymentWithGoods:arr AddressId:self.address.addressID ChannelStr:self.paySelectedIndex==0?@"alipay":@"wx" Voucher:nil success:^(id result) {
        if ([result[@"code"] intValue]==200) {
            [SystemServer sharedSystemServer].inPay = YES;
            [Pingpp createPayment:[result[@"data"] JSONRepresentation] viewController:self appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                NSLog(@"completion block: %@", result);
                if (error == nil) {
                    NSLog(@"PingppError is nil");
                    //                    [self paySuccess];
                    [self toSuccessPage];
                }
                else if ([result isEqualToString:@"cancel"]){
                    [self payCancel];
                }
                else {
                    [self payFailed];
                    NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                }
                [SystemServer sharedSystemServer].inPay = NO;
                //                [weakSelf showAlertMessage:result];
            }];
            
        }
        else {
            if (result[@"message"]) {
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
            }
            else
                [SVProgressHUD showErrorWithStatus:@"订单创建失败，请稍后再试"];
        }
        
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [SVProgressHUD showErrorWithStatus:@"订单创建失败，请稍后再试"];
    }];
}

-(void)payCancel
{
    [SVProgressHUD showErrorWithStatus:@"支付已取消"];
    [self.navigationController popViewControllerAnimated:NO];
    //    [self toSuccessPage];
}

-(void)payFailed
{
    [SVProgressHUD showErrorWithStatus:@"支付遇到了一点问题，请稍后再试"];
    //    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败，接下来您要？" delegate:self cancelButtonTitle:@"暂不支付" otherButtonTitles:@"重新支付",@"修改支付方式", nil];
    //    alert.tag = 100;
    //    [alert show];
}

-(void)toSuccessPage
{
    
    PaySuccessViewController * pv = [[PaySuccessViewController alloc] init];
    pv.price = [NSString stringWithFormat:@"共%d元",(int)self.totalPrice];
    pv.orderId = self.orderNo;
    __block YZOrderConfimViewController * blockSelf = self;
    pv.back = ^(){
        [blockSelf.navigationController popToRootViewControllerAnimated:NO];
    };
    
    UINavigationController * ui = [[UINavigationController alloc] initWithRootViewController:pv];
    [self.navigationController presentViewController:ui animated:YES completion:^{
        
    }];
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
                
                viewC.finishTitle = @"使用并保存";
                
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
    else if (section==1&&self.orderNo){
        headerView.textLabel.text = [NSString stringWithFormat:@"订单编号:%@",self.orderNo];
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
        return 100.f;
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
    else if (section==1&&self.orderNo){
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
            viewC.finishTitle = @"使用并保存";
            WS(weakSelf);
            [viewC setUseAddress:^(ReceiptAddress *receiptAddress) {
                weakSelf.address = receiptAddress;
                [weakViewC.navigationController popViewControllerAnimated:YES];
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            [weakSelf.navigationController pushViewController:viewC animated:YES];
        }
    } else if (indexPath.section == 2) {
        YZOrderConfimModeCell *cell = (YZOrderConfimModeCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell changeConfimStyle];
    }
}

@end
