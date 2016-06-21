//
//  ConsultIconView.m
//  TalkingPet
//
//  Created by Tolecen on 15/7/19.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ConsultIconView.h"

@implementation ConsultIconView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * g = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        g.backgroundColor = [UIColor clearColor];
        g.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        g.font = [UIFont boldSystemFontOfSize:14];
        g.text = @"联系我们";
        [self addSubview:g];
        
        float w = (ScreenWidth-270)/4;
        UIButton * b1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [b1 setBackgroundImage:[UIImage imageNamed:@"onlineconsult"] forState:UIControlStateNormal];
        [b1 setFrame:CGRectMake(w, 40, 90, 63)];
        [self addSubview:b1];
        [b1 addTarget:self action:@selector(liaison) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * b2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [b2 setBackgroundImage:[UIImage imageNamed:@"phoneconsult"] forState:UIControlStateNormal];
        [b2 setFrame:CGRectMake(w*2+90, 40, 90, 63)];
        [self addSubview:b2];
        [b2 addTarget:self action:@selector(makephonecall) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * b3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [b3 setBackgroundImage:[UIImage imageNamed:@"qqconsult"] forState:UIControlStateNormal];
        [b3 setFrame:CGRectMake(w*3+90*2, 40, 90, 63)];
        [self addSubview:b3];
        [b3 addTarget:self action:@selector(copyqq) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 112, ScreenWidth-20, 1)];
        lineV.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
        [self addSubview:lineV];
    }
    return self;
}
-(void)liaison
{
    ChatDetailViewController * chatDV = [[ChatDetailViewController alloc] init];
    Pet * theP = [[Pet alloc] init];
    theP.petID = @"44239";
    chatDV.thePet = theP;
    [self.vc.navigationController pushViewController:chatDV animated:YES];
}
-(void)makephonecall
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定拨打电话 010-67528566 吗？" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"拨打", nil];
    alert.tag = 1;
    [alert show];
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (alertView.tag==1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://010-67528566"]];
        }
        else if (alertView.tag==2){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mqq://"]];
        }
        
    }
}
-(void)copyqq
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"3028317583";
//    [SVProgressHUD showSuccessWithStatus:@"QQ号已复制到剪切板"];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"QQ号已复制到剪切板,现在打开QQ吗？" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"打开QQ", nil];
    alert.tag = 2;
    [alert show];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
