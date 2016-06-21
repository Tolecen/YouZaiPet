//
//  WXRTextViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-9-4.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "WXRTextViewController.h"

@interface WXRTextViewController ()

@end

@implementation WXRTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(backBtnDo)];

    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, self.view.frame.size.height-5-navigationBarHeight)];
    textView.text = self.content;
    textView.showsVerticalScrollIndicator = NO;
    textView.font = [UIFont systemFontOfSize:15];
    textView.editable = NO;
    [self.view addSubview:textView];
    
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
