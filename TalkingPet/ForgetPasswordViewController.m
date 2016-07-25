//
//  ForgetPasswordViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-8-25.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ReSetPassWordViewController.h"
#import "IdentifyingString.h"
#import "SVProgressHUD.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate>
{
    int remainingTime;
    BOOL usernameCanUse;
    UIButton * nextB;
}
@property (nonatomic,strong) UITextField * usernameTF;
@property (nonatomic,strong) UITextField * verifyTF;
@property (nonatomic,strong) UIButton * verificationCodeB;
@property (nonatomic,strong) NSTimer * checkT;
@end

@implementation ForgetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"找回密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(back)];
    
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, self.view.frame.size.height - 10 - navigationBarHeight)];
//    imageV.image = [UIImage imageNamed:@"publishBg"];
    [imageV setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled = YES;
    
    UIImageView * phoneNoIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, imageV.frame.size.width - 20, 47)];
    phoneNoIV.image = [UIImage imageNamed:@"labelBG"];
    [imageV addSubview:phoneNoIV];
    
    self.usernameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 19, imageV.frame.size.width - 20-20, 30)];
    _usernameTF.placeholder = @"输入注册时的手机号";
    _usernameTF.borderStyle = UITextBorderStyleNone;
    _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
    _usernameTF.backgroundColor = [UIColor clearColor];
    _usernameTF.font = [UIFont systemFontOfSize:16];
    _usernameTF.textAlignment = NSTextAlignmentLeft;
    _usernameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _usernameTF.returnKeyType = UIReturnKeyNext;
    _usernameTF.delegate = self;
    [imageV addSubview:self.usernameTF];
    
    UIImageView * verificationCodeIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, imageV.frame.size.width - 20, 47)];
    verificationCodeIV.image = [UIImage imageNamed:@"labelBG"];
    [imageV addSubview:verificationCodeIV];
    
    self.verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 79, imageV.frame.size.width - 20-20, 30)];
    _verifyTF.placeholder = @"输入验证码";
    _verifyTF.borderStyle = UITextBorderStyleNone;
    _verifyTF.backgroundColor = [UIColor clearColor];
    _verifyTF.secureTextEntry = YES;
    _verifyTF.font = [UIFont systemFontOfSize:16];
    _verifyTF.textAlignment = NSTextAlignmentLeft;
    _verifyTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _verifyTF.returnKeyType = UIReturnKeyDone;
    [imageV addSubview:_verifyTF];
    
    self.verificationCodeB = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verificationCodeB setBackgroundImage:[UIImage imageNamed:@"verificationCode_normal"] forState:UIControlStateNormal];
    [_verificationCodeB setTitle:@"点击发送验证码" forState:UIControlStateNormal];
    _verificationCodeB.frame = CGRectMake(imageV.frame.size.width - 135, 72.5, 123, 42);
    [_verificationCodeB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _verificationCodeB.titleLabel.font = [UIFont systemFontOfSize:14];
    [imageV addSubview:_verificationCodeB];
    [_verificationCodeB addTarget:self action:@selector(checkUsername) forControlEvents:UIControlEventTouchUpInside];
    
    nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB .frame = CGRectMake(10, 180, imageV.frame.size.width - 20, 47);
    [nextB setTitle:@"下一步" forState:UIControlStateNormal];
    [nextB addTarget:self action:@selector(resetNewPassword) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:nextB];
    
    [self buildViewWithSkintype];
}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];
    [nextB setBackgroundImage:[UIImage imageNamed:@"login_normal"] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_usernameTF resignFirstResponder];
    [_verifyTF resignFirstResponder];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)resetNewPassword
{
    if (![IdentifyingString validateMobile:self.usernameTF.text]||usernameCanUse) {
        [SVProgressHUD showErrorWithStatus:@"请输入注册时的手机号码"];
        return;
    }
    if (self.verifyTF.text.length<6) {
        [SVProgressHUD showErrorWithStatus:@"请输入6位验证码"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在验证..."];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"account" forKey:@"command"];
    [regDict setObject:@"002" forKey:@"type"];
    [regDict setObject:@"verifyCaptcha"forKey:@"options"];
    [regDict setObject:self.usernameTF.text forKey:@"phoneNum"];
    [regDict setObject:self.verifyTF.text forKey:@"code"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        ReSetPassWordViewController * reSetVC = [[ReSetPassWordViewController alloc] init];
        reSetVC.phoneNo = self.usernameTF.text;
        [self.navigationController pushViewController:reSetVC animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }];
}
- (void)sendVerifyCode
{
    if (![IdentifyingString validateMobile:self.usernameTF.text] || usernameCanUse) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的已注册手机号码"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在发送..."];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"account" forKey:@"command"];
    [regDict setObject:@"002" forKey:@"type"];
    [regDict setObject:@"generateCaptcha"forKey:@"options"];
    [regDict setObject:self.usernameTF.text forKey:@"phoneNum"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"get verify code success info:%@",responseObject);
        remainingTime = 60;
        [self.verificationCodeB setTitle:[NSString stringWithFormat:@"重新发送(%ds)",remainingTime] forState:UIControlStateNormal];
        [self.verificationCodeB setEnabled:NO];
        self.checkT = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(remainingTime) userInfo:nil repeats:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"get verify code failed info:%@",error);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }];
}
-(void)remainingTime
{
    remainingTime--;
    [self.verificationCodeB setEnabled:YES];
    [self.verificationCodeB setTitle:[NSString stringWithFormat:@"重新发送(%ds)",remainingTime] forState:UIControlStateNormal];
    [self.verificationCodeB setEnabled:NO];
    if (remainingTime==0) {
        [self.verificationCodeB setTitle:@"点击发送验证码" forState:UIControlStateNormal];
        [self.verificationCodeB setEnabled:YES];
        if (self.checkT != nil) {
            if( [self.checkT isValid])
            {
                [self.checkT invalidate];
            }
            self.checkT = nil;
        }
    }
}
-(void)checkUsername
{
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"account" forKey:@"command"];
    [regDict setObject:self.usernameTF.text forKey:@"username"];
    [regDict setObject:@"checkUsername"forKey:@"options"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"register success info:%@",responseObject);
        if([[responseObject objectForKey:@"value"] isEqualToString:@"false"])
        {
            usernameCanUse = NO;
            [self sendVerifyCode];
        }
        else{
            usernameCanUse = YES;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不存在" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register failed info:%@",error);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.usernameTF]&&[IdentifyingString validateMobile:self.usernameTF.text]) {
        [self checkUsername];
    }
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
