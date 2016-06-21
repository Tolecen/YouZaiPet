//
//  OrderConfirmViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/6/8.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "OrderConfirmViewController.h"

@interface OrderConfirmViewController ()

@end

@implementation OrderConfirmViewController
-(void)dealloc
{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selectedQuanId = -1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.haveAddress = YES;
    self.agreeProtocol = YES;
    self.payChannel = 1;
    
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    self.title = @"订单确认";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    if (self.orderDict) {
        NSDictionary * product = [[self.orderDict objectForKey:@"orderProducts"] firstObject];
        self.imageUrl = [NSURL URLWithString:[product objectForKey:@"cover"]];
        self.goodsTitle = [product objectForKey:@"name"];
        self.univalent = [product objectForKey:@"price"];
        self.goodsNum = [self.orderDict objectForKey:@"productCount"];
        self.allPriceStr = [NSString stringWithFormat:@"%.2f",[[self.orderDict objectForKey:@"amount"] floatValue]-[[self.orderDict objectForKey:@"shippingFee"] floatValue]];
        self.yunfeiValue = [[self.orderDict objectForKey:@"shippingFee"] floatValue];
        if (self.yunfeiValue==0) {
            self.yunfei = @"免运费";
        }
        else{
            self.yunfei = [NSString stringWithFormat:@"运费:￥%@",[self.orderDict objectForKey:@"shippingFee"]];
        }
        self.orderId = [self.orderDict objectForKey:@"id"];
        NSString * payChannel = [self.orderDict objectForKey:@"payChannel"];
        if ([payChannel isEqualToString:@"alipay"]) {
            self.payChannel = 1;
        }
        else if ([payChannel isEqualToString:@"wx"]){
            self.payChannel = 2;
        }
        else if ([payChannel isEqualToString:@"upacp"]){
            self.payChannel = 3;
        }
        
        NSString * theName = [self.orderDict objectForKey:@"shippingName"];
        if (theName&&![theName isEqualToString:@" "]) {
            self.haveAddress = YES;
            self.rAddress = [[ReceiptAddress alloc] init];
            self.rAddress.receiptName = [self.orderDict objectForKey:@"shippingName"];
            self.rAddress.phoneNo = [self.orderDict objectForKey:@"shippingMobile"];
            self.rAddress.zipCode = [self.orderDict objectForKey:@"shippingZipcode"];
            self.rAddress.province = [self.orderDict objectForKey:@"shippingProvince"];
            self.rAddress.city = [self.orderDict objectForKey:@"shippingCity"];
            self.rAddress.address = [self.orderDict objectForKey:@"shippingAddress"];
            [self setViewFrame];
        }
    }
    
    self.bgScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame)-40-navigationBarHeight)];
    self.bgScrollV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgScrollV];
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, 2000);
    
    self.originRect = self.bgScrollV.frame;
    
    self.firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 50)];
    self.firstView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.firstView];
    
    self.addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addAddressBtn setFrame:CGRectMake(10, 10, ScreenWidth-20, 30)];
    [self.addAddressBtn setTitle:@"+ 编辑收货地址" forState:UIControlStateNormal];
    [self.addAddressBtn setTitleColor:[UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1] forState:UIControlStateNormal];
    self.addAddressBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.firstView addSubview:self.addAddressBtn];
    [self.addAddressBtn addTarget:self action:@selector(toAddressPage) forControlEvents:UIControlEventTouchUpInside];
    
    self.addressBgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    self.addressBgv.backgroundColor = [UIColor clearColor];
    [self.firstView addSubview:self.addressBgv];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toAddressPage)];
    [self.addressBgv addGestureRecognizer:tap];
    
    
    self.addressIconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 28)];
    [self.addressIconV setImage:[UIImage imageNamed:@"dizhizuobiao"]];
    [self.addressBgv addSubview:self.addressIconV];
    self.addressIconV.userInteractionEnabled = NO;
    
    self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 120, 20)];
    self.nameL.backgroundColor = [UIColor clearColor];
    self.nameL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.nameL.font = [UIFont systemFontOfSize:14];
    [self.addressBgv addSubview:self.nameL];
    self.nameL.text = @"我是名字";
    self.nameL.userInteractionEnabled = NO;
    
    self.addressL = [[UILabel alloc] initWithFrame:CGRectMake(40, 35, ScreenWidth-40-30, 20)];
    self.addressL.backgroundColor = [UIColor clearColor];
    self.addressL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.addressL.font = [UIFont systemFontOfSize:14];
    self.addressL.numberOfLines = 0;
    self.addressL.lineBreakMode = NSLineBreakByCharWrapping;
    [self.addressBgv addSubview:self.addressL];
    self.addressL.text = @"北京市朝阳区北安街道办事处日日日小区11号楼304";
    self.addressL.userInteractionEnabled = NO;
    
    self.subArrowIconV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-20, 15, 11, 19)];
    [self.subArrowIconV setImage:[UIImage imageNamed:@"sidessArrow"]];
    [self.addressBgv addSubview:self.subArrowIconV];
    
    self.phoneIconV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30-100-10, 13, 8, 13)];
    [self.phoneIconV setImage:[UIImage imageNamed:@"dianhua"]];
    [self.addressBgv addSubview:self.phoneIconV];
    
    self.phoneL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-30-100, 10, 100, 20)];
    self.phoneL.backgroundColor = [UIColor clearColor];
    self.phoneL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.phoneL.font = [UIFont systemFontOfSize:14];
    [self.addressBgv addSubview:self.phoneL];
    self.phoneL.text = @"15652298800";
    
    
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(0, self.firstView.frame.origin.y+self.firstView.frame.size.height+10, ScreenWidth, 90)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.secondView];
    
    self.goodsThumbImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 350/4.0f, 70)];
    self.goodsThumbImageV.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    [self.secondView addSubview:self.goodsThumbImageV];
    [self.goodsThumbImageV setImageWithURL:self.imageUrl];
    
    self.goodsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(350/4.0f+20, 10, ScreenWidth-10-(350/4.0f+20), 20)];
    self.goodsTitleLabel.backgroundColor = [UIColor clearColor];
    self.goodsTitleLabel.font = [UIFont systemFontOfSize:14];
    self.goodsTitleLabel.numberOfLines = 0;
    self.goodsTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.goodsTitleLabel.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    [self.secondView addSubview:self.goodsTitleLabel];
    self.goodsTitleLabel.text = self.goodsTitle;
    
    self.singlePriceL = [[UILabel alloc] initWithFrame:CGRectMake(350/4.0f+20, 60, 100, 20)];
    self.singlePriceL.backgroundColor = [UIColor clearColor];
    self.singlePriceL.font = [UIFont systemFontOfSize:14];
    self.singlePriceL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.singlePriceL.text = [NSString stringWithFormat:@"￥%@",self.univalent];
    self.singlePriceL.adjustsFontSizeToFitWidth = YES;
//    self.singlePriceL.textAlignment = NSTextAlignmentRight;
    [self.secondView addSubview:self.singlePriceL];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(350/4.0f+20+100+10, 60, 100, 20)];
    self.numL.backgroundColor = [UIColor clearColor];
    self.numL.font = [UIFont systemFontOfSize:14];
    self.numL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.numL.text = [NSString stringWithFormat:@"×%@",self.goodsNum];
    self.numL.adjustsFontSizeToFitWidth = YES;
    self.numL.textAlignment = NSTextAlignmentLeft;
    [self.secondView addSubview:self.numL];
    
    self.thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, self.secondView.frame.origin.y+self.secondView.frame.size.height+10, ScreenWidth, 90)];
    self.thirdView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.thirdView];
    
    UILabel * s = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    s.backgroundColor = [UIColor clearColor];
    s.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    s.font = [UIFont boldSystemFontOfSize:14];
    [self.thirdView addSubview:s];
    s.text = @"支付方式";
    
//    if ([SystemServer sharedSystemServer].appstoreIsInReview) {
//        self.alipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.alipayBtn setFrame:CGRectMake(20+(ScreenWidth-40)/3.0f, 40, (ScreenWidth-40)/3.0f, ((ScreenWidth-40)/3.0f*7)/11)];
//        [self.alipayBtn setBackgroundImage:[UIImage imageNamed:@"zhifangfangshi"] forState:UIControlStateNormal];
//        [self.thirdView addSubview:self.alipayBtn];
//        self.alipayBtn.tag = 1;
//        [self.alipayBtn addTarget:self action:@selector(whichPay:) forControlEvents:UIControlEventTouchUpInside];
//        UIImageView * a = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth-40)/3.0f, ((ScreenWidth-40)/3.0f*7)/11)];
//        [a setImage:[UIImage imageNamed:@"zhifubao"]];
//        [self.alipayBtn addSubview:a];
//    }
//    else{
    
        self.alipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alipayBtn setFrame:CGRectMake(10, 40, (ScreenWidth-40)/3.0f, ((ScreenWidth-40)/3.0f*7)/11)];
        [self.alipayBtn setBackgroundImage:[UIImage imageNamed:@"zhifangfangshi"] forState:UIControlStateNormal];
        [self.thirdView addSubview:self.alipayBtn];
        self.alipayBtn.tag = 1;
        [self.alipayBtn addTarget:self action:@selector(whichPay:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * a = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth-40)/3.0f, ((ScreenWidth-40)/3.0f*7)/11)];
        [a setImage:[UIImage imageNamed:@"zhifubao"]];
        [self.alipayBtn addSubview:a];
    
    if ([WXApi isWXAppInstalled]) {
        self.wechatPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.wechatPayBtn setFrame:CGRectMake(20+(ScreenWidth-40)/3.0f, 40, (ScreenWidth-40)/3.0f, ((ScreenWidth-40)/3.0f*7)/11)];
        [self.wechatPayBtn setBackgroundImage:[UIImage imageNamed:@"zhifufangshi1"] forState:UIControlStateNormal];
        [self.thirdView addSubview:self.wechatPayBtn];
        self.wechatPayBtn.tag = 2;
        [self.wechatPayBtn addTarget:self action:@selector(whichPay:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * b = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth-40)/3.0f, ((ScreenWidth-40)/3.0f*7)/11)];
        [b setImage:[UIImage imageNamed:@"weixin"]];
        [self.wechatPayBtn addSubview:b];
    }
    
        self.unionPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.unionPayBtn setFrame:CGRectMake(30+(ScreenWidth-40)/3.0f*2, 40, (ScreenWidth-40)/3.0f, ((ScreenWidth-40)/3.0f*7)/11)];
        [self.unionPayBtn setBackgroundImage:[UIImage imageNamed:@"zhifufangshi1"] forState:UIControlStateNormal];
        [self.thirdView addSubview:self.unionPayBtn];
        self.unionPayBtn.tag = 3;
        [self.unionPayBtn addTarget:self action:@selector(whichPay:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * c = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth-40)/3.0f, ((ScreenWidth-40)/3.0f*7)/11)];
        [c setImage:[UIImage imageNamed:@"yinlian"]];
        [self.unionPayBtn addSubview:c];
    
//    }

    
    
    self.forthView = [[UIView alloc] initWithFrame:CGRectMake(5, self.secondView.frame.origin.y+self.secondView.frame.size.height+10, ScreenWidth-10, 30)];
    self.forthView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.forthView];
    
    self.addtionalMsgTF = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth-20, 30)];
    self.addtionalMsgTF.borderStyle = UITextBorderStyleNone;
    self.addtionalMsgTF.font = [UIFont systemFontOfSize:14];
    self.addtionalMsgTF.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    //    [self.addtionalMsgTF setValue:[NSNumber numberWithInt:5] forKey:@"_paddingLeft"];
    //    [self.addtionalMsgTF setValue:[NSNumber numberWithInt:5] forKey:@"_paddingRight"];
    self.addtionalMsgTF.backgroundColor = [UIColor whiteColor];
    [self.forthView addSubview:self.addtionalMsgTF];
    self.addtionalMsgTF.delegate = self;
    self.addtionalMsgTF.placeholder = @"买家留言(限100个字)";
    self.addtionalMsgTF.returnKeyType = UIReturnKeyDone;
    
    
    self.quanView = [[UIView alloc] initWithFrame:CGRectMake(0, self.forthView.frame.origin.y+self.forthView.frame.size.height+10, ScreenWidth, 40)];
    self.quanView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.quanView];
    self.quanView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * ty = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapquan)];
    [self.quanView addGestureRecognizer:ty];
    
    self.quanTextL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
    self.quanTextL.backgroundColor = [UIColor clearColor];
    self.quanTextL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.quanTextL.font = [UIFont systemFontOfSize:14];
    [self.quanView addSubview:self.quanTextL];
    self.quanTextL.userInteractionEnabled = NO;
    self.quanTextL.text = @"优惠券：未使用优惠券";
    
    UIImageView * k = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-13, 8, 13, 23)];
    [k setImage:[UIImage imageNamed:@"moredetail"]];
    [self.quanView addSubview:k];
    
    self.fifthView = [[UIView alloc] initWithFrame:CGRectMake(0, self.quanView.frame.origin.y+self.quanView.frame.size.height+10, ScreenWidth, 100)];
    self.fifthView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.fifthView];
    
    self.goodPrice = [self.allPriceStr floatValue];
    
    self.bottomPriceL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    self.bottomPriceL.backgroundColor = [UIColor clearColor];
    self.bottomPriceL.font = [UIFont systemFontOfSize:14];
    self.bottomPriceL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.bottomPriceL.text = [NSString stringWithFormat:@"商品价格:￥%@",self.allPriceStr];
    self.bottomPriceL.adjustsFontSizeToFitWidth = YES;
    //    self.singlePriceL.textAlignment = NSTextAlignmentRight;
    [self.fifthView addSubview:self.bottomPriceL];
    
    self.allPriceStr = [NSString stringWithFormat:@"共%.2f元",[self.allPriceStr floatValue]+self.yunfeiValue];
    
    self.bottomYunFeiL = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 200, 20)];
    self.bottomYunFeiL.backgroundColor = [UIColor clearColor];
    self.bottomYunFeiL.font = [UIFont systemFontOfSize:14];
    self.bottomYunFeiL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.bottomYunFeiL.text = self.yunfei;
    self.bottomYunFeiL.adjustsFontSizeToFitWidth = YES;
    //    self.singlePriceL.textAlignment = NSTextAlignmentRight;
    [self.fifthView addSubview:self.bottomYunFeiL];
    

//    
//    UILabel * h = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2+25, 60, 200, 30)];
//    h.backgroundColor = [UIColor clearColor];
//    h.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
//    h.textAlignment = NSTextAlignmentCenter;
//    h.font = [UIFont systemFontOfSize:14];
//    h.text = @"同意支付协议";
//    [self.fifthView addSubview:h];
//    h.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer * hTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toProtocolPage)];
//    [h addGestureRecognizer:hTap];
//    
//    CGSize j = [h.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 30)];
//    self.agreeImageV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-j.width)/2, 66, 18, 18)];
//    [self.agreeImageV setImage:[UIImage imageNamed:@"tongyizhifutiaokuan"]];
//    [self.fifthView addSubview:self.agreeImageV];
    
//    self.agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.agreeBtn setFrame:CGRectMake((ScreenWidth-j.width)/2-10, 55, 40, 40)];
//    self.agreeBtn.backgroundColor = [UIColor clearColor];
//    [self.fifthView addSubview:self.agreeBtn];
//    [self.agreeBtn addTarget:self action:@selector(ifAgree) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * tolistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tolistBtn setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, ScreenWidth/2, 40)];
    [tolistBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tolistBtn];
    //    [tolistBtn addTarget:self action:@selector(toOrderList) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomFinalPriceL = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth/2, 20)];
    [self.bottomFinalPriceL setBackgroundColor:[UIColor clearColor]];
    self.bottomFinalPriceL.textAlignment = NSTextAlignmentCenter;
    //    [self.priceL setText:@"￥5元/张"];
    [self.bottomFinalPriceL setFont:[UIFont systemFontOfSize:16]];
    self.bottomFinalPriceL.adjustsFontSizeToFitWidth= YES;
    [self.bottomFinalPriceL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
    [tolistBtn addSubview:self.bottomFinalPriceL];
//    self.allPriceStr = [NSString stringWithFormat:@"商品价格:￥%@",self.allPriceStr];
    
    NSMutableAttributedString * attributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
    self.bottomFinalPriceL.attributedText = attributedStr3;
    
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1]];
    [buyBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setFrame:CGRectMake(ScreenWidth/2, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, ScreenWidth/2, 40)];
    [self.view addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(requestPayInfo) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentResultReceived:) name:@"PaymentResultReceived" object:nil];
    
    [self getDefaultAddress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.orderDict) {
        [self selectWhichPay:self.payChannel];
    }
//    self.yunFeiL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-100, 60, 100, 20)];
//    self.yunFeiL.backgroundColor = [UIColor clearColor];
//    self.yunFeiL.font = [UIFont systemFontOfSize:14];
//    self.yunFeiL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
//    self.yunFeiL.text = @"运费：￥10";
//    self.yunFeiL.adjustsFontSizeToFitWidth = YES;
//    self.yunFeiL.textAlignment = NSTextAlignmentRight;
//    [self.secondView addSubview:self.yunFeiL];
    
    // Do any additional setup after loading the view.
}
-(void)toProtocolPage
{
    WebContentViewController * webVC = [[WebContentViewController alloc] init];
    webVC.urlStr = @"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=205284014&idx=1&sn=7fa978b2abe59d83ccb25425a0709371#rd";
    [self.navigationController pushViewController:webVC animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.addtionalMsgTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgScrollV.frame = self.originRect;
    }];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * h = [self.addtionalMsgTF.text stringByAppendingString:string];
    if (h.length>100) {
        [SVProgressHUD showErrorWithStatus:@"最多输入100个字"];
        return NO;
    }
    return YES;
}
#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self autoMovekeyBoard:keyboardRect.size.height];
}


- (void)keyboardWillHide:(NSNotification *)notification {

    [self autoMovekeyBoard:0];
    
}

-(void) autoMovekeyBoard: (float) h{
    NSLog(@"keyboardHeight:%f",h);
    NSLog(@"viewHeight:%f",self.view.frame.size.height);
    CGRect u = [self.view convertRect:self.addtionalMsgTF.frame fromView:self.forthView];
    NSString * g = NSStringFromCGRect(u);
    NSLog(@"rect：%@",g);
    if (u.origin.y+30>self.view.frame.size.height-h) {
        if (self.bgScrollV.frame.origin.y==self.originRect.origin.y) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.bgScrollV setFrame:CGRectMake(self.originRect.origin.x, self.originRect.origin.y-(u.origin.y+30-self.view.frame.size.height+h)-60, self.originRect.size.width, self.originRect.size.height)];
            }];
            
        }
        
    }
    
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
}
-(void)payFailed
{
//    [SVProgressHUD showErrorWithStatus:@"支付遇到了一点问题，请稍后再试"];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败，接下来您要？" delegate:self cancelButtonTitle:@"暂不支付" otherButtonTitles:@"重新支付",@"修改支付方式", nil];
    alert.tag = 100;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(buttonIndex==1){
            [self requestPayInfo];
        }
        else if (buttonIndex==2){
            
        }
    }
}
-(void)payCancel
{
    [SVProgressHUD showErrorWithStatus:@"支付已取消"];
    [self.navigationController popViewControllerAnimated:NO];
//    [self toSuccessPage];
}
-(void)toSuccessPage
{
    
    PaySuccessViewController * pv = [[PaySuccessViewController alloc] init];
    pv.price = self.allPriceStr;
    pv.orderId = self.orderId;
    __block OrderConfirmViewController * blockSelf = self;
    pv.back = ^(){
        [blockSelf.navigationController popViewControllerAnimated:NO];
    };

    UINavigationController * ui = [[UINavigationController alloc] initWithRootViewController:pv];
    [self.navigationController presentViewController:ui animated:YES completion:^{
        
    }];
}

-(void)ifAgree
{
    if (self.agreeProtocol) {
        self.agreeProtocol = NO;
        [self.agreeImageV setImage:[UIImage imageNamed:@"butongyizhifutiaokuan"]];
    }
    else
    {
        self.agreeProtocol = YES;
        [self.agreeImageV setImage:[UIImage imageNamed:@"tongyizhifutiaokuan"]];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.addtionalMsgTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgScrollV.frame = self.originRect;
    }];
    
}
-(void)whichPay:(UIButton *)sender
{
    for (int i = 0; i<3; i++) {
        UIButton * d = (UIButton *)[self.thirdView viewWithTag:i+1];
        if (d.tag==sender.tag) {
            [d setBackgroundImage:[UIImage imageNamed:@"zhifangfangshi"] forState:UIControlStateNormal];
        }
        else
            [d setBackgroundImage:[UIImage imageNamed:@"zhifufangshi1"] forState:UIControlStateNormal];
    }
    self.payChannel = (int)sender.tag;
    NSLog(@"select %d",(int)sender.tag);
}
-(void)selectWhichPay:(int)payChannel
{
    for (int i = 0; i<3; i++) {
        UIButton * d = (UIButton *)[self.thirdView viewWithTag:i+1];
        if (d.tag==payChannel) {
            [d setBackgroundImage:[UIImage imageNamed:@"zhifangfangshi"] forState:UIControlStateNormal];
        }
        else
            [d setBackgroundImage:[UIImage imageNamed:@"zhifufangshi1"] forState:UIControlStateNormal];
    }
}
-(void)requestPayInfo
{
    if (!self.agreeProtocol) {
        [SVProgressHUD showErrorWithStatus:@"请同意支付协议才能支付哦"];
        return;
    }
    if (!self.rAddress) {
        [SVProgressHUD showErrorWithStatus:@"还没有收货地址呢，你想寄到火星么"];
        return;
    }

    if (!self.rAddress.receiptName) {
        [SVProgressHUD showErrorWithStatus:@"没名字怎么行！"];
        return;
    }
    if (!self.rAddress.phoneNo) {
        [SVProgressHUD showErrorWithStatus:@"留个电话呗"];
        return;
    }
    if (!self.rAddress.zipCode) {
        [SVProgressHUD showErrorWithStatus:@"邮编得写啊"];
        return;
    }
    if (!self.rAddress.province) {
        [SVProgressHUD showErrorWithStatus:@"地址填完整了没"];
        return;
    }
    if (!self.rAddress.city) {
        [SVProgressHUD showErrorWithStatus:@"地址填完整了没"];
        return;
    }
    if (!self.rAddress.address) {
        [SVProgressHUD showErrorWithStatus:@"地址填完整了没"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"请求支付信息..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"order" forKey:@"command"];
    [usersDict setObject:@"confirm" forKey:@"options"];
    [usersDict setObject:self.orderId forKey:@"id"];
    if (self.quanId) {
        [usersDict setObject:self.quanId forKey:@"couponId"];
    }
    if (self.payChannel==1) {
        [usersDict setObject:@"alipay" forKey:@"payChannel"];
    }
    else if (self.payChannel==2){
        [usersDict setObject:@"wx" forKey:@"payChannel"];
    }
    else if (self.payChannel==3){
        [usersDict setObject:@"upacp" forKey:@"payChannel"];
    }
    if (self.addtionalMsgTF.text&&self.addtionalMsgTF.text.length>0) {
        [usersDict setObject:self.addtionalMsgTF.text forKey:@"note"];
    }
    
    [usersDict setObject:self.rAddress.receiptName forKey:@"shippingName"];
    [usersDict setObject:self.rAddress.phoneNo forKey:@"shippingMobile"];
    [usersDict setObject:self.rAddress.zipCode forKey:@"shippingZipcode"];
    [usersDict setObject:self.rAddress.province forKey:@"shippingProvince"];
    [usersDict setObject:self.rAddress.city forKey:@"shippingCity"];
    [usersDict setObject:self.rAddress.address forKey:@"shippingAddress"];
    
    if ([UserServe sharedUserServe].currentPet.petID) {
        [usersDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    }
    OrderConfirmViewController * __weak weakSelf = self;
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
-(void)payThisOrder
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setViewFrame];
}
-(void)setViewFrame
{
    if (self.haveAddress) {
        self.addAddressBtn.hidden = YES;
        self.addressBgv.hidden = NO;
        NSString * addressStr = [NSString stringWithFormat:@"%@%@%@",self.rAddress.province,self.rAddress.city,self.rAddress.address];
        CGSize i = [addressStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-40-30, 60) lineBreakMode:NSLineBreakByCharWrapping];
        [self.addressL setFrame:CGRectMake(40, 35, ScreenWidth-40-30, i.height)];
        self.addressL.text = addressStr;
        self.firstView.frame = CGRectMake(0, 10, ScreenWidth, i.height+35+10);
        self.addressBgv.frame = CGRectMake(0, 0, ScreenWidth, i.height+35+10);
        self.addressIconV.frame = CGRectMake(10, self.addressBgv.frame.size.height/2-14, 20, 28);
        [self.subArrowIconV setFrame:CGRectMake(ScreenWidth-21, self.addressBgv.frame.size.height/2-10, 11, 19)];
        
        self.nameL.text = self.rAddress.receiptName;
        self.addressL.text = [NSString stringWithFormat:@"%@%@%@",self.rAddress.province,self.rAddress.city,self.rAddress.address];
        self.phoneL.text = self.rAddress.phoneNo;
    }
    else
    {
        self.addAddressBtn.hidden = NO;
        self.addressBgv.hidden = YES;
        self.firstView.frame = CGRectMake(0, 10, ScreenWidth, 50);
    }
    
    [self.secondView setFrame:CGRectMake(0, self.firstView.frame.origin.y+self.firstView.frame.size.height+10, ScreenWidth, 90)];
//    NSString * title = @"漂亮的衣服啊alksdjlkadj那就卡机了凯撒即可点击啊上课了打算卡拉到就卡机的";
    CGSize i = [self.goodsTitle sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake( ScreenWidth-10-(350/4.0f+20), 60) lineBreakMode:NSLineBreakByCharWrapping];
    [self.goodsTitleLabel setFrame:CGRectMake(350/4.0f+20, 10, ScreenWidth-10-(350/4.0f+20), i.height)];
    self.goodsTitleLabel.text = self.goodsTitle;
    [self.thirdView setFrame:CGRectMake(0, self.secondView.frame.origin.y+self.secondView.frame.size.height+10, ScreenWidth, ((ScreenWidth-40)/3.0f*7)/11+50)];
    
    
    [self.forthView setFrame:CGRectMake(5, self.thirdView.frame.origin.y+self.thirdView.frame.size.height+10, ScreenWidth-10, 30)];
    [self.quanView setFrame:CGRectMake(0, self.forthView.frame.origin.y+self.forthView.frame.size.height+10, ScreenWidth, 40)];
    [self.fifthView setFrame:CGRectMake(0, self.quanView.frame.origin.y+self.quanView.frame.size.height+10, ScreenWidth, 100)];
    
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, self.fifthView.frame.origin.y+self.fifthView.frame.size.height+10);
    
//    self.allPriceStr = @"共123元";
    
    NSMutableAttributedString * attributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
    self.bottomFinalPriceL.attributedText = attributedStr3;
}
-(void)getDefaultAddress
{
    [SVProgressHUD showWithStatus:@"获取您的信息..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"shippingAddress" forKey:@"command"];
    [usersDict setObject:@"defaultOne" forKey:@"options"];

    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.haveAddress = YES;
        NSDictionary * dic = [responseObject objectForKey:@"value"];
        ReceiptAddress *address = [[ReceiptAddress alloc] init];
        address.addressID = dic[@"id"];
        address.receiptName = dic[@"name"];
        address.phoneNo = dic[@"mobile"];
        address.province = dic[@"province"];
        address.city = dic[@"city"];
        address.address = dic[@"address"];
        address.zipCode = dic[@"zipcode"];
        address.action = [dic[@"isDefault"] isEqualToString:@"true"];
        self.haveAddress = YES;
        self.rAddress = address;

        [self setViewFrame];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code==6080) {
            self.haveAddress = NO;
            [self setViewFrame];
        }
        [SVProgressHUD dismiss];
    }];
    
}
-(void)toAddressPage
{
    AddressManageViewController * addressManageV = [[AddressManageViewController alloc] init];
    [self.navigationController pushViewController:addressManageV animated:YES];
    addressManageV.finishTitle = @"使用并保存";
    __weak OrderConfirmViewController * weakSelf = self;
    addressManageV.useAddress = ^(ReceiptAddress * address){
        self.rAddress = address;
//        self.nameL.text = address.receiptName;
//        self.addressL.text = [NSString stringWithFormat:@"%@%@%@",address.province,address.city,address.address];
//        self.phoneL.text = address.phoneNo;
        self.haveAddress = YES;
        [self setViewFrame];
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    };
}

-(void)tapquan
{
    QuanViewController * qv = [[QuanViewController alloc] init];
    qv.delegate = self;
    qv.pageType = 1;
    qv.orderId = self.orderId;
    if (self.selectedQuanId!=-1) {
        qv.selectedId = self.selectedQuanId;
    }
    [self.navigationController pushViewController:qv animated:YES];
}
-(void)getQuanId:(NSDictionary *)quanDict Selected:(int)selected
{
    NSMutableAttributedString * attributedStr3;
    NSString * finalStr;
    if (quanDict) {
        self.quanDict = quanDict;
        self.quanId = quanDict[@"id"];
        self.quanTextL.text =[NSString stringWithFormat:@"优惠券：%@元",quanDict[@"faceValue"]];
        self.selectedQuanId = selected;
        float f = self.goodPrice-[quanDict[@"faceValue"] floatValue];
        f = (f>=0?f:0);
        finalStr = [NSString stringWithFormat:@"共%.2f元",f+self.yunfeiValue];
        self.allPriceStr = finalStr;
        attributedStr3 = [[NSMutableAttributedString alloc] initWithString:finalStr];
    }
    else
    {
        self.quanDict = nil;
        self.quanId = nil;
        self.quanTextL.text =@"优惠券：未使用优惠券";
        self.selectedQuanId = -1;
        finalStr = [NSString stringWithFormat:@"共%.2f元",self.goodPrice+self.yunfeiValue];
        self.allPriceStr = finalStr;
        attributedStr3 = [[NSMutableAttributedString alloc] initWithString:finalStr];
    }
    
    
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, finalStr.length)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, finalStr.length)];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, finalStr.length-2)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, finalStr.length-2)];
    self.bottomFinalPriceL.attributedText = attributedStr3;
    
    
}

-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
