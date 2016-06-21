//
//  VideoPlayViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14-9-4.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MediaPlayer/MediaPlayer.h"

#define OpenMode 1
@protocol PlayDoneDelegate <NSObject>
@optional
-(void)playDone;
@end
@interface VideoPlayViewController : UIViewController<UIScrollViewDelegate>
{
    AVAsset *movieAsset;
    AVPlayerItem *playerItem;
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    
    UIScrollView *m_scrollView;
    
    int aa;
    UIPageControl * m_Emojipc;
}
@property (nonatomic,assign) id<PlayDoneDelegate> delegate;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic,assign)BOOL haveCloseBtn;
@end
