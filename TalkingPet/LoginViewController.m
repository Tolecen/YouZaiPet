//
//  LoginViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "DatabaseServe.h"
#import "SystemServer.h"
#import "WXRTextViewController.h"

@interface LoginViewController ()<AttributedLabelDelegate>
{
    UIButton * loginB ;
    WXRAttributedLabel * label;
    UIButton * agreeB;
    BOOL qqInstalled;
    
    UIButton * qqBtn;
    UILabel * qqL;
}
@property (nonatomic,retain)UILabel * phoneNoL;
@property (nonatomic,retain)UILabel * passwordL;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"登录宠物说";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(back)];
    qqInstalled = NO;
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, self.view.frame.size.height - 10 - navigationBarHeight)];
//    imageV.image = [UIImage imageNamed:@"publishBg"];
    imageV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled = YES;
    
    self.phoneNoIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, imageV.frame.size.width - 20, 47)];
    _phoneNoIV.image = [UIImage imageNamed:@"labelBG"];
    [imageV addSubview:_phoneNoIV];
    
    self.usernameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 19, imageV.frame.size.width - 20-20, 30)];
    _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
    _usernameTF.placeholder = @"输入用户名/手机号";
    _usernameTF.borderStyle = UITextBorderStyleNone;
    _usernameTF.backgroundColor = [UIColor clearColor];
    _usernameTF.font = [UIFont systemFontOfSize:16];
    _usernameTF.textAlignment = NSTextAlignmentLeft;
    _usernameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _usernameTF.returnKeyType = UIReturnKeyNext;
    [imageV addSubview:self.usernameTF];
    
    UIImageView * passWordIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, imageV.frame.size.width - 20, 47)];
    passWordIV.image = [UIImage imageNamed:@"labelBG"];
    [imageV addSubview:passWordIV];
    
    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 79, imageV.frame.size.width - 20-20, 30)];
    _passwordTF.placeholder = @"输入密码";
    _passwordTF.borderStyle = UITextBorderStyleNone;
    _passwordTF.backgroundColor = [UIColor clearColor];
    _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTF.secureTextEntry = YES;
    _passwordTF.font = [UIFont systemFontOfSize:16];
    _passwordTF.textAlignment = NSTextAlignmentLeft;
    _passwordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTF.returnKeyType = UIReturnKeyDone;
    [imageV addSubview:_passwordTF];
    
    loginB = [UIButton buttonWithType:UIButtonTypeCustom];
    loginB .frame = CGRectMake(10, 130, imageV.frame.size.width - 20, 47);
    [loginB setTitle:@"登录" forState:UIControlStateNormal];
    [loginB addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:loginB];
    
    UIButton * registerB = [UIButton buttonWithType:UIButtonTypeCustom];
    registerB .frame = CGRectMake(self.view.center.x-1-110-5, 220-20, 110, 20);
    [registerB setTitle:@"新用户注册" forState:UIControlStateNormal];
    [registerB setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [registerB addTarget:self action:@selector(registerNewUser) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:registerB];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-1, 220-20, 2, 20)];
    lineView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [imageV addSubview:lineView];
    
    UIButton * forgetPassWordB = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPassWordB .frame = CGRectMake(self.view.center.x+1+5, 220-20, 90, 20);
    [forgetPassWordB setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPassWordB setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [forgetPassWordB addTarget:self action:@selector(forgetPassWord) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:forgetPassWordB];
    
    
    agreeB = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeB.frame = CGRectMake((ScreenWidth-10-200)/2, self.view.frame.size.height - navigationBarHeight - 60, 40, 40);
    [imageV addSubview:agreeB];
    [agreeB addTarget:self action:@selector(agreeUserAgreement:) forControlEvents:UIControlEventTouchUpInside];
    
    label = [[WXRAttributedLabel alloc] initWithFrame:CGRectMake((ScreenWidth-10-200)/2+40, self.view.frame.size.height - navigationBarHeight - 47, 160, 20)];
    label.delegate = self;
    [imageV addSubview:label];
    
    UILabel * ggh = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-90-navigationBarHeight-50-15, ScreenWidth, 20)];
    [ggh setBackgroundColor:[UIColor clearColor]];
    [ggh setTextAlignment:NSTextAlignmentCenter];
    [ggh setText:@"第三方社交平台登录"];
    [ggh setFont:[UIFont systemFontOfSize:16]];
    [ggh setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]];
    [self.view addSubview:ggh];
    
    
    UIButton * sinaWeiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaWeiboBtn setFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-23, self.view.frame.size.height-90-navigationBarHeight-30, 45, 45)];
    [sinaWeiboBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:sinaWeiboBtn];
    [sinaWeiboBtn addTarget:self action:@selector(signInWithSinaWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [sinaWeiboBtn setImage:[UIImage imageNamed:@"sineLogin"] forState:UIControlStateNormal];
    
    UILabel * sinaL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-23, self.view.frame.size.height-90-navigationBarHeight+45-30, 45, 20)];
    [sinaL setText:@"微博"];
    [self.view addSubview:sinaL];
    [sinaL setTextAlignment:NSTextAlignmentCenter];
    sinaL.backgroundColor = [UIColor clearColor];
    [sinaL setFont:[UIFont systemFontOfSize:15]];
    
    if ([QQApi isQQInstalled]) {
        qqInstalled = YES;
        qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [qqBtn setFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2+10, self.view.frame.size.height-90-navigationBarHeight-30, 45, 45)];
        [qqBtn setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:qqBtn];
        [qqBtn addTarget:self action:@selector(signInWithQQ:) forControlEvents:UIControlEventTouchUpInside];
        [qqBtn setImage:[UIImage imageNamed:@"qqLogin"] forState:UIControlStateNormal];
        
        qqL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2+10, self.view.frame.size.height-90-navigationBarHeight+45-30, 45, 20)];
        [qqL setText:@"QQ"];
        [self.view addSubview:qqL];
        [qqL setTextAlignment:NSTextAlignmentCenter];
        qqL.backgroundColor = [UIColor clearColor];
        [qqL setFont:[UIFont systemFontOfSize:15]];
        
        [sinaWeiboBtn setFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-10-45, sinaWeiboBtn.frame.origin.y, 45, 45)];
        [sinaL setFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-10-45, sinaL.frame.origin.y, 45, 20)];
    }
    
    
    
    if ([WXApi isWXAppInstalled]) {
        UIButton * wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatBtn setFrame:CGRectMake(self.view.frame.size.width-50-45, self.view.frame.size.height-90-navigationBarHeight-30, 45, 45)];
        [wechatBtn setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:wechatBtn];
        [wechatBtn addTarget:self action:@selector(signInWithWeChat:) forControlEvents:UIControlEventTouchUpInside];
        [wechatBtn setImage:[UIImage imageNamed:@"weicharLogin"] forState:UIControlStateNormal];
        
        UILabel * wechatL = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50-45, self.view.frame.size.height-90-navigationBarHeight+45-30, 45, 20)];
        [wechatL setText:@"微信"];
        [self.view addSubview:wechatL];
        [wechatL setTextAlignment:NSTextAlignmentCenter];
        wechatL.backgroundColor = [UIColor clearColor];
        [wechatL setFont:[UIFont systemFontOfSize:15]];
        
        if (qqInstalled) {
            [sinaWeiboBtn setFrame:CGRectMake(50, sinaWeiboBtn.frame.origin.y, 45, 45)];
            [sinaL setFrame:CGRectMake(50, sinaL.frame.origin.y, 45, 20)];
            
            [qqBtn setFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-23, self.view.frame.size.height-90-navigationBarHeight-30, 45, 45)];
            [qqL setFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-23,sinaL.frame.origin.y, 45, 20)];
            
        }
        else
        {
            [sinaWeiboBtn setFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-10-45, sinaWeiboBtn.frame.origin.y, 45, 45)];
            [sinaL setFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-10-45, sinaL.frame.origin.y, 45, 20)];
            [wechatBtn setFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2+10, self.view.frame.size.height-90-navigationBarHeight-30, 45, 45)];
            [wechatL setFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2+10, self.view.frame.size.height-90-navigationBarHeight+45-30, 45, 20)];
        }
    }
    
    
    
    
    
    Account * acc = [DatabaseServe getLastActionedAccount];
    if (acc) {
        _usernameTF.text = acc.username;
//        _passwordTF.text = acc.password;
        if ([acc.username hasPrefix:@"wx"]||[acc.username hasPrefix:@"qq"]||[acc.username hasPrefix:@"sina"]) {
            _usernameTF.text = @"";
//            _passwordTF.text = @"";
        }
        
    }
    [self buildViewWithSkintype];
}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"同意《宠物说用户协议》"];
    [str addAttribute:NSForegroundColorAttributeName
                value:(id)[UIColor grayColor].CGColor
                range:NSMakeRange(0, 3)];
    [str addAttribute:NSForegroundColorAttributeName
                value:(id)[UIColor grayColor].CGColor
                range:NSMakeRange(10, 1)];
    
    [str addAttribute:NSFontAttributeName
                value:[UIFont systemFontOfSize:14]
                range:NSMakeRange(0, str.length)];
    [loginB setBackgroundImage:[UIImage imageNamed:@"login_normal"] forState:UIControlStateNormal];
    [str addAttribute:NSForegroundColorAttributeName
                value:(id)CommonGreenColor.CGColor
                range:NSMakeRange(3, 7)];
    [agreeB setImage:[UIImage imageNamed:@"login_state_select"] forState:UIControlStateNormal];
    label.text = str;
}
-(void)signInWithSinaWeibo:(UIButton *)sender
{
    
    [ShareServe getCurrentUserInfoWithPlatformSinaSuccess:^(NSDictionary *dict) {
        NSLog(@"finalSuccessSina:%@",dict);
        [SVProgressHUD showWithStatus:@"处理中..."];
        [self checkUsernameWithDict:dict];
    }];
}
-(void)signInWithQQ:(UIButton *)sender
{
    //    [ShareServe getCurrentUserInfoWithPlatformQQ];
    
    
    [SVProgressHUD showWithStatus:@"授权中..."];
    if (!_tencentOAuth) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1102327672"  andDelegate:self];
        //        _tencentOAuth.localAppId = @"QQ41B42F78";
    }
    
    NSArray * permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo",@"get_info", nil];
    [_tencentOAuth authorize:permissions inSafari:NO];
}
-(void)tencentDidNotNetWork
{
    
}
- (void)tencentDidLogin
{
    NSLog(@"qq login success");
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(@"qq login success token:%@",_tencentOAuth.accessToken);
        [_tencentOAuth getUserInfo];
        //        _labelAccessToken.text = _tencentOAuth.accessToken;
    }
    else
    {
        NSLog(@"not qq login ,no token");
    }
}
- (void)getUserInfoResponse:(APIResponse*) response
{
    NSLog(@"get user info response d:%@,j:%@,k:%@,openid:%@",response.jsonResponse,response.userData,response.message,_tencentOAuth.openId);
    NSMutableDictionary * hDict = [NSMutableDictionary dictionary];
    [hDict setObject:[response.jsonResponse objectForKey:@"nickname"] forKey:@"name"];
    [hDict setObject:[@"qq" stringByAppendingString:_tencentOAuth.openId] forKey:@"id"];
    [self checkUsernameWithDict:hDict];
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    [SVProgressHUD dismiss];
    NSLog(@"qq login failed");
}
-(void)signInWithWeChat:(UIButton *)sender
{
    //    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"wechat login doesn't work now!..." delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    //    [alert show];
    //    return;
    //    if (![WXApi isWXAppInstalled]) {
    //        UIAlertView * nalert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还没有安装微信哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    //        [nalert show];
    //        return;
    //    }
    if (![WXApi isWXAppSupportApi]) {
        UIAlertView * nalert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您安装的微信版本不支持登陆哦，请升级您的微信" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [nalert show];
        return;
    }
    //    [SVProgressHUD showWithStatus:@"授权中..."];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxOauthCodeGeted:) name:@"WXOauthCodeGeted" object:nil];
    
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"chongwushuo_get_info";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    
    
    //    [ShareServe getCurrentUserInfoWithPlatformWeChat];
}
-(void)wxOauthCodeGeted:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXOauthCodeGeted" object:nil];
    NSString * oauthCode = noti.object;
    NSLog(@"oauthCode = %@",oauthCode);
    [self getWXTokenByCode:oauthCode];
}
-(void)getWXTokenByCode:(NSString *)oauthCode
{
    [SVProgressHUD showWithStatus:@"授权中..."];
    NSString * reqPath = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxb62f795f2bc6b770&secret=dda1c576f7eb296d7a62eb0a4cc7ed2c&code=%@&grant_type=authorization_code",oauthCode];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:reqPath]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient getPath:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * dict = [receiveStr JSONValue];
        NSLog(@"wx get token success: %@",dict);
        [self getWXUserInfoByToken:[dict objectForKey:@"access_token"] UUId:[dict objectForKey:@"openid"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"wx get token failed: %@",error);
    }];
}
-(void)getWXUserInfoByToken:(NSString *)theToken UUId:(NSString *)uuid
{
    NSString * reqPath = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",theToken,uuid];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:reqPath]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient getPath:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * dict = [receiveStr JSONValue];
        NSLog(@"wx get info success: %@",dict);
        
        NSMutableDictionary * hDict = [NSMutableDictionary dictionary];
        [hDict setObject:[dict objectForKey:@"nickname"] forKey:@"name"];
        [hDict setObject:[@"wx" stringByAppendingString:[dict objectForKey:@"openid"]] forKey:@"id"];
        [self checkUsernameWithDict:hDict];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"wx get info failed: %@",error);
    }];
}
-(void) onReq:(BaseReq*)req
{
    NSLog(@"on req");
}
-(void) onResp:(BaseResp*)resp
{
    NSLog(@"req:%@",resp);
}
-(void)loginWithThirdInfo:(NSDictionary *)infoDict
{
    [SVProgressHUD showWithStatus:@"登录中..."];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"login" forKey:@"command"];
    [regDict setObject:[infoDict objectForKey:@"id"] forKey:@"loginName"];
    [regDict setObject:[self calPasswordWithUserId:[infoDict objectForKey:@"id"]] forKey:@"password"];
    
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UserServe * userServe = [UserServe sharedUserServe];
        userServe.userName = [infoDict objectForKey:@"id"];
        userServe.userID = (responseObject[@"value"])[@"id"];
        NSArray * petlist = (responseObject[@"value"])[@"petList"];
        
        [SFHFKeychainUtils storeUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,userServe.userID] andPassword:(responseObject[@"value"])[@"sessionToken"] forServiceName:CHONGWUSHUOTOKENSTORESERVICE updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:[NSString stringWithFormat:@"%@%@SKey",DomainName,userServe.userID] andPassword:(responseObject[@"value"])[@"sessionKey"] forServiceName:CHONGWUSHUOTOKENSTORESERVICE updateExisting:YES error:nil];
        
        NSMutableArray * petArr = [NSMutableArray array];
        for (NSDictionary * petDic in petlist) {
            if ([petDic[@"active"] isEqualToString:@"false"]) {
                Pet * pet = [[Pet alloc] init];
                pet.petID = petDic[@"id"];
                pet.nickname = petDic[@"nickName"];
                pet.headImgURL = petDic[@"headPortrait"];
                pet.gender = petDic[@"gender"];
                pet.breed = petDic[@"type"];
                pet.region = petDic[@"address"];
                pet.birthday = [NSDate dateWithTimeIntervalSince1970:[petDic[@"birthday"] doubleValue]/1000];
                pet.fansNo = (petDic[@"counter"])[@"fans"];
                pet.attentionNo = (petDic[@"counter"])[@"focus"];
                pet.issue = (petDic[@"counter"])[@"issue"];
                pet.relay = (petDic[@"counter"])[@"relay"];
                pet.comment = (petDic[@"counter"])[@"comment"];
                pet.favour = (petDic[@"counter"])[@"favour"];
                pet.grade = [petDic[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];
                pet.score = petDic[@"score"];
                pet.coin = petDic[@"coin"];
                pet.ifDaren = [petDic[@"star"] isEqualToString:@"1"]?YES:NO;
                [petArr addObject:pet];
                [DatabaseServe savePet:pet WithUsername:userServe.userName];
            }else{
                userServe.currentPet = ({
                    Pet * pet = [[Pet alloc] init];
                    pet.petID = petDic[@"id"];
                    pet.nickname = petDic[@"nickName"];
                    pet.headImgURL = petDic[@"headPortrait"];
                    pet.gender = petDic[@"gender"];
                    pet.breed = petDic[@"type"];
                    pet.region = petDic[@"address"];
                    pet.birthday = [NSDate dateWithTimeIntervalSince1970:[petDic[@"birthday"] doubleValue]/1000];
                    pet.fansNo = (petDic[@"counter"])[@"fans"];
                    pet.attentionNo = (petDic[@"counter"])[@"focus"];
                    pet.issue = (petDic[@"counter"])[@"issue"];
                    pet.relay = (petDic[@"counter"])[@"relay"];
                    pet.comment = (petDic[@"counter"])[@"comment"];
                    pet.favour = (petDic[@"counter"])[@"favour"];
                    pet.grade = [petDic[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];
                    pet.score = petDic[@"score"];
                    pet.coin = petDic[@"coin"];
                    pet;
                });
            }
        }
        userServe.petArr = petArr;
        
        Account * acc = [[Account alloc]init];
        acc.username = [infoDict objectForKey:@"id"];
        acc.userID = userServe.userID;
        acc.password = [self calPasswordWithUserId:[infoDict objectForKey:@"id"]];
        [DatabaseServe activateUeserWithAccount:acc];
        [DatabaseServe activatePet:userServe.currentPet WithUsername:acc.username];
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRLoginSucceed" object:self userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register failed info:%@",error);
        [SVProgressHUD dismiss];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error.domain delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
    }];
    
}
-(void)checkUsernameWithDict:(NSDictionary *)infoDict
{
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"account" forKey:@"command"];
    [regDict setObject:[infoDict objectForKey:@"id"] forKey:@"loginName"];
    [regDict setObject:@"checkLoginName"forKey:@"options"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"register success info:%@",responseObject);
        if([[responseObject objectForKey:@"value"] isEqualToString:@"false"])
        {
            [self loginWithThirdInfo:infoDict];
            //            [SVProgressHUD showWithStatus:@"登录中..."];
            //            usernameCanUse = NO;
            //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名已存在" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
            //            [alert show];
            //            //            [self.usernameTF becomeFirstResponder];
        }
        else{
            [SVProgressHUD dismiss];
            
            //To Register Page
            NewUserViewController * newUserVC = [[NewUserViewController alloc]init];
            [self.navigationController pushViewController:newUserVC animated:YES];
            newUserVC.username = [infoDict objectForKey:@"id"];
            newUserVC.password = [self calPasswordWithUserId:[infoDict objectForKey:@"id"]];
            newUserVC.nickname = [[infoDict objectForKey:@"name"] stringByAppendingString:@"的宝贝"];
            if ([[infoDict objectForKey:@"id"] hasPrefix:@"sina"]) {
                newUserVC.userPlatform = @"sina";
            }
            else if ([[infoDict objectForKey:@"id"] hasPrefix:@"qq"]){
                newUserVC.userPlatform = @"qq";
            }
            else if ([[infoDict objectForKey:@"id"] hasPrefix:@"wx"]){
                newUserVC.userPlatform = @"wechat";
            }
            
            //Auto register
            //            [self goToRegisterWithDict:infoDict];
            
            
            //            NewUserViewController * newUserVC = [[NewUserViewController alloc]init];
            //            [self.navigationController pushViewController:newUserVC animated:YES];
            //            newUserVC.username = self.usernameTF.text;
            //            newUserVC.password = self.passwordTF.text;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}
-(NSString *)calPasswordWithUserId:(NSString *)userId
{
    return userId;
}

-(void)goToRegisterWithDict:(NSDictionary *)infoDict
{
    [SVProgressHUD showWithStatus:@"设置资料..."];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"register" forKey:@"command"];
    [regDict setObject:[infoDict objectForKey:@"id"] forKey:@"loginName"];
    [regDict setObject:[self calPasswordWithUserId:[infoDict objectForKey:@"id"]] forKey:@"password"];
    [regDict setObject:[infoDict objectForKey:@"name"] forKey:@"nickName"];
    [regDict setObject:@"" forKey:@"headPortrait"];
    [regDict setObject:@"" forKey:@"gender"];
    [regDict setObject:@"" forKey:@"type"];
    [regDict setObject:@"" forKey:@"birthday"];
    [regDict setObject:@"" forKey:@"address"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * petDic = ((responseObject[@"value"])[@"petList"])[0];
        UserServe * userServe = [UserServe sharedUserServe];
        userServe.userName = [infoDict objectForKey:@"id"];
        userServe.userID = (responseObject[@"value"])[@"id"];
        userServe.petArr = nil;
        userServe.currentPet = ({
            Pet * pet = [[Pet alloc] init];
            pet.petID = petDic[@"id"];
            pet.nickname = petDic[@"nickName"];
            pet.headImgURL = petDic[@"headPortrait"];
            pet.gender = petDic[@"gender"];
            pet.breed = petDic[@"type"];
            pet.region = petDic[@"address"];
            pet.birthday = [NSDate dateWithTimeIntervalSince1970:[petDic[@"birthday"] doubleValue]/1000];
            pet.fansNo = (petDic[@"counter"])[@"fans"];
            pet.attentionNo = (petDic[@"counter"])[@"focus"];
            pet.issue = (petDic[@"counter"])[@"issue"];
            pet.relay = (petDic[@"counter"])[@"relay"];
            pet.comment = (petDic[@"counter"])[@"comment"];
            pet.favour = (petDic[@"counter"])[@"favour"];
            pet.grade = [petDic[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];
            pet.score = petDic[@"score"];
            pet.coin = petDic[@"coin"];
            pet;
        });
        
        Account * acc = [[Account alloc]init];
        acc.username = [infoDict objectForKey:@"id"];
        acc.userID = userServe.userID;
        acc.password = [self calPasswordWithUserId:[infoDict objectForKey:@"id"]];
        [DatabaseServe activateUeserWithAccount:acc];
        [DatabaseServe activatePet:userServe.currentPet WithUsername:acc.username];
        
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRLoginSucceed" object:self userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register failed info:%@",error);
        [SVProgressHUD dismiss];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        //        [self showAlertWithMessage:error.domain];
        
    }];
}

-(void)agreeUserAgreement:(UIButton *)sender
{
    [SystemServer sharedSystemServer].agreeUserAgreement = ![SystemServer sharedSystemServer].agreeUserAgreement;
    loginB.enabled = [SystemServer sharedSystemServer].agreeUserAgreement;
    if ([SystemServer sharedSystemServer].agreeUserAgreement) {
        [sender setImage:[UIImage imageNamed:@"login_state_select"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"login_state_nomal"] forState:UIControlStateNormal];
    }
    
}
-(void)touchAttributedLabel
{
    WXRTextViewController * controller = [[WXRTextViewController alloc] init];
    controller.title = @"用户协议";
    NSString *path =[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"UserProtocol"ofType:@"txt"]];
    NSData* data = [[NSData alloc]initWithContentsOfFile:path];
    controller.content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)login
{
    if (!self.usernameTF.text||!self.usernameTF.text.length) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"要填用户名哦" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (!self.passwordTF.text||!self.passwordTF.text.length) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"要填密码哦" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [SVProgressHUD showWithStatus:@"登录中..."];
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"login" forKey:@"command"];
    [regDict setObject:self.usernameTF.text forKey:@"loginName"];
    [regDict setObject:self.passwordTF.text forKey:@"password"];
    
    [NetServer requestWithEncryptParameters:regDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UserServe * userServe = [UserServe sharedUserServe];
        [SystemServer sharedSystemServer].metionTokenOutTime = NO;
        userServe.userName = _usernameTF.text;
        userServe.userID = (responseObject[@"value"])[@"id"];
        NSArray * petlist = (responseObject[@"value"])[@"petList"];
        
        [SFHFKeychainUtils storeUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,userServe.userID] andPassword:(responseObject[@"value"])[@"sessionToken"] forServiceName:CHONGWUSHUOTOKENSTORESERVICE updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:[NSString stringWithFormat:@"%@%@SKey",DomainName,userServe.userID] andPassword:(responseObject[@"value"])[@"sessionKey"] forServiceName:CHONGWUSHUOTOKENSTORESERVICE updateExisting:YES error:nil];
        
        NSMutableArray * petArr = [NSMutableArray array];
        for (NSDictionary * petDic in petlist) {
            if ([petDic[@"active"] isEqualToString:@"false"]) {
                Pet * pet = [[Pet alloc] init];
                pet.petID = petDic[@"id"];
                pet.nickname = petDic[@"nickName"];
                pet.headImgURL = petDic[@"headPortrait"];
                pet.gender = petDic[@"gender"];
                pet.breed = petDic[@"type"];
                pet.region = petDic[@"address"];
                pet.birthday = [NSDate dateWithTimeIntervalSince1970:[petDic[@"birthday"] doubleValue]/1000];
                pet.fansNo = (petDic[@"counter"])[@"fans"];
                pet.attentionNo = (petDic[@"counter"])[@"focus"];
                pet.issue = (petDic[@"counter"])[@"issue"];
                pet.relay = (petDic[@"counter"])[@"relay"];
                pet.comment = (petDic[@"counter"])[@"comment"];
                pet.favour = (petDic[@"counter"])[@"favour"];
                pet.grade = [petDic[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];
                pet.score = petDic[@"score"];
                pet.coin = petDic[@"coin"];
                pet.ifDaren = [petDic[@"star"] isEqualToString:@"1"]?YES:NO;
                [petArr addObject:pet];
                [DatabaseServe savePet:pet WithUsername:userServe.userName];
            }else{
                userServe.currentPet = ({
                    Pet * pet = [[Pet alloc] init];
                    pet.petID = petDic[@"id"];
                    pet.nickname = petDic[@"nickName"];
                    pet.headImgURL = petDic[@"headPortrait"];
                    pet.gender = petDic[@"gender"];
                    pet.breed = petDic[@"type"];
                    pet.region = petDic[@"address"];
                    pet.birthday = [NSDate dateWithTimeIntervalSince1970:[petDic[@"birthday"] doubleValue]/1000];
                    pet.fansNo = (petDic[@"counter"])[@"fans"];
                    pet.attentionNo = (petDic[@"counter"])[@"focus"];
                    pet.issue = (petDic[@"counter"])[@"issue"];
                    pet.relay = (petDic[@"counter"])[@"relay"];
                    pet.comment = (petDic[@"counter"])[@"comment"];
                    pet.favour = (petDic[@"counter"])[@"favour"];
                    pet.grade = [petDic[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];
                    pet.score = petDic[@"score"];
                    pet.coin = petDic[@"coin"];
                    pet;
                });
            }
        }
        userServe.petArr = petArr;
        
        Account * acc = [[Account alloc]init];
        acc.username = _usernameTF.text;
        acc.userID = userServe.userID;
        acc.password = _passwordTF.text;
        [DatabaseServe activateUeserWithAccount:acc];
        [DatabaseServe activatePet:userServe.currentPet WithUsername:acc.username];
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRLoginSucceed" object:self userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register failed info:%@",error);
        NSInteger sCode = [error code];
        [SVProgressHUD dismiss];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:sCode==-1001?@"您的网络可能不太好哦":error.domain delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}
- (void)registerNewUser
{
    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (void)forgetPassWord
{
    ForgetPasswordViewController * forgetVC = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
