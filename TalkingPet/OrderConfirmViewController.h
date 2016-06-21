//
//  OrderConfirmViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/6/8.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "EGOImageView.h"
#import "SVProgressHUD.h"
#import "Pingpp.h"
#import "ReceiptAddress.h"
#import "AddressManageViewController.h"
#import "PaySuccessViewController.h"
#import "WebContentViewController.h"
#import "QuanViewController.h"
@interface OrderConfirmViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate,QuanDelegate>
@property (nonatomic,strong)UIScrollView * bgScrollV;
@property (nonatomic,strong)UIView * firstView;
@property (nonatomic,strong)UIView * secondView;
@property (nonatomic,strong)UIView * thirdView;
@property (nonatomic,strong)UIView * forthView;
@property (nonatomic,strong)UIView * fifthView;
@property (nonatomic,strong)UIView * quanView;
@property (nonatomic,strong)UILabel * quanTextL;
@property (nonatomic,assign)BOOL haveAddress;
@property (nonatomic,strong)UIButton * addAddressBtn;
@property (nonatomic,strong)UIView * addressBgv;
@property (nonatomic,strong)UIImageView * addressIconV;
@property (nonatomic,strong)UIImageView * phoneIconV;
@property (nonatomic,strong)UILabel * nameL;
@property (nonatomic,strong)UILabel * phoneL;
@property (nonatomic,strong)UILabel * addressL;
@property (nonatomic,strong)UIImageView * subArrowIconV;

@property (nonatomic,strong)UIImageView * goodsThumbImageV;
@property (nonatomic,strong)UILabel * goodsTitleLabel;
@property (nonatomic,strong)UILabel * singlePriceL;
@property (nonatomic,strong)UILabel * numL;
@property (nonatomic,strong)UILabel * yunFeiL;

@property (nonatomic,strong)UIButton * alipayBtn;
@property (nonatomic,strong)UIButton * wechatPayBtn;
@property (nonatomic,strong)UIButton * unionPayBtn;

@property (nonatomic,strong)UITextField * addtionalMsgTF;

@property (nonatomic,strong)UILabel * bottomPriceL;
@property (nonatomic,strong)UILabel * bottomNumL;
@property (nonatomic,strong)UILabel * bottomYunFeiL;
@property (nonatomic,strong)UILabel * bottomFinalPriceL;
//@property (nonatomic,strong)NSString * allPriceStr;
@property (nonatomic,strong)UIButton * agreeBtn;
@property (nonatomic,strong)UIImageView * agreeImageV;

@property (nonatomic,assign)BOOL agreeProtocol;
@property (nonatomic,assign)int payChannel;


@property (nonatomic,strong)NSURL * imageUrl;
@property (nonatomic,strong)NSString * goodsTitle;
@property (nonatomic,strong)NSString * univalent;
@property (nonatomic,strong)NSString * goodsNum;
@property (nonatomic,strong)NSString * allPriceStr;
@property (nonatomic,strong)NSString * yunfei;
@property (nonatomic,assign)float goodPrice;
@property (nonatomic,assign)float yunfeiValue;
@property (nonatomic,strong)NSString * orderId;

@property (nonatomic,assign)CGRect originRect;

@property (nonatomic,strong)ReceiptAddress * rAddress;

@property (nonatomic,strong)NSDictionary * orderDict;

@property (nonatomic,strong)NSString * quanId;
@property (nonatomic,assign)int selectedQuanId;
@property (nonatomic,strong)NSDictionary * quanDict;

@end
