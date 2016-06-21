//
//  OpinionViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-8-28.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "OpinionViewController.h"
#import "SVProgressHUD.h"

@interface OpinionViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic,retain)UITextView * textV;
@property (nonatomic,retain)UILabel * placeholder;
@property (nonatomic,retain)UITextField * contactWayTF;
@end

@implementation OpinionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"意见反馈";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    [self setRightButtonWithName:@"发送" BackgroundImg:nil Target:@selector(puchOpinion)];
    UIImageView * bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, self.view.frame.size.height-5-navigationBarHeight)];
//    bgIV.image = [UIImage imageNamed:@"squareBG"];
    bgIV.backgroundColor = [UIColor clearColor];
    bgIV.userInteractionEnabled = YES;
    [self.view addSubview:bgIV];
    
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, bgIV.frame.size.width-10, 150)];
//    imageV.image = [UIImage imageNamed:@"opinionBg"];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.layer.cornerRadius = 5;
    imageV.layer.borderColor = [UIColor colorWithWhite:230/255.0f alpha:1].CGColor;
    imageV.layer.borderWidth = 1;
    imageV.layer.masksToBounds = YES;
    [bgIV addSubview:imageV];
    
    UIImageView * lin = [[UIImageView alloc] initWithFrame:CGRectMake(10, 122, bgIV.frame.size.width-20, 1)];
//    lin.image = [UIImage imageNamed:@"opinionLine"];
    lin.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
    [bgIV addSubview:lin];
    
    self.textV = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, bgIV.frame.size.width-20, 110)];
    _textV.returnKeyType = UIReturnKeyDone;
    _textV.font = [UIFont systemFontOfSize:14];
    _textV.delegate = self;
    [bgIV addSubview:_textV];
    
    self.placeholder = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, bgIV.frame.size.width-20, 50)];
    _placeholder.numberOfLines = 0;
    _placeholder.font = [UIFont systemFontOfSize:14];
    _placeholder.text = @"请输入您的问题和意见,您的反馈是我们进步的最大动力";
    _placeholder.backgroundColor = [UIColor clearColor];
    [_placeholder setTextColor:[UIColor lightGrayColor]];
    [bgIV addSubview:_placeholder];
    _textV.font = _placeholder.font;
    
    self.contactWayTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 125, bgIV.frame.size.width-20, 30)];
    self.contactWayTF.font = [UIFont systemFontOfSize:14];
    _contactWayTF.placeholder = @"您的联系方式(QQ,微信,手机号,微博)";
    _contactWayTF.returnKeyType = UIReturnKeyDone;
    _contactWayTF.delegate = self;
    [bgIV addSubview:_contactWayTF];
    
    [self buildViewWithSkintype];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backBtnDo
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)puchOpinion
{
    if (_textV.text.length<=0||_contactWayTF.text.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请填写意见以及您的联系方式"];
        return;
    }
    [SVProgressHUD showSuccessWithStatus:@"提交成功,感谢您提供的宝贵意见,我们会尽快处理"];
    [self backBtnDo];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"message" forKey:@"command"];
    [mDict setObject:@"CULM" forKey:@"options"];
    [mDict setObject:_contactWayTF.text forKey:@"phoneNum"];
    [mDict setObject:_textV.text forKey:@"desc"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textV resignFirstResponder];
    [_contactWayTF resignFirstResponder];
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        _placeholder.text = @"";
    }else
    {
        _placeholder.text = @"请输入您的问题和意见,您的反馈使我们进步的最大动力";
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
