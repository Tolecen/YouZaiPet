//
//  LoginViewController.h
//  TalkingPet
//
//  Created by wangxr on 14-7-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "NetServer.h"
#import "SVProgressHUD.h"
#import "ShareServe.h"
#import "NewUserViewController.h"
#import "WXApi.h"
@interface LoginViewController : BaseViewController<TencentSessionDelegate>
@property (nonatomic,strong) UITextField * usernameTF;
@property (nonatomic,strong) UITextField * passwordTF;
@property (nonatomic,strong) UIImageView * phoneNoIV;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@end
