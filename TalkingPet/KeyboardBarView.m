//
//  KeyboardBarView.m
//  TalkingPet
//
//  Created by Tolecen on 15/4/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "KeyboardBarView.h"

@implementation KeyboardBarView
- (id)initWithFrame:(CGRect)frame textView:(UITextView *)textView baseView:(UIView *)baseview;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, baseview.frame.size.height, ScreenWidth, 40)];
        self.backgroundColor = [UIColor colorWithWhite:245/255.0f alpha:1];
        
        self.textView = textView;
        self.baseView = baseview;
        
//        self.textView.delegate = self;
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        [line1 setBackgroundColor:[UIColor colorWithWhite:200/255.0f alpha:1]];
        [self addSubview:line1];
        
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        [line2 setBackgroundColor:[UIColor colorWithWhite:200/255.0f alpha:1]];
        [self addSubview:line2];
        
        self.emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.emojiBtn setFrame:CGRectMake(10, 0, 40, 40)];
        [self.emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
        [self addSubview:self.emojiBtn];
        [self.emojiBtn addTarget:self action:@selector(emojiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.theEmojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0, self.baseView.frame.size.height-213, ScreenWidth, 213) WithSendBtn:NO];
        self.theEmojiView.delegate = self;
        [self.baseView addSubview:self.theEmojiView];
        self.theEmojiView.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        
    }
    return self;
}



-(void)emojiBtnClicked:(UIButton *)sender
{
    if (!ifEmoji) {
        
        [self.textView resignFirstResponder];
        ifEmoji = YES;
        [sender setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];

        [self showEmojiScrollView];
        

        
        
    }
    else
    {
        
        [self.textView becomeFirstResponder];
        ifEmoji = NO;
        self.theEmojiView.hidden = YES;
        //        [m_EmojiScrollView removeFromSuperview];
        //        [emojiBGV removeFromSuperview];
        //        [m_Emojipc removeFromSuperview];
        [sender setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    }
}

-(void)showEmojiScrollView
{
    
//    [self.textView resignFirstResponder];
    
    //    [self setFrame:CGRectMake(0, self.baseView.frame.size.height-self.naviH-227-self.frame.size.height, 320, self.frame.size.height)];
    self.theEmojiView.hidden = NO;
    [self.theEmojiView setFrame:CGRectMake(0, self.baseView.frame.size.height-213, ScreenWidth, 213)];
    //    [self autoMovekeyBoard:213];
    CGRect containerFrame = self.frame;
    containerFrame.origin.y = (self.baseView.frame.size.height - (213 + containerFrame.size.height));
    
    self.frame = containerFrame;
    
    if ([self.delegate respondsToSelector:@selector(heightChanged:)]) {
        [self.delegate heightChanged:containerFrame.origin.y];
    }
    
}

-(NSString *)selectedEmoji:(NSString *)ssss
{
    if (self.textView.text == nil) {
        self.textView.text = ssss;
    }
    else {
        self.textView.text = [self.textView.text stringByAppendingString:ssss];
    }
    if ([self.delegate respondsToSelector:@selector(emojiEntered)]) {
        [self.delegate emojiEntered];
    }
    return 0;
}
-(void)deleteEmojiStr
{
    if (self.textView.text.length>=1) {
        self.textView.text = [self.textView.text substringToIndex:(self.textView.text.length-1)];
    }
}
-(void)emojiSendBtnDo
{
    if ([self.textView.text CutSpacing].length<1) {
        [SVProgressHUD showErrorWithStatus:@"要输入内容哦"];
        return;
    }
    //    [self dismissInputView];
//    [self.delegate didSendTextAction:[self.textView.text CutSpacing]];
    //    self.textView.text = @"";
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
//    if (keyboardRect.size.height<200) {
        [self autoMovekeyBoard:keyboardRect.size.height];
//    }
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    //    NSDictionary* userInfo = [notification userInfo];
    //    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSTimeInterval animationDuration;
    //    [animationDurationValue getValue:&animationDuration];
    
//    if (shouldDismissKeyboard) {
        [self autoMovekeyBoard:0];
//    }
    
}


-(void) autoMovekeyBoard: (float) h{
    if (h==0) {
        ifEmoji = NO;
        self.theEmojiView.hidden = YES;
        [self.emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    }
    
    
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.2];
    //
    //
    //    [UIView commitAnimations];
//    if (!ifEmoji) {
        CGRect containerFrame = self.frame;
        containerFrame.origin.y = (self.baseView.frame.size.height - (h + containerFrame.size.height));
//        [UIView animateWithDuration:0.2 animations:^{
    
            
            self.frame = containerFrame;
//            NSLog(@"sdsgghjkl;%@",NSStringFromCGRect(self.frame));
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
 
    if ([self.delegate respondsToSelector:@selector(heightChanged:)]) {
        [self.delegate heightChanged:containerFrame.origin.y];
    }
    
}
-(void)dealloc
{
    self.delegate = nil;
}
-(void)removeFromSuperview
{
    [super removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
