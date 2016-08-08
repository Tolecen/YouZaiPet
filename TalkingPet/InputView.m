//
//  InputView.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-16.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "InputView.h"
#if TARGET_IPHONE_SIMULATOR

#elif TARGET_OS_IPHONE
#import "amrFileCodec.h"
#endif
@implementation InputView

- (id)initWithFrame:(CGRect)frame BaseView:(UIView *)theView Type:(int)theTye
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, theTye==2?(theView.frame.size.height-100):(theView.frame.size.height-110), ScreenWidth, 50)];
        self.pageType = (theTye==3?2:theTye);
        if (theTye==2||theTye==3) {
            textMaxLength = 500;
        }
        else
            textMaxLength = 60;
        // Initialization code
        ifAudio = NO;
        ifEmoji = NO;
        shouldDismissKeyboard = YES;
        self.isVisible = NO;
        
        self.baseView = theView;
        
        self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(theTye==3?10:40, 7, ScreenWidth-(theTye==3?50:120), 35)];
        self.textView.isScrollable = NO;
        self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        
        self.textView.minNumberOfLines = 1;
        self.textView.maxNumberOfLines = 6;
        // you can also set the maximum height in points with maxHeight
        // textView.maxHeight = 200.0f;
        self.textView.returnKeyType = UIReturnKeySend; //just as an example
        self.textView.font = [UIFont systemFontOfSize:15.0f];
        self.textView.delegate = self;
        self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        self.textView.backgroundColor = [UIColor clearColor];
        
        if (theTye==2) {
            self.textView.placeholder = @"输入消息";
        }
        else
            self.textView.placeholder = @"评论";
        
        UIImage *rawEntryBackground = [UIImage imageNamed:@"chat_input.png"];
        UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        self.entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
        self.entryImageView.frame = CGRectMake(theTye==3?10:40, 7, ScreenWidth-(theTye==3?50:120), 35);
        self.entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UIImage *rawBackground = [UIImage imageNamed:@"inputbg.png"];
        UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        self.imageView = [[UIImageView alloc] initWithImage:background];
        _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // view hierachy
        [self addSubview:_imageView];
        
        [self addSubview:self.entryImageView];
        [self addSubview:self.textView];
        
//        self.emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.emojiBtn setFrame:CGRectMake(ScreenWidth-45, self.frame.size.height-12-36, 45, 45)];
//        [self.emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
//        [self addSubview:self.emojiBtn];
//        [self.emojiBtn addTarget:self action:@selector(emojiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.favorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.favorBtn setFrame:CGRectMake(ScreenWidth-80, self.frame.size.height-12-36, 45, 45)];
        [self.favorBtn setImage:[UIImage imageNamed:@"keyboard_favor.png"] forState:UIControlStateNormal];
        [self addSubview:self.favorBtn];
        [self.favorBtn addTarget:self action:@selector(favorClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareBtn setFrame:CGRectMake(ScreenWidth-45, self.frame.size.height-12-36, 45, 45)];
        [self.shareBtn setImage:[UIImage imageNamed:@"keyboard_share.png"] forState:UIControlStateNormal];
        [self addSubview:self.shareBtn];
        [self.shareBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (theTye!=3) {
            self.audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.audioBtn setFrame:CGRectMake(-2, self.frame.size.height-12-36, 45, 45)];
            [self.audioBtn setImage:[UIImage imageNamed:@"audioBtn.png"] forState:UIControlStateNormal];
            [self addSubview:self.audioBtn];
            [self.audioBtn addTarget:self action:@selector(audioBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            self.audioRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //[UIButton buttonWithType:UIButtonTypeCustom];
            [self.audioRecordBtn setFrame:CGRectMake(40, self.frame.size.height-43, ScreenWidth-120, 35)];
            [self.audioRecordBtn setBackgroundImage:[UIImage imageNamed:@"recordB"] forState:UIControlStateNormal];
            //    [audioRecordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
            [self addSubview:self.audioRecordBtn];
            self.audioRecordBtn.hidden = YES;
            [self.audioRecordBtn addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
            [self.audioRecordBtn addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
            [self.audioRecordBtn addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [self.audioRecordBtn addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
            [self.audioRecordBtn addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
            [self.audioRecordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
            [self.audioRecordBtn setTitle:@"松开结束" forState:UIControlStateHighlighted];
            [self.audioRecordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.audioRecordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.audioRecordBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];

        }
        
        
        
//        self.recordTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7.5, 200+40, 20)];
//        [self.recordTextLabel setBackgroundColor:[UIColor clearColor]];
//        [self.recordTextLabel setText:@"按住说话"];
//        [self.recordTextLabel setTextColor:[UIColor grayColor]];
//        [self.audioRecordBtn addSubview:self.recordTextLabel];
//        [self.recordTextLabel setTextAlignment:NSTextAlignmentCenter];
        
        self.theEmojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0, self.viewH-self.naviH-213, ScreenWidth, 213) WithSendBtn:NO];
        self.theEmojiView.delegate = self;
        [self.baseView addSubview:self.theEmojiView];
        self.theEmojiView.hidden = YES;
        
        self.clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        [self.clearView setBackgroundColor:[UIColor clearColor]];
        [self.baseView addSubview:self.clearView];
        self.clearView.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}

-(void)favorClicked:(UIButton *)sender
{
    if (self.favorBtnClicked) {
        self.favorBtnClicked(sender);
    }
}
-(void)shareClicked:(UIButton *)sender
{
    if (self.shareBtnClicked) {
        self.shareBtnClicked(sender);
    }
}
-(void)setTextPlaceHolder:(NSString *)placeHolder
{
    self.textView.placeholder = placeHolder;
}
-(void)showInputViewWithAudioBtn:(BOOL)haveAudioBtn
{
    if(haveAudioBtn){
        self.audioBtn.hidden = NO;
        [self.textView setFrame:CGRectMake(40, 7, ScreenWidth-120, self.textView.frame.size.height)];
        self.entryImageView.frame = CGRectMake(40, 7, ScreenWidth-120, self.textView.frame.size.height);
        [self.audioRecordBtn setFrame:CGRectMake(40, 7, ScreenWidth-120, 35)];
    }
    else
    {
        self.audioBtn.hidden = YES;
        [self.textView setFrame:CGRectMake(10, 7, ScreenWidth-90, self.textView.frame.size.height)];
        self.entryImageView.frame = CGRectMake(10, 7,ScreenWidth-90, self.textView.frame.size.height);
        [self.audioRecordBtn setFrame:CGRectMake(10, 7, ScreenWidth-90, 35)];
        
    }
    self.isVisible = YES;
    if (ifAudio) {
        [self autoMovekeyBoard:0];
        [UIView animateWithDuration:0.2 animations:^{
            [self.theEmojiView setFrame:CGRectMake(0, self.theEmojiView.frame.origin.y+260+self.naviH, ScreenWidth, 213)];
        } completion:^(BOOL finished) {
            self.theEmojiView.hidden = YES;
        }];
    }
    else
    {
        self.audioRecordBtn.hidden = YES;
        [self.textView becomeFirstResponder];
    }
    if (currentAudioBtnHiddenStatus!=haveAudioBtn) {
//        [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, 7, 200+40, 35)];
//        self.entryImageView.frame = CGRectMake(self.entryImageView.frame.origin.x, 7, 200+40, 35);
//        [self setFrame:CGRectMake(0, self.baseView.frame.size.height, 320, 50)];
        ifAudio = NO;
        self.textView.hidden = NO;
        self.audioRecordBtn.hidden = YES;
        self.textView.text = @"";
        [self.textView becomeFirstResponder];
    }

    [self.emojiBtn setFrame:CGRectMake(ScreenWidth-45, self.frame.size.height-12-36, 45, 45)];
    [self.audioBtn setFrame:CGRectMake(-2, self.frame.size.height-12-36, 45, 45)];
    currentAudioBtnHiddenStatus = haveAudioBtn;
  
}

-(void)dismissInputView
{
    self.isVisible = NO;
    self.clearView.hidden = YES;

    if(ifAudio){
        [UIView animateWithDuration:0.2 animations:^{
            [self.theEmojiView setFrame:CGRectMake(0, self.baseView.frame.size.height, ScreenWidth, 213)];
            [self setFrame:CGRectMake(0, self.pageType!=2 ? (self.baseView.frame.size.height-50):(self.baseView.frame.size.height-50), ScreenWidth, self.frame.size.height)];
        } completion:^(BOOL finished) {
            self.theEmojiView.hidden = YES;
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            [self.theEmojiView setFrame:CGRectMake(0, self.baseView.frame.size.height, ScreenWidth, 213)];
            [self setFrame:CGRectMake(0, self.pageType!=2 ? (self.baseView.frame.size.height-50):(self.baseView.frame.size.height-(self.frame.size.height)), ScreenWidth, self.frame.size.height)];
            ifEmoji = NO;
            self.theEmojiView.hidden = YES;
            [self.emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            self.theEmojiView.hidden = YES;
        }];
        [self.textView resignFirstResponder];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputViewDidResignActive)]) {
        [self.delegate inputViewDidResignActive];
    }
}

-(void)emojiBtnClicked:(UIButton *)sender
{
    if (!ifEmoji) {
        shouldDismissKeyboard = NO;
        [self.textView resignFirstResponder];
        ifEmoji = YES;
        ifAudio = NO;
        [sender setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
        [self.audioBtn setImage:[UIImage imageNamed:@"audioBtn.png"] forState:UIControlStateNormal];
        self.textView.hidden = NO;
        self.audioRecordBtn.hidden = YES;
        [self showEmojiScrollView];
        
        if ([self.delegate respondsToSelector:@selector(inputViewDidChangeHeightWithOriginY:)]) {
            [self.delegate inputViewDidChangeHeightWithOriginY:(self.theEmojiView.frame.size.height+self.frame.size.height)];
        }

        
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

-(void)audioBtnClicked:(UIButton *)sender
{
    if (!ifAudio) {
        self.textView.text = @"";
        ifAudio = YES;
        [sender setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
        self.audioRecordBtn.hidden = NO;
        self.textView.hidden = YES;
        shouldDismissKeyboard = YES;
        [self.textView resignFirstResponder];
        if (ifEmoji) {
            [self autoMovekeyBoard:0];
            ifEmoji = NO;
            [UIView animateWithDuration:0.2 animations:^{
                [self.theEmojiView setFrame:CGRectMake(0, self.theEmojiView.frame.origin.y+260+self.naviH, ScreenWidth, 213)];
            } completion:^(BOOL finished) {
                self.theEmojiView.hidden = YES;
            }];
            
            [self.emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        ifAudio = NO;
        [sender setImage:[UIImage imageNamed:@"audioBtn.png"] forState:UIControlStateNormal];
        self.textView.hidden = NO;
        self.audioRecordBtn.hidden = YES;
        [self.textView becomeFirstResponder];
    }
}

- (void)holdDownButtonTouchDown {
    NSLog(@"didStartRecordingVoice");
    [self startRecord];
//    if ([self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction)]) {
//        [self.delegate didStartRecordingVoiceAction];
//    }
}

- (void)holdDownButtonTouchUpOutside {
    NSLog(@"didCancelRecordingVoice");
    [self cancelRecord];
//    if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
//        [self.delegate didCancelRecordingVoiceAction];
//    }
}

- (void)holdDownButtonTouchUpInside {
    NSLog(@"didFinishRecoingVoice");
    [self finishRecorded];
//    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction)]) {
//        [self.delegate didFinishRecoingVoiceAction];
//    }
}

- (void)holdDownDragOutside {
    NSLog(@"didDragOutsideAction");
    [self resumeRecord];
//    if ([self.delegate respondsToSelector:@selector(didDragOutsideAction)]) {
//        [self.delegate didDragOutsideAction];
//    }
}

- (void)holdDownDragInside {
    NSLog(@"didDragInsideAction");
    [self pauseRecord];
//    if ([self.delegate respondsToSelector:@selector(didDragInsideAction)]) {
//        [self.delegate didDragInsideAction];
//    }
}
- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        WEAKSELF
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            DLog(@"已经达到最大限制时间了，进入下一步的提示");
            [weakSelf finishRecorded];
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
    }
    return _voiceRecordHelper;
}
- (XHVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}
- (void)startRecord {
    [self.voiceRecordHUD startRecordingHUDAtView:self.baseView];
    [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
        
    }];
}

- (void)finishRecorded {
    WEAKSELF
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        NSLog(@"recordPath=%@, and duration:%@",weakSelf.voiceRecordHelper.recordPath,weakSelf.voiceRecordHelper.recordDuration);
        if ([weakSelf.voiceRecordHelper.recordDuration intValue]<2) {
            [SVProgressHUD showErrorWithStatus:@"说话时间不能少于2秒"];
        }
        else
            [self transferAudioWithPath:weakSelf.voiceRecordHelper.recordPath Duration:weakSelf.voiceRecordHelper.recordDuration];
//        [weakSelf didSendMessageWithVoice:weakSelf.voiceRecordHelper.recordPath voiceDuration:weakSelf.voiceRecordHelper.recordDuration];
    }];
}

-(void)transferAudioWithPath:(NSString *)audioPath Duration:(NSString *)audioDuration
{
    #if TARGET_IPHONE_SIMULATOR
        
    #elif TARGET_OS_IPHONE
        NSData * data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:audioPath]];
        NSLog(@"LENGTH:%d",[data length]);
        
        //待上传的dada1
        NSData * data1 =EncodeWAVEToAMR(data,1,16);
        NSLog(@"LENGTH2:%d",[data1 length]);
    if (self.pageType==2) {
        [self.delegate didAudioDataRecorded:data1 WithDuration:audioDuration AudioPath:audioPath];
    }
    else
        [self.delegate didAudioDataRecorded:data1 WithDuration:audioDuration];
    #endif
}

- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
    [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
    WEAKSELF
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}

- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Library/Caches/", NSHomeDirectory()];
    //    dateFormatter.dateFormat = @"hh-mm-ss";
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.caf", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

#pragma mark -
#pragma mark HPExpandingTextView delegate
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    ifEmoji = NO;
    self.isVisible = YES;
    self.theEmojiView.hidden = YES;
    [self.emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];

    return YES;
}
//改变键盘高度
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.frame = r;

    [self.emojiBtn setFrame:CGRectMake(ScreenWidth-45, self.frame.size.height-12-36, 45, 45)];
    [self.audioBtn setFrame:CGRectMake(-2, self.frame.size.height-12-36, 45, 45)];
    
    if ([self.delegate respondsToSelector:@selector(inputViewDidChangeHeightWithOriginY:)]) {
        [self.delegate inputViewDidChangeHeightWithOriginY:(keyboardHeight+self.frame.size.height)];
    }
}

-(BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (growingTextView.text.length>textMaxLength&&text) {
        growingTextView.text = [growingTextView.text substringToIndex:textMaxLength];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多输入%d个字哦",textMaxLength] delegate:self cancelButtonTitle:@"好吧,知道了" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
//    [self sendButton:nil];
    if ([self.textView.text CutSpacing].length<1) {
        [SVProgressHUD showErrorWithStatus:@"要输入内容哦"];
        return YES;
    }
//    [self dismissInputView];
    [self.delegate didSendTextAction:[self.textView.text CutSpacing]];
//    self.textView.text = @"";
    return YES;
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];

    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    [self autoMovekeyBoard:keyboardRect.size.height];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
//    NSDictionary* userInfo = [notification userInfo];
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
    
    if (shouldDismissKeyboard) {
        [self autoMovekeyBoard:0];
    }
    
}

-(void)showEmojiScrollView
{
    
    [self.textView resignFirstResponder];
    
//    [self setFrame:CGRectMake(0, self.baseView.frame.size.height-self.naviH-227-self.frame.size.height, 320, self.frame.size.height)];
    self.theEmojiView.hidden = NO;
    [self.theEmojiView setFrame:CGRectMake(0, self.baseView.frame.size.height-213, ScreenWidth, 213)];
//    [self autoMovekeyBoard:213];
    CGRect containerFrame = self.frame;
    containerFrame.origin.y = (self.viewH-self.naviH - (213 + containerFrame.size.height));
    
    self.frame = containerFrame;
    
}

-(NSString *)selectedEmoji:(NSString *)ssss
{
	if (self.textView.text == nil) {
		self.textView.text = ssss;
	}
	else {
		self.textView.text = [self.textView.text stringByAppendingString:ssss];
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
    [self.delegate didSendTextAction:[self.textView.text CutSpacing]];
//    self.textView.text = @"";
}

-(void) autoMovekeyBoard: (float) h{
    keyboardHeight = h;
    if (!self.isVisible) {
        return;
    }
    if (h==0) {
        ifEmoji = NO;
        self.theEmojiView.hidden = YES;
        [self.emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
        shouldDismissKeyboard = YES;
    }
    
    
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
//
//
//    [UIView commitAnimations];
    CGRect containerFrame = self.frame;
    containerFrame.origin.y = (self.viewH-self.naviH - (h + containerFrame.size.height));
    [UIView animateWithDuration:0.2 animations:^{
        
        
        self.frame = containerFrame;
        NSLog(@"sdsgghjkl;%@",NSStringFromCGRect(self.frame));
    } completion:^(BOOL finished) {
        self.clearView.hidden = NO;
        [self.clearView setFrame:CGRectMake(0, 0, ScreenWidth, self.frame.origin.y)];
    }];
    
    if ([self.delegate respondsToSelector:@selector(inputViewDidChangeHeightWithOriginY:)]) {
        [self.delegate inputViewDidChangeHeightWithOriginY:(h+containerFrame.size.height)];
    }
 
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
