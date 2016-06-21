//
//  TextEditViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/7/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "TextEditViewController.h"
#import "SVProgressHUD.h"

@interface TextEditViewController ()<UITextViewDelegate>
{
    UILabel * placeholderL;
    UITextView * titleView;
}
@property (nonatomic,retain)NSString * text;
@end
@implementation TextEditViewController
- (void)dealloc
{
    
}
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
    
    [self setBackButtonWithTarget:@selector(goBack)];
    [self setRightButtonWithName:@"确定" BackgroundImg:nil Target:@selector(finishEdit)];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    titleView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, self.view.frame.size.height-navigationBarHeight-10)];
    titleView.backgroundColor = [UIColor whiteColor];
//    titleView.layer.borderWidth = 1;
    titleView.delegate = self;
    titleView.returnKeyType = UIReturnKeyDone;
//    titleView.layer.borderColor = [UIColor colorWithWhite:200/255.0 alpha:1].CGColor;
    titleView.text = _text;
    [self.view addSubview: titleView];
    
    placeholderL = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    placeholderL.textColor = [UIColor colorWithWhite:160/255.0 alpha:1];
    placeholderL.text = @"讲个故事听呗";
    [titleView addSubview:placeholderL];
    if(titleView.text.length>0)
    {
        placeholderL.hidden = YES;
    }
    
    titleView.font = placeholderL.font;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)finishEdit
{
    if (!titleView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"还没有输入文字呢!"];
        return;
    }
    if (titleView.text.length>_max) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"文字描述最多%d字请酌情删减",_max]];
        return;
    }
    [self dismissViewControllerAnimated:NO completion:^{
        if (_finish) {
            _finish(titleView.text);
        }
    }];
}
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setText:(NSString*)text
{
    _text = text;
    titleView.text = text;
    placeholderL.hidden = YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [titleView resignFirstResponder];
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
