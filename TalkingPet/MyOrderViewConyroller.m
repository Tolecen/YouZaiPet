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
        self.title = @"订单管理";
        self.orderArr = [NSMutableArray array];
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    [self setBackButtonWithTarget:@selector(back)];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, self.view.frame.size.width/4, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:133/255.0 green:203/255.0 blue:252/255.0 alpha:1];
    [headerView addSubview:lineView];
    
    for (int i = 0; i<4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.view.frame.size.width*i/4, 0, self.view.frame.size.width/4, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor colorWithWhite:100/255.0 alpha:1] forState:UIControlStateNormal];
        [headerView addSubview:button];
        [button addTarget:self action:@selector(changeOrderType:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+100;
        if (i>0) {
            UIView * a = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i/4, 10, 1, 10)];
            a.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
            [headerView addSubview:a];
        }
        switch (i) {
            case 0:{
                [button setTitle:@"待支付" forState:UIControlStateNormal];
                currentButton = button;
                [button setTitleColor:[UIColor colorWithRed:133/255.0 green:203/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
            }break;
            case 1:{
                [button setTitle:@"待发货" forState:UIControlStateNormal];
            }break;
            case 2:{
                [button setTitle:@"待收货" forState:UIControlStateNormal];
            }break;
            default:{
                [button setTitle:@"已完成" forState:UIControlStateNormal];
            }break;
        }
    }
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight - 45) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    option = @"toPayList";
    [_tableView addHeaderWithTarget:self action:@selector(getFristList)];
    [_tableView addFooterWithTarget:self action:@selector(getOtherlist)];
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
            option = @"toPayList";
        }break;
        case 1:{
            option = @"toShipList";
        }break;
        case 2:{
            option = @"toReceiveList";
        }break;
        case 3:{
            option = @"finishedList";
        }break;
        default:
            break;
    }
    [currentButton  setTitleColor:[UIColor colorWithRed:133/255.0 green:203/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
    __block UIView * view = lineView;
    [UIView animateWithDuration:0.3 animations:^{
        view.center = CGPointMake(btn.center.x, view.center.y);
    }];
    [_tableView headerBeginRefreshing];
}
-(void)getFristList
{
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"order" forKey:@"command"];
    [usersDict setObject:option forKey:@"options"];
    [usersDict setObject:@"10" forKey:@"pageSize"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_tableView headerEndRefreshing];
        [_orderArr removeAllObjects];
        [_orderArr addObjectsFromArray:responseObject[@"value"]];
        [_tableView reloadData];
        if (!_orderArr.count) {
            if (!blankPage) {
                __weak UINavigationController * weakNav = self.navigationController;
                blankPage = [[BlankPageView alloc] initWithImage];
                [blankPage showWithView:self.view image:[UIImage imageNamed:@"order_without"] buttonImage:[UIImage imageNamed:@"order_toShop"] action:^{
                    [weakNav popToRootViewControllerAnimated:YES];
                }];
            }
        }
        else if(blankPage){
            [blankPage removeFromSuperview];
            blankPage = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView headerEndRefreshing];
        [_orderArr removeAllObjects];
        [_tableView reloadData];
    }];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableViewCell";
    __weak MyOrderViewConyroller * blockSelf = self;
    __weak NSString * bolckOption = option;
    WXROrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[WXROrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary * dic = _orderArr[indexPath.section];
    [cell bulidCellWithDictionary:dic];
    cell.liaisonAction = ^(){
        ChatDetailViewController * chatDV = [[ChatDetailViewController alloc] init];
        Pet * theP = [[Pet alloc] init];
        theP.petID = @"44239";
        chatDV.thePet = theP;
        [blockSelf.navigationController pushViewController:chatDV animated:YES];
    };
    cell.payAction = ^(){
        if ([bolckOption isEqual:@"toPayList"]) {
            [blockSelf payThisOrder:dic];
//            OrderConfirmViewController * vc = [[OrderConfirmViewController alloc] init];
//            vc.orderDict = dic;
//            [blockSelf.navigationController pushViewController:vc animated:YES];
        }else
        {
            [blockSelf receipt:dic];
        }
    };
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
    return 230;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetailViewController * orderVC = [[OrderDetailViewController alloc] init];
    orderVC.orderID = _orderArr[indexPath.section][@"id"];
    [orderVC buildWithSimpleDic:_orderArr[indexPath.section]];
    __weak NSMutableArray * weakArr = _orderArr;
    __weak MyOrderViewConyroller * weakSelf = self;
    orderVC.deleteThisOrder =^(){
        [weakArr removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        [self.navigationController popToViewController:weakSelf animated:YES];
    };
    orderVC.actionOrder = ^(){
        [self getFristList];
    };
    [self.navigationController pushViewController:orderVC animated:YES];
}
@end
