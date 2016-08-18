//
//  MyOrderViewConyroller.m
//  TalkingPet
//
//  Created by wangxr on 15/6/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "MyOrderViewConyroller.h"
#import "MJRefresh.h"
#import "OrderDetailViewController.h"
#import "OrderConfirmViewController.h"
#import "ChatDetailViewController.h"
#import "WXROrderCell.h"
#import "BlankPageView.h"
#import "NetServer+Payment.h"
#import "OrderListSingleCell.h"
#import "OrderYZList.h"
#import "OrderYZGoodInfo.h"
#import "OrderHeaderView.h"
#import "OrderFooterView.h"
#import "NSDate+XMGExtension.h"
#import "YZOrderConfimViewController.h"

@interface MyOrderViewConyroller ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UIButton * currentButton;
    UIView * lineView;
    
    NSString * option;
    NSDictionary * tmpDict;
    
    BlankPageView * blankPage;
}
@property (nonatomic,retain)NSMutableArray * orderArr;
@property (nonatomic,retain)UITableView * tableView;
@end
@implementation MyOrderViewConyroller
- (void)dealloc
{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的订单";
        self.orderArr = [NSMutableArray array];
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    [self setBackButtonWithTarget:@selector(back)];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width/5, 2)];
    lineView.backgroundColor = CommonGreenColor;
    [headerView addSubview:lineView];
    
    for (int i = 0; i<5; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.view.frame.size.width*i/5, 0, self.view.frame.size.width/5, headerView.frame.size.height);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor colorWithWhite:100/255.0 alpha:1] forState:UIControlStateNormal];
        [headerView addSubview:button];
        [button addTarget:self action:@selector(changeOrderType:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+100;
        switch (i) {
            case 0:{
                [button setTitle:@"全部" forState:UIControlStateNormal];
                currentButton = button;
                [button setTitleColor:CommonGreenColor forState:UIControlStateNormal];
            }break;
            case 1:{
                [button setTitle:@"待付款" forState:UIControlStateNormal];
                
            }break;
            case 2:{
                [button setTitle:@"待发货" forState:UIControlStateNormal];
            }break;
            case 3:{
                [button setTitle:@"待收货" forState:UIControlStateNormal];
            }break;
            default:{
                [button setTitle:@"待评价" forState:UIControlStateNormal];
            }break;
        }
    }
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight - 43) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithWhite:245/255.f alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    option = @"allList";
    [_tableView addHeaderWithTarget:self action:@selector(getFristList)];
    [_tableView addFooterWithTarget:self action:@selector(getFristList)];
    [_tableView headerBeginRefreshing];
    
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changeOrderType:(UIButton*)btn
{
    if ([btn isEqual:currentButton]) {
        return;
    }
    [currentButton  setTitleColor:[UIColor colorWithWhite:100/255.0 alpha:1] forState:UIControlStateNormal];
    currentButton = btn;
    switch (btn.tag-100) {
        case 0:{
            option = @"allList";
        }break;
        case 1:{
            option = @"unpaid";
        }break;
        case 2:{
            option = @"unposted";
        }break;
        case 3:{
            option = @"unpicked";
        }break;
        case 4:{
            option = @"picked";
        }break;
        default:
            break;
    }
    [currentButton  setTitleColor:CommonGreenColor forState:UIControlStateNormal];
    __block UIView * view = lineView;
    [UIView animateWithDuration:0.3 animations:^{
        view.center = CGPointMake(btn.center.x, view.center.y);
    }];
    [self.orderArr removeAllObjects];
    [_tableView reloadData];
    [_tableView headerBeginRefreshing];
}
-(void)getFristList
{
    
    [NetServer fetchOrderListWithPageIndex:1 Option:option  success:^(id result) {
        NSLog(@"orderList:%@",result);
        if ([result[@"code"] intValue] == 200) {
            self.orderArr = [self getModelArray:result[@"data"][@"list"]];
            [_tableView reloadData];
            
            
        }
        
        //        [SVProgressHUD dismissWithError:@"订单信息已经全部加载完毕" afterDelay:2];
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
        
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
    
    //    NSMutableDictionary* usersDict = [NetServer commonDict];
    //    [usersDict setObject:@"order" forKey:@"command"];
    //    [usersDict setObject:option forKey:@"options"];
    //    [usersDict setObject:@"10" forKey:@"pageSize"];
    //    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        [_tableView headerEndRefreshing];
    //        [_orderArr removeAllObjects];
    //        [_orderArr addObjectsFromArray:responseObject[@"value"]];
    //        [_tableView reloadData];
    //        if (!_orderArr.count) {
    //            if (!blankPage) {
    //                __weak UINavigationController * weakNav = self.navigationController;
    //                blankPage = [[BlankPageView alloc] initWithImage];
    //                [blankPage showWithView:self.view image:[UIImage imageNamed:@"order_without"] buttonImage:[UIImage imageNamed:@"order_toShop"] action:^{
    //                    [weakNav popToRootViewControllerAnimated:YES];
    //                }];
    //            }
    //        }
    //        else if(blankPage){
    //            [blankPage removeFromSuperview];
    //            blankPage = nil;
    //        }
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        [_tableView headerEndRefreshing];
    //        [_orderArr removeAllObjects];
    //        [_tableView reloadData];
    //    }];
}

-(NSMutableArray *)getModelArray:(NSArray *)array
{
    NSMutableArray * arr = [NSMutableArray array];
    
    for (int i = 0; i<array.count; i++) {
        NSDictionary * dict = array[i];
        OrderYZList * listModel = [[OrderYZList alloc] initWithDictionary:dict error:nil];
        int amount = 0;
        NSMutableArray * garr = [NSMutableArray array];
        for (int j = 0; j<listModel.goods.count; j++) {
            NSDictionary * gd = listModel.goods[j];
            OrderYZGoodInfo * goodModel = [[OrderYZGoodInfo alloc] initWithDictionary:gd error:nil];
            
            listModel.total_money = goodModel.real_amount;
            listModel.shippingfee = goodModel.real_shipping;
            if (goodModel.confirmUrl && goodModel.confirmUrl.length>1) {
                listModel.confirmUrl = goodModel.confirmUrl;
            }
            if (goodModel.model && goodModel.model.length>1) {
                listModel.model = goodModel.model;
            }
            if (goodModel.post_status) {
                listModel.post_status = goodModel.post_status;
            }
            
            if (gd[@"field_id"]) {
                goodModel.goodId = gd[@"field_id"];
            }
            
            amount = amount+[goodModel.total intValue];
            
            [garr addObject:goodModel];
        }
        listModel.goods = garr;
        listModel.total_amount = [NSString stringWithFormat:@"%d",amount];
        [arr addObject:listModel];
    }
    
    
    
    return arr;
}
-(void)getOtherlist
{
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"order" forKey:@"command"];
    [usersDict setObject:option forKey:@"options"];
    [usersDict setObject:@"10" forKey:@"pageSize"];
    [usersDict setObject:[_orderArr lastObject][@"id"] forKey:@"id"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        [_tableView footerEndRefreshing];
        [_orderArr addObjectsFromArray:responseObject[@"value"]];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView footerEndRefreshing];
    }];
}
- (void)receipt:(NSDictionary*)dic
{
    tmpDict = dic;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认收货吗？一定要确认收到再点击哦" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"确认收货", nil];
    alert.tag = 90;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==90&&buttonIndex==1) {
        [self sureToConfirmReceive];
    }
}
-(void)sureToConfirmReceive
{
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"order" forKey:@"command"];
    [usersDict setObject:@"receiveProduct" forKey:@"options"];
    [usersDict setObject:tmpDict[@"id"] forKey:@"id"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger section = [_orderArr indexOfObject:tmpDict];
        [_orderArr removeObject:tmpDict];
        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    } failure:nil];
}
#pragma mark -
#pragma mark - UITableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    OrderYZList * listModel = self.orderArr[section];
    
    
    
    if ([listModel.pay_status isEqualToString:@"0"]) {
        return 85.f;
    }
    else if([listModel.post_status isEqualToString:@"1"])
    {
        return 85.f;
    }
    else
    {
        return 45.f;
    }
    
    return 85.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * header = @"header";
    OrderHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    if (view == nil) {
        view = [[OrderHeaderView alloc] initWithReuseIdentifier:header];
    }
    OrderYZList * listModel = self.orderArr[section];
    NSString  *currentDateStr =listModel.time;
    
    view.timeL.text =currentDateStr;
    view.statusL.text = listModel.pay_status_zh;
    
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    static NSString * header = @"footer";
    OrderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    if (view == nil) {
        view = [[OrderFooterView alloc] initWithReuseIdentifier:header WithButton:YES];
    }
    
    
    
    
    OrderYZList * listModel = self.orderArr[section];
    view.desL.text = [NSString stringWithFormat:@"共 %@ 件 合计：￥%@（含运费 ￥%@）",listModel.total_amount,listModel.total_money,listModel.shippingfee];
    
    
    if ([listModel.pay_status isEqualToString:@"0"]) {
        view.btn1.hidden = NO;
        view.btn2.hidden = NO;
        [view.btn1 setTitle:@"删除订单" forState:UIControlStateNormal];
        [view.btn2 setTitle:@"立刻付款" forState:UIControlStateNormal];
    }
    else if([listModel.post_status isEqualToString:@"1"])
    {
        view.btn1.hidden = YES;
        view.btn2.hidden = NO;
        [view.btn2 setTitle:@"确认收货" forState:UIControlStateNormal];
    }
    else
    {
        view.btn1.hidden = YES;
        view.btn2.hidden = YES;
    }
    view.buttonClicked = ^(NSString * title){
        [self buttonAction:title order:listModel];
    };
    
    return view;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return _orderArr.count;
    return self.orderArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderYZList * listModel = self.orderArr[section];
    return listModel.goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableViewCell";
    //    __weak MyOrderViewConyroller * blockSelf = self;
    //    __weak NSString * bolckOption = option;
    OrderListSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[OrderListSingleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OrderYZList * listModel = self.orderArr[indexPath.section];
    cell.goodInfo = listModel.goods[indexPath.row];
    
    //    NSDictionary * dic = _orderArr[indexPath.section];
    //    [cell bulidCellWithDictionary:dic];
    //    cell.liaisonAction = ^(){
    //        ChatDetailViewController * chatDV = [[ChatDetailViewController alloc] init];
    //        Pet * theP = [[Pet alloc] init];
    //        theP.petID = @"44239";
    //        chatDV.thePet = theP;
    //        [blockSelf.navigationController pushViewController:chatDV animated:YES];
    //    };
    //    cell.payAction = ^(){
    //        if ([bolckOption isEqual:@"toPayList"]) {
    //            [blockSelf payThisOrder:dic];
    ////            OrderConfirmViewController * vc = [[OrderConfirmViewController alloc] init];
    ////            vc.orderDict = dic;
    ////            [blockSelf.navigationController pushViewController:vc animated:YES];
    //        }else
    //        {
    //            [blockSelf receipt:dic];
    //        }
    //    };
    return cell;
}
-(void)payThisOrder:(NSDictionary *)dict
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentResultReceived:) name:@"PaymentResultReceived" object:nil];
    tmpDict = dict;
    [SVProgressHUD showWithStatus:@"请求支付信息..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"order" forKey:@"command"];
    [usersDict setObject:@"confirm" forKey:@"options"];
    [usersDict setObject:[dict objectForKey:@"id"] forKey:@"id"];
    if ([[dict objectForKey:@"useCoupon"] isEqualToString:@"true"]) {
        [usersDict setObject:[[dict objectForKey:@"coupon"] objectForKey:@"id"]forKey:@"couponId"];
    }
    [usersDict setObject:[dict objectForKey:@"payChannel"] forKey:@"payChannel"];
    
    if ([dict objectForKey:@"note"]) {
        [usersDict setObject:[dict objectForKey:@"note"] forKey:@"note"];
    }
    
    [usersDict setObject:[dict objectForKey:@"shippingName"] forKey:@"shippingName"];
    [usersDict setObject:[dict objectForKey:@"shippingMobile"] forKey:@"shippingMobile"];
    [usersDict setObject:[dict objectForKey:@"shippingZipcode"] forKey:@"shippingZipcode"];
    [usersDict setObject:[dict objectForKey:@"shippingProvince"] forKey:@"shippingProvince"];
    [usersDict setObject:[dict objectForKey:@"shippingCity"] forKey:@"shippingCity"];
    [usersDict setObject:[dict objectForKey:@"shippingAddress"] forKey:@"shippingAddress"];
    
    if ([UserServe sharedUserServe].userID) {
        [usersDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    }
    MyOrderViewConyroller * __weak weakSelf = self;
    [NetServer requestWithEncryptParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * h = [responseObject objectForKey:@"value"];
        NSString * charge = [h JSONRepresentation];
        [SystemServer sharedSystemServer].inPay = YES;
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                NSLog(@"completion block: %@", result);
                if (error == nil) {
                    NSLog(@"PingppError is nil");
                    [self paySuccess];
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
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求有点问题，稍后再试吧"];
    }];
    
    
}
-(void)paymentResultReceived:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString * result = noti.object;
    if ([result isEqualToString:@"success"]) {
        [self paySuccess];
    }
    else if ([result isEqualToString:@"cancel"]){
        [self payCancel];
    }
    else
    {
        [self payFailed];
    }
}
-(void)paySuccess
{
    [SVProgressHUD showSuccessWithStatus:@"支付成功！"];
    [self toSuccessPage];
}
-(void)payFailed
{
    [SVProgressHUD showErrorWithStatus:@"支付遇到了一点问题，请稍后再试"];
    
}

-(void)payCancel
{
    [SVProgressHUD showErrorWithStatus:@"支付已取消"];
    //    [self.navigationController popViewControllerAnimated:NO];
    //    [self toSuccessPage];
}
-(void)toSuccessPage
{
    
    PaySuccessViewController * pv = [[PaySuccessViewController alloc] init];
    pv.price = [tmpDict objectForKey:@"amount"];
    pv.orderId = [tmpDict objectForKey:@"id"];
    __block MyOrderViewConyroller * blockSelf = self;
    pv.back = ^(){
        //        [blockSelf.navigationController popViewControllerAnimated:NO];
        [blockSelf getFristList];
    };
    
    UINavigationController * ui = [[UINavigationController alloc] initWithRootViewController:pv];
    [self.navigationController presentViewController:ui animated:YES completion:^{
        
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 5;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 5;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderYZList * listModel = self.orderArr[indexPath.section];
    OrderDetailViewController * orderVC = [[OrderDetailViewController alloc] init];
    orderVC.myOrder = listModel;
    orderVC.deleteThisOrder = ^(){
        [_tableView headerBeginRefreshing];
    };
    //    orderVC.orderID = _orderArr[indexPath.section][@"id"];
    //    [orderVC buildWithSimpleDic:_orderArr[indexPath.section]];
    //    __weak NSMutableArray * weakArr = _orderArr;
    //    __weak MyOrderViewConyroller * weakSelf = self;
    //    orderVC.deleteThisOrder =^(){
    //        [weakArr removeObjectAtIndex:indexPath.section];
    //        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    //        [self.navigationController popToViewController:weakSelf animated:YES];
    //    };
    //    orderVC.actionOrder = ^(){
    //        [self getFristList];
    //    };
    [self.navigationController pushViewController:orderVC animated:YES];
}

-(void)buttonAction:(NSString *)title order:(OrderYZList *)order
{
    if ([title isEqualToString:@"删除订单"]) {
        [SVProgressHUD showWithStatus:@"删除中..."];
        [NetServer deleteOrderWithOrderNo:order.order_no success:^(id result) {
            [SVProgressHUD showSuccessWithStatus:@"删除订单成功"];
            [_tableView headerBeginRefreshing];
            //            self.myOrder.pay_status = @"2";
            //            [_tableView reloadData];
        } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
            [SVProgressHUD showErrorWithStatus:@"删除订单失败"];
        }];
    }
    else if ([title isEqualToString:@"立刻付款"]){
        YZOrderConfimViewController *viewC = [[YZOrderConfimViewController alloc] init];
        viewC.orders = order.goods;
        viewC.orderCount = [order.total_amount integerValue];
        viewC.totalPrice = [order.total_money integerValue];
        [self.navigationController pushViewController:viewC animated:YES];
    }
    else if ([title isEqualToString:@"确认收货"]){
        if (!order.confirmUrl) {
            return;
        }
        if (![order.model isEqualToString:@"Dog"]) {
            [SVProgressHUD showWithStatus:@"确认中..."];
            [NetServer confirmReceviedGoodWithGoodUrl:order.confirmUrl paras:nil success:^(id result) {
                [SVProgressHUD showSuccessWithStatus:@"确认收货成功"];
                order.post_status = @"2";
                [_tableView reloadData];
            } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                [SVProgressHUD showErrorWithStatus:@"确认收货失败"];
            }];
        }
        else
        {
            ConfirmDogReceivedVC * cd = [[ConfirmDogReceivedVC alloc] init];
            cd.myOrder = order;
            cd.back = ^()
            {
                [self confirmSuccess];
            };
            [self.navigationController pushViewController:cd animated:YES];
        }
        
    }
}

-(void)confirmSuccess
{
    [_tableView headerBeginRefreshing];
}



@end
