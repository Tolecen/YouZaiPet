//
//  reSetPassWordViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-8-25.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ReSetPassWordViewController.h"
#import "SVProgressHUD.h"

@interface ReSetPassWordViewController ()
{
    UIButton * nextB;
}
@property (nonatomic,strong) UITextField * passwordTF;
@property (nonatomic,strong) UITextField * repasswordTF;
@end

@implementation ReSetPassWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"重置密码";
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
    
    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 19, imageV.frame.size.width - 20-20, 30)];
    _passwordTF.placeholder = @"输入新密码";
    _passwordTF.borderStyle = UITextBorderStyleNone;
    _passwordTF.backgroundColor = [UIColor clearColor];
    _passwordTF.font = [UIFont systemFontOfSize:16];
    _passwordTF.textAlignment = NSTextAlignmentLeft;
    _passwordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTF.returnKeyType = UIReturnKeyNext;
    _passwordTF.secureTextEntry = YES;
    [imageV addSubview:_passwordTF];
    
    UIImageView * passwordIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, imageV.frame.size.width - 20, 47)];
    passwordIV.image = [UIImage imageNamed:@"labelBG"];
    [imageV addSubview:passwordIV];
    
    self.repasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 79, imageV.frame.size.width - 20-20, 30)];
    _repasswordTF.placeholder = @"重复密码";
    _repasswordTF.borderStyle = UITextBorderStyleNone;
    _repasswordTF.backgroundColor = [UIColor clearColor];
    _repasswordTF.secureTextEntry = YES;
    _repasswordTF.font = [UIFont systemFontOfSize:16];
    _repasswordTF.textAlignment = NSTextAlignmentLeft;
    _repasswordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _repasswordTF.returnKeyType = UIReturnKeyDone;
    [imageV addSubview:_repasswordTF];
    
    nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB .frame = CGRectMake(10, 180, imageV.frame.size.width - 20, 47);
    [nextB setTitle:@"确定" forState:UIControlStateNormal];
    [nextB addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
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
    [_passwordTF resignFirstResponder];
    [_repasswordTF resignFirstResponder];
}
- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)resetPassword
{
    if (self.passwordTF.text.length<6) {
        [SVProgressHUD showErrorWithStatus:@"请输入最少6位密码"];
        return;
    }
    if (self.repasswordTF.text.length<6) {
        [SVProgressHUD showErrorWithStatus:@"请输入最少6位密码"];
        return;
    }
    if (![self.repasswordTF.text isEqualToString:self.passwordTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请确保两次输入的密码一致"];
        return;
    }
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"account" forKey:@"command"];
    [regDict setObject:@"restPw"forKey:@"options"];
    [regDict setObject:self.passwordTF.text forKey:@"password"];
    [regDict setObject:_phoneNo forKey:@"username"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        
    }];
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
