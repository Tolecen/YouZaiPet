//
//  KeyboardBarView.h
//  TalkingPet
//
//  Created by Tolecen on 15/4/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiView.h"
#import "SVProgressHUD.h"
@protocol KeyboardViewDelegate <NSObject>

@optional

-(void)heightChanged:(float)height;
-(void)emojiEntered;

@end
@interface KeyboardBarView : UIView<EmojiViewDelegate,UITextViewDelegate>
{
    BOOL ifEmoji;
}
@property (strong,nonatomic) UIButton *emojiBtn;
@property (strong,nonatomic) UITextView * textView;
@property (strong,nonatomic) UIView * baseView;
@property (strong,nonatomic) EmojiView *theEmojiView;
@property (assign,nonatomic) id<KeyboardViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame textView:(UITextView *)textView baseView:(UIView *)baseview;
@end
