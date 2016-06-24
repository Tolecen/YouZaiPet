//
//  RegisterViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "RegisterViewController.h"
#import<CoreText/CoreText.h>
#import "NewUserViewController.h"
#import "WXRTextViewController.h"

@implementation WXRAttributedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    NSAttributedString *attriString = _text;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
    //    CGContextTranslateCTM(ctx, 0, rect.size.height);
    //    CGContextScaleCTM(ctx, 1, -1);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attriString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CFRelease(framesetter);
    
    CTFrameDraw(frame, ctx);
    CFRelease(frame);
}
- (void)tapAction:(UIGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded && self.delegate && [self.delegate respondsToSelector:@selector(touchAttributedLabel)]) {
        [_delegate touchAttributedLabel];
    }
}
@end
@interface RegisterViewController ()<AttributedLabelDelegate>
{
    UIButton * nextB;
    WXRAttributedLabel * label;
}
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"新用户注册";
        usernameCanUse = YES;
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
    imageV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled = YES;
    
    UIImageView * phoneNoIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, imageV.frame.size.width - 20, 47)];
    phoneNoIV.image = [UIImage imageNamed:@"labelBG"];
    [imageV addSubview:phoneNoIV];
    
    self.usernameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 19, imageV.frame.size.width - 20-20, 30)];
    _usernameTF.placeholder = @"输入手机号来注册";
    _usernameTF.borderStyle = UITextBorderStyleNone;
    _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
    _usernameTF.backgroundColor = [UIColor clearColor];
    _usernameTF.font = [UIFont systemFontOfSize:16];
    _usernameTF.textAlignment = NSTextAlignmentLeft;
    _usernameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _usernameTF.returnKeyType = UIReturnKeyNext;
    _usernameTF.delegate = self;
    [imageV addSubview:self.usernameTF];
    
    UIImageView * passwordIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, imageV.frame.size.width - 20, 47)];
    passwordIV.image = [UIImage imageNamed:@"labelBG"];
    [imageV addSubview:passwordIV];
    
    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 79, imageV.frame.size.width - 20-20, 30)];
    _passwordTF.placeholder = @"设置密码";
    _passwordTF.borderStyle = UITextBorderStyleNone;
    _passwordTF.backgroundColor = [UIColor clearColor];
    _passwordTF.secureTextEntry = YES;
    _passwordTF.delegate = self;
    _passwordTF.font = [UIFont systemFontOfSize:16];
    _passwordTF.textAlignment = NSTextAlignmentLeft;
    _passwordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTF.returnKeyType = UIReturnKeyDone;
    [imageV addSubview:_passwordTF];
    
    UIImageView * verificationCodeIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 130, imageV.frame.size.width - 20, 47)];
    verificationCodeIV.image = [UIImage imageNamed:@"labelBG"];
    [imageV addSubview:verificationCodeIV];
    
    self.verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 139, imageV.frame.size.width - 20-20, 30)];
    _verifyTF.placeholder = @"输入验证码";
    _verifyTF.keyboardType = UIKeyboardTypeNumberPad;
    _verifyTF.borderStyle = UITextBorderStyleNone;
    _verifyTF.backgroundColor = [UIColor clearColor];
    _verifyTF.delegate = self;
    _verifyTF.font = [UIFont systemFontOfSize:16];
    _verifyTF.textAlignment = NSTextAlignmentLeft;
    _verifyTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _verifyTF.returnKeyType = UIReturnKeyDone;
    [imageV addSubview:_verifyTF];
    
    self.verificationCodeB = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verificationCodeB setBackgroundImage:[UIImage imageNamed:@"verificationCode_normal"] forState:UIControlStateNormal];
    [_verificationCodeB setTitle:@"点击发送验证码" forState:UIControlStateNormal];
    [_verificationCodeB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _verificationCodeB.frame = CGRectMake(imageV.frame.size.width - 135, 132.5, 123, 42);
    _verificationCodeB.titleLabel.font = [UIFont systemFontOfSize:14];
    [imageV addSubview:_verificationCodeB];
    [_verificationCodeB addTarget:self action:@selector(sendVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    
    label = [[WXRAttributedLabel alloc] initWithFrame:CGRectMake(12, 190, imageV.frame.size.width - 20, 40)];
    label.delegate = self;
    [imageV addSubview:label];
    
    nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB .frame = CGRectMake(10, 240, imageV.frame.size.width - 20, 47);
    [nextB setTitle:@"下一步" forState:UIControlStateNormal];
    [nextB addTarget:self action:@selector(registerNewUser) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:nextB];
    
    [self buildViewWithSkintype];
}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"点击“下一步”按钮，即表示您同意《宠物说用户协议》"];
    [str addAttribute:NSForegroundColorAttributeName
                value:(id)[UIColor grayColor].CGColor
                range:NSMakeRange(0, 17)];
    [str addAttribute:NSForegroundColorAttributeName
                value:(id)[UIColor grayColor].CGColor
                range:NSMakeRange(24, 1)];
    
    [str addAttribute:NSFontAttributeName
                value:[UIFont systemFontOfSize:14]
                range:NSMakeRange(0, str.length)];
    [nextB setBackgroundImage:[UIImage imageNamed:@"login_normal"] forState:UIControlStateNormal];
    [str addAttribute:NSForegroundColorAttributeName
                value:(id)[UIColor colorWithRed:6/255.0 green:198/255.0 blue:255/255.0 alpha:1].CGColor
                range:NSMakeRange(17, 7)];
    label.text = str;
}
-(void)sendVerifyCode:(UIButton *)sender
{
    if (![IdentifyingString validateMobile:self.usernameTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"正在发送..."];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"account" forKey:@"command"];
    [regDict setObject:@"001" forKey:@"type"];
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
-(void)verifyCodeWithString:(NSString *)codeStr
{
    [SVProgressHUD showWithStatus:@"正在验证..."];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"account" forKey:@"command"];
    [regDict setObject:@"001" forKey:@"type"];
    [regDict setObject:@"verifyCaptcha"forKey:@"options"];
    [regDict setObject:self.usernameTF.text forKey:@"phoneNum"];
    [regDict setObject:self.verifyTF.text forKey:@"code"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"verify success info:%@",responseObject);
        if ([[responseObject objectForKey:@"value"] isEqualToString:@"false"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误，请重新输入" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
            return;
        }
        NewUserViewController * newUserVC = [[NewUserViewController alloc]init];
        [self.navigationController pushViewController:newUserVC animated:YES];
        newUserVC.username = self.usernameTF.text;
        newUserVC.password = self.passwordTF.text;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"verify failed info:%@",error);
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.verifyTF resignFirstResponder];
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
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名已存在" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
            //            [self.usernameTF becomeFirstResponder];
        }
        else{
            usernameCanUse = YES;
            //            NewUserViewController * newUserVC = [[NewUserViewController alloc]init];
            //            [self.navigationController pushViewController:newUserVC animated:YES];
            //            newUserVC.username = self.usernameTF.text;
            //            newUserVC.password = self.passwordTF.text;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register failed info:%@",error);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }];
    
}
- (void)registerNewUser
{
    if (![IdentifyingString validateMobile:self.usernameTF.text]||!usernameCanUse) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    if (self.passwordTF.text.length<6) {
        [SVProgressHUD showErrorWithStatus:@"请输入最少6位密码"];
        return;
    }
    if (self.verifyTF.text.length<6) {
        [SVProgressHUD showErrorWithStatus:@"验证码是6位哦"];
        return;
    }
    if ([IFNeedVerifyCode isEqualToString:@"0"]) {
        NewUserViewController * newUserVC = [[NewUserViewController alloc]init];
        [self.navigationController pushViewController:newUserVC animated:YES];
        newUserVC.username = self.usernameTF.text;
        newUserVC.password = self.passwordTF.text;
    }
    else
    {
        [self verifyCodeWithString:self.verifyTF.text];
    }
    //    [self checkUsername];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.usernameTF]&&[IdentifyingString validateMobile:self.usernameTF.text]) {
        [self checkUsername];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.usernameTF]){
        usernameCanUse = YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
