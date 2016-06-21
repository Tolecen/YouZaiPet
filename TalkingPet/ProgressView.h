//
//  ProgressView.h
//  TalkingPet
//
//  Created by wangxr on 14-8-9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVAudioPlayer;
@interface ProgressView : UIView
-(void)playWithAudioPlayer:(AVAudioPlayer*)audioPlayer;
-(void)stop;
@end
