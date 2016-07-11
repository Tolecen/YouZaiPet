//
//  OrderDetailViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/6/11.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "MJRefresh.h"
#import "ReceiptAddress.h"
#import "ChatDetailViewController.h"
#import "OrderConfirmViewController.h"
#import "EGOImageView.h"

@interface WXRLabelsCell : UITableViewCell
{
    UILabel * label1;
    UILabel * label2;
    UILabel * label3;
    UILabel * label4;
    UILabel * label5;
    UILabel * label6;
    UILabel * label7;
    UIView * line;
    EGOImageView * imageV;
}
- (void)loadWithOrderMessage:(NSDictionary*)order;
- (void)loadWithPayMessage:(NSDictionary*)pay;
- (void)loadWithAddress:(ReceiptAddress*)address;
- (void)loadWithproductMessage:(NSDictionary*)product;
@end
@implementation WXRLabelsCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        label1 = [[UILabel alloc] init];
        [self.contentView addSubview:label1];
        label2 = [[UILabel alloc] init];
        [self.contentView addSubview:label2];
        label3 = [[UILabel alloc] init];
        [self.contentView addSubview:label3];
        label4 = [[UILabel alloc] init];
        [self.contentView addSubview:label4];
        label5 = [[UILabel alloc] init];
        [self.contentView addSubview:label5];
        label6 = [[UILabel alloc] init];
        [self.contentView addSubview:label6];
        label7 = [[UILabel alloc] init];
        [self.contentView addSubview:label7];
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        [self.contentView addSubview:line];
        imageV = [[EGOImageView alloc] init];
        [self.contentView addSubview:imageV];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)loadWithOrderMessage:(NSDictionary*)order
{
    if (!order) {
        return;
    }
    label1.hidden = NO;
    label2.hidden = NO;
    label3.hidden = NO;
    label4.hidden = NO;
    label5.hidden = YES;
    label6.hidden = YES;
    label7.hidden = YES;
    line.hidden = YES;
    imageV.hidden = YES;
    
    label1.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    label1.frame = CGRectMake(10, 10, 100, 20);
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"订单信息";
    
    if ([order[@"state"] intValue]== 2) {
        label2.textColor = [UIColor orangeColor];
    }else{
        label2.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    }
    label2.textAlignment = NSTextAlignmentRight;
    label2.frame = CGRectMake(ScreenWidth-110, 10, 100, 20);
    label2.font = [UIFont systemFontOfSize:16];
    label2.text = order[@"stateDesc"];
    
    label3.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
    label3.frame = CGRectMake(30, 40, 200, 20);
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = [@"订单编号:" stringByAppendingString:order[@"id"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSDate *timesp = [NSDate dateWithTimeIntervalSince1970:[order[@"time"]  doubleValue]/1000];
    NSString *timespStr = [formatter stringFromDate:timesp];
    label4.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
    label4.frame = CGRectMake(30, 70, 200, 20);
    label4.font = [UIFont systemFontOfSize:14];
    label4.text = [@"确认时间:" stringByAppendingString:timespStr];
}
- (void)loadWithPayMessage:(NSDictionary*)pay
{
    if (!pay) {
        return;
    }
    label1.hidden = NO;
    label2.hidden = NO;
    label3.hidden = NO;
    label4.hidden = YES;
    label5.hidden = YES;
    label6.hidden = YES;
    label7.hidden = YES;
    line.hidden = YES;
    imageV.hidden = YES;
    
    label1.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    label1.frame = CGRectMake(10, 10, 100, 20);
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"支付信息";
    
    label2.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.frame = CGRectMake(30, 40, 250, 20);
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = [@"支付金额: ￥" stringByAppendingString:pay[@"amount"]];
    
    NSString * str  = @"";
    if ([pay[@"payChannel"] isEqualToString:@"alipay"]) {
        str = @"支付宝";
    }
    if ([pay[@"payChannel"] isEqualToString:@"wx"]) {
        str = @"微信支付";
    }
    if ([pay[@"payChannel"] isEqualToString:@"upacp"]) {
        str = @"银联支付";
    }
    label3.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
    label3.frame = CGRectMake(30, 70, 200, 20);
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = [@"支付方式:" stringByAppendingString:str];
}
- (void)loadWithAddress:(ReceiptAddress*)address
{
    if (!address) {
        return;
    }
    label1.hidden = NO;
    label2.hidden = NO;
    label3.hidden = NO;
    label4.hidden = YES;
    label5.hidden = YES;
    label6.hidden = YES;
    label7.hidden = YES;
    line.hidden = YES;
    imageV.hidden = NO;
    imageV.frame = CGRectMake(10, 32, 19.5, 27.5);
    imageV.image = [UIImage imageNamed:@"defaultAddress"];
    
    label1.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    label1.frame = CGRectMake(40, 10, 150, 20);
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = [@"收货人:" stringByAppendingString:address.receiptName];
    
    label2.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
    label2.textAlignment = NSTextAlignmentRight;
    label2.frame = CGRectMake(ScreenWidth-110, 10, 100, 20);
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = address.phoneNo;
    
    label3.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
    label3.frame = CGRectMake(40, 40, ScreenWidth-80, 40);
    label3.numberOfLines = 0;
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = [NSString stringWithFormat:@"%@%@%@",address.province,address.city,address.address];
}
- (void)loadWithproductMessage:(NSDictionary*)product
{
    if (!product) {
        return;
    }
    label1.hidden = NO;
    label2.hidden = NO;
    label3.hidden = NO;
    label4.hidden = NO;
    label5.hidden = NO;
    label6.hidden = NO;
    label7.hidden = YES;
    line.hidden = NO;
    imageV.hidden = NO;
    
    imageV.imageURL = [NSURL URLWithString:product[@"cover"]];
    imageV.frame = CGRectMake(10, 10, 80, 80);
    
    label1.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    label1.frame = CGRectMake(100, 10, ScreenWidth-180, 80);
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = product[@"name"];
    
    label2.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    label2.textAlignment = NSTextAlignmentRight;
    label2.frame = CGRectMake(ScreenWidth-80, 10, 70, 20);
    label2.font = [UIFont systemFontOfSize:16];
    label2.adjustsFontSizeToFitWidth = YES;
    label2.text = [@"￥" stringByAppendingString:product[@"price"]];
    
    label3.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    label3.textAlignment = NSTextAlignmentRight;
    label3.frame = CGRectMake(ScreenWidth-80, 45, 70, 20);
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = [@"×" stringByAppendingString:product[@"count"]];
    
    label4.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    label4.textAlignment = NSTextAlignmentRight;
    label4.frame = CGRectMake(ScreenWidth-80, 80, 70, 20);
    label4.font = [UIFont systemFontOfSize:12];
    label4.text = [@"运费:" stringByAppendingString:product[@"transportationCosts"]];
    
    line.frame = CGRectMake(10, 115, ScreenWidth-20, 1);
    
    label5.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    label5.textAlignment = NSTextAlignmentRight;
    label5.frame = CGRectMake(ScreenWidth-150, 130, 50, 20);
    label5.font = [UIFont systemFontOfSize:12];
    label5.text = @"共计:";
    
    label6.textColor = [UIColor orangeColor];
    label6.textAlignment = NSTextAlignmentRight;
    label6.frame = CGRectMake(ScreenWidth-100, 130, 90, 20);
    label6.font = [UIFont systemFontOfSize:20];
    label6.adjustsFontSizeToFitWidth = YES;
    label6.text = [@"￥" stringByAppendingString:product[@"amount"]];
    
    if (product[@"couponValue"]) {
        label4.frame = CGRectMake(ScreenWidth-80, 70, 70, 20);
        
        label7.hidden = NO;
        label7.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        label7.textAlignment = NSTextAlignmentRight;
        label7.adjustsFontSizeToFitWidth = YES;
        label7.frame = CGRectMake(ScreenWidth-80, 90, 70, 20);
        label7.font = [UIFont systemFontOfSize:12];
        label7.text = [NSString stringWithFormat:@"优惠劵:-%@元",product[@"couponValue"]];
    }
}
@end;
@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * liaisonB;
    UIButton * cancelB;
    UIButton * payB;
    UITableView * _tableView;
}
@property (nonatomic,retain)NSDictionary * orderMessage;
@property (nonatomic,retain)NSDictionary * payMessage;
@property (nonatomic,retain)ReceiptAddress * address;
@property (nonatomic,retain)NSDictionary * productMessage;

@property (nonatomic,retain)NSDictionary * toPayDic;
@end
@implementation OrderDetailViewController
- (void)dealloc
{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"订单详情";
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    [self setBackButtonWithTarget:@selector(back)];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight - 50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView addHeaderWithTarget:self action:@selector(loadOrderWithOrderID)];
    [_tableView headerBeginRefreshing];
    UIView * whiteView  = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50 - navigationBarHeight, self.view.frame.size.width, 50)];
    whiteView.backgroundColor = [UIColor whiteColor];
    liaisonB = [UIButton buttonWithType:UIButtonTypeCustom];
    liaisonB.frame = CGRectMake(10, 9, 90, 32);
    [liaisonB addTarget:self action:@selector(liaison) forControlEvents:UIControlEventTouchUpInside];
    [liaisonB setImage:[UIImage imageNamed:@"liaison"] forState:UIControlStateNormal];
    [whiteView addSubview:liaisonB];
    cancelB = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelB.frame = CGRectMake(ScreenWidth/2-45, 9, 90, 32);
    cancelB.hidden = YES;
    [cancelB addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    [cancelB setImage:[UIImage imageNamed:@"cancelOrder"] forState:UIControlStateNormal];
    [whiteView addSubview:cancelB];
    payB = [UIButton buttonWithType:UIButtonTypeCustom];
    payB.frame = CGRectMake(ScreenWidth-100, 9, 90, 32);
    [payB addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    payB.hidden = YES;
    [payB setImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
    [whiteView addSubview:payB];
    [self.view addSubview:whiteView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentResultReceived:) name:@"PaymentResultReceived" object:nil];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)liaison
{
    ChatDetailViewController * chatDV = [[ChatDetailViewController alloc] init];
    Pet * theP = [[Pet alloc] init];
    theP.petID = @"44239";
    chatDV.thePet = theP;
    [self.navigationController pushViewController:chatDV animated:YES];
}
-(void)cancelOrder
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要删除订单吗？删除之后不可恢复哦" delegate:self cancelButtonTitle:@"留着吧" otherButtonTitles:@"删除", nil];
    alert.tag = 80;
    [alert show];
    
}
-(void)sureTodeleteOrder
{
    [SVProgressHUD showWithStatus:@"正在取消订单.."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"order" forKey:@"command"];
    [usersDict setObject:@"cancelOrder" forKey:@"options"];
    [usersDict setObject:_orderMessage[@"id"] forKey:@"id"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (_deleteThisOrder) {
            _deleteThisOrder();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"取消失败，请重试"];
    }];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==90&&buttonIndex==1) {
        [self sureToConfirm];
    }
    else if (alertView.tag==80&&buttonIndex==1) {
        [self sureTodeleteOrder];
    }
}
-(void)pay
{
    if ([_orderMessage[@"state"] intValue]== 2) {
//        OrderConfirmViewController * vc = [[OrderConfirmViewController alloc] init];
//        vc.orderDict = _toPayDic;
//        [self.navigationController pushViewController:vc animated:YES];
        [self payThisOrder:self.toPayDic];
    }else if([_orderMessage[@"state"] intValue]== 5)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认收货吗？一定要确认收到再点击哦" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"确认收货", nil];
        alert.tag = 90;
        [alert show];

    }
}

-(void)sureToConfirm
{
    [SVProgressHUD showWithStatus:@"确认中..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"order" forKey:@"command"];
    [usersDict setObject:@"receiveProduct" forKey:@"options"];
    [usersDict setObject:_orderMessage[@"id"] forKey:@"id"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_deleteThisOrder) {
            _deleteThisOrder();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"确认失败，请重试"];
    }];
}
-(void)loadOrderWithOrderID
{
    if (!_orderID) {
        [_tableView headerEndRefreshing];
        return;
    }
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"order" forKey:@"command"];
    [usersDict setObject:@"one" forKey:@"options"];
    [usersDict setObject:_orderID forKey:@"id"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = responseObject[@"value"];
        [_tableView headerEndRefreshing];
        self.orderMessage = @{@"state":dic[@"state"],@"stateDesc":dic[@"stateDesc"],@"id":dic[@"id"],@"time":dic[@"confirmTime"]};
        self.payMessage = @{@"amount":dic[@"amount"],@"payChannel":dic[@"payChannel"]};
        self.productMessage = @{@"cover":[dic[@"orderProducts"] lastObject][@"cover"],@"name":[dic[@"orderProducts"] lastObject][@"name"],@"price":[dic[@"orderProducts"] lastObject][@"price"],@"count":dic[@"productCount"],@"transportationCosts":dic[@"shippingFee"],@"amount":dic[@"amount"]};
        if ([dic[@"coupon"] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary * lDic = [NSMutableDictionary dictionaryWithDictionary:_productMessage];
            [lDic setObject:[dic[@"coupon"] objectForKey:@"faceValue"] forKey:@"couponValue"];
            self.productMessage = lDic;
        }
        self.address = ({
            ReceiptAddress * address = [[ReceiptAddress alloc] init];
            address.receiptName = dic[@"shippingName"];
            address.phoneNo = dic[@"shippingMobile"];
            address.province = dic[@"shippingProvince"];
            address.city = dic[@"shippingCity"];
            address.address = dic[@"shippingAddress"];
            address.zipCode = dic[@"shippingZipcode"];
            address;
        });
        [_tableView reloadData];
        [self loadTooleBarView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView headerEndRefreshing];
    }];
}
-(void)buildWithSimpleDic:(NSDictionary*)dic
{
    self.toPayDic = dic;
    self.orderMessage = @{@"state":dic[@"state"],@"stateDesc":dic[@"stateDesc"],@"id":dic[@"id"],@"time":dic[@"confirmTime"]};
    self.productMessage = @{@"cover":[dic[@"orderProducts"] lastObject][@"cover"],@"name":[dic[@"orderProducts"] lastObject][@"name"],@"price":[dic[@"orderProducts"] lastObject][@"price"],@"count":dic[@"productCount"],@"transportationCosts":dic[@"shippingFee"],@"amount":dic[@"amount"]};
    [_tableView reloadData];
    [self loadTooleBarView];
}
- (void)loadTooleBarView
{
    if ([_orderMessage[@"state"] intValue]== 2) {
        payB.hidden = NO;
        [payB setImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
        cancelB.hidden = NO;
    }else if([_orderMessage[@"state"] intValue]== 5)
    {
        payB.hidden = NO;
        cancelB.hidden = YES;
        [payB setImage:[UIImage imageNamed:@"receipt"] forState:UIControlStateNormal];
    }else
    {
        cancelB.hidden = YES;
        payB.hidden = YES;
    }
}
#pragma mark -
#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WXRLabelsCell";
    WXRLabelsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[WXRLabelsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0: {
            [cell loadWithOrderMessage:_orderMessage];
        }break;
        case 1: {
            [cell loadWithPayMessage:_payMessage];
        }break;
        case 2: {
            [cell loadWithAddress:_address];
        }break;
        case 3: {
            [cell loadWithproductMessage:_productMessage];
        }break;
        default:
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            if (_orderMessage) {
                return 110;
            }
        }break;
        case 1:{
            if (_payMessage) {
                return 110;
            }
        }break;
        case 2:{
            if (_address) {
                return 90;
            }
        }break;
        case 3:{
            if (_productMessage) {
                return 165;
            }
        }break;
        default:
        break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 50;
    }
    return 1;
}

-(void)payThisOrder:(NSDictionary *)dict
{
//    tmpDict = dict;
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
    OrderDetailViewController * __weak weakSelf = self;
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
    if (_actionOrder) {
        self.actionOrder();
    }
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
    pv.price = [self.toPayDic objectForKey:@"amount"];
    pv.orderId = [self.toPayDic objectForKey:@"id"];
    __block OrderDetailViewController * blockSelf = self;
    pv.back = ^(){
        //        [blockSelf.navigationController popViewControllerAnimated:NO];
//        [blockSelf getFristList];
        [blockSelf loadOrderWithOrderID];
    };
    
    UINavigationController * ui = [[UINavigationController alloc] initWithRootViewController:pv];
    [self.navigationController presentViewController:ui animated:YES completion:^{
        
    }];
}

@end
