//
//  EmojiView.h
//  PetGroup
//
//  Created by Tolecen on 13-11-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emoji.h"
@protocol EmojiViewDelegate<NSObject>
@optional
-(NSString *)selectedEmoji:(NSString *)ssss;
-(void)deleteEmojiStr;
-(void)emojiSendBtnDo;
@end
@interface EmojiView : UIView<UIScrollViewDelegate>
{
    UIScrollView *m_EmojiScrollView;
    UIPageControl *m_Emojipc;
    UIView * emojiBGV;
}
@property (nonatomic,strong)NSArray * emojiArray;
- (id)initWithFrame:(CGRect)frame WithSendBtn:(BOOL)ifWith;
- (id)initWithFrame:(CGRect)frame WithSendBtn:(BOOL)ifWith withDeleteBtn:(BOOL)dele;
@property (nonatomic,assign)id<EmojiViewDelegate>delegate;
@end
