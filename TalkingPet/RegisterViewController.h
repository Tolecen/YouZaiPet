//
//  RegisterViewController.h
//  TalkingPet
//
//  Created by wangxr on 14-7-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "IdentifyingString.h"
#import "SVProgressHUD.h"
#import "WebContentViewController.h"
#define IFNeedVerifyCode  @"1"

@protocol AttributedLabelDelegate <NSObject>
@optional
-(void)touchAttributedLabel;
@end
@interface WXRAttributedLabel : UIView
@property (nonatomic,retain)NSAttributedString * text;
@property (nonatomic,assign)id<AttributedLabelDelegate>delegate;
@end

@interface RegisterViewController : BaseViewController<UITextFieldDelegate>
{
    int remainingTime;
    BOOL usernameCanUse;
}
@property (nonatomic,strong) UITextField * usernameTF;
@property (nonatomic,strong) UITextField * passwordTF;
@property (nonatomic,strong) UITextField * verifyTF;
@property (nonatomic,strong) UIButton * verificationCodeB;
@property (nonatomic,strong) NSTimer * checkT;
@end
