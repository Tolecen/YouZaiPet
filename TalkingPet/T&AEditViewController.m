//
//  T&AEditViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/7/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "T&AEditViewController.h"
#import "SVProgressHUD.h"

@interface T_AEditViewController ()<UITextViewDelegate,UITextFieldDelegate,UITextFieldDelegate>
{
    UILabel * placeholderL;
    UITextView * addressView;
    UITextField * timeTF;
}
@property (nonatomic,retain)NSString * time;
@property (nonatomic,retain)NSString * address;
@end
@implementation T_AEditViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackButtonWithTarget:@selector(goBack)];
    [self setRightButtonWithName:@"完成" BackgroundImg:nil Target:@selector(finishEdit)];
    
    //    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    addressView = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width-10, 60)];
    addressView.backgroundColor = [UIColor clearColor];
    addressView.layer.borderWidth = 1;
    addressView.delegate = self;
    addressView.returnKeyType = UIReturnKeyDone;
    addressView.layer.borderColor = [UIColor colorWithWhite:240/255.0 alpha:1].CGColor;
    addressView.text = _address;
    [self.view addSubview: addressView];
    
    placeholderL = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, 20)];
    placeholderL.textAlignment = NSTextAlignmentLeft;
    placeholderL.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    placeholderL.text = @"输入地点";
    [addressView addSubview:placeholderL];
    if(addressView.text.length>0)
    {
        placeholderL.hidden = YES;
    }
    
    addressView.font = placeholderL.font;
    
    timeTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 30)];
    timeTF.placeholder = @"添加时间";
    timeTF.font = placeholderL.font;
    timeTF.textAlignment = NSTextAlignmentLeft;
    timeTF.backgroundColor = [UIColor clearColor];
    //    timeTF.layer.borderWidth = 1;
    //    timeTF.layer.borderColor = [UIColor colorWithWhite:240/255.0 alpha:1].CGColor;
    timeTF.text = _time;
    timeTF.delegate = self;
    timeTF.inputView = ({
        UIDatePicker*datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 200)];
        datePicker.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        datePicker.datePickerMode = UIDatePickerModeDate;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
        datePicker.locale = locale;
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        datePicker.maximumDate = [NSDate date];
        datePicker;
    });
    
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 50, ScreenWidth-20, 1)];
    lineV.backgroundColor = [UIColor colorWithR:240 g:240 b:240 alpha:1];
    [self.view addSubview:lineV];
    //    timeTF.inputAccessoryView =({
    //        UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    //        toolbar.tintColor = [UIColor blackColor];
    //        UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(timeFinishSelected)];
    //        rb.tintColor = [UIColor blackColor];
    //        toolbar.items = @[rb];
    //        toolbar;
    //    });
    [self.view addSubview: timeTF];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)finishEdit
{
    if (!addressView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请添加一个地点"];
        return;
    }
    if (addressView.text.length>20) {
        [SVProgressHUD showErrorWithStatus:@"地点最多20个字请酌情删减"];
    }
    if (!timeTF.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请选择一个时间"];
        return;
    }
    [self dismissViewControllerAnimated:NO completion:^{
        if (_finish) {
            _finish(timeTF.text,addressView.text);
        }
    }];
}
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setTimeString:(NSString*)time andAddress:(NSString*)address
{
    self.time = time;
    self.address = address;
    addressView.text = address;
    placeholderL.hidden = YES;
    timeTF.text = time;
}
-(void)dateChanged:(UIDatePicker*)dateP
{
    NSDate* date = dateP.date;
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy.MM.dd";
    _time = [dateF stringFromDate:date];
    [timeTF setText:_time];
}
-(void)timeFinishSelected
{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [addressView resignFirstResponder];
    [timeTF resignFirstResponder];
}
#pragma mark - UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!_time.length) {
        NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
        dateF.dateFormat = @"yyyy.MM.dd";
        _time = [dateF stringFromDate:[NSDate date]];
    }
    [timeTF setText:_time];
}
#pragma mark - UITextView
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeholderL.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!textView.text.length) {
        placeholderL.hidden = NO;
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
@end
