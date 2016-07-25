//
//  ChangePasswordViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-8-26.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "SVProgressHUD.h"

@interface ChangePasswordViewController ()
{
    UIButton * nextB;
}
@property (nonatomic,strong) UITextField * oldpasswordTF;
@property (nonatomic,strong) UITextField * newpasswordTF;
@property (nonatomic,strong) UITextField * repasswordTF;
@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"修改密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, self.view.frame.size.height - 10 - navigationBarHeight)];
    imageV.image = [UIImage imageNamed:@"publishBg"];
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled = YES;
    
    UIImageView * phoneNoIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, imageV.frame.size.width - 20, 47)];
    phoneNoIV.image = [UIImage imageNamed:@"labelBG"];
    [imageV addSubview:phoneNoIV];
    
    self.oldpasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 19, imageV.frame.size.width - 20-20, 30)];
    _oldpasswordTF.placeholder = @"输入原密码";
    _oldpasswordTF.borderStyle = UITextBorderStyleNone;
    _oldpasswordTF.secureTextEntry = YES;
    _oldpasswordTF.backgroundColor = [UIColor clearColor];
    _oldpasswordTF.font = [UIFont systemFontOfSize:16];
    _oldpasswordTF.textAlignment = NSTextAlignmentLeft;
    _oldpasswordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _oldpasswordTF.returnKeyType = UIReturnKeyNext;
    [imageV addSubview:_oldpasswordTF];
    
    UIImageView * passwordIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, imageV.frame.size.width - 20, 47)];
    passwordIV.image = [UIImage imageNamed:@"labelBG"];
    [imageV addSubview:passwordIV];
    
    self.newpasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 79, imageV.frame.size.width - 20-20, 30)];
    _newpasswordTF.placeholder = @"输入你的新密码";
    _newpasswordTF.borderStyle = UITextBorderStyleNone;
    _newpasswordTF.backgroundColor = [UIColor clearColor];
    _newpasswordTF.secureTextEntry = YES;
    _newpasswordTF.font = [UIFont systemFontOfSize:16];
    _newpasswordTF.textAlignment = NSTextAlignmentLeft;
    _newpasswordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _newpasswordTF.returnKeyType = UIReturnKeyNext;
    [imageV addSubview:_newpasswordTF];
    
    UIImageView * verificationCodeIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 130, imageV.frame.size.width - 20, 47)];
    verificationCodeIV.image = [UIImage imageNamed:@"labelBG"];
    [imageV addSubview:verificationCodeIV];
    
    self.repasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 139, imageV.frame.size.width - 20-20, 30)];
    _repasswordTF.placeholder = @"重新输入";
    _repasswordTF.borderStyle = UITextBorderStyleNone;
    _repasswordTF.backgroundColor = [UIColor clearColor];
    _repasswordTF.secureTextEntry = YES;
    _repasswordTF.font = [UIFont systemFontOfSize:16];
    _repasswordTF.textAlignment = NSTextAlignmentLeft;
    _repasswordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _repasswordTF.returnKeyType = UIReturnKeyDone;
    [imageV addSubview:_repasswordTF];
    
    nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB .frame = CGRectMake(10, 240, imageV.frame.size.width - 20, 47);
    [nextB setBackgroundImage:[UIImage imageNamed:@"login_normal"] forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"login_click"] forState:UIControlStateHighlighted];
    [nextB setTitle:@"确定" forState:UIControlStateNormal];
    [nextB addTarget:self action:@selector(reSetPassWord) forControlEvents:UIControlEventTouchUpInside];
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
    [_oldpasswordTF resignFirstResponder];
    [_newpasswordTF resignFirstResponder];
    [_repasswordTF resignFirstResponder];
}
-(void)backBtnDo
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)reSetPassWord
{
    if (_oldpasswordTF.text.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请填写您的密码"];
        return;
    }
    if (_newpasswordTF.text.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请填写新密码"];
        return;
    }
    if (_repasswordTF.text.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请重复新密码"];
        return;
    }
    if (![_repasswordTF.text isEqualToString:_newpasswordTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请确保两次填写新密码一致"];
        return;
    }
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"account" forKey:@"command"];
    [mDict setObject:@"updtPw" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    [mDict setObject:_oldpasswordTF.text forKey:@"password"];
    [mDict setObject:_newpasswordTF.text forKey:@"newPassword"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alertView show];
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
