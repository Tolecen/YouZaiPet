//
//  InputView.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-16.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "EmojiView.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "XHMacro.h"
#import "SVProgressHUD.h"
#import "XHAudioPlayerHelper.h"
@protocol MessageInputViewDelegate <NSObject>

@optional

- (void)didChangeSendVoiceAction:(BOOL)changed;
- (void)didSendTextAction:(NSString *)text;
- (void)didSelectedMultipleMediaAction;
- (void)didStartRecordingVoiceAction;
- (void)didCancelRecordingVoiceAction;
- (void)didFinishRecoingVoiceAction;
- (void)didDragOutsideAction;
- (void)didDragInsideAction;
- (void)inputViewDidChangeHeightWithOriginY:(float)oy;
- (void)inputViewDidResignActive;
- (void)didAudioDataRecorded:(NSData *)audioData WithDuration:(NSString *)theDuration;
- (void)didAudioDataRecorded:(NSData *)audioData WithDuration:(NSString *)theDuration AudioPath:(NSString *)audioPath;

@end

@interface InputView : UIView<HPGrowingTextViewDelegate,EmojiViewDelegate,XHAudioPlayerHelperDelegate>
{
    BOOL ifAudio;
    BOOL ifEmoji;
    
    BOOL shouldDismissKeyboard;
    BOOL currentAudioBtnHiddenStatus;
    
    float keyboardHeight;
    
    int textMaxLength;
}
@property (strong,nonatomic) HPGrowingTextView *textView;
@property (strong,nonatomic) UIButton *emojiBtn;
@property (strong,nonatomic) UIButton *audioBtn;
@property (strong,nonatomic) UILabel *recordTextLabel;
@property (strong,nonatomic) UIButton *audioRecordBtn;
@property (assign,nonatomic) int pageType;
@property (strong,nonatomic) EmojiView *theEmojiView;
@property (strong,nonatomic) UIImageView *entryImageView;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UIView *clearView;
@property (assign,nonatomic) float viewH;
@property (assign,nonatomic) float naviH;
@property (nonatomic,strong)UIButton * favorBtn;
@property (nonatomic,strong)UIButton * shareBtn;
@property (assign,nonatomic) BOOL isVisible;
@property (weak,nonatomic) UIView *baseView;
@property (nonatomic, weak) id <MessageInputViewDelegate> delegate;
@property (nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;
@property (nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;

- (id)initWithFrame:(CGRect)frame BaseView:(UIView *)theView Type:(int)theTye;
-(void)setTextPlaceHolder:(NSString *)placeHolder;
-(void)showInputViewWithAudioBtn:(BOOL)haveAudioBtn;
-(void)dismissInputView;

@property (nonatomic,copy)void(^favorBtnClicked) (UIButton * sender);
@property (nonatomic,copy)void(^shareBtnClicked) (UIButton * sender);

@end
