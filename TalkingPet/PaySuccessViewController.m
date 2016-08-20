//
//  PaySuccessViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/6/16.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PaySuccessViewController.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    self.title = @"支付成功";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    self.successV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-100, 60, 200, 100)];
    self.successV.backgroundColor = [UIColor clearColor];
    [self.successV setImage:[UIImage imageNamed:@"successpage_topimg"]];
    [self.view addSubview:self.successV];
    
    UILabel * sL = [[UILabel alloc] initWithFrame:CGRectMake(10, self.successV.frame.size.height+self.successV.frame.origin.y+30, ScreenWidth-20, 30)];
    sL.backgroundColor = [UIColor clearColor];
    sL.textColor = [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1];
    sL.text = @"支付成功";
    sL.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:sL];
    sL.textAlignment = NSTextAlignmentCenter;
    
    UILabel * h = [[UILabel alloc] initWithFrame:CGRectMake(10, sL.frame.origin.y+sL.frame.size.height+10, ScreenWidth-20, 20)];
    h.backgroundColor = [UIColor clearColor];
    h.textAlignment = NSTextAlignmentCenter;
    h.font = [UIFont systemFontOfSize:16];
    h.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    [self.view addSubview:h];
    h.text = [NSString stringWithFormat:@"支付金额：%@",self.price];
    
//    UIButton * toOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [toOrderBtn setFrame:CGRectMake(ScreenWidth/2-50, h.frame.origin.y+h.frame.size.height+20, 100, 35)];
//    toOrderBtn.backgroundColor = [UIColor clearColor];
//    toOrderBtn.layer.cornerRadius = 5;
//    toOrderBtn.layer.borderColor = [[UIColor colorWithWhite:160/255.0f alpha:1] CGColor];
//    toOrderBtn.layer.borderWidth = 1;
//    toOrderBtn.layer.masksToBounds = YES;
//    [toOrderBtn setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
//    [toOrderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
//    toOrderBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [self.view addSubview:toOrderBtn];
//    [toOrderBtn addTarget:self action:@selector(toOrderDetailPage) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)toOrderDetailPage
{
    OrderDetailViewController * ov = [[OrderDetailViewController alloc] init];
    ov.orderID = self.orderId;
    [self.navigationController pushViewController:ov animated:YES];
}
-(void)backBtnDo:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (_back) {
            _back();
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
